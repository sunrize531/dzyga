package org.dzyga.collections {
    import org.as3commons.collections.framework.ISetIterator;
    import org.dzyga.utils.IterUtils;

    public class SetUtils {
        public static function toSet (iterable:*):ISet {
            if (iterable is ISet) {
                return iterable;
            } else {
                var s:Set = new Set();
                s.update(iterable);
                return s;
            }
        }

        public static function update (s:ISet, iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = s.add(iterator.next()) || _re;
            }
            return _re;
        }

        public static function subtract (s:ISet, iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = s.remove(iterator.next()) || _re;
            }
            return _re;
        }

        public static function intersect (s:ISet, iterable:*):Boolean {
            var iterator:ISetIterator = s.iterator() as ISetIterator;
            var other:ISet = toSet(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                var value:* = iterator.next();
                if (!other.has(value)) {
                    iterator.remove();
                    _re = true;
                }
            }
            return _re;
        }

        public static function isSubSet (s:ISet, iterable:*):Boolean {
            var iterator:ISetIterator = s.iterator() as ISetIterator;
            var other:ISet = toSet(iterable);
            var _re:Boolean = true;
            while (iterator.hasNext()) {
                var value:* = iterator.next();
                if (!other.has(value)) {
                    _re = false;
                    break;
                }
            }
            return _re;
        }

        public static function isSuperSet (s:ISet, iterable:*):Boolean {
            var _re:Boolean = true;
            var iterator:IIterator = IterUtils.iterator(iterable);
            while (iterator.hasNext()) {
                var value:* = iterator.next();
                if (!s.has(value)) {
                    _re = false;
                    break;
                }
            }
            return _re;
        }
    }
}
