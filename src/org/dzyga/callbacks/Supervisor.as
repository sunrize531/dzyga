package org.dzyga.callbacks {
    import flash.errors.IllegalOperationError;

    import org.as3commons.collections.LinkedSet;
    import org.as3commons.collections.Map;
    import org.as3commons.collections.framework.IIterator;

    public class Supervisor extends Task {
        public function Supervisor (... args) {
            for each (var i:* in args) {
                add(i);
            }
        }

        protected var _operativeList:LinkedSet = new LinkedSet();
        protected var _callbackList:LinkedSet = new LinkedSet();

        protected function supervisorCallbackRegister (
                promise:IPromise, subject:*, callback:Function):SupervisorCallback {
            var supervisorCallback:SupervisorCallback = new SupervisorCallback(subject, callback);
            promise.callbackList.add(supervisorCallback);
            _callbackList.add(supervisorCallback);
            return supervisorCallback;
        }

        protected var _taskStateMap:Map = new Map();

        /**
         * Add task to Supervisor. Supervisor will wait till task is resolved or rejected.
         * When all tasks and promises resolved at least once - Supervisor will be resolved.
         * If one of the tasks rejected - Supervisor will rejected.
         * If there are
         *
         * @param task
         * @return
         */
        public function taskAdd (task:ITask):Supervisor {
            if (_state == TaskState.RESOLVED || _state == TaskState.REJECTED) {
                throw IllegalOperationError('Could not add Task. Invalid Supervisor state: ' + state);
            }

            _operativeList.add(task);

            supervisorCallbackRegister(task.started, task, taskStartedCallback);
            supervisorCallbackRegister(task.done, task, taskDoneCallback);
            supervisorCallbackRegister(task.failed, task, taskFailedCallback);
            supervisorCallbackRegister(task.progress, task, taskProgressCallback);

            check();
            return this;
        }

        protected var _promiseStateMap:Map = new Map();

        public function promiseAdd (promise:IPromise):Supervisor {
            _promiseStateMap.add(promise, false);
            _operativeList.add(promise);
            supervisorCallbackRegister(promise, promise, promiseResolveCallback);
            if (state == TaskState.IDLE) {
                super.start();
            }
            return this;
        }

        /**
         * Add Task or Promise to the Supervisor.
         * If you are adding Promise and Supervisor is not started yet - Supervisor will start.
         * If you are adding Task in started state, and Supervisor is not started - Supervisor will start.
         * Otherwise Supervisor will start after the first of added Tasks started.
         * Supervisor will notify when each of the registered Tasks resolves it's progress promise.
         * Supervisor will be rejected when one of registered Tasks rejected.
         * Supervisor will be resolved when all registered Tasks and Promises was resolved.
         * If you are adding Task in resolved state, and
         *
         * @param object Task or Promise instance.
         * @return this
         */
        public function add (object:*):Supervisor {
            if (object is IPromise) {
                promiseAdd(object);
            } else if (object is ITask) {
                taskAdd(object);
            }
            return this;
        }

        /**
         * Check supervisor state. If all tasks was resolved at least once - resolve supervisor instance.
         *
         * @param args
         * @return
         */
        public function check (... args):Supervisor {
            var resolved:Boolean = true;
            var operativeIterator:IIterator = _operativeList.iterator();
            while (operativeIterator.hasNext()) {
                var operative:* = operativeIterator.hasNext();
                if (operative is ITask) {
                    resolved &= _taskStateMap.itemFor(operative);
                } else if (operative is IPromise) {
                    resolved &= _promiseStateMap.itemFor(operative);
                }
                if (!resolved) {
                    return this;
                }
            }
            return super.resolve.apply(this, args);
        }

        protected function taskDoneCallback (task:ITask):void {
            var currentTaskState:String = _taskStateMap.itemFor(task);
            if (currentTaskState != TaskState.REJECTED) {
                _taskStateMap.replaceFor(task, TaskState.RESOLVED);
                check();
            }
        }

        protected function taskFailedCallback (task:ITask):void {
            _taskStateMap.replaceFor(task, TaskState.REJECTED);
            super.reject();
        }

        protected function taskStartedCallback (task:ITask):void {
            if (state == TaskState.IDLE) {
                super.start();
            }
        }

        protected function taskProgressCallback (... args):void {
            check();
        }

        protected function promiseResolveCallback (promise:IPromise):void {
            _promiseStateMap.replaceFor(promise, true);
            check();
        }

        /**
         * Start Supervisor, if applicable. Also call start on all registered tasks which are in IDLE state.
         *
         * @param args
         * @return
         */
        override public function start (...args):ITask {
            super.start.apply(this, args);
            return this;
        }

        /**
         * Resolve all registered promises and tasks, which can be resolved.
         * If not all of registered tasks can be resolved, or resolved already,
         * will throw IllegalOperationError.
         *
         * @param args
         * @return this
         * @throws IllegalOperationError Not all tasks can be resolved, or resolved already.
         */
        override public function resolve (...args):ITask {
            super.resolve.apply(this, args);
            // Resolve operatives
            var operativeIterator:IIterator = _operativeList.iterator();
            while (operativeIterator.hasNext()) {
                var operative:* = operativeIterator.next();

            }
            return this;
        }

        /**
         * Reject Supervisor. Also attempt to reject all registered tasks.
         *
         * @param args
         * @return
         */
        override public function reject (...args):ITask {
            super.reject.apply(this, args);
            return null;
        }
    }
}
