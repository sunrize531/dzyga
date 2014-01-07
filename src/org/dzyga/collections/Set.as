package org.dzyga.collections {
    import org.dzyga.utils.IterUtils;
    public class Set extends SetSimple implements ISet {
        public function Set () {
        }

        public function update (iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = add(iterator.next()) || _re;
            }
            return _re;
        }

        public function subtract (iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = remove(iterator.next()) || _re;
            }
            return _re;
        }

        protected var _iteratorLocal:SetIterator;

        public function intersect (iterable:*):Boolean {
            _iteratorLocal ||= iterator() as SetIterator;
            var other:ISet = Set.coerce(iterable);
            var _re:Boolean = false;
            while (_iteratorLocal.hasNext()) {
                var value:* = _iteratorLocal.next();
                if (!other.has(value)) {
                    _iteratorLocal.remove();
                    _re = true;
                }
            }
            _iteratorLocal.reset();
            return _re;
        }

        public function isSubSet (iterable:*):Boolean {
            _iteratorLocal ||= iterator() as SetIterator;
            var other:ISet = Set.coerce(iterable);
            var _re:Boolean = true;
            while (_iteratorLocal.hasNext()) {
                var value:* = _iteratorLocal.next();
                if (!other.has(value)) {
                    _re = false;
                    break;
                }
            }
            _iteratorLocal.reset();
            return _re;
        }

        public function isSuperSet (iterable:*):Boolean {
            var _re:Boolean = true;
            var iterator:IIterator = IterUtils.iterator(iterable);
            while (iterator.hasNext()) {
                var value:* = iterator.next();
                if (!has(value)) {
                    _re = false;
                    break;
                }
            }
            return _re;
        }

        public static function coerce (iterable:*):ISet {
            if (iterable is ISet) {
                return iterable;
            } else {
                var s:Set = new Set();
                s.update(iterable);
                return s;
            }
        }
    }
}
