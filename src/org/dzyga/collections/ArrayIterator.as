package org.dzyga.collections {
    public class ArrayIterator implements IIterator {
        protected var _array:Array;
        protected var _current:int = -1;

        public function ArrayIterator (array:Array) {
            _array = array;
        }

        public function hasNext ():Boolean {
            return _current < _array.length - 1;
        }

        public function next ():* {
            return _array[++_current];
        }

        public function reset ():void {
            _current = -1;
        }
    }
}
