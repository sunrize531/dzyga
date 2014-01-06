package org.dzyga.collections {
    import org.dzyga.utils.IterUtils;
    import org.dzyga.utils.ObjectUtils;

    public class Set implements ISet {
        internal var _items:Object = {};
        protected var _size:int = 0;

        public function Set (...args) {
            if (args.length) {
                add.apply(this, args);
            }
        }

        public function has (item:*):Boolean {
            return _items.hasOwnProperty(ObjectUtils.hash(item));
        }

        internal function _itemAdd (item:*):Boolean {
            var h:String = ObjectUtils.hash(item);
            if (!_items.hasOwnProperty(h)) {
                _items[h] = item;
                _size++;
                return true;
            }
            return false;
        }

        internal function _itemRemove (item:*):Boolean {
            var h:String = ObjectUtils.hash(item);
            if (_items.hasOwnProperty(h)) {
                delete _items[h];
                _size--;
                return true;
            }
            return false;
        }

        public function add (...args):Boolean {
            var _re:Boolean = false;
            for each (var item:* in args) {
                _re = _itemAdd(item) || _re;
            }
            return _re;
        }

        public function remove (...args):Boolean {
            if (args.length) {
                var _re:Boolean = false;
                for each (var item:* in args) {
                    _re = _itemRemove(item) || _re;
                }
                return _re;
            } else {
                return clear();
            }
        }

        public function size ():int {
            return _size;
        }

        public function clear ():Boolean {
            if (_size) {
                _items = {};
                _size = 0;
                return true;
            }
            return false;
        }

        public function items ():Array {
            return ObjectUtils.values(_items);
        }

        public function iterator ():IIterator {
            return new SetIterator(this);
        }

        public function update (iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = _itemAdd(iterator.next()) || _re;
            }
            return _re;
        }

        public function subtract (iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = _itemRemove(iterator.next()) || _re;
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
