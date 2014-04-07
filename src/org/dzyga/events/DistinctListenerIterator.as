package org.dzyga.events {
    import org.dzyga.collections.ISequenceIterator;

    /**
     * Iterate through one (yeah) event within specified _listenerHash
     */
    internal class DistinctListenerIterator implements ISequenceIterator {
        private var _targetHash:String;
        private var _listenerHash:String;
        private var _listenerMap:Object;
        private var _targetListenerSet:TargetListenerSet;
        private var _next:EventListener;
        private var _current:EventListener;

        public function DistinctListenerIterator (listenerMap:Object, targetHash:String, listenerHash:String) {
            _listenerMap = listenerMap;
            _targetHash = targetHash;
            _listenerHash = listenerHash;
        }

        public function hasNext ():Boolean {
            if (_current) {
                return false;
            }
            _targetListenerSet = _listenerMap[_targetHash];
            if (!_targetListenerSet) {
                return false;
            } else {
                _next = _targetListenerSet.getEqualItem(_listenerHash);
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
                _targetListenerSet.remove(_listenerHash);
                _current = undefined;
                return true;
            }
            return false;
        }

        public function reset ():void {
            _current = undefined;
        }
    }
}
