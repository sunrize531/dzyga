package org.dzyga.callbacks {
    public class OnceTaskFactory extends PromiseTaskFactory {
        public function OnceTaskFactory () {
            super();
        }

        /**
         * Override this function to replace once with subclass.
         *
         * @param once
         * @return
         */
        protected function getOnce(once:IPromise):IPromise {
            return once || new Once();
        }


        override public function get started ():IPromise {
            return _started = getOnce(_started);
        }

        override public function get done ():IPromise {
            return _done = getOnce(_done);
        }

        override public function get failed ():IPromise {
            return _failed = getOnce(_failed);
        }

        override public function get finished ():IPromise {
            return _finished = getOnce(_finished);
        }

        protected function resetOnce (promise:IPromise):IPromise {
            var once:Once = promise as Once;
            if (once) {
                once.reset();
            }
            return once;
        }

        override public function reset ():IPromiseTaskFactory {
            resetOnce(_started);
            resetOnce(_done);
            resetOnce(_failed);
            resetOnce(_finished);
            return this;
        }
    }
}
