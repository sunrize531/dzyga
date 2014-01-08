package org.dzyga.collections {
    use namespace dz_collections;

    public class ListSimple extends ListAbstract implements IListSimple {
        protected var _first:IBinaryNode;
        protected var _last:IBinaryNode;
        protected var _size:int = 0;

        override dz_collections function get _firstNode ():IBinaryNode {
            return _first;
        }

        dz_collections function set _firstNode (v:IBinaryNode):void {
            _first = v;
        }

        override dz_collections function get _lastNode ():IBinaryNode {
            return _last;
        }

        dz_collections function set _lastNode (v:IBinaryNode):void {
            _last = v;
        }

        override dz_collections function _nodeInit (item:*):IBinaryNode {
            if (item is IBinaryNode) {
                return item;
            } else {
                return new BinaryNode(item);
            }
        }

        override dz_collections function _nodeAppend (node:IBinaryNode):void {
            if (_last) {
                _last.right = node;
                node.left = _last;
                _last = node;
            } else {
                _first = node;
                _last = node;
            }
            _size++;
        }

        override dz_collections function _nodePrepend (node:IBinaryNode):void {
            if (_first) {
                _first.left = node;
                node.right = _first;
                _first = node;
            } else {
                _first = node;
                _last = node;
            }
            _size++;
        }

        override dz_collections function _nodeRemove (node:IBinaryNode):Boolean {
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
            node.left = node.right = null;
            return true;
        }

        override public function add (item:*):Boolean {
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

        override public function size ():int {
            return _size;
        }

        public function iterator ():IIterator {
            return new ListIterator(this);
        }

        protected var _iteratorLocal:ListIterator;

        override public function remove (item:*):Boolean {
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
