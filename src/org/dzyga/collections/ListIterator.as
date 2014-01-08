package org.dzyga.collections {
    use namespace dz_collections;

    public class ListIterator implements IOrderedIterator, ISequenceIterator {
        protected var _list:ListAbstract;
        internal var _currentNode:IBinaryNode;

        public function ListIterator (list:ListAbstract) {
            _list = list;
            _currentNode = null;
        }

        public function hasNext ():Boolean {
            return _list.size() && (!_currentNode || _currentNode.right !== null);
        }

        public function hasPrev ():Boolean {
            return _list.size() && _currentNode && _currentNode.left !== null;
        }

        public function next ():* {
            return _nextNode().value;
        }

        internal function _nextNode ():IBinaryNode {
            if (!_currentNode) {
                _currentNode = _list._firstNode;
            } else {
                _currentNode = _currentNode.right;
            }
            return _currentNode;
        }

        public function current ():* {
            return _currentNode && _currentNode.value;
        }

        public function prev ():* {
            return _prevNode().value;
        }

        internal function _prevNode ():IBinaryNode {
            _currentNode = _currentNode.left;
            return _currentNode;
        }

        public function reset ():void {
            _currentNode = null;
        }

        public function end ():* {
            _currentNode = _list._lastNode;
            return _currentNode.value;
        }

        public function remove ():Boolean {
            var node:IBinaryNode = _currentNode;
            _currentNode = _currentNode.left;
            return _list._nodeRemove(node);
        }
    }
}
