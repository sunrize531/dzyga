package org.dzyga.events {
    import flash.errors.IllegalOperationError;

    import org.dzyga.utils.ObjectUtils;

    public class Handle implements IHandle {
        protected var _canceled:Boolean = false;
        protected var _thisArg:*;
        protected var _argsArray:Array;
        protected var _callback:Function;
        protected var _hash:String;
        protected var _result:*;

        public function Handle (
                callback:Function, thisArg:* = null, argsArray:Array = null, hash:String = '') {
            _callback = callback;
            _thisArg = thisArg;
            _argsArray = argsArray || [];
            _hash = hash || hashGenerate();
        }

        public function hashGenerate ():String {
            return ObjectUtils.hash(this);
        }

        /**
         * @inheritDoc
         */
        public function get callback ():Function {
            return _callback;
        }

        /**
         * @inheritDoc
         */
        public function get thisArg ():* {
            return _thisArg;
        }

        /**
         * @inheritDoc
         */
        public function get argsArray ():Array {
            return _argsArray;
        }

        /**
         * @inheritDoc
         */
        public function get hash ():String {
            return _hash;
        }

        /**
         * @inheritDoc
         */
        public function get canceled ():Boolean {
            return _canceled;
        }

        /**
         * @inheritDoc
         */
        public function get result ():* {
            return _result;
        }

        /**
         * @inheritDoc
         */
        public function call (... args):* {
            if (_canceled) {
                throw new IllegalOperationError('Handle is canceled');
            }
            _result = _callback.apply(_thisArg, args.concat(_argsArray));
            return result;
        }

        /**
         * @inheritDoc
         */
        public function cancel ():Boolean {
            if (!_canceled) {
                _canceled = true;
                return true;
            } else {
                return false;
            }
        }
    }
}
