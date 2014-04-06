package org.dzyga.collections {
    use namespace dz_collections;
    public class SetSortedIterator implements IOrderedIterator {
        var _treeIterator:TreeSortedIterator;

        public function SetSortedIterator (collection:SetSorted, offset:* = null) {
            var tree:TreeSorted = collection._getItemsTree();
            if (arguments.length > 1) {
                offset = collection._getNode(offset);
            }
            _treeIterator = new TreeSortedIterator(tree, offset);
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
    }
}
