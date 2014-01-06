package org.dzyga.collections {
    public class SetIterator implements IStripIterator {
        protected var _set:Set;
        protected var _item:*;
        protected var _items:Array = [];
        protected var _current:int = -1;

        public function SetIterator (s:Set) {
            _set = s;
            _items = s.items();
        }

        public function hasNext ():Boolean {
            return _current < _items.length - 1;
        }

        public function next ():* {
            _item = _items[++_current];
            return _item;
        }

        public function remove ():Boolean {
            return _current != -1 && _set._itemRemove(_item);
        }

        public function reset ():void {
            _current = -1;
            _items = _set.items();
        }
    }
}
