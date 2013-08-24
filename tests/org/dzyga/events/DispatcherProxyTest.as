package org.dzyga.events {
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import org.flexunit.asserts.assertEquals;

    public class DispatcherProxyTest {
        private var _listenerFirstCounter:int = 0;
        private var _listenerSecondCounter:int = 0;
        private var _dispatcherProxy:DispatcherProxy;

        public function DispatcherProxyTest () {
            _dispatcherProxy = new DispatcherProxy(new EventDispatcher());
        }

        [Before]
        public function before ():void {
            _listenerFirstCounter = 0;
            _listenerSecondCounter = 0;
        }

        private function listenerFirstCallback (e:Event, inc:int=0):void {
            trace('listenerFirstCallback: ' + e);
            _listenerFirstCounter++;
            _listenerFirstCounter += inc;
        }

        private function listenerSecondCallback (e:Event):void {
            trace('listenerSecondCallback: ' + e);
            _listenerSecondCounter++;
        }


        [Test]
        public function testDirectEventListener ():void {
            _dispatcherProxy.addEventListener(Event.ACTIVATE, listenerFirstCallback);
            _dispatcherProxy.addEventListener(Event.ACTIVATE, listenerFirstCallback);
            _dispatcherProxy.addEventListener(Event.ACTIVATE, listenerSecondCallback);
            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(2, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);


            _dispatcherProxy.removeEventListener(Event.ACTIVATE, listenerFirstCallback);
            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(2, _listenerFirstCounter);
            assertEquals(2, _listenerSecondCounter);
            _dispatcherProxy.removeEventListener(Event.ACTIVATE, listenerSecondCallback);
            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(2, _listenerSecondCounter);
        }

        [Test]
        public function testListen ():void {
            _dispatcherProxy
                .listen(Event.ACTIVATE, listenerFirstCallback)
                .listen(Event.ACTIVATE, listenerFirstCallback)
                .listen(Event.ACTIVATE, listenerSecondCallback);

            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);
            _dispatcherProxy
                .stopListening(Event.ACTIVATE)
                .dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);
        }

        [Test]
        public function testStopListening ():void {
            _dispatcherProxy.listen(Event.ACTIVATE, listenerFirstCallback);
            _dispatcherProxy.addEventListener(Event.ACTIVATE, listenerSecondCallback);
            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);

            _dispatcherProxy.stopListening();
            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);
        }

        [Test]
        public function testListenOnce ():void {
            _dispatcherProxy.listen(Event.ACTIVATE, listenerFirstCallback, true);
            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            _dispatcherProxy.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
        }

        [Test]
        public function testArgsArray ():void {
            _dispatcherProxy
                .listen(Event.ACTIVATE, listenerFirstCallback, false, null, [2])
                .trigger(Event.ACTIVATE);
            assertEquals(3, _listenerFirstCounter);
        }
    }
}
