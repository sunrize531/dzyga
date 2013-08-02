package org.dzyga.events {
    import flash.events.Event;
    import flash.events.EventDispatcher;

    import org.flexunit.asserts.assertEquals;

    public class EventBridgeTest {
        private var _listenerFirstCounter:int = 0;
        private var _listenerSecondCounter:int = 0;
        private var _eventBridge:EventBridge;

        public function EventBridgeTest () {
            _eventBridge = new EventBridge(new EventDispatcher());
        }

        [Before]
        public function before ():void {
            _listenerFirstCounter = 0;
            _listenerSecondCounter = 0;
        }

        private function listenerFirstCallback (e:Event):void {
            trace('listenerFirstCallback: ' + e);
            _listenerFirstCounter++;
        }

        private function listenerSecondCallback (e:Event):void {
            trace('listenerSecondCallback: ' + e);
            _listenerSecondCounter++;
        }


        [Test]
        public function testDirectEventListener ():void {
            _eventBridge.addEventListener(Event.ACTIVATE, listenerFirstCallback);
            _eventBridge.addEventListener(Event.ACTIVATE, listenerFirstCallback);
            _eventBridge.addEventListener(Event.ACTIVATE, listenerSecondCallback);
            _eventBridge.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(2, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);


            _eventBridge.removeEventListener(Event.ACTIVATE, listenerFirstCallback);
            _eventBridge.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(2, _listenerFirstCounter);
            assertEquals(2, _listenerSecondCounter);
            _eventBridge.removeEventListener(Event.ACTIVATE, listenerSecondCallback);
            _eventBridge.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(2, _listenerSecondCounter);
        }

        [Test]
        public function testListen ():void {
            _eventBridge.listen(Event.ACTIVATE, listenerFirstCallback);
            _eventBridge.listen(Event.ACTIVATE, listenerFirstCallback);
            _eventBridge.listen(Event.ACTIVATE, listenerSecondCallback);
            _eventBridge.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);
            _eventBridge.stopListening(Event.ACTIVATE);
            _eventBridge.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);
        }

        [Test]
        public function testStopListening ():void {
            _eventBridge.listen(Event.ACTIVATE, listenerFirstCallback);
            _eventBridge.addEventListener(Event.ACTIVATE, listenerSecondCallback);
            _eventBridge.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);

            _eventBridge.stopListening();
            _eventBridge.dispatchEvent(new Event(Event.ACTIVATE));
            assertEquals(1, _listenerFirstCounter);
            assertEquals(1, _listenerSecondCounter);
        }
    }
}
