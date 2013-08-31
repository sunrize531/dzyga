package org.dzyga.events {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.getTimer;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;
    import org.flexunit.async.Async;

    public class LoopTest {

        private static var _dispatcher:EventDispatcher;
        private static var _loop:Loop;

        [BeforeClass]
        public static function initLoop ():void {
            _dispatcher = new EventDispatcher();
            _loop = new LoopSubclass();
            LoopSubclass.initLoop(_dispatcher, 25);
        }


        private static function frameEnterTrigger ():void {
            _dispatcher.dispatchEvent(new Event(Event.ENTER_FRAME));
        }

        private static function frameExitTrigger ():void {
            _dispatcher.dispatchEvent(new Event(Event.EXIT_FRAME));
        }

        private var _frameEnterCounter:Number = 0;
        private var _frameExitCounter:Number = 0;
        private var _fuckingSlowCounter:Number = 0;
        private var _callCounter:Number = 0;

        [Before]
        public function reset ():void {
            _frameEnterCounter = 0;
            _frameExitCounter = 0;
            _fuckingSlowCounter = 0;
            _callCounter = 0;
            _loop.clear();
        }

        private function frameEnterCallback (i:Number = 1):Number {
            _frameEnterCounter += i;
            return i;
        }

        private function frameExitCallback (i:Number = 1):Number {
            _frameExitCounter += i;
            return i;
        }

        private static function wait (time:Number):void {
            var ts:Number = getTimer();
            while (true) {
                if (getTimer() - ts > time) {
                    break;
                }
            }
        }

        private static const FUCKING_SLOW_TIMEOUT:Number = 1000;
        private function fuckingSlowCallback (i:Number = 1):Number {
            wait(FUCKING_SLOW_TIMEOUT);
            _fuckingSlowCounter += i;
            return i;
        }

        /**
         * Just test call
         */
        [Test]
        public function testFrameEnterCall ():void {
            var firstCallback:ILoopCallback = _loop.frameEnterCall(frameEnterCallback, 1);
            var secondCallback:ILoopCallback = _loop.frameEnterCall(frameEnterCallback, 1, null, [2]);

            // Both callbacks executed
            frameEnterTrigger();
            assertEquals(3, _frameEnterCounter);
            assertEquals(1, firstCallback.result);
            assertEquals(2, secondCallback.result);

            // Cancel the first callback.
            firstCallback.cancel();

            // Only secondCallback executed.
            frameEnterTrigger();
            assertEquals(5, _frameEnterCounter);

            // Test fucking slow callback
            // We have secondCallback, registered with priority 1.
            // First add slow callback with priority 0, and see that only FSC executed.
            var slowCallback:ILoopCallback = _loop.frameEnterCall(fuckingSlowCallback, 0);
            frameEnterTrigger();
            assertEquals(5, _frameEnterCounter);
            assertEquals(1, _fuckingSlowCounter);
            assertEquals(1, slowCallback.result);

            // Now cancel FSC, and re-add it with priority 3. Both registered callbacks should be executed now.
            slowCallback.cancel();
            slowCallback = _loop.frameEnterCall(fuckingSlowCallback, 3);
            frameEnterTrigger();
            assertEquals(7, _frameEnterCounter);
            assertEquals(2, _fuckingSlowCounter);
        }

        [Test]
        public function testFrameExitCall ():void {
            // Should work absolutely the same as frameEnterCall. So, only the first part here,
            // just verify that event is processed by loop correctly.

            var firstCallback:ILoopCallback = _loop.frameExitCall(frameExitCallback, 1);
            var secondCallback:ILoopCallback = _loop.frameExitCall(frameExitCallback, 1, null, [2]);

            // Both callbacks executed
            frameExitTrigger();
            assertEquals(3, _frameExitCounter);
            assertEquals(1, firstCallback.result);
            assertEquals(2, secondCallback.result);
        }

        private static const DELAYED_CALLBACK_EVENT:String = 'DELAYED_CALLBACK';
        private static const DELAY:Number = 1000;
        private function delayedCallback ():void {
            _dispatcher.dispatchEvent(new Event(DELAYED_CALLBACK_EVENT));
        }

        [Test(async, timeout=2000)]
        public function testDelayedCall ():void {
            Async.proceedOnEvent(this, _dispatcher, DELAYED_CALLBACK_EVENT);
            _loop.delayedCall(delayedCallback, DELAY);
            wait(DELAY + 100);
            frameEnterTrigger();
        }


        private function callCallback (i:Number = 1, chain:Boolean = false):Number {
            _callCounter += i;
            if (chain) {
                _loop.call(callCallback, 10, null, [1, false]);
            }
            return i;
        }

        [Test]
        public function testCall ():void {
            // Just test execution
            var firstCallback:ILoopCallback = _loop.call(callCallback, 1);
            var secondCallback:ILoopCallback = _loop.call(callCallback, 1, null, [2]);
            frameEnterTrigger();
            frameEnterTrigger();
            assertEquals(3, _callCounter);
            frameEnterTrigger();
            assertEquals(3, _callCounter);

            // Test chained call
            firstCallback = _loop.call(callCallback, 1, null, [2, true]);
            frameEnterTrigger();
            // callCallback should add itself back to the loop. Chained callback should be executed in the same frame.
            assertEquals(6, _callCounter);
            frameEnterTrigger();
            assertEquals(6, _callCounter);

            // Test call with FSC.
            firstCallback = _loop.call(callCallback, 2);
            secondCallback = _loop.call(fuckingSlowCallback, 1);
            frameEnterTrigger();
            // fuckingSlowCallback executed, firstCallback not yet.
            assertEquals(1, _fuckingSlowCounter);
            assertEquals(6, _callCounter);

            frameEnterTrigger();
            // firstCallback executed.
            assertEquals(7, _callCounter);
            assertEquals(1, _fuckingSlowCounter);
        }

        [Test]
        public function testWillCall ():void {
            _loop.call(callCallback);
            assertTrue(_loop.willCall(callCallback));
            frameEnterTrigger();
            assertFalse(_loop.willCall(callCallback));
        }
    }
}
