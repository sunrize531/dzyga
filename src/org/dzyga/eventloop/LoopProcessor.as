package org.dzyga.eventloop {

    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.getTimer;

    import org.as3commons.collections.LinkedList;
    import org.as3commons.collections.SortedSet;
    import org.dzyga.events.DispatcherProxy;

    import org.dzyga.events.IDispatcherProxy;

    public class LoopProcessor {
        public static const FRAME_ENTER_STATE:String = 'frame:enter';
        public static const FRAME_EXIT_STATE:String = 'frame:exit';
        public static const IDLE_STATE:String = 'idle';
        public static const FRAME_ENTER_THRESHOLD:Number = 0.7;
        public static const FRAME_EXIT_THRESHOLD:Number = 0.3;


        private var _fps:Number;
        private var _stage:Stage;
        private var _state:String;
        private var _frameTime:Number = 0;
        private var _dispatcher:IDispatcherProxy;

        public function init (dispatcher:IEventDispatcher, fps:Number = NaN):void {
            if (_dispatcher) {
                throw new IllegalOperationError('Loop already initialized.');
            }
            if (dispatcher is Stage) {
                _stage = dispatcher as Stage;
            } else if (dispatcher is DisplayObject) {
                _stage = DisplayObject(dispatcher).stage;
            }
            if (!_stage && isNaN(fps)) {
                throw new IllegalOperationError('Stage or fps should be specified.');
            }
            _dispatcher = (new DispatcherProxy(dispatcher))
                    .listen(Event.ENTER_FRAME, frameEnterHandler)
                    .listen(Event.EXIT_FRAME, frameExitHandler);
            if (!isNaN(fps)) {
                _fps = fps;
            }
        }

        public function get fps ():Number {
            return _fps || _stage.frameRate;
        }

        private var _frameEnterCallbackCollection:SortedSet = new SortedSet(new LoopCallbackComparator());
        private var _delayedCallbackCollection:SortedSet = new SortedSet(new LoopCallbackDelayedComparator());
        private var _immediateCallbackCollection:LinkedList = new LinkedList();
        private var _frameExitCallbackCollection:SortedSet = new SortedSet(new LoopCallbackComparator());
        private var _callbackIterator:LoopCallbackIterator = new LoopCallbackIterator();

        public function get frameTime ():Number {
            return _frameTime;
        }

        public function get state ():String {
            return _state;
        }

        protected function callbackCollectionListProcess (
                callbackIterator:LoopCallbackIterator, frameTime:Number):void {
            _frameTime = getTimer();
            var elapsedTime:Number = 0;
            while (callbackIterator.hasNext()) {
                var callback:ILoopCallback = callbackIterator.next();
                if (callback.canceled) {
                    callbackIterator.remove();
                } else if (callback.timeout <= _frameTime && (!callback.priority || elapsedTime < frameTime)) {
                    callback.call();
                    if (callback.once) {
                        callback.cancel();
                        callbackIterator.remove();
                    }
                }
                elapsedTime = getTimer() - _frameTime;
            }
        }

        protected function frameEnterProcess (frameTime:Number):void {
            _state = FRAME_ENTER_STATE;
            _callbackIterator.setCallbackCollection(
                    _frameEnterCallbackCollection, _delayedCallbackCollection, _immediateCallbackCollection);
            callbackCollectionListProcess(_callbackIterator, frameTime);
            _immediateCallbackCollection.clear();
            _state = IDLE_STATE;
        }

        protected function frameExitProcess (frameTime:Number):void {
            _state = FRAME_EXIT_STATE;
            _callbackIterator.setCallbackCollection(_frameExitCallbackCollection);
            callbackCollectionListProcess(_callbackIterator, frameTime);
            _state = IDLE_STATE;
        }

        protected function frameEnterHandler (e:Event):void {
            frameEnterProcess(1000 / fps * FRAME_ENTER_THRESHOLD);
        }

        protected function frameExitHandler (e:Event):void {
            frameExitProcess(1000 / fps * FRAME_EXIT_THRESHOLD);
        }

        public function get frameEnterCallbackCollection ():SortedSet {
            return _frameEnterCallbackCollection;
        }

        public function get delayedCallbackCollection ():SortedSet {
            return _delayedCallbackCollection;
        }

        public function get immediateCallbackCollection ():LinkedList {
            return _immediateCallbackCollection;
        }

        public function get frameExitCallbackCollection ():SortedSet {
            return _frameExitCallbackCollection;
        }

        public function get callbackIterator ():LoopCallbackIterator {
            return _callbackIterator;
        }
    }
}
