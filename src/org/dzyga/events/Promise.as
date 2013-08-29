package org.dzyga.events {
    import flash.utils.Dictionary;

    import org.as3commons.collections.LinkedList;

    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterator;
    import org.as3commons.collections.iterators.CollectionFilterIterator;

    public class Promise implements IPromise {

        protected var _callbackList:LinkedList = new LinkedList();
        protected var _callbackMap:Dictionary = new Dictionary(true);
        protected var _unique:Boolean;

        public function Promise (unique:Boolean = true) {
            _unique = unique;
        }

        public function resolve (... args):IPromise {
            var iterator:ICollectionIterator = callbackIterator();
            while (iterator.hasNext()) {
                var callback:ICallback = iterator.next();
                callback.call.apply(null, args);
                if (callback.once) {
                    iterator.remove();
                }
            }
            return this;
        }

        protected function callbackInit (callback:Function, once:Boolean, thisArg:*, argsArray:Array):ICallback {
            return new Callback(callback, once, thisArg, argsArray);
        }

        public function callbackRegister (
                callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise {
            var handle:ICallback;
            if (_unique) {
                handle = _callbackMap[callback];
                if (handle) {
                    return this;
                } else {
                    handle = callbackInit(callback, once, thisArg, argsArray);
                    _callbackMap[callback] = handle;
                    _callbackList.add(handle);
                }
            } else {
                handle = callbackInit(callback, once, thisArg, argsArray);
                _callbackList.add(handle);
            }
            return this;
        }

        public function callbackRemove (callback:Function = null):IPromise {
            var iterator:ICollectionIterator = callbackIterator(callback);
            while (iterator.hasNext()) {
                iterator.next();
                iterator.remove();
            }
            return this;
        }

        public function callbackIterator (callback:Function = null):ICollectionIterator {
            if (callback == null) {
                return _callbackList.iterator() as ICollectionIterator;
            } else {
                var filter:Function = function (handle:IHandle):Boolean {
                    return handle.callback === callback;
                };
                return new CollectionFilterIterator(_callbackList, filter);
            }
        }

        public function iterator (cursor:* = null):IIterator {
            return callbackIterator();
        }

        public function get unique ():Boolean {
            return _unique;
        }

        public function clear ():IPromise {
            _callbackList.clear();
            if (_unique) {
                _callbackMap = new Dictionary(true);
            }
            return null;
        }
    }
}
