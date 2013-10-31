package org.dzyga.eventloop {
    internal class LoopTaskSubclass extends LoopTask {
        private var _counter:int = 0;
        private var _iterations:int = 0;

        public function LoopTaskSubclass (loop:Loop = null, iterations:int = 10) {
            super(loop);
            _iterations = iterations;
        }


        override public function run (... args):* {
            wait(100);
            if (_counter++ >= _iterations) {
                resolve();
            } else {
                notify();
            }
        }
    }
}
