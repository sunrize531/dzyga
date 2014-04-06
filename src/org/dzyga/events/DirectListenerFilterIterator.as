package org.dzyga.events {
    import flash.events.IEventDispatcher;

    import org.dzyga.collections.ICollection;
    import org.dzyga.collections.IIterable;
    import org.dzyga.collections.ISequence;
    import org.dzyga.collections.ISequenceIterator;
    import org.dzyga.collections.SequenceFilterIterator;

    /**
     * Filter for direct listeners.
     */
    internal class DirectListenerFilterIterator implements ISequenceIterator {
        private var _target:IEventDispatcher;
        private var _event:String;
        private var _callback:Function;
        private var _iterator:SequenceFilterIterator;
        private var _useCapture:*;

        public function DirectListenerFilterIterator (
                listeners:IIterable, target:IEventDispatcher = null,
                event:String = '', callback:Function = null, useCapture:* = undefined) {
            _target = target;
            _event = event;
            _callback = callback;
            _iterator = new SequenceFilterIterator(listeners.iterator(), listenerFilter);
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

        public function reset ():void {
        }
    }
}
