package org.dzyga.callbacks {
    import flash.errors.IllegalOperationError;

    import org.as3commons.collections.LinkedMap;
    import org.as3commons.collections.Map;
    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterator;
    import org.as3commons.collections.framework.IMapIterator;

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

        protected var _supervisorCallbackMap:Map = new Map();
        protected function supervisorCallbackRegister (promise:IPromise):SupervisorCallback {
            var supervisorCallback:SupervisorCallback = new SupervisorCallback(promiseResolveCallback, promise);
            promise.callbackCollection.add(supervisorCallback);
            _supervisorCallbackMap.add(promise, supervisorCallback);
            return supervisorCallback;
        }

        protected function supervisorCallbackRemove (promise:IPromise):void {
            promise.callbackCollection.remove(_supervisorCallbackMap.itemFor(promise));
            _supervisorCallbackMap.removeKey(promise);
        }

        protected var _promiseStateMap:LinkedMap = new LinkedMap();

        /**
         * Add promise to Supervisor. If Supervisor is resolved, IllegalOperationError will be thrown.
         *
         * @param promise
         * @return this
         * @throws IllegalOperationError is Supervisor is resolved
         */
        public function promiseAdd (promise:IPromise):Supervisor {
            if (_resolved) {
                throw new IllegalOperationError('Cannot add more promises. Supervisor is resolved. ' +
                    'Reset it to add more promises')
            }
            if (_promiseStateMap.add(promise, false)) {
                supervisorCallbackRegister(promise);
            }
            return this;
        }

        /**
         * Remove promise from Supervisor. If all other promises are resolved, Supervisor will be resolved immediately.
         *
         * @param promise
         * @return this
         */
        public function promiseRemove (promise:IPromise):Supervisor {
            if (_promiseStateMap.removeKey(promise) !== undefined) {
                if (!_resolved) {
                    supervisorCallbackRemove(promise);
                    check();
                }
            }
            return this;
        }

        public function promiseIterator ():ICollectionIterator {
            return _promiseStateMap.keyIterator() as ICollectionIterator;
        }

        protected function promiseResolveCallback (promise:IPromise):void {
            _promiseStateMap.replaceFor(promise, true);
            supervisorCallbackRemove(promise);
            check();
        }


        protected function check (... args):IPromise {
            if (!_resolved) {
                var promiseIterator:IIterator = _promiseStateMap.iterator() as IIterator;
                while (promiseIterator.hasNext()) {
                    var promiseState:Boolean = promiseIterator.next();
                    if (!promiseState) {
                        return this;
                    }
                }

                // All promises are resolved
                super.resolve.apply(this, args);
                _resolved = true;
            }
            return this;
        }

        /**
         * Resolve all registered promises, with args, than resolve Supervisor.
         *
         * @param args Args to apply to callbacks.
         * @return this
         */
        override public function resolve (...args):IPromise {
            var promiseIterator:IIterator = _promiseStateMap.keyIterator();
            while (promiseIterator.hasNext()) {
                var promise:IPromise = promiseIterator.next();
                supervisorCallbackRemove(promise);
                promise.resolve.apply(null, args);
            }
            super.resolve.apply(this, args);
            _resolved = true;
            return this;
        }

        /**
         * Reset supervisor for reusing.
         *
         * @return this
         */
        public function reset ():Supervisor {
            var promiseIterator:IIterator = _promiseStateMap.keyIterator() as IIterator;
            while (promiseIterator.hasNext()) {
                var promise:IPromise = promiseIterator.next();
                if (_promiseStateMap.itemFor(promise)) {
                    _promiseStateMap.replaceFor(promise, false);
                    supervisorCallbackRegister(promise);
                }
            }
            _resolved = false;
            return this;
        }

        /**
         * Remove all registered promises.
         *
         * @return this
         */
        override public function clear ():IPromise {
            var promiseIterator:IMapIterator = _promiseStateMap.iterator() as IMapIterator;
            while (promiseIterator.hasNext()) {
                promiseIterator.next();
                var promise:IPromise = promiseIterator.key;
                supervisorCallbackRemove(promise);
                promiseIterator.remove();
            }
            _resolved = false;
            return super.clear();
        }

    }
}
