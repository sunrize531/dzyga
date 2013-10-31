package org.dzyga.callbacks {
    public class PromiseTaskFactory implements IPromiseTaskFactory {

        protected var _started:IPromise;
        protected var _done:IPromise;
        protected var _failed:IPromise;
        protected var _finished:IPromise;
        protected var _progress:IPromise;

        public function PromiseTaskFactory () {
        }

        /**
         * Override this function to replace promise with subclass.
         *
         * @param promise
         * @return
         */
        protected function getPromise (promise:IPromise):IPromise {
            return promise || new Promise();
        }

        public function get started ():IPromise {
            return _started = getPromise(_started);
        }

        public function get done ():IPromise {
            return _done = getPromise(_done);
        }

        public function get failed ():IPromise {
            return _failed = getPromise(_failed);
        }

        public function get finished ():IPromise {
            return _finished = getPromise(_finished);
        }

        public function get progress ():IPromise {
            return _progress = getPromise(_progress);
        }


        protected function clearPromise (promise:IPromise):IPromise {
            if (promise) {
                promise.clear();
            }
            return promise;
        }

        public function clear ():IPromiseTaskFactory {
            clearPromise(_started);
            clearPromise(_done);
            clearPromise(_failed);
            clearPromise(_finished);
            clearPromise(_progress);
            return this;
        }

        public function reset ():IPromiseTaskFactory {
            // Noop by default
            return this;
        }
    }
}
