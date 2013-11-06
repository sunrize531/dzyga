package org.dzyga.callbacks {
    public class OnceTaskTest extends TaskTest {
        override protected function taskInit ():ITask {
            return new OnceTask();
        }


        [Test(expects="flash.errors.IllegalOperationError")]
        override public function testStart ():void {
            super.testStart();
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        override public function testNotify ():void {
            super.testNotify();
        }

        [Test]
        override public function testResolve ():void {
            super.testResolve();
        }

        [Test]
        override public function testReject ():void {
            super.testReject();
        }

        [Test]
        override public function testFinished ():void {
            super.testFinished();
        }
    }
}
