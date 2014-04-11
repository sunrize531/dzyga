package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;

    use namespace dz_collections;

    public class SetSorted implements ISet {
        public function SetSorted (comparator:Function = null) {
            _itemsTree = new TreeSorted(comparator);
        }

        protected var _itemsHash:Object = {};
        protected var _itemsTree:TreeSorted;

        public function getEqualItem (item:*):* {
            var node:INodeBinary = _nodeGet(item);
            return node && node.item;
        }

        public function clear ():Boolean {
            return false;
        }

        public function items ():Array {
            return null;
        }

        public function has (item:*):Boolean {
            return _itemsHash.hasOwnProperty(ObjectUtils.hash(item));
        }

        public function size ():int {
            return _itemsTree.size;
        }

        public function iterator ():IIterator {
            return new SetSortedIterator(this);
        }

        public function add (item:*):Boolean {
            var hash:String = _hash(item);
            if (!_itemsHash.hasOwnProperty(hash)) {
                var node:INodeSorted = _nodeInit(item);
                _itemsTree.nodeAdd(node);
                _itemsHash[hash] = node;
                return true;
            }
            return false;
        }

        public function remove (item:*):Boolean {
            var hash:String = _hash(item);
            var node:INodeSorted = _itemsHash[hash];
            if (node) {
                _itemsTree.nodeRemove(node);
                delete _itemsHash[hash];
                return true;
            }
            return false;
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

        protected function _nodeInit (item:*):INodeSorted {
            if (item is INodeSorted) {
                return item;
            } else {
                return new NodeSortedInternal(item);
            }
        }

        dz_collections function _getItemsTree ():TreeSorted {
            return _itemsTree;
        }

        dz_collections function _nodeGet (item:*):INodeSorted {
            return _itemsHash[_hash(item)];
        }

        dz_collections function _nodeRemove (node:INodeSorted):void {
            delete _itemsHash[_hash(node.item)];
        }
    }
}
