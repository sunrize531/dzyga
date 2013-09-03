/**
 * Created with IntelliJ IDEA.
 * User: sunrize
 * Date: 03.09.13
 * Time: 6:11
 * To change this template use File | Settings | File Templates.
 */
package org.dzyga.callbacks {
    import org.flexunit.asserts.assertEquals;

    public class SupervisorTest {
        private var _promise1:Promise;
        private var _promise2:Promise;
        private var _promise3:Promise;
        private var _supervisor:Supervisor;
        private var _supervisorCallbackCounter:int = 0;
        private var _promiseCallbackCounter:int = 0;


        private function supervisorCallback (inc:int = 1):void {
            _supervisorCallbackCounter += inc;
        }

        private function promiseCallback (inc:int = 1):void {
            _promiseCallbackCounter += inc;
        }

        public function promisesInit ():void {
        }

        [Before]
        public function setUp ():void {
            _promise1 = new Promise();
            _promise1.callbackRegister(promiseCallback, false, null, [1]);
            _promise2 = new Promise();
            _promise2.callbackRegister(promiseCallback, false, null, [2]);
            _promise3 = new Promise();
            _promise3.callbackRegister(promiseCallback, false, null, [4]);
            _supervisorCallbackCounter = 0;
            _promiseCallbackCounter = 0;
        }

        [After]
        public function tearDown ():void {
            if (_supervisor) {
                _supervisor.clear();
            }
            _supervisor = null;
            _promise1 = _promise2 = _promise3 = null;
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function testPromiseAdd ():void {
            _supervisor = new Supervisor();
            _supervisor.promiseAdd(_promise1).promiseAdd(_promise2).callbackRegister(supervisorCallback).resolve();
            assertEquals(3, _promiseCallbackCounter);
            assertEquals(1, _supervisorCallbackCounter);

            // IllegalOperationError here.
            _supervisor.promiseAdd(_promise3);
        }

        [Test]
        public function testPromiseRemove ():void {
            _supervisor = new Supervisor(_promise1, _promise2);
            _supervisor.callbackRegister(supervisorCallback);
            _promise1.resolve();

            // Supervisor should be resolved.
            _supervisor.promiseRemove(_promise2);
            assertEquals(1, _promiseCallbackCounter);
            assertEquals(1, _supervisorCallbackCounter);
        }

        [Test]
        public function testReset ():void {
            _supervisor = new Supervisor(_promise1, _promise2, _promise3);
            _supervisor.callbackRegister(supervisorCallback);
            _promise1.resolve();
            _promise2.resolve();
            _promise3.resolve();
            // Supervisor resolved
            assertEquals(1, _supervisorCallbackCounter);
            _supervisor.reset();
            _supervisor.resolve();
            // Supervisor and promises resolved again.
            assertEquals(2, _supervisorCallbackCounter);
            assertEquals(14, _promiseCallbackCounter);

        }
    }
}
