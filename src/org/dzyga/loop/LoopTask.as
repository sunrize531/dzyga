/**
 * Created with IntelliJ IDEA.
 * User: sunrize
 * Date: 01.09.13
 * Time: 13:31
 * To change this template use File | Settings | File Templates.
 */
package org.dzyga.loop {
    import flash.errors.IllegalOperationError;

    import org.dzyga.callback.ITask;

    import org.dzyga.callback.Task;
    import org.dzyga.callback.TaskState;
    import org.dzyga.utils.FunctionUtils;

    public class LoopTask extends Task {
        protected var _loop:Loop = new Loop();
        protected var _result:*;

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

        protected var _loopCallback:ILoopCallback;
        protected function runner ():void {
            if (state == TaskState.STARTED) {
                _result = callback.apply(thisArg, argsArray);
            }
            if (state == TaskState.STARTED) {
                _loopCallback = _loop.call(runner);
            }
        }

        public function get result ():* {
            return _result;
        }

        override public function start (...args):ITask {
            super.start.apply(this, args);
            runner();
            return this;
        }

        override public function resolve (...args):ITask {
            if (_loopCallback) {
                _loopCallback.cancel();
            }
            return super.resolve(args);
        }

        override public function reject (...args):ITask {
            if (_loopCallback) {
                _loopCallback.cancel();
            }
            return super.reject(args);
        }

        override public function clear ():ITask {
            _loop.clear();
            return super.clear();
        }
    }
}
