package org.dzyga.events {
    import flash.events.IEventDispatcher;

    import org.as3commons.collections.framework.IMap;
    import org.as3commons.collections.iterators.CollectionFilterIterator;
    import org.as3commons.collections.iterators.FilterIterator;

    /**
     * Filter matched event listeners
     */
    internal class EventListenerFilteredIterator implements IStripIterator {
        private var _target:IEventDispatcher;
        private var _event:String;
        private var _callback:Function;
        private var _listenerMap:IMap;
        private var _targetIterator:FilterIterator;
        private var _targetListenerIterator:CollectionFilterIterator;

        public function EventListenerFilteredIterator (listenerMap:IMap, target:IEventDispatcher, event:String, callback:Function) {
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
                _targetIterator = new FilterIterator(_listenerMap, targetListenerFilter);
            }
            while (_targetIterator.hasNext()) {
                _targetListenerIterator = new CollectionFilterIterator(_targetIterator.next(), eventListenerFilter);
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

        private function targetListenerFilter (targetListener:TargetListenerMap):Boolean {
            return (!_target || targetListener.target == _target) &&
                (!_event || targetListener.event == _event);
        }

        private function eventListenerFilter (eventListener:EventListener):Boolean {
            return _callback == null || eventListener.callback == _callback;
        }
    }
}
