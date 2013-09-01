package org.dzyga.eventloop {
    import org.dzyga.callbacks.Callback;

    import org.dzyga.utils.ObjectUtils;

    public class LoopCallback extends Callback implements ILoopCallback {
        protected var _loop:Loop;
        protected var _timeout:Number;
        protected var _priority:Number;

        public function LoopCallback (
                loop:Loop, callback:Function,
                timeout:Number, priority:Number, once:Boolean,
                thisArg:* = null, argsArray:Array = null) {
            super(callback, once, thisArg, argsArray, ObjectUtils.hash(callback));
            _loop = loop;
            _priority = priority;
            _timeout = timeout;
        }

        public function get loop ():Loop {
            return _loop;
        }

        public function get timeout ():Number {
            return _timeout;
        }

        public function get priority ():Number {
            return _priority;
        }
    }
}
