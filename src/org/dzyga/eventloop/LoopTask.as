package org.dzyga.eventloop {
    import org.dzyga.callbacks.ITask;

    import org.dzyga.callbacks.Task;
    import org.dzyga.callbacks.TaskState;
    import org.dzyga.utils.FunctionUtils;

    public class LoopTask extends Task {
        protected var _loop:Loop;
        protected var _result:*;


        public function LoopTask (loop:Loop = null) {
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

        public function get callback ():Function {
            if (hasOwnProperty('run')) {
                return this['run'];
            } else {
                return FunctionUtils.identity;
            }
        }

        public function get thisArg():* {
            return this;
        }

        public function get argsArray ():Array {
            return null;
        }

        public function get priority ():Number {
            return 1;
        }

        protected function deferRunner ():void {
            _loopCallback = _loop.call(runner, priority);
        }

        protected var _loopCallback:ILoopCallback;
        protected function runner ():void {
            if (state == TaskState.STARTED) {
                _result = callback.apply(thisArg, argsArray);
            }
            if (state == TaskState.STARTED) {
                deferRunner();
            }
        }

        public function get result ():* {
            return _result;
        }

        override public function start (...args):ITask {
            super.start.apply(this, args);
            deferRunner();
            return this;
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
