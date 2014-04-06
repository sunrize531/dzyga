package org.dzyga.collections {
    public class SequenceFilterIterator extends FilterIterator implements ISequenceIterator {
        public function SequenceFilterIterator (sourceIterator:IIterator, f:Function, thisArg:* = null, argsArray:Array = null) {
            super(sourceIterator, f, thisArg, argsArray);
        }

        public function remove ():Boolean {
            return ISequenceIterator(_sourceIterator).remove();
        }
    }
}
