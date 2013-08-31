package org.dzyga.events {
    import flash.errors.IllegalOperationError;

    import org.dzyga.utils.ArrayUtils;

    public class Task implements ITask {
        public function Task () {
        }

        /**
         * Override this function to replace promise with subclass.
         *
         * @param promise
         * @return
         */
        protected static function getPromise (promise:IPromise):IPromise {
            return promise || new Promise();
        }

        // Be lazy
        protected var _started:IPromise;

        /**
         * @inheritDoc
         */
        public function get started ():IPromise {
            _started = getPromise(_started);
            return _started;
        }

        protected var _done:IPromise;

        /**
         * @inheritDoc
         */
        public function get done ():IPromise {
            _done = getPromise(_done);
            return _done;
        }

        protected var _failed:IPromise;

        /**
         * @inheritDoc
         */
        public function get failed ():IPromise {
            _failed = getPromise(_failed);
            return _failed;
        }

        protected var _finished:IPromise;

        /**
         * @inheritDoc
         */
        public function get finished ():IPromise {
            _finished = getPromise(_finished);
            return _finished;
        }

        protected var _progress:IPromise;

        /**
         * @inheritDoc
         */
        public function get progress ():IPromise {
            _progress = getPromise(_progress);
            return _progress;
        }

        protected var _state:String = TaskState.IDLE;

        /**
         * @inheritDoc
         */
        public function get state ():String {
            return _state;
        }


        /**
         * Override this function to pass additional arguments to promise.
         *
         * @param promise
         * @param argsArray
         * @return
         */
        protected function resolvePromise (promise:IPromise, argsArray:Array):IPromise {
            if (promise) {
                promise.resolve.apply(null, ArrayUtils.add([this], argsArray));
            }
            return promise;
        }

        /**
         * @inheritDoc
         */
        public function start (...args):ITask {
            if (_state !== TaskState.IDLE) {
                throw new IllegalOperationError('Reject or resolve the task first. Current state - ' + _state);
            }
            _state = TaskState.STARTED;
            resolvePromise(_started, args);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function notify (...args):ITask {
            if (_state !== TaskState.IDLE) {
                throw new IllegalOperationError('Start the task first. Current state - ' + _state);
            }
            resolvePromise(_progress, args);
            return this;
        }

        /**
         * @inheritDoc
         */
        public function resolve (...args):ITask {
            _state = TaskState.RESOLVED;
            resolvePromise(_done, args);
            resolvePromise(_finished, args);
            _state = TaskState.IDLE;
            return this;
        }

        /**
         * @inheritDoc
         */
        public function reject (...args):ITask {
            _state = TaskState.REJECTED;
            resolvePromise(_failed, args);
            resolvePromise(_finished, args);
            _state = TaskState.IDLE;
            return this;
        }

        protected function clearPromise (promise:IPromise):IPromise {
            if (promise) {
                promise.clear();
            }
            return promise;
        }

        /**
         * @inheritDoc
         */
        public function clear ():ITask {
            clearPromise(_started);
            clearPromise(_progress);
            clearPromise(_done);
            clearPromise(_failed);
            clearPromise(_finished);
            _started = _progress = _done = _failed = _finished = undefined;
            _state = TaskState.IDLE;
            return this;
        }
    }
}