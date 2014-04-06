package org.dzyga.callbacks {
    import flash.utils.Dictionary;

    import org.dzyga.collections.IIterator;
    import org.dzyga.collections.ISequenceIterator;
    import org.dzyga.collections.SequenceFilterIterator;
    import org.dzyga.collections.SetOrdered;

    public class Promise implements IPromise {

        protected var _callbackCollection:SetOrdered = new SetOrdered();
        protected var _callbackMap:Dictionary = new Dictionary(true);
        protected var _unique:Boolean;

        public function Promise (unique:Boolean = true) {
            _unique = unique;
        }

        /**
         * @inheritDoc
         */
        public function resolve (... args):IPromise {
            var iterator:ISequenceIterator = callbackIterator();
            while (iterator.hasNext()) {
                var callback:ICallback = iterator.next();
                callback.call.apply(null, args);
                if (callback.once) {
                    iterator.remove();
                    delete _callbackMap[callback.callback];
                }
            }
            return this;
        }

        protected function callbackInit (callback:Function, once:Boolean, thisArg:*, argsArray:Array):ICallback {
            return new Callback(callback, once, thisArg, argsArray);
        }

        /**
         * @inheritDoc
         */
        public function callbackRegister (
                callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise {
            if (callback != null) {
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
            }
            return this;
        }

        /**
         * @inheritDoc
         */
        public function callbackRemove (callback:Function = null):IPromise {
            var iterator:ISequenceIterator = callbackIterator(callback);
            while (iterator.hasNext()) {
                iterator.next();
                iterator.remove();
            }
            delete _callbackMap[callback];
            return this;
        }

        /**
         * Return LinkedSet, containing handles for all registered callbacks.
         */
        public function get callbackCollection ():SetOrdered {
            return _callbackCollection;
        }

        /**
         * @inheritDoc
         */
        public function callbackIterator (callback:Function = null):ISequenceIterator {
            if (callback == null) {
                return _callbackCollection.iterator() as ISequenceIterator;
            } else {
                var filter:Function = function (handle:IHandle):Boolean {
                    return handle.callback === callback;
                };
                return new SequenceFilterIterator(_callbackCollection.iterator(), filter);
            }
        }

        /**
         * Alias for callbackIterator, and also IIterable implementation.
         *
         * @param cursor
         * @return
         */
        public function iterator ():IIterator {
            return callbackIterator();
        }

        /**
         * True, if Promise will check callbacks when registering to prevent creation of several handles
         * for one callback.
         */
        public function get unique ():Boolean {
            return _unique;
        }

        /**
         * @inheritDoc
         */
        public function clear ():IPromise {
            _callbackCollection.clear();
            if (_unique) {
                _callbackMap = new Dictionary(true);
            }
            return null;
        }
    }
}
