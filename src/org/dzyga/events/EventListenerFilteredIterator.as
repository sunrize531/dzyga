package org.dzyga.events {
    import flash.events.IEventDispatcher;
    import org.dzyga.collections.IIterator;
    import org.dzyga.collections.ISequenceIterator;
    import org.dzyga.collections.MapperIterator;
    import org.dzyga.collections.ObjectIterator;
    import org.dzyga.collections.SequenceFilterIterator;
    import org.dzyga.utils.IterUtils;

    /**
     * Filter matched event listeners
     */
    internal class EventListenerFilteredIterator implements ISequenceIterator {
        private var _target:IEventDispatcher;
        private var _event:String;
        private var _callback:Function;
        private var _listenerMap:Object;
        private var _targetIterator:IIterator;
        private var _targetListenerIterator:SequenceFilterIterator;

        public function EventListenerFilteredIterator (
                listenerMap:Object, target:IEventDispatcher, event:String, callback:Function) {
            _target = target;
            _event = event;
            _callback = callback;
            _listenerMap = listenerMap;
        }

        public function hasNext ():Boolean {
            if (_targetListenerIterator) {
                // Just pass to current _targetListenerIterator.
                if (_targetListenerIterator.hasNext()) {
                    return true;
                }
            }

            if (!_targetIterator) {
                // First call here...
                _targetIterator = IterUtils.filter(new ObjectIterator(_listenerMap), targetListenerFilter);
            }
            while (_targetIterator.hasNext()) {
                _targetListenerIterator = new SequenceFilterIterator(
                        _targetIterator.next().iterator(), eventListenerFilter);
                if (_targetListenerIterator.hasNext()) {
                    // We have matched events here...
                    return true;
                }
            }
            return false;
        }

        public function next ():* {
            if (_targetListenerIterator || hasNext()) {
                return _targetListenerIterator.next();
            }
            return undefined;
        }

        public function remove ():Boolean {
            if (_targetListenerIterator) {
                return _targetListenerIterator.remove();
            }
            return false;
        }

        private function targetListenerFilter (targetListener:TargetListenerSet):Boolean {
            return (!_target || targetListener.target == _target) &&
                (!_event || targetListener.event == _event);
        }

        private function eventListenerFilter (eventListener:EventListener):Boolean {
            return _callback == null || eventListener.callback == _callback;
        }

        public function reset ():void {
            _targetListenerIterator = null;
            _targetIterator = null;
        }
    }
}
