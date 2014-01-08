package org.dzyga.collections {
    public class ListSimple implements IListSimple {
        internal var _first:IBinaryNode;
        internal var _last:IBinaryNode;
        protected var _size:int = 0;

        internal function _nodeInit (item:*):IBinaryNode {
            if (item is IBinaryNode) {
                return item;
            } else {
                return new BinaryNode(item);
            }
        }

        internal function _nodeAppend (node:IBinaryNode):void {
            if (_last) {
                _last.right = node;
                _last = node;
            } else {
                _first = node;
                _last = node;
            }
            _size++;
        }

        internal function _nodePrepend (node:IBinaryNode):void {
            if (_first) {
                _first.left = node;
                _first = node;
            } else {
                _first = node;
                _last = node;
            }
            _size++;
        }

        public function add (item:*):Boolean {
            var node:IBinaryNode = _nodeInit(item);
            _nodeAppend(node);
            return true;
        }

        public function prepend (item:*):Boolean {
            var node:IBinaryNode = _nodeInit(item);
            _nodePrepend(node);
            return true;
        }

        public function first ():* {
            return _first && _first.value;
        }

        public function last ():* {
            return _last && _last.value;
        }

        public function pop ():* {
            var last:IBinaryNode = _last;
            if (last) {
                _last = last.left || _first;
            }
            return last && last.value;
        }

        public function shift ():* {
            var first:IBinaryNode = _first;
            if (first) {
                _first = first.left || _last;
                _size--;
            }
            return first && first.value;
        }

        public function items ():Array {
            var _re:Array = [];
            var current:IBinaryNode = _first;
            while (current) {
                _re.push(current.value);
                current = current.right;
            }
            return _re;
        }

        public function size ():int {
            return _size;
        }

        public function iterator ():IIterator {
            return new ListIterator(this);
        }

        protected var _iteratorLocal:ListIterator;

        internal function _nodeRemove (node:IBinaryNode):Boolean {
            if (_size == 1) {
                if (node == _first) {
                    _size = 0;
                    _first = _last = null;
                    return true;
                }
                return false;
            }

            if (node == _first) {
                _first = node.right;
                _first.left = null;
            } else if (node == _last) {
                _last = node.left;
                _last.right = null;
            } else {
                node.left.right = node.right;
                node.right.left = node.left;
            }
            _size--;
            return true;
        }

        public function remove (item:*):Boolean {
            if (!_size) {
                return false;
            }

            if (item is IBinaryNode) {
                return _nodeRemove(item);
            }

            _iteratorLocal ||= new ListIterator(this);
            var _re:Boolean = false;
            while (_iteratorLocal.hasNext()) {
                var node:IBinaryNode = _iteratorLocal._nextNode();
                if (node.value === item) {
                    _nodeRemove(item);
                    _re = true;
                }
            }
            _iteratorLocal.reset();
            return _re;
        }

        public function clear ():Boolean {
            var _re:Boolean = (_size != 0);
            _first = _last = null;
            _size = 0;
            return _re;
        }
    }
}
