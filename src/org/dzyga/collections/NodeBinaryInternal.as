package org.dzyga.collections {
    /**
     * This class used internally to store instances of classes
     * which are not implements INodeBinary in linked collections.
     */
    internal class NodeBinaryInternal implements INodeBinary {
        protected var _left:INodeBinary;
        protected var _right:INodeBinary;
        protected var _item:*;

        public function NodeBinaryInternal (value:* = undefined) {
            _item = value;
        }

        public function get left ():INodeBinary {
            return _left;
        }

        public function set left (v:INodeBinary):void {
            _left = v;
        }

        public function get right ():INodeBinary {
            return _right;
        }

        public function set right (v:INodeBinary):void {
            _right = v;
        }

        public function get item ():* {
            return _item;
        }

        public function hash ():* {
            return _item;
        }

        public function set item(v:*):void {
        }
    }
}
