package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;
    use namespace dz_collections;

    public class SetOrdered extends ListAbstract implements ISet, IOrdered {
        internal var _itemsList:ListSimple = new ListSimple();
        protected var _itemsHash:Object = {};


        override dz_collections function get _firstNode ():IBinaryNode {
            return _itemsList._firstNode;
        }

        override dz_collections function get _lastNode ():IBinaryNode {
            return _itemsList._lastNode;
        }

        override dz_collections function _nodeInit (item:*):IBinaryNode {
            return _itemsList._nodeInit(item);
        }

        override dz_collections function _nodeAppend (node:IBinaryNode):void {
            _itemsList._nodeAppend(node);
        }

        override dz_collections function _nodePrepend (node:IBinaryNode):void {
            _itemsList._nodePrepend(node);
        }

        override dz_collections function _nodeRemove (node:IBinaryNode):Boolean {
            var hash:String = _hash(node.value);
            delete _itemsHash[hash];
            return _itemsList._nodeRemove(node);
        }

        protected function _hash (item:*):String {
            return ObjectUtils.hash(item);
        }

        public function has (item:*):Boolean {
            return _itemsHash.hasOwnProperty(ObjectUtils.hash(item));
        }

        public function first ():* {
            return _itemsList.first();
        }

        public function last ():* {
            return _itemsList.last();
        }

        override public function add (item:*):Boolean {
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

        override public function remove (item:*):Boolean {
            var hash:String = _hash(item);
            var node:IBinaryNode = _itemsHash[hash];
            if (node) {
                _nodeRemove(node);
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

        override public function size ():int {
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
            return new ListIterator(this);
        }

        public function update (iterable:*):Boolean {
            return SetUtils.update(this, iterable);
        }

        public function subtract (iterable:*):Boolean {
            return SetUtils.subtract(this, iterable);
        }

        public function intersect (iterable:*):Boolean {
            return SetUtils.intersect(this, iterable);
        }

        public function isSubSet (iterable:*):Boolean {
            return SetUtils.isSubSet(this, iterable);
        }

        public function isSuperSet (iterable:*):Boolean {
            return SetUtils.isSuperSet(this, iterable);
        }
    }
}
