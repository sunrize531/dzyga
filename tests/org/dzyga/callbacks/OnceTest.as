package org.dzyga.callbacks {
    import org.flexunit.asserts.assertEquals;

    public class OnceTest extends PromiseTest {

        override protected function getPromise (uniq:Boolean = true):IPromise {
            return new Once(uniq);
        }

        [Before]
        override public function before ():void {
            super.before();
        }

        [Test]
        override public function testCallbackRegisterUniq ():void {
            super.testCallbackRegisterUniq();
        }

        [Test]
        override public function testCallbackRegister ():void {
            super.testCallbackRegister();
        }

        [Test]
        override public function testCallbackRemoveUniq ():void {
            super.testCallbackRemoveUniq();
        }

        [Test]
        override public function testCallbackRemove ():void {
            super.testCallbackRemove();
        }

        [Test]
        override public function testCallbackReRegister ():void {
            var promise:IPromise = getPromise();
            promise.callbackRegister(firstCallback)
                    .resolve()
                    .callbackRemove(firstCallback)
                    .callbackRegister(firstCallback);
            assertEquals(2, _firstCounter);
        }

        [Test]
        override public function testCallbackRegisterOnce ():void {
            super.testCallbackRegisterOnce();
        }

        [Test]
        override public function testResolveArgs ():void {
            super.testResolveArgs();
        }

        [Test]
        public function testResolveOnceArgs ():void {
            var promise:IPromise = getPromise();
            promise.callbackRegister(multipleArgsCallback, false, null, [1, 2])
                    .resolve(3);
            assertEquals(6, _multipleCounter);
            _multipleCounter = 0;
            promise.callbackRegister(multipleArgsCallback, false, null, [1]);
            assertEquals(4, _multipleCounter);
        }
    }
}
