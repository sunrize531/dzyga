package org.dzyga.eventloop {
    import org.dzyga.callbacks.ITask;

    public class FrameEnterTask extends LoopTaskBasic {
        public function FrameEnterTask (loop:Loop = null) {
            super(loop);
        }

        override public function start (...args):ITask {
            super.start(args);
            _loop.frameEnterCall(callback, priority, thisArg, argsArray);
            return this;
        }
    }
}
