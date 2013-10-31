package org.dzyga.eventloop {
    import org.dzyga.callbacks.ITask;
    import org.dzyga.callbacks.Task;

    public class LoopTaskBasic extends Task {
        protected var _loop:Loop;
        protected var _result:*;
        protected var _loopCallback:ILoopCallback;

        public function LoopTaskBasic (loop:Loop = null) {
            if (loop) {
                _loop = loop;
            } else {
                loopInit();
            }
        }

        protected function loopInit ():Loop {
            _loop = new Loop();
            return _loop;
        }

        public function get thisArg():* {
            return this;
        }

        public function get priority ():Number {
            return 1;
        }

        public function get argsArray ():Array {
            return null;
        }

        public function get result ():* {
            return _result;
        }

        /**
         * This method will be executed by loop till the task is resolved.
         * The value returned but this method will be stored in result.
         *
         * @param args
         * @return
         */
        public function run (...args):* {
        }

        protected function loopCallbackRegister ():void {
        }

        protected function loopCallbackCancel ():void {
            if (_loopCallback) {
                _loopCallback.cancel();
                _loopCallback = null;
            }
        }

        protected function loopCallbackRemove ():void {
            if (_loopCallback) {
                _loop.callbackRemove(_loopCallback);
                _loopCallback = null;
            }
        }

        override public function start (...args):ITask {
            loopCallbackRegister();
            return super.start.apply(this, args);
        }

        override public function resolve (...args):ITask {
            loopCallbackCancel();
            return super.resolve.apply(this, args);
        }

        override public function reject (...args):ITask {
            loopCallbackCancel();
            return super.reject.apply(this, args);
        }

        override public function clear ():ITask {
            loopCallbackRemove();
            return super.clear();
        }
    }
}
