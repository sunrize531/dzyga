package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;

    /**
     * Primitive NodeBinary implementation to subclass.
     * Use this class as prototype for items to place in collections to improve performance.
     */
    public class NodeBinary implements INodeBinary {
        protected var _left:INodeBinary;
        protected var _right:INodeBinary;

        public function get left():INodeBinary {
            return _left;
        }

        public function set left(v:INodeBinary):void {
            _left = v;
        }

        public function get right():INodeBinary {
            return _right;
        }

        public function set right(v:INodeBinary):void {
            _right = v;
        }

        public function get item():* {
            return this;
        }

        public function hash():* {
            return ObjectUtils.hash(this);
        }
    }
}
