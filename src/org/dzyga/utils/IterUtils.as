package org.dzyga.utils {
    import org.dzyga.callbacks.Handle;
    import org.dzyga.collections.ArrayIterator;
    import org.dzyga.collections.FilterIterator;
    import org.dzyga.collections.IList;
    import org.dzyga.collections.ISet;
    import org.dzyga.collections.MapperIterator;
    import org.dzyga.collections.PrimitiveIterator;
    import org.dzyga.collections.IIterable;
    import org.dzyga.collections.IIterator;

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
         * Return iterator which applies f to each value in object. object will be passed to iterator() first, so
         * primitive, arrays, iterables and iterators allowed.
         *
         * @param object primitive or iterable or iterator
         * @param f function to apply
         * @param thisArg
         * @param args
         * @return iterator
         */
            // TODO: implement class instantiation support here.
        public static function map (object:*, f:Function, thisArg:* = null, ...args):IIterator {
            return new MapperIterator(iterator(object), f, thisArg, args);
        }

        /**
         * Apply f to each value in object. object will be passed to iterator() first, so
         * primitive, arrays, iterables and iterators allowed.
         *
         * @param object primitive or iterable or iterator
         * @param f function to apply
         * @param thisArg
         * @param args
         */
        public static function forEach (object:*, f:Function, thisArg:* = null, ...args):void {
            var i:IIterator = iterator(object);
            while (i.hasNext()) {
                f.apply(thisArg, ArrayUtils.add([i.next()], args));
            }
        }


        /**
         * Return iterator which filters object with f function. object will be passed to iterator() first, so
         * primitive, arrays, iterables and iterators allowed.
         *
         * @param object
         * @param f
         * @param thisArg
         * @param args
         * @return iterator
         */
        public static function filter (object:*, f:Function, thisArg:* = null, ...args):IIterator {
            return new FilterIterator(iterator(object), f, thisArg, args);
        }

        /**
         * Return true if all elements of object passes filter function.
         *
         * @param object
         * @param f
         * @param thisArg
         * @param args
         * @return
         */
        public static function check (object:*, f:Function, thisArg:* = null, ...args):Boolean {
            var i:IIterator = iterator(object);
            var handle:Handle = new Handle(f, thisArg, args);
            while (i.hasNext()) {
                if (!handle.call(i.next())) {
                    return false;
                }
            }
            return true;
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

        /**
         * Iterate IList with objects elements.
         *
         * @param collection
         * @param object
         * @return collection
         */
        public static function toList (collection:IList, object:*):IList {
            var i:IIterator = iterator(object);
            while (i.hasNext()) {
                collection.add(i.next());
            }
            return collection;
        }

        /**
         * Populate ISet instance with objects elements.
         *
         * @param collection
         * @param object
         * @return collection
         */
        public static function toSet (collection:ISet, object:*):ISet {
            var i:IIterator = iterator(object);
            while (i.hasNext()) {
                collection.add(i.next());
            }
            return collection;
        }


        /**
         * Create iterator from object with IterUtils.iterator and run through it. Return object itself.
         * Useful for iterators created with IterUtils.map, if you do not need result of mapping function.
         *
         * @param object
         * @return
         */
        public static function iterate (object:*):Object {
            var objectIterator:IIterator = iterator(object);
            while (objectIterator.hasNext()) {
                objectIterator.next();
            }
            return object;
        }
    }
}




