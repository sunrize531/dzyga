package org.dzyga.collections {
    public class BinaryNode implements IBinaryNode {
        protected var _left:IBinaryNode;
        protected var _right:IBinaryNode;
        protected var _value:*;

        public function BinaryNode (value:* = undefined) {
            _value = value;
        }

        public function get left ():IBinaryNode {
            return _left;
        }

        public function set left (v:IBinaryNode):void {
            _left = v;
        }

        public function get right ():IBinaryNode {
            return _right;
        }

        public function set right (v:IBinaryNode):void {
            _right = v;
        }

        public function get value ():* {
            return _value;
        }

        public function set value (v:*):void {
            _value = v;
        }

        public function hash ():* {
            return _value;
        }
    }
}
