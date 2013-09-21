package org.dzyga.eventloop {
    public class FrameEnterTask extends LoopTaskBasic {
        public function FrameEnterTask (loop:Loop = null) {
            super(loop);
        }

        override protected function loopCallbackRegister ():void {
            if (!_loopCallback) {
                _loopCallback = _loop.frameEnterCall(callback, priority, thisArg, argsArray);
            }
        }
    }
}
