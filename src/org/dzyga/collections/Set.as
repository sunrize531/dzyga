package org.dzyga.collections {
    import flash.utils.Dictionary;

    public class Set implements ISet {
        protected var _items:Dictionary;

        public function has (item:*):Boolean {
            return _items.hasOwnProperty(item);
        }

        public function update (iterable:*):Boolean {
            return false;
        }

        public function add (...args):Boolean {
            return false;
        }

        public function remove (...args):Boolean {
            return false;
        }

        public function size ():int {
            return 0;
        }
    }
}
