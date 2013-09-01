package org.dzyga.callback {

    public class Callback extends Handle implements ICallback {
        protected var _once:Boolean;

        public function Callback (
                callback:Function, once:Boolean = false,
                thisArg:* = null, args:Array = null, hash:String = '') {
            super(callback, thisArg, args, hash);
            _once = once;
        }

        /**
         * @inheritDoc
         */
        public function get once ():Boolean {
            return _once;
        }
    }
}
