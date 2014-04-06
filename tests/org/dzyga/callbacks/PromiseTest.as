package org.dzyga.callbacks {
    import org.flexunit.asserts.assertEquals;

    public class PromiseTest {
        protected var _firstCounter:int = 0;
        protected var _secondCounter:int = 0;
        protected var _multipleCounter:int = 0;

        protected function getPromise(uniq:Boolean = true):IPromise {
            return new Promise(uniq);
        }

        [Before]
        public function before ():void {
            _firstCounter = 0;
            _secondCounter = 0;
            _multipleCounter = 0;
        }

        [Test]
        public function testCallbackRegisterUniq ():void {
            var promise:IPromise = getPromise();
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
            var promise:IPromise = getPromise(false);
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
            var promise:IPromise = getPromise();
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
            var promise:IPromise = getPromise(false);
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
            var promise:IPromise = getPromise();
            promise.callbackRegister(firstCallback)
                .resolve()
                .callbackRemove(firstCallback)
                .callbackRegister(firstCallback)
                .resolve();
            assertEquals(2, _firstCounter);
        }


        [Test]
        public function testCallbackRegisterOnce ():void {
            var promise:IPromise = getPromise();
            promise
                .callbackRegister(firstCallback, true, null, [2])
                .resolve()
                .resolve();
            assertEquals(2, _firstCounter); // 4, if first callback hits twice...
        }

        [Test]
        public function testResolveArgs ():void {
            var promise:IPromise = getPromise();
            promise
                .callbackRegister(firstCallback)
                .callbackRegister(multipleArgsCallback, false, null, [1, 1, 1])
                .resolve(2)
                .resolve();
            assertEquals(3, _firstCounter);
            assertEquals(8, _multipleCounter);
        }


        protected function firstCallback (inc:int = 1):void {
            _firstCounter += inc;
        }

        protected function secondCallback (inc:int = 1):void {
            _secondCounter += inc;
        }

        protected function multipleArgsCallback (... args):void {
            for each (var i:int in args) {
                _multipleCounter += i;
            }
        }
    }
}
