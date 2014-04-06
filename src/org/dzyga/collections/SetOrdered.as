package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;

    use namespace dz_collections;

    public class SetOrdered extends ListSimple implements ISet, IOrdered {
        protected var _itemsHash:Object = {};

        override dz_collections function _nodeRemove (node:INodeBinary):Boolean {
            var hash:String = _hash(node.item);
            delete _itemsHash[hash];
            return super._nodeRemove(node);
        }

        override public function add (item:*):Boolean {
            var hash:String = _hash(item);
            if (!_itemsHash.hasOwnProperty(hash)) {
                var node:INodeBinary = _nodeInit(item);
                _nodeAppend(node);
                _itemsHash[hash] = node;
                return true;
            }
            return false;
        }

        override public function prepend (item:*):Boolean {
            var hash:String = _hash(item);
            if (!_itemsHash.hasOwnProperty(hash)) {
                var node:INodeBinary = _nodeInit(item);
                _nodePrepend(node);
                _itemsHash[hash] = node;
                return true;
            }
            return false;
        }

        override public function remove (item:*):Boolean {
            var hash:String = _hash(item);
            var node:INodeBinary = _itemsHash[hash];
            if (node) {
                _nodeRemove(node);
                return true;
            }
            return false;
        }

        override public function pop ():* {
            if (size()) {
                var item:* = super.pop();
                var hash:String = _hash(item);
                delete _itemsHash[hash];
                return item;
            }
        }

        override public function shift ():* {
            if (size()) {
                var item:* = super.shift();
                var hash:String = _hash(item);
                delete _itemsHash[hash];
                return item;
            }
        }

        override public function clear ():Boolean {
            if (size()) {
                super.clear();
                _itemsHash = {};
                return true;
            }
            return false;
        }

        public function has (item:*):Boolean {
            return _itemsHash.hasOwnProperty(ObjectUtils.hash(item));
        }

        public function getItem (item:*):* {
            var node:INodeBinary = _itemsHash[_hash(item)];
            return node && node.item;
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

        protected function _hash (item:*):String {
            return ObjectUtils.hash(item);
        }
    }
}
