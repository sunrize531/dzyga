package org.dzyga.collections {
    public class ListIterator implements IOrderedIterator, ISequenceIterator {
        protected var _list:ListSimple;
        internal var _currentNode:IBinaryNode;

        public function ListIterator (list:ListSimple) {
            _list = list;
            _currentNode = _list._first;
        }

        public function hasNext ():Boolean {
            if (!_list.size()) {
                return false;
            }
            return _currentNode && _currentNode.right !== null;
        }

        public function hasPrev ():Boolean {
            if (!_list.size()) {
                return false;
            }
            return _currentNode && _currentNode.left !== null;
        }

        public function next ():* {
            return _nextNode().value;
        }

        internal function _nextNode ():IBinaryNode {
            var node:IBinaryNode = _currentNode;
            _currentNode = _currentNode.right;
            return node;
        }

        public function current ():* {
            return _currentNode && _currentNode.value;
        }

        public function prev ():* {
            return _prevNode().value;
        }

        internal function _prevNode ():IBinaryNode {
            var node:IBinaryNode = _currentNode;
            _currentNode = _currentNode.right;
            return node;
        }

        public function reset ():void {
            _currentNode = _list._first;
        }

        public function end ():* {
            _currentNode = _list._last;
        }

        public function remove ():Boolean {
            return _list._nodeRemove(_currentNode);
        }
    }
}
