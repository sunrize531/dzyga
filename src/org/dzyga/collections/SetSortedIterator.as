package org.dzyga.collections {
    use namespace dz_collections;
    public class SetSortedIterator implements IOrderedIterator, ISequenceIterator {
        private var _set:SetSorted;
        private var _treeIterator:TreeSortedIterator;

        public function SetSortedIterator (collection:SetSorted, offset:* = null) {
            _set = collection;
            if (arguments.length > 1) {
                offset = _set._nodeGet(offset);
            }
            _treeIterator = new TreeSortedIterator(_set._getItemsTree(), offset);
        }

        public function hasPrev ():Boolean {
            return _treeIterator.hasPrev();
        }

        public function prev ():* {
            var node:INodeSorted = _treeIterator.prev();
            return node && node.item;
        }


        public function hasNext ():Boolean {
            return _treeIterator.hasNext();
        }

        public function next ():* {
            var node:INodeSorted = _treeIterator.next();
            return node && node.item;
        }

        public function last ():* {
            return _treeIterator.last();
        }

        public function first ():* {
            return _treeIterator.first();
        }

        public function reset ():void {
            _treeIterator.reset();
        }

        public function remove ():Boolean {
            var current:INodeSorted = _treeIterator.current;
            if (current) {
                _set._nodeRemove(current);
                return _treeIterator.remove();
            }
            return false;
        }
    }
}
