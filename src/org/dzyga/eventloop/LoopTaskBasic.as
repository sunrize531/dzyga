package org.dzyga.eventloop {
    import org.dzyga.callbacks.ITask;
    import org.dzyga.callbacks.Task;
    import org.dzyga.utils.FunctionUtils;

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

        public function get callback ():Function {
            if (hasOwnProperty('run')) {
                return this['run'];
            } else {
                return FunctionUtils.identity;
            }
        }

        override public function resolve (...args):ITask {
            if (_loopCallback) {
                _loopCallback.cancel();
            }
            return super.resolve.apply(this, args);
        }

        override public function reject (...args):ITask {
            if (_loopCallback) {
                _loopCallback.cancel();
            }
            return super.reject.apply(this, args);
        }

        override public function clear ():ITask {
            if (_loopCallback) {
                _loop.callbackRemove(_loopCallback);
            }
            return super.clear();
        }
    }
}
