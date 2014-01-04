package org.dzyga.collections {
    public class List implements IList {
        internal var _first:IBinaryNode;
        internal var _last:IBinaryNode;
        protected var _size:int = 0;

        public function List (...args) {
            add.apply(this, args);
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
            }
            return first && first.value;
        }

        protected function _nodeInit (item:*):IBinaryNode {
            if (item is IBinaryNode) {
                return item;
            } else {
                return new BinaryNode(item);
            }
        }

        public function append (item:*):int {
            var node:IBinaryNode = _nodeInit(item);
            if (_last) {
                _last.right = node;
                _last = node;
            } else {
                _first = node;
                _last = node;
            }
            return _size++;
        }

        public function prepend (item:*):int {
            var node:IBinaryNode = _nodeInit(item);
            if (_first) {
                _first.left = node;
                _first = node;
            } else {
                _first = node;
                _last = node;
            }
            return _size++;
        }

        public function add (...args):Boolean {
            for each (var item:* in args) {
                append(item);
            }
            return true;
        }

        internal function _nodeRemove (node:IBinaryNode):Boolean {
            if (_size) {
                if (_size == 1 && node == _first) {
                    _size = 0;
                    _first = _last = null;
                    return true;
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
                _size -= 1;
                return true;
            }
            return false;
        }

        protected function _nodeFind (item:*):IBinaryNode {
            var cursor:IBinaryNode = _first;
            while (cursor) {
                if (cursor.value === item) {
                    return cursor;
                }
                cursor = cursor.right;
            }
            return null;
        }

        private static var _removeItemSet:Set;

        public function remove (...args):Boolean {
            if (_size) {
                if (args.length) {
                    _removeItemSet.add.apply(null, args);
                    var cursor:IBinaryNode = _first;
                    var removed:IBinaryNode;
                    while (cursor) {
                        if (_removeItemSet.has(cursor.value)) {
                            removed = cursor;
                            cursor = cursor.right;
                            _nodeRemove(removed);
                        } else {
                            cursor = cursor.right;
                        }
                    }
                    return true;
                }
                return clear();
            }
            return false;
        }

        public function size ():int {
            return _size;
        }

        public function has (item:*):Boolean {
            var node:IBinaryNode = _nodeFind(item);
            return node !== null;
        }

        public function clear ():Boolean {
            var _re:Boolean = (_size != 0);
            _first = _last = null;
            _size = 0;
            return _re;
        }
    }
}
