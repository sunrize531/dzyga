package org.dzyga.collections {

    public class PrimitiveIterator implements IIterator {
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

        public function reset ():void {
            _done = false;
        }
    }
}
