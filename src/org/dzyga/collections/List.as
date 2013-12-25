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

        public function remove (...args):Boolean {
            // TODO: make it with ListIterator and Set
            /*
            var r:Boolean = false;
            for
            for each (var value:* in args) {
                var node:IBinaryNode = _nodeFind(value);
                if (node) {
                    _nodeRemove(node);
                    r = true;
                }
            }
            return r;
            */
            return false;
        }

        public function size ():int {
            return _size;
        }

        public function has (item:*):Boolean {
            var node:IBinaryNode = _nodeFind(item);
            return node !== null;
        }
    }
}
