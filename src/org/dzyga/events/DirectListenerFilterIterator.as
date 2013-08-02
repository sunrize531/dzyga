package org.dzyga.events {
    import flash.events.IEventDispatcher;

    import org.as3commons.collections.framework.ICollection;
    import org.as3commons.collections.iterators.CollectionFilterIterator;

    /**
     * Filter for direct listeners.
     */
    internal class DirectListenerFilterIterator implements IStripIterator {
        private var _target:IEventDispatcher;
        private var _event:String;
        private var _callback:Function;
        private var _iterator:CollectionFilterIterator;
        private var _useCapture:*;

        public function DirectListenerFilterIterator (listenerMap:ICollection, target:IEventDispatcher = null, event:String = '', callback:Function = null, useCapture:* = undefined) {
            _target = target;
            _event = event;
            _callback = callback;
            _iterator = new CollectionFilterIterator(listenerMap, listenerFilter);
            _useCapture = useCapture;
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

        private function listenerFilter (eventListener:EventListener):Boolean {
            var re:Boolean =
                (!_target || eventListener.target == _target) &&
                    (!_event || eventListener.event == _event) &&
                    (_callback == null || eventListener.callback == _callback) &&
                    (_useCapture === undefined || eventListener.useCapture == _useCapture);
            return re;
        }
    }
}
