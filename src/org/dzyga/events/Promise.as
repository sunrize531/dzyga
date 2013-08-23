package org.dzyga.events {
    import flash.utils.Dictionary;

    import org.as3commons.collections.LinkedList;

    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterator;
    import org.as3commons.collections.iterators.CollectionFilterIterator;

    public class Promise implements IPromise {

        protected var _handleList:LinkedList = new LinkedList();
        protected var _handleMap:Dictionary = new Dictionary(true);
        private var _uniq:Boolean;

        public function Promise (uniq:Boolean = true) {
            _uniq = uniq;
        }

        public function resolve (... args):IPromise {
            var iterator:ICollectionIterator = handleIterator();
            while (iterator.hasNext()) {
                var handle:IHandle = iterator.next();
                handle.call.apply(null, args);
                if (handle.once) {
                    iterator.remove();
                }
            }
            return this;
        }

        public function callbackRegister (
                callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise {
            var handle:Handle;
            if (_uniq) {
                handle = _handleMap[callback];
                if (handle) {
                    return this;
                } else {
                    handle = new Handle(callback, once, thisArg, argsArray);
                    _handleMap[callback] = handle;
                    _handleList.add(handle);
                }
            } else {
                handle = new Handle(callback, once, thisArg, argsArray);
                _handleList.add(handle);
            }
            return this;
        }

        public function callbackRemove (callback:Function = null):IPromise {
            var iterator:ICollectionIterator = handleIterator(callback);
            while (iterator.hasNext()) {
                iterator.next();
                iterator.remove();
            }
            return this;
        }

        public function handleIterator (callback:Function = null):ICollectionIterator {
            if (callback == null) {
                return _handleList.iterator() as ICollectionIterator;
            } else {
                var filter:Function = function (handle:IHandle):Boolean {
                    return handle.callback === callback;
                };
                return new CollectionFilterIterator(_handleList, filter);
            }
        }

        public function iterator (cursor:* = null):IIterator {
            return handleIterator();
        }

        public function get uniq ():Boolean {
            return _uniq;
        }

        public function clear ():IPromise {
            _handleList.clear();
            if (_uniq) {
                _handleMap = new Dictionary(true);
            }
            return null;
        }
    }
}
