package org.dzyga.events {
    import org.dzyga.collections.ISequenceIterator;

    /**
     * Iterate through all events for specified targetHash
     */
    internal class EventListenerIterator implements ISequenceIterator {
        private var _listenerMap:Object;
        private var _targetHash:String;
        private var _targetListenerIterator:ISequenceIterator;


        public function EventListenerIterator (listenerMap:Object, targetHash:String) {
            _listenerMap = listenerMap;
            _targetHash = targetHash;
        }

        public function hasNext ():Boolean {
            if (!_targetListenerIterator) {
                var targetListenerSet:TargetListenerSet = _listenerMap[_targetHash];
                if (!targetListenerSet) {
                    return false;
                } else {
                    _targetListenerIterator = targetListenerSet.iterator() as ISequenceIterator;
                }
            }
            return _targetListenerIterator.hasNext();
        }

        public function next ():* {
            if (_targetListenerIterator) {
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

        public function reset ():void {
            _targetListenerIterator = null;
        }
    }
}
