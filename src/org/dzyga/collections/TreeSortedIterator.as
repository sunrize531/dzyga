package org.dzyga.collections {
    use namespace dz_collections;

    /**
     * Iterate through nodes in tree. For internal usage.
     */
    internal class TreeSortedIterator implements IOrderedIterator, ISequenceIterator {
        private var _tree:TreeSorted;
        private var _next:INodeSorted;
        private var _current:INodeSorted;

        public function TreeSortedIterator (tree:TreeSorted, offset:INodeSorted = null) {
            _tree = tree;
            if (offset) {
                _next = offset;
            } else if (_tree.size) {
                _next = _tree.nodeLeftMost();
            }
        }

        public function hasNext ():Boolean {
            return _next != null;
        }

        public function next ():* {
            if (!hasNext()) {
                _current = null;
                return undefined;
            }

            _current = _next;
            _next = _tree.nodeNext(_next);
            return _current;
        }

        public function hasPrev ():Boolean {
            return _tree.size && _next != _tree.nodeLeftMost();
        }

        public function prev ():* {
            if (!hasPrev()) {
                _current = null;
                return undefined;
            }
            if (_next == 0) {
                _next = _tree.nodeRightMost();
            } else {
                _next = _tree.nodePrevious(_next);
            }
            _current = _next;
            return _current;
        }

        public function last ():* {
            _next = _current = null;
            return prev();
        }

        public function first ():* {
            _next = _tree.nodeLeftMost();
            return next();
        }

        public function reset ():void {
            _next = _tree.nodeLeftMost();
            _current = null;
        }

        public function remove ():Boolean {
            if (_current) {
                _next = _tree.nodeNext(_current);
                _tree.nodeRemove(_current);
                _current = null;
                return true;
            }
            return false;
        }

        dz_collections function get current ():INodeSorted {
            return _current;
        }
    }
}
