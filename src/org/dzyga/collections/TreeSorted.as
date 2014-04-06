package org.dzyga.collections {
    import org.dzyga.utils.FunctionUtils;

    internal class TreeSorted implements IIterable {
        private static const RIGHT_ATTR:String = 'right';
        private static const LEFT_ATTR:String = 'left';

        public function TreeSorted (comparator:Function = null) {
            if (comparator is Function) {
                _comparator = comparator;
            } else {
                _comparator = FunctionUtils.compare;
            }
        }

        private var _comparator:Function;
        private var _nodeCounter:int = 0;

        private var _root:INodeSorted;

        public function get root ():org.dzyga.collections.INodeSorted {
            return _root;
        }

        private var _size:int = 0;

        public function get size ():int {
            return _size;
        }

        public function hasEqual (item:*):Boolean {
            var node:INodeSorted = _root;
            while (node) {
                var cmp:Number = _comparator(item, node.item);
                if (cmp < 0) {
                    node = INodeSorted(node.left);
                } else if (cmp > 0) {
                    node = INodeSorted(node.right);
                } else {
                    return true;
                }
            }
            return false;
        }

        public function nodeLeftMost (node:INodeSorted = null):INodeSorted {
            if (!_root) {
                return null;
            }
            node ||= _root;
            while (node.left) {
                node = INodeSorted(node.left);
            }
            return node;
        }

        public function nodeRightMost (node:INodeSorted = null):INodeSorted {
            if (!_root) {
                return null;
            }
            node ||= _root;
            while (node.right) {
                node = INodeSorted(node.right);
            }
            return node;
        }

        public function nodeNext (node:INodeSorted):INodeSorted {
            if (node.right) {
                return nodeLeftMost(INodeSorted(node.right));
            } else {
                var parent:INodeSorted = node.parent;
                while (parent && node == parent.right) {
                    node = parent;
                    parent = parent.parent;
                }
                return node.parent;
            }
        }

        public function nodePrevious (node:INodeSorted):INodeSorted {
            if (node.left) {
                return nodeRightMost(INodeSorted(node.left));
            } else {
                var parent:INodeSorted = node.parent;
                while (parent && node == parent.left) {
                    node = parent;
                    parent = parent.parent;
                }
                return node.parent;
            }
        }

        public function nodeAdd (node:INodeSorted):void {
            _size++;
            node.order = _nodeCounter++;

            // add first node
            if (!_root) {
                _root = node;
                return;
            }

            // add node to tree
            var currentNode:INodeSorted = _root;
            while (currentNode) {
                var cmp:int = _comparator(node.item, currentNode.item) ||
                        FunctionUtils.compare(node.order, currentNode.order) || 1;

                if (cmp < 0) { // add item in left branch
                    if (currentNode.left) {
                        currentNode = INodeSorted(currentNode.left);
                    } else {
                        node.parent = currentNode;
                        currentNode.left = node;
                        currentNode = INodeSorted(currentNode.left);
                        break;
                    }
                } else if (cmp > 0) { // add item in right branch
                    if (currentNode.right) {
                        currentNode = INodeSorted(currentNode.right);
                    } else {
                        node.parent = currentNode;
                        currentNode.right = node;
                        currentNode = INodeSorted(currentNode.right);
                        break;
                    }
                }
            }

            // Balancing
            while (currentNode.parent) {
                if (currentNode.parent.priority >= currentNode.priority) break;
                _nodeRotate(currentNode.parent, currentNode);
            }
        }

        public function nodeRemove (node:INodeSorted):void {
            var child:INodeSorted;
            while (true) {
                var nodeLeft:INodeSorted = node.left as INodeSorted;
                var nodeRight:INodeSorted = node.right as INodeSorted;
                if (nodeLeft || nodeRight) {
                    var leftPriority:int = nodeLeft ? nodeLeft.priority : -1;
                    var rightPriority:int = nodeRight ? nodeRight.priority : -1;
                    child = leftPriority < rightPriority ? nodeLeft : nodeRight;
                    _nodeRotate(node, child);
                } else {
                    break;
                }
            }

            // remove node from tree
            if (node.parent) {
                if (node.parent.left == node) {
                    node.parent.left = null;
                } else {
                    node.parent.right = null;
                }
                node.parent = null;
            } else {
                _root = null;
            }
            _size--;
        }

        private function _nodeRotate (parent:INodeSorted, child:INodeSorted):INodeSorted {
            var grandparent:INodeSorted = parent.parent;
            var right:String = RIGHT_ATTR; // rotate with right child
            var left:String = LEFT_ATTR;
            if (child == parent.left) { // rotate with left child
                right = LEFT_ATTR;
                left = RIGHT_ATTR;
            }

            // set left of child to be the new right of parent
            parent[right] = child[left];
            if (child[left]) {
                INodeSorted(child[left]).parent = parent;
            }

            // set child as the new parent
            parent.parent = child;
            child[left] = parent;

            // link grandparent to the child
            child.parent = grandparent;
            if (grandparent) {
                if (grandparent[left] == parent) {
                    grandparent[left] = child;
                } else {
                    grandparent[right] = child;
                }
            } else {
                _root = child;
            }
        }

        public function iterator ():IIterator {
            return null;
        }
    }
}
