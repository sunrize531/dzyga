package org.dzyga.events {
    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IMap;
    import org.dzyga.collections.IStripIterator;

    /**
     * Iterate through all events for specified targetHash
     */
    internal class EventListenerIterator implements IStripIterator {
        private var _listenerMap:IMap;
        private var _targetHash:String;
        private var _targetListenerIterator:ICollectionIterator;


        public function EventListenerIterator (listenerMap:IMap, targetHash:String) {
            _listenerMap = listenerMap;
            _targetHash = targetHash;
        }

        public function hasNext ():Boolean {
            if (!_targetListenerIterator) {
                var targetListenerMap:TargetListenerMap = _listenerMap.itemFor(_targetHash);
                if (!targetListenerMap) {
                    return false;
                } else {
                    _targetListenerIterator = targetListenerMap.iterator() as ICollectionIterator;
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
    }
}
