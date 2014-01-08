package org.dzyga.collections {
    public class Set extends SetSimple implements ISet {
        public function update (iterable:*):Boolean {
            return SetUtils.update(this, iterable);
        }

        public function subtract (iterable:*):Boolean {
            return SetUtils.subtract(this, iterable);
        }

        public function intersect (iterable:*):Boolean {
            return SetUtils.intersect(this, iterable);
        }

        public function isSubSet (iterable:*):Boolean {
            return SetUtils.isSubSet(this, iterable);
        }

        public function isSuperSet (iterable:*):Boolean {
            return SetUtils.isSuperSet(this, iterable);
        }
    }
}
