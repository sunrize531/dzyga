package org.dzyga.events {
    import org.dzyga.utils.ObjectUtils;

    public class Handle implements IHandle {
        protected var _once:Boolean;
        protected var _thisArg:*;
        protected var _args:Array;
        protected var _callback:Function;
        protected var _hash:String;
        protected var _result:*;

        public function Handle (
                callback:Function, once:Boolean = false,
                thisArg:* = null, args:Array = null, hash:String = '') {
            _once = once;
            _callback = callback;
            _thisArg = thisArg;
            _args = args;
            _hash = hash || hashGenerate();
        }

        public function hashGenerate ():String {
            return ObjectUtils.hash(this);
        }

        public function get callback ():Function {
            return _callback;
        }

        public function get once ():Boolean {
            return _once;
        }

        public function get thisArg ():* {
            return _thisArg;
        }

        public function get args ():Array {
            return _args;
        }

        public function get hash ():String {
            return _hash;
        }

        public function get result ():* {
            return _result;
        }

        public function call (... args):* {
            _result = _callback.apply(_thisArg, args.concat(_args));
            return result;
        }
    }
}
