package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;

    public class ObjectIterator implements IIterator {
        protected var _object:Object;
        protected var _keyIterator:ArrayIterator;

        public function ObjectIterator (object:Object) {
            _object = object;
            reset();
        }

        public function hasNext ():Boolean {
            return _keyIterator.hasNext();
        }

        public function next ():* {
            return _object[_keyIterator.next()];
        }

        public function nextKey ():* {
            return _keyIterator.next();
        }

        public function reset ():void {
            _keyIterator = new ArrayIterator(ObjectUtils.keys(_object));
        }
    }
}
