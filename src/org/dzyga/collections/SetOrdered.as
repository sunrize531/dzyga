package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;

    public class SetOrdered implements ISet, IOrdered {
        protected var _itemsList:ListSimple = new ListSimple();
        protected var _itemsHash:Object = {};

        protected function _hash (item:*):String {
            return ObjectUtils.hash(item);
        }

        public function has (item:*):Boolean {
            return _itemsHash.hasOwnProperty(ObjectUtils.hash(item));
        }

        public function first ():* {
            return _itemsList._first;
        }

        public function last ():* {
            return _itemsList._last;
        }

        public function add (item:*):Boolean {
            var hash:String = _hash(item);
            if (!_itemsHash.hasOwnProperty(hash)) {
                var node:IBinaryNode = _itemsList._nodeInit(item);
                _itemsList._nodeAppend(node);
                _itemsHash[hash] = node;
                return true;
            }
            return false;
        }

        public function prepend (item:*):Boolean {
            var hash:String = _hash(item);
            if (!_itemsHash.hasOwnProperty(hash)) {
                var node:IBinaryNode = _itemsList._nodeInit(item);
                _itemsList._nodePrepend(node);
                _itemsHash[hash] = node;
                return true;
            }
            return false;
        }

        public function remove (item:*):Boolean {
            var hash:String = _hash(item);
            var node:IBinaryNode = _itemsHash[hash];
            if (node) {
                _itemsList._nodeRemove(node);
                delete _itemsHash[hash];
                return true;
            }
            return false;
        }

        public function pop ():* {
            if (size()) {
                var item:* = _itemsList.pop();
                var hash:String = _hash(item);
                delete _itemsHash[hash];
                return item;
            }
        }

        public function shift ():* {
            if (size()) {
                var item:* = _itemsList.shift();
                var hash:String = _hash(item);
                delete _itemsHash[hash];
                return item;
            }
        }

        public function size ():int {
            return _itemsList.size();
        }

        public function clear ():Boolean {
            if (_itemsList.size()) {
                _itemsList.clear();
                _itemsHash = {};
                return true;
            }
            return false;
        }

        public function items ():Array {
            return _itemsList.items();
        }

        public function iterator ():IIterator {
            return null;
        }

        public function update (iterable:*):Boolean {
            return false;
        }

        public function subtract (iterable:*):Boolean {
            return false;
        }

        public function intersect (iterable:*):Boolean {
            return false;
        }

        public function isSubSet (iterable:*):Boolean {
            return false;
        }

        public function isSuperSet (iterable:*):Boolean {
            return false;
        }
    }
}
