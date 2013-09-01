package org.dzyga.callback {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;

    public class TaskTest {
        private var _task:Task = new Task();
        private var _flag:Boolean = false;

        [Before]
        public function clear ():void {
            _task.clear();
            _flag = false;
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function testStart ():void {
            _task.started.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.STARTED, task.state);
                _flag = true;
            });
            _task.start();
            assertTrue(_flag);

            // Exception here...
            _task.start();
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function testNotify ():void {
            _task.progress.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.STARTED, task.state);
                _flag = true;
            });
            _task.start();
            _task.notify();
            assertTrue(_flag);
            _task.resolve();

            // Exception here...
            _task.notify();
        }


        [Test]
        public function testResolve ():void {
            _task.done.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.RESOLVED, task.state);
                _flag = true;
            });
            _task.resolve();
            assertTrue(_flag);
            assertEquals(TaskState.IDLE, _task.state);
        }

        [Test]
        public function testReject ():void {
            _task.failed.callbackRegister(function (task:ITask):void {
                assertEquals(TaskState.REJECTED, task.state);
                _flag = true;
            });
            _task.reject();
            assertTrue(_flag);
            assertEquals(TaskState.IDLE, _task.state);
        }

        [Test]
        public function testFinished ():void {
            _task.finished.callbackRegister(function (task:ITask):void {
                _flag = true;
            });
            _task.reject();
            assertTrue(_flag);

            _flag = false;
            _task.resolve();
            assertTrue(_flag);

            assertEquals(TaskState.IDLE, _task.state);
        }
    }
}
