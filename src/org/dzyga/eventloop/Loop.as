package org.dzyga.eventloop {
    import org.dzyga.events.*;
    import flash.display.Stage;
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.utils.getTimer;

    import org.as3commons.collections.LinkedList;
    import org.as3commons.collections.Map;
    import org.as3commons.collections.SortedSet;
    import org.as3commons.collections.framework.ICollection;
    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterator;

    public class Loop {
        public static const FRAME_ENTER_STATE:String = 'frame:enter';
        public static const FRAME_EXIT_STATE:String = 'frame:exit';
        public static const IDLE_STATE:String = 'idle';

        protected static var _stage:Stage;
        protected static var _dispatcher:IDispatcherProxy;
        protected static var _state:String;

        public function Loop () {
        }

        public static function init (stage:Stage):void {
            if (_stage) {
                throw new IllegalOperationError('Loop already initialized.');
            }
            _stage = stage;
            _dispatcher = new DispatcherProxy(stage);
            _dispatcher
                .listen(Event.ENTER_FRAME, frameEnterHandler)
                .listen(Event.EXIT_FRAME, frameExitHandler);
        }

        public static function get fps ():Number {
            return _stage.frameRate;
        }

        // Callback lists

        protected static var _frameEnterCallbackCollection:SortedSet = new SortedSet(new LoopCallbackComparator());
        protected static var _delayedCallbackCollection:SortedSet = new SortedSet(new LoopCallbackDelayedComparator());
        protected static var _immediateCallbackCollection:LinkedList = new LinkedList();

        protected static var _frameExitCallbackCollection:SortedSet = new SortedSet(new LoopCallbackComparator());

        protected static var _callbackIterator:LoopCallbackIterator = new LoopCallbackIterator();

        protected static const FRAME_ENTER_THRESHOLD:Number = 0.7;
        protected static const FRAME_EXIT_THRESHOLD:Number = 0.3;

        protected static var _frameTime:Number = 0;

        protected static function callbackCollectionListProcess (
                callbackIterator:LoopCallbackIterator, frameTime:Number):void {
            _frameTime = getTimer();
            var elapsedTime:Number = 0;
            while (callbackIterator.hasNext()) {
                var callback:ILoopCallback = callbackIterator.next();
                if (callback.canceled) {
                    callbackIterator.remove();
                } else if (callback.timeout <= _frameTime && (!callback.priority || elapsedTime < frameTime)) {
                    callback.call();
                    if (callback.once) {
                        callback.cancel();
                        callbackIterator.remove();
                    }
                }
                elapsedTime = getTimer() - _frameTime;
            }
        }

        protected static function frameEnterProcess (frameTime:Number):void {
            _state = FRAME_ENTER_STATE;
            _callbackIterator.setCallbackCollection(
                _frameEnterCallbackCollection, _delayedCallbackCollection, _immediateCallbackCollection);
            callbackCollectionListProcess(_callbackIterator, frameTime);
            _immediateCallbackCollection.clear();
            _state = IDLE_STATE;
        }

        protected static function frameExitProcess (frameTime:Number):void {
            _state = FRAME_EXIT_STATE;
            _callbackIterator.setCallbackCollection(_frameExitCallbackCollection);
            callbackCollectionListProcess(_callbackIterator, frameTime);
            _state = IDLE_STATE;
        }

        protected static function frameEnterHandler (e:Event):void {
            frameEnterProcess(1000 / fps * FRAME_ENTER_THRESHOLD);
        }

        protected static function frameExitHandler (e:Event):void {
            frameExitProcess(1000 / fps * FRAME_EXIT_THRESHOLD);
        }

        // Instance methods.

        /**
         * Override this method to init callbacks with overwritten class.
         *
         * @param callback Function to call.
         * @param delay Time in milliseconds from now.
         * @param priority Callbacks with priority == 0 will be executed regardless of frame time.
         * @param once Remove callback after first run
         * @param thisArg Apply callback to specified context
         * @param argsArray Execute callback with provided args.
         * @return new ILoopCallback instance
         */
        protected function callbackInit (callback:Function,
                                         delay:Number, priority:uint, once:Boolean,
                                         thisArg:*, argsArray:Array):ILoopCallback {
            return new LoopCallback(this, callback, delay, priority, once, thisArg, argsArray);
        }

        protected var _callbackHash:Map = new Map();


        /**
         * Execute callback on frame enter.
         *
         * @param callback Function to call.
         * @param priority Callbacks with priority == 0 will be executed regardless of frame time.
         * @param thisArg Apply callback to specified context
         * @param argsArray Execute callback with provided args.
         * @return new ILoopCallback instance
         */
        public function frameEnterCall (callback:Function, priority:uint = 1,
                                        thisArg:* = null, argsArray:Array = null):ILoopCallback {
            var loopCallback:ILoopCallback = callbackInit(callback, 0, priority, false, thisArg, argsArray);
            _frameEnterCallbackCollection.add(loopCallback);
            _callbackHash.add(loopCallback, _frameEnterCallbackCollection);
            return loopCallback;
        }

        /**
         * Execute callback on frame exit.
         *
         * @param callback Function to call.
         * @param priority Callbacks with priority == 0 will be executed regardless of frame time.
         * @param thisArg Apply callback to specified context
         * @param argsArray Execute callback with provided args.
         * @return new ILoopCallback instance
         */
        public function frameExitCall (callback:Function, priority:uint = 1,
                                       thisArg:* = null, argsArray:Array = null):ILoopCallback {
            var loopCallback:ILoopCallback = callbackInit(callback, 0, priority, false, thisArg, argsArray);
            _frameExitCallbackCollection.add(loopCallback);
            _callbackHash.add(loopCallback, _frameExitCallbackCollection);
            return loopCallback;
        }

        /**
         * Execute callback as soon as possible. If Loop is in FRAME_ENTER_STATE, callback will be pushed to
         * the end of current execution query. If there is no time remaining in this frame,
         * or Loop is not in FRAME_ENTER_STATE, callback will be executed along with delayed calls
         * in the next Loop iteration.
         *
         * @param callback Function to call.
         * @param priority Callbacks with priority == 0 will be executed regardless of frame time.
         * @param thisArg Apply callback to specified context
         * @param argsArray Execute callback with provided args.
         * @return new ILoopCallback instance
         */
        public function call (callback:Function, priority:uint = 1,
                              thisArg:* = null, argsArray:Array = null):ILoopCallback {
            var loopCallback:ILoopCallback = callbackInit(
                callback, _frameTime, priority, true,
                thisArg, argsArray);
            _delayedCallbackCollection.add(loopCallback);
            _callbackHash.add(loopCallback, _delayedCallbackCollection);
            if (_state == FRAME_ENTER_STATE) {
                _immediateCallbackCollection.add(loopCallback);
            }
            return loopCallback;
        }

        /**
         * Execute callback after delay milliseconds from now.
         *
         * @param callback Function to call.
         * @param delay Time in milliseconds from now.
         * @param priority Callbacks with priority == 0 will be executed regardless of frame time.
         * @param thisArg Apply callback to specified context
         * @param argsArray Execute callback with provided args.
         * @return new ILoopCallback instance
         */
        public function delayedCall (callback:Function, delay:Number = 0, priority:uint = 1,
                                     thisArg:* = null, argsArray:Array = null):ILoopCallback {
            var loopCallback:ILoopCallback = callbackInit(
                callback, getTimer() + delay, priority, true,
                thisArg, argsArray);
            _delayedCallbackCollection.add(loopCallback);
            _callbackHash.add(loopCallback, _delayedCallbackCollection);
            return loopCallback;
        }

        /**
         * Remove callback from loop. Also you can just cancel it.
         *
         * @param loopCallback Callback to remove
         * @return this
         */
        public function callbackRemove (loopCallback:ILoopCallback):Loop {
            var collection:ICollection = _callbackHash.itemFor(loopCallback);
            if (collection) {
                loopCallback.cancel();
                collection.remove(loopCallback);
                _callbackHash.removeKey(loopCallback);
            }
            return this;
        }

        /**
         * Check if callback registered in loop.
         *
         * @param loopCallback Callback to check
         * @return this
         */
        public function hasCallback (loopCallback:ILoopCallback):Boolean {
            return _callbackHash.hasKey(loopCallback);
        }

        /**
         * Return true if loop instance will call specified function.
         *
         * @return true if specified function was added to the loop somehow.
         */
        public function willCall (callback:Function):Boolean {
            var iterator:IIterator = _callbackHash.keyIterator();
            while (iterator.hasNext()) {
                var loopCallback:ILoopCallback = iterator.next();
                if (loopCallback.callback == callback && !loopCallback.canceled) {
                    return true;
                }
            }
            return false;
        }

        /**
         * Cancel all callbacks registered in current loop.
         *
         * @return this
         */
        public function clear ():Loop {
            var iterator:ICollectionIterator = _callbackHash.keyIterator() as ICollectionIterator;
            while (iterator.hasNext()) {
                var callback:ILoopCallback = iterator.next();
                callback.cancel();
                iterator.remove();
            }
            return this;
        }
    }
}









