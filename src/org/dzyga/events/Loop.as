package org.dzyga.events {
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.getTimer;

    import org.as3commons.collections.Map;
    import org.as3commons.collections.SortedSet;
    import org.as3commons.collections.Treap;
    import org.as3commons.collections.framework.ICollection;
    import org.as3commons.collections.framework.ICollectionIterator;

    public class Loop {
        protected static var _stage:Stage;
        protected static var _dispatcher:DispatcherProxy;
        public static function init (stage:Stage):void {
            _stage = stage;
            _dispatcher = new DispatcherProxy(stage);
            _dispatcher.listen(Event.ENTER_FRAME, enterFrameHandler);
            _dispatcher.listen(Event.EXIT_FRAME, exitFrameHandler);
        }

        public static function get fps ():Number {
            return _stage.frameRate;
        }

        // Callback lists
        protected static var _enterFrameCallbackCollection:Treap = new Treap(new CallbackComparator());
        protected static var _delayedCallbackCollection:Treap = new Treap(new CallbackDelayedComparator());
        protected static var _exitFrameCallbackCollection:Treap = new Treap(new CallbackComparator());

        protected static const _enterFrameCallbackCollectionList:Array = [
            _enterFrameCallbackCollection, _delayedCallbackCollection];
        protected static const _exitFrameCallbackCollectionList:Array = [
            _exitFrameCallbackCollection];

        protected static const ENTER_FRAME_THRESHOLD:Number = 0.7;
        protected static const EXIT_FRAME_THRESHOLD:Number = 0.3;

        protected static var _frameTime:Number = 0;

        protected static function callbackCollectionListProcess (callbackCollectionList:Array, frameTime:Number):void {
            _frameTime = getTimer();
            var elapsedTime:Number = 0;

            for each (var collection:SortedSet in callbackCollectionList) {
                if (collection.size) {
                    var iterator:ICollectionIterator = collection.iterator() as ICollectionIterator;
                    while (iterator.hasNext()) {
                        var callback:ILoopCallback = iterator.next();
                        if (callback.canceled) {
                            iterator.remove();
                        } else if (callback.timeout <= _frameTime && (!callback.priority || elapsedTime < frameTime)) {
                            if (callback.once) {
                                iterator.remove();
                            }
                            callback.call();
                        }
                        elapsedTime = getTimer() - _frameTime;
                    }
                }
            }
        }

        protected static function enterFrameHandler (e:Event):void {
            callbackCollectionListProcess(_enterFrameCallbackCollectionList, 1 / fps * ENTER_FRAME_THRESHOLD);
        }

        protected static function exitFrameHandler (e:Event):void {
            callbackCollectionListProcess(_exitFrameCallbackCollectionList, 1 / fps * EXIT_FRAME_THRESHOLD);
        }

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
        public function enterFrameCall (callback:Function, priority:uint = 0,
                                        thisArg:* = null, argsArray:Array = null):ILoopCallback {
            var loopCallback:ILoopCallback = callbackInit(callback, 0, priority, false, thisArg, argsArray);
            _enterFrameCallbackCollection.add(loopCallback);
            _callbackHash.add(_callbackHash, _enterFrameCallbackCollection);
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
        public function exitFrameCall (callback:Function, priority:uint = 0,
                                       thisArg:* = null, argsArray:Array = null):ILoopCallback {
            var loopCallback:ILoopCallback = callbackInit(callback, 0, priority, false, thisArg, argsArray);
            _exitFrameCallbackCollection.add(loopCallback);
            _callbackHash.add(_callbackHash, _exitFrameCallbackCollection);
            return loopCallback;
        }

        /**
         * Execute callback once on next frame enter.
         *
         * @param callback Function to call.
         * @param priority Callbacks with priority == 0 will be executed regardless of frame time.
         * @param thisArg Apply callback to specified context
         * @param argsArray Execute callback with provided args.
         * @return new ILoopCallback instance
         */
        public function call (callback:Function, priority:uint = 0,
                                       thisArg:* = null, argsArray:Array = null):ILoopCallback {
            return delayedCall(callback, _frameTime, priority, thisArg, argsArray);
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
        public function delayedCall (callback:Function, delay:Number = 0, priority:uint = 0,
                                     thisArg:* = null, argsArray:Array = null):ILoopCallback {
            var loopCallback:ILoopCallback = callbackInit(
                callback, _frameTime + delay, priority, true,
                thisArg, argsArray);
            _delayedCallbackCollection.add(loopCallback);
            _callbackHash.add(_callbackHash, _delayedCallbackCollection);
            return null;
        }

        /**
         * Remove callback from loop. Also you can just cancel it.
         *
         * @param callback Callback to remove
         * @return this
         */
        public function callbackRemove (callback:ILoopCallback):Loop {
            var collection:ICollection = _callbackHash.itemFor(callback);
            if (collection) {
                collection.remove(callback);
                _callbackHash.removeKey(callback);
            }
            return this;
        }

        /**
         * Check if callback registered in loop.
         *
         * @param callback Callback to check
         * @return this
         */
        public function hasCallback (callback:ILoopCallback):Boolean {
            return _callbackHash.hasKey(callback);
        }

        public function clear ():Loop {
            var iterator:ICollectionIterator = _callbackHash.iterator() as ICollectionIterator;
            while (iterator.hasNext()) {
                var callback:ILoopCallback = iterator.next();
                callback.cancel();
                iterator.remove();
            }
            return this;
        }
    }
}

import org.as3commons.collections.framework.IComparator;
import org.as3commons.collections.utils.NumericComparator;
import org.as3commons.collections.utils.StringComparator;
import org.dzyga.events.ILoopCallback;

class CallbackComparator implements IComparator {
    protected var _numeric:NumericComparator = new NumericComparator();
    protected var _string:StringComparator = new StringComparator();

    public function compare (item1:*, item2:*):int {
        var c1:ILoopCallback = ILoopCallback(item1);
        var c2:ILoopCallback = ILoopCallback(item2);
        return _numeric.compare(c1.priority, c2.priority) ||
            _string.compare(c1.hash, c2.hash);
    }
}

class CallbackDelayedComparator implements IComparator {
    protected var _numeric:NumericComparator = new NumericComparator();
    protected var _string:StringComparator = new StringComparator();

    public function compare (item1:*, item2:*):int {
        var c1:ILoopCallback = ILoopCallback(item1);
        var c2:ILoopCallback = ILoopCallback(item2);
        return _numeric.compare(c1.timeout, c2.timeout) ||
            _numeric.compare(c1.priority, c2.priority) ||
            _string.compare(c1.hash, c2.hash);
    }
}
