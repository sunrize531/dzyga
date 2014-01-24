package org.dzyga.callbacks {
    import flash.errors.IllegalOperationError;

    public class StackTasks extends OnceTask {
        private var _breakIfFail:Boolean;
        private var _taskStack:Array = [];
        private var _currentTask:Task;
        private var _currentIndex:int = 0;
        private var _progress:Number;

        public function StackTasks (breakIfFail:Boolean) {
            _breakIfFail = breakIfFail;
        }

        public function taskAdd (task:ITask, ...args):StackTasks {
            if (_state == TaskState.REJECTED || _state == TaskState.RESOLVED) {
                throw new IllegalOperationError('Cannot add more promises. StackTasks finished. ' +
                    'Reset it to add more promises');
            }
            _taskStack.push([task, args]);
            return this;
        }


        override public function start (...args):ITask {
            super.start(args);
            next();
            return this;
        }

        private function next ():void {
            if (_taskStack.length == _currentIndex) {
                _progress = 1;
                progress.resolve();
                resolve();
            } else {
                var data:Array = _taskStack[_currentIndex];
                _currentTask = data[0];
                _progress = _taskStack.length / _currentIndex
                progress.resolve();
                _currentIndex++;
                _currentTask.doneCallbackRegister(next).failedCallbackRegister(fail).start.apply(null, data[1]);
            }
        }

        private function fail ():void {
            if (_breakIfFail) {
                reject();
            } else {
                next();
            }
        }

        public function get taskStack ():Array {
            return _taskStack;
        }

        public function get breakIfFail ():Boolean {
            return _breakIfFail;
        }

        public function get currentTask ():Task {
            return _currentTask;
        }
    }
}
