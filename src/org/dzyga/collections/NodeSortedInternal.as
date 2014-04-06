package org.dzyga.collections {
    internal class NodeSortedInternal extends NodeBinaryInternal implements INodeSorted {
        private var _parent:INodeSorted;
        private var _priority:int;
        private var _order:int;

        public function NodeSortedInternal(value:* = undefined) {
            super(value);
            _priority = int.MAX_VALUE * Math.random();
        }

        public function get parent():INodeSorted {
            return _parent;
        }

        public function set parent(v:INodeSorted):void {
            _parent = v;
        }

        public function get order():int {
            return _order;
        }

        public function set order(v:int):void {
            _order = v;
        }

        public function get priority():int {
            return _priority;
        }
    }
}
