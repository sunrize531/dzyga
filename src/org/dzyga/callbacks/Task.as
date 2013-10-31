package org.dzyga.callbacks {
    import flash.errors.IllegalOperationError;


    public class Task implements ITask {
        public function Task () {
        }

        /**
         * Override this method to generate different promise factory for this task.
         */
        protected var _promiseFactory:IPromiseTaskFactory;
        protected function initPromiseFactory ():IPromiseTaskFactory {
            return _promiseFactory = new PromiseTaskFactory();
        }

        protected final function get promiseFactory ():IPromiseTaskFactory {
            if (!_promiseFactory) {
                initPromiseFactory();
            }
            return _promiseFactory;
        }

        /**
         * @inheritDoc
         */
        public function get started ():IPromise {
            return promiseFactory.started;
        }

        /**
         * @inheritDoc
         */
        public function get done ():IPromise {
            return promiseFactory.done;
        }

        /**
         * @inheritDoc
         */
        public function get failed ():IPromise {
            return promiseFactory.failed;
        }

        /**
         * @inheritDoc
         */
        public function get finished ():IPromise {
            return promiseFactory.finished;
        }

        /**
         * @inheritDoc
         */
        public function get progress ():IPromise {
            return promiseFactory.progress;
        }

        protected var _state:String = TaskState.IDLE;

        /**
         * @inheritDoc
         */
        public function get state ():String {
            return _state;
        }

        /**
         * @inheritDoc
         */
        public function get running ():Boolean {
            return _state == TaskState.STARTED;
        }

        /**
         * Override this function to pass additional arguments to callback.
         *
         * @param promise
         * @param argsArray
         * @return
         */
        protected function resolvePromise (promise:IPromise, argsArray:Array):IPromise {
            if (promise) {
                promise.resolve.apply(null, argsArray);
            }
            return promise;
        }

        /**
         * @inheritDoc
         */
        public function start (...args):ITask {
            if (_state == TaskState.STARTED) {
                throw new IllegalOperationError('Reject or resolve the task first. Current state - ' + _state);
            }
            _state = TaskState.STARTED;
            resolvePromise(started, args);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function notify (...args):ITask {
            if (_state != TaskState.STARTED) {
                throw new IllegalOperationError('Start the task first. Current state - ' + _state);
            }
            resolvePromise(progress, args);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function resolve (...args):ITask {
            _state = TaskState.RESOLVED;
            resolvePromise(done, args);
            resolvePromise(finished, args);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function reject (...args):ITask {
            _state = TaskState.REJECTED;
            resolvePromise(failed, args);
            resolvePromise(finished, args);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function clear ():ITask {
            promiseFactory.clear();
            _state = TaskState.IDLE;
            return this;
        }

        /**
         * @inheritDoc
         */
        public function reset():ITask {
            promiseFactory.reset();
            _state = TaskState.IDLE;
            return this;
        }

        /**
         * @inheritDoc
         */
        public function startedCallbackRegister (callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):ITask {
            started.callbackRegister(callback, once, thisArg, argsArray);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function startedCallbackRemove (callback:Function):ITask {
            started.callbackRemove(callback);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function progressCallbackRegister (callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):ITask {
            progress.callbackRegister(callback, once, thisArg, argsArray);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function progressCallbackRemove (callback:Function):ITask {
            progress.callbackRemove(callback);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function doneCallbackRegister (callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):ITask {
            done.callbackRegister(callback, once, thisArg, argsArray);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function doneCallbackRemove (callback:Function):ITask {
            done.callbackRemove(callback);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function failedCallbackRegister (callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):ITask {
            failed.callbackRegister(callback, once, thisArg, argsArray);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function failedCallbackRemove (callback:Function):ITask {
            failed.callbackRemove(callback);
            return this;
        }
    }
}
