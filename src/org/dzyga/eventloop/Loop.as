package org.dzyga.eventloop {
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    import org.dzyga.collections.ICollection;
    import org.dzyga.collections.IIterator;
    import org.dzyga.collections.ISequence;
    import org.dzyga.collections.ObjectIterator;
    import org.dzyga.collections.ObjectIterator;
    import org.dzyga.collections.ObjectIterator;

    import org.dzyga.events.*;
    import flash.display.Stage;
    import flash.utils.getTimer;

    import org.dzyga.utils.ObjectUtils;

    public class Loop {
        public static const FRAME_ENTER_STATE:String = 'frame:enter';
        public static const FRAME_EXIT_STATE:String = 'frame:exit';
        public static const IDLE_STATE:String = 'idle';

        protected static var _stage:Stage;
        protected static var _state:String;
        protected static var _dispatcher:IDispatcherProxy;
        protected static var _processor:LoopProcessor = new LoopProcessor();

        public function Loop () {
        }

        public static function init (dispatcher:IEventDispatcher, fps:Number = NaN):void {
            _processor.init(dispatcher, fps);
        }

        public function get fps ():Number {
            return _processor.fps;
        }

        public function get frameTime ():Number {
            return _processor.frameTime;
        }

        public function get state ():String {
            return _processor.state;
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
        protected function callbackInit (callback:Function, delay:Number, priority:uint, once:Boolean,
                                         thisArg:*, argsArray:Array):ILoopCallback {
            return new LoopCallback(this, callback, delay, priority, once, thisArg, argsArray);
        }

        protected var _callbackHash:Dictionary = new Dictionary();


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
            _processor.frameEnterCallbackCollection.add(loopCallback);
            _callbackHash[loopCallback] = _processor.frameEnterCallbackCollection;
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
            _processor.frameExitCallbackCollection.add(loopCallback);
            _callbackHash[loopCallback] = _processor.frameExitCallbackCollection;
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
                callback, frameTime, priority, true,
                thisArg, argsArray);
            _processor.delayedCallbackCollection.add(loopCallback);
            _callbackHash[loopCallback] = _processor.delayedCallbackCollection;
            if (_state == FRAME_ENTER_STATE) {
                _processor.immediateCallbackCollection.add(loopCallback);
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
            _processor.delayedCallbackCollection.add(loopCallback);
            _callbackHash[loopCallback] = _processor.delayedCallbackCollection;
            return loopCallback;
        }

        /**
         * Remove callback from loop. Also you can just cancel it.
         *
         * @param loopCallback Callback to remove
         * @return this
         */
        public function callbackRemove (loopCallback:ILoopCallback):Loop {
            var collection:ISequence = _callbackHash[loopCallback];
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
            var iterator:ObjectIterator = new ObjectIterator(_callbackHash);
            while (iterator.hasNext()) {
                var loopCallback:ILoopCallback = iterator.nextKey();
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
            var iterator:ObjectIterator = new ObjectIterator(_callbackHash);
            while (iterator.hasNext()) {
                var callback:ILoopCallback = iterator.nextKey();
                callback.cancel();
                iterator.remove();
            }
            return this;
        }
    }
}









