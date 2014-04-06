package org.dzyga.callbacks {
    import flash.errors.IllegalOperationError;

    import org.dzyga.collections.ISequenceIterator;

    public class Supervisor extends Promise {
        public function Supervisor (... args) {
            for each (var i:IPromise in args) {
                promiseAdd(i);
            }
        }

        protected var _resolved:Boolean = false;
        public function get resolved ():Boolean {
            return _resolved;
        }

        protected function supervisorCallbackRegister (promise:IPromise):SupervisorCallback {
            // TODO: implement...
        }

        protected function supervisorCallbackRemove (promise:IPromise):void {
            // TODO: implement...
        }

        /**
         * Add promise to Supervisor. If Supervisor is resolved, IllegalOperationError will be thrown.
         *
         * @param promise
         * @return this
         * @throws IllegalOperationError is Supervisor is resolved
         */
        public function promiseAdd (promise:IPromise):Supervisor {
            return this;
        }

        /**
         * Remove promise from Supervisor. If all other promises are resolved, Supervisor will be resolved immediately.
         *
         * @param promise
         * @return this
         */
        public function promiseRemove (promise:IPromise):Supervisor {
            return this;
        }

        public function promiseIterator ():ISequenceIterator {
            return null;
        }

        protected function promiseResolveCallback (...args):void {
        }


        public function check (... args):IPromise {
        }

        /**
         * Resolve all registered promises, with args, than resolve Supervisor.
         *
         * @param args Args to apply to callbacks.
         * @return this
         */
        override public function resolve (...args):IPromise {
        }

        /**
         * Reset supervisor for reusing.
         *
         * @return this
         */
        public function reset ():Supervisor {
        }

        /**
         * Remove all registered promises.
         *
         * @return this
         */
        override public function clear ():IPromise {
        }
    }
}
