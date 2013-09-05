package org.dzyga.callbacks {
    import org.dzyga.callbacks.Promise;
    import org.flexunit.asserts.assertEquals;

    public class PromiseTest {
        private var _firstCounter:int = 0;
        private var _secondCounter:int = 0;


        [Before]
        public function before ():void {
            _firstCounter = 0;
            _secondCounter = 0;
        }

        [Test]
        public function testCallbackRegisterUniq ():void {
            var promise:Promise = new Promise();
            promise
                .callbackRegister(firstCallback, false, null, [2])
                .callbackRegister(firstCallback)
                .callbackRegister(secondCallback)
                .resolve();
            assertEquals(2, _firstCounter); // 3, if first callback added twice...
            assertEquals(1, _secondCounter);

            promise.clear();
        }

        [Test]
        public function testCallbackRegister ():void {
            var promise:Promise = new Promise(false);
            promise
                .callbackRegister(firstCallback, false, null, [2])
                .callbackRegister(firstCallback)
                .callbackRegister(secondCallback)
                .resolve();
            assertEquals(3, _firstCounter); // 3, if first callback added twice...
            assertEquals(1, _secondCounter);
        }

        [Test]
        public function testCallbackRemoveUniq ():void {
            var promise:Promise = new Promise();
            promise
                .callbackRegister(firstCallback)
                .callbackRegister(secondCallback)
                .callbackRemove(firstCallback)
                .resolve();
            assertEquals(0, _firstCounter);
            assertEquals(1, _secondCounter);
        }

        [Test]
        public function testCallbackRemove ():void {
            var promise:Promise = new Promise(false);
            promise
                .callbackRegister(firstCallback)
                .callbackRegister(firstCallback)
                .resolve();
            assertEquals(2, _firstCounter);
            promise
                .callbackRemove(firstCallback)
                .resolve();
            assertEquals(2, _firstCounter);
        }

        [Test]
        public function testCallbackReRegister ():void {
            var promise:Promise = new Promise();
            promise.callbackRegister(firstCallback)
                .resolve()
                .callbackRemove(firstCallback)
                .callbackRegister(firstCallback)
                .resolve();
            assertEquals(2, _firstCounter);
        }


        [Test]
        public function testCallbackRegisterOnce ():void {
            var promise:Promise = new Promise();
            promise
                .callbackRegister(firstCallback, true, null, [2])
                .resolve()
                .resolve();
            assertEquals(2, _firstCounter); // 4, if first callback hits twice...
        }

        [Test]
        public function testResolveArgs ():void {
            var promise:Promise = new Promise();
            promise
                .callbackRegister(firstCallback)
                .resolve(2)
                .resolve();
            assertEquals(3, _firstCounter);
        }


        private function firstCallback (inc:int = 1):void {
            _firstCounter += inc;
        }

        private function secondCallback (inc:int = 1):void {
            _secondCounter += inc;
        }
    }
}
