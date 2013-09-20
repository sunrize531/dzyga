package org.dzyga.utils {
    import org.as3commons.collections.framework.IIterable;
    import org.as3commons.collections.framework.IIterator;
    import org.as3commons.collections.iterators.ArrayIterator;

    public final class IterUtils {
        /**
         * object can be primitive, IIterable or IIterator. If object is primitive, create iterator with
         * one value for this object. If object is Array - returns new ArrayIterator.
         * If object is IIterable - returns its iterator. If object is IIterator - returns object itself.
         *
         * @param object
         * @return
         */
        public static function iterator (object:*):IIterator {
            if (object is IIterator) {
                return object;
            } else if (object is IIterable) {
                return object.iterator();
            } else if (object is Array) {
                return new ArrayIterator(object);
            } else {
                return new PrimitiveIterator(object);
            }
        }

        /**
         * Return iterator which applies f to each value for object. object will be passed to iterator() first, so
         * primitive, arrays, iterables and iterators allowed.
         *
         * @param object primitive or iterable or iterator
         * @param f function to apply
         * @return iterator
         */
        public static function map (object:*, f:Function):IIterator {
            return new MapperIterator(iterator(object), f);
        }


        /**
         * Return iterator which filters object with f function. object will be passed to iterator() first, so
         * primitive, arrays, iterables and iterators allowed.
         *
         * @param object
         * @param f
         * @return iterator
         */
        public static function filter (object:*, f:Function):IIterator {
            return new FilterIterator(iterator(object), f);
        }

        /**
         * Create array from object. object will be passed to iterator() method first.
         *
         * @param object
         * @return
         */
        public static function array (object:*):Array {
            var i:IIterator = iterator(object);
            var re:Array = [];
            while (i.hasNext()) {
                re.push(i.next());
            }
            return re;
        }
    }
}




