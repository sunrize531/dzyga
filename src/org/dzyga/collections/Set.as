package org.dzyga.collections {
    import flash.utils.Dictionary;

    import org.dzyga.utils.IterUtils;

    public class Set implements ISet {
        protected var _items:Dictionary;
        protected var _size:int = 0;

        public function has (item:*):Boolean {
            return _items.hasOwnProperty(item);
        }

        protected function _itemAdd (item:*):Boolean {
            if (!_items.hasOwnProperty(item)) {
                _items[item] = null;
                _size += 1;
                return true;
            }
            return false;
        }

        protected function _itemRemove (item:*):Boolean {
            if (_items.hasOwnProperty(item)) {
                delete _items[item];
                _size -= 1;
                return true;
            }
            return false;
        }

        public function update (iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re ||= _itemAdd(iterator.next());
            }
            return _re;
        }

        public function add (...args):Boolean {
            var _re:Boolean = false;
            for each (var item:* in args) {
                _re ||= _itemAdd(item);
            }
            return _re;
        }

        public function remove (...args):Boolean {
            if (args.length) {
                var _re:Boolean = false;
                for each (var item:* in args) {
                    _re ||= _itemRemove(item);
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
                _items = new Dictionary();
                _size = 0;
                return true;
            }
            return false;
        }
    }
}
