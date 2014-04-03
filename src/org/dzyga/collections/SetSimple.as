package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;

    public class SetSimple implements ISetSimple {
        internal var _items:Object = {};
        protected var _size:int = 0;

        public function has (item:*):Boolean {
            return _items.hasOwnProperty(ObjectUtils.hash(item));
        }

        public function get (item:*):* {
            var h:String = ObjectUtils.hash(item);
            if (_items.hasOwnProperty(h)) {
                return _items[h];
            } else {
                return null;
            }
        }

        public function add (item:*):Boolean {
            var h:String = ObjectUtils.hash(item);
            if (!_items.hasOwnProperty(h)) {
                _items[h] = item;
                _size++;
                return true;
            }
            return false;
        }

        public function remove (item:*):Boolean {
            var h:String = ObjectUtils.hash(item);
            if (_items.hasOwnProperty(h)) {
                delete _items[h];
                _size--;
                return true;
            }
            return false;
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
    }
}
