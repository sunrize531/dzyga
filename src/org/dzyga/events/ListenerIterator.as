package org.dzyga.events {
    import flash.events.IEventDispatcher;

    import org.as3commons.collections.framework.IMap;
    import org.dzyga.collections.IStripIterator;

    internal final class ListenerIterator implements IStripIterator {
        private var _iterator:IStripIterator;

        public function ListenerIterator (listenerMap:IMap, target:IEventDispatcher = null, event:String = '', callback:Function = null) {
            if (target && event) {
                var _targetHash:String = DispatcherProxy.targetHashGenerate(target, event);
                if (callback != null) {
                    var _listenerHash:String = DispatcherProxy.listenerHashGenerate(target, event, callback);
                    _iterator = new DistinctListenerIterator(listenerMap, _targetHash, _listenerHash);
                } else {
                    _iterator = new EventListenerIterator(listenerMap, _targetHash);
                }
            } else {
                _iterator = new EventListenerFilteredIterator(listenerMap, target, event, callback);
            }
        }

        public function hasNext ():Boolean {
            return _iterator.hasNext();
        }

        public function next ():* {
            return _iterator.next();
        }

        public function remove ():Boolean {
            return _iterator.remove();
        }
    }
}











