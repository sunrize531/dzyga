package org.dzyga.utils {
    import org.as3commons.collections.framework.IIterable;
    import org.as3commons.collections.framework.IIterator;

    public final class CollectionUtils {
        /**
         * object can be primitive, IIterable or IIterator. If object is primitive, create iterator with
         * one value for this object. If object is IIterable - returns its iterator. If object is IIterator -
         * returns object itself.
         *
         * @param object
         * @return
         */
        public function iterator (object:*):IIterator {
            if (object is IIterator) {
                return object;
            } else if (object is IIterable) {
                return object.iterator();
            } else {
                return new PrimitiveIterator(object);
            }
        }

        public function map (object:*, )
    }
}

import org.as3commons.collections.framework.IIterator;

class PrimitiveIterator implements IIterator {
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
