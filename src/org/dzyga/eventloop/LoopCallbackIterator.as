package org.dzyga.eventloop {
    import org.dzyga.collections.ICollection;
    import org.dzyga.collections.IIterator;
    import org.dzyga.collections.ISequenceIterator;
    import org.dzyga.collections.List;

    internal class LoopCallbackIterator implements ISequenceIterator {
        private var _callbackCollectionList:List = new List();
        private var _callbackCollectionIterator:IIterator;
        private var _callbackIterator:ISequenceIterator;

        public function setCallbackCollection (...args):void {
            _callbackCollectionList.clear();
            for each (var i:ICollection in args) {
                _callbackCollectionList.add(i);
            }
            _callbackCollectionIterator = _callbackCollectionList.iterator();
            _callbackIterator = null;
        }

        private function nextCollectionIterator ():* {
            return ICollection(_callbackCollectionIterator.next()).iterator();
        }

        public function hasNext ():Boolean {
            // Some ugly repetitions here to avoid redundant calls.
            if (!_callbackIterator) {
                while (_callbackCollectionIterator.hasNext()) {
                    _callbackIterator = nextCollectionIterator();
                    if (_callbackIterator.hasNext()) {
                        return true;
                    }
                }
                return false;
            } else if (_callbackIterator.hasNext()) {
                return true;
            } else {
                while (_callbackCollectionIterator.hasNext()) {
                    _callbackIterator = nextCollectionIterator();
                    if (_callbackIterator.hasNext()) {
                        return true;
                    }
                }
                return false;
            }
        }

        public function next ():* {
            return _callbackIterator.next();
        }

        public function remove ():Boolean {
            return _callbackIterator.remove();
        }

        public function reset ():void {
        }
    }
}
