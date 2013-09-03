package org.dzyga.callbacks {
    import flash.utils.Dictionary;

    import org.as3commons.collections.LinkedSet;
    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterator;
    import org.as3commons.collections.iterators.CollectionFilterIterator;

    public class Promise implements IPromise {

        protected var _callbackCollection:LinkedSet = new LinkedSet();
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
                    _callbackCollection.add(handle);
                }
            } else {
                handle = callbackInit(callback, once, thisArg, argsArray);
                _callbackCollection.add(handle);
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

        public function get callbackCollection ():LinkedSet {
            return _callbackCollection;
        }

        public function callbackIterator (callback:Function = null):ICollectionIterator {
            if (callback == null) {
                return _callbackCollection.iterator() as ICollectionIterator;
            } else {
                var filter:Function = function (handle:IHandle):Boolean {
                    return handle.callback === callback;
                };
                return new CollectionFilterIterator(_callbackCollection, filter);
            }
        }

        public function iterator (cursor:* = null):IIterator {
            return callbackIterator();
        }

        public function get unique ():Boolean {
            return _unique;
        }

        public function clear ():IPromise {
            _callbackCollection.clear();
            if (_unique) {
                _callbackMap = new Dictionary(true);
            }
            return null;
        }
    }
}
