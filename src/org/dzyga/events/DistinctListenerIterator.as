package org.dzyga.events {
    import org.as3commons.collections.framework.IMap;
    import org.dzyga.collections.ISequenceIterator;

    /**
     * Iterate through one (yeah) event with specified _listenerHash
     */
    internal class DistinctListenerIterator implements ISequenceIterator {
        private var _targetHash:String;
        private var _listenerHash:String;
        private var _listenerMap:IMap;
        private var _targetListenerMap:TargetListenerMap;
        private var _next:EventListener;
        private var _current:EventListener;

        public function DistinctListenerIterator (listenerMap:IMap, targetHash:String, listenerHash:String) {
            _listenerMap = listenerMap;
            _targetHash = targetHash;
            _listenerHash = listenerHash;
        }

        public function hasNext ():Boolean {
            if (_current) {
                return false;
            }
            _targetListenerMap = _listenerMap.itemFor(_targetHash) as TargetListenerMap;
            if (!_targetListenerMap) {
                return false;
            } else {
                _next = _targetListenerMap.itemFor(_listenerHash);
                return Boolean(_next);
            }
        }

        public function next ():* {
            if (_next || hasNext()) {
                _current = _next;
            } else {
                _current = undefined;
            }
            return _current;
        }

        public function remove ():Boolean {
            if (_next || hasNext()) {
                _targetListenerMap.removeKey(_listenerHash);
                _current = undefined;
                return true;
            }
            return false;
        }
    }
}
