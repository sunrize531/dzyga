package org.dzyga.eventloop {
    import org.dzyga.callbacks.ITask;
    import org.dzyga.callbacks.TaskState;

    public class LoopTask extends LoopTaskBasic {
        public function LoopTask (loop:Loop = null) {
            super(loop);
        }

        protected function deferRunner ():void {
            _loopCallback = _loop.call(runner, priority);
        }

        protected function runner ():void {
            if (state == TaskState.STARTED) {
                _result = callback.apply(thisArg, argsArray);
            }
            if (state == TaskState.STARTED) {
                deferRunner();
            }
        }

        override public function start (...args):ITask {
            super.start.apply(this, args);
            deferRunner();
            return this;
        }
    }
}
