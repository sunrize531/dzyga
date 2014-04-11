package org.dzyga.collections {
    /**
     * Primitive implementation of node for both sorted and linked collections.
     * Subclass it to improve performance and decrease memory usage.
     */
    public class Node extends NodeBinary implements INodeSorted {
        private var _parent:INodeSorted;
        private var _order:int;

        public function get parent ():INodeSorted {
            return _parent;
        }

        public function set parent (v:INodeSorted):void {
            _parent = v;
        }

        public function get order ():int {
            return _order;
        }

        public function set order (v:int):void {
            _order = v;
        }
    }
}
