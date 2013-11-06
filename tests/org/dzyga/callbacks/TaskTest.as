package org.dzyga.callbacks {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;

    public class TaskTest {
        private var _task:ITask;
        protected function taskInit ():ITask {
            return new Task();
        }


        protected function get task ():ITask {
            if (!_task) {
                _task = taskInit();
            }
            return _task;
        }

        private var _flag:Boolean = false;

        [Before]
        public function clear ():void {
            task.clear();
            _flag = false;
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function testStart ():void {
            task.started.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.STARTED, task.state);
                _flag = true;
            }, false, null, [task]);
            task.start();
            assertTrue(_flag);

            // Exception here...
            task.start();
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function testNotify ():void {
            task.progress.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.STARTED, task.state);
                _flag = true;
            }, false, null, [task]);
            task.start();
            task.notify();
            assertTrue(_flag);
            task.resolve();

            // Exception here...
            task.notify();
        }


        [Test]
        public function testResolve ():void {
            task.done.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.RESOLVED, task.state);
                _flag = true;
            }, true, null, [task]);
            task.resolve();
            assertTrue(_flag);
            assertEquals(TaskState.RESOLVED, task.state);
        }

        [Test]
        public function testReject ():void {
            task.failed.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.REJECTED, task.state);
                _flag = true;
            }, true, null, [task]);
            task.reject();
            assertTrue(_flag);
            assertEquals(TaskState.REJECTED, task.state);
        }

        [Test]
        public function testFinished ():void {
            task.finished.callbackRegister(function (task:ITask):void {
                _flag = true;
            }, false, null, [task]);
            task.reject();
            assertTrue(_flag);

            _flag = false;
            task.resolve();
            assertTrue(_flag);

            assertEquals(TaskState.RESOLVED, task.state);
        }
    }
}
