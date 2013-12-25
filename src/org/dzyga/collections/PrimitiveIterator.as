package org.dzyga.collections {
    import org.as3commons.collections.framework.IIterator;

    internal class PrimitiveIterator implements IIterator {
        private var _primitive:*;
        private var _done:Boolean = false;

        public function PrimitiveIterator (primitive:*) {
            _primitive = primitive;
        }

        public function next ():* {
            if (!_done) {
                _done = true;
                return _primitive;
            } else {
                return null;
            }
        }

        public function hasNext ():Boolean {
            return !_done;
        }
    }
}
