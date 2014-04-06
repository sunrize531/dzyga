package org.dzyga.collections {
    public class SortedIterator implements IOrderedIterator {
        public function hasPrev ():Boolean {
            return false;
        }

        public function prev ():* {
            return null;
        }

        public function last ():* {
            return null;
        }

        public function hasNext ():Boolean {
            return false;
        }

        public function next ():* {
            return null;
        }

        public function reset ():void {
        }
    }
}
