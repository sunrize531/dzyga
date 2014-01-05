package org.dzyga.collections {
    import flash.utils.Dictionary;

    import org.dzyga.utils.IterUtils;

    public class Set implements ISet {
        internal var _items:Dictionary = new Dictionary();
        internal var _strings:Object = {};
        protected var _size:int = 0;


        public function Set (...args) {
            if (args.length) {
                add.apply(this, args);
            }
        }

        public function has (item:*):Boolean {
            var container:Object = _itemContainer(item);
            return container.hasOwnProperty(item);
        }

        protected function _itemContainer (item:*):Object {
            if (item is String) {
                return _strings;
            }
            return _items;
        }

        internal function _itemAdd (item:*):Boolean {
            var container:Object = _itemContainer(item);
            if (!container[item]) {
                container[item] = true;
                _size += 1;
                return true;
            }
            return false;
        }

        internal function _itemRemove (item:*):Boolean {
            var container:Object = _itemContainer(item);
            if (container[item]) {
                delete container[item];
                _size -= 1;
                return true;
            }
            return false;
        }

        public function update (iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = _itemAdd(iterator.next()) || _re;
            }
            return _re;
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
                _items = new Dictionary();
                _strings = {};
                _size = 0;
                return true;
            }
            return false;
        }

        public function iterator ():IIterator {
            return new SetIterator(this);
        }
    }
}
