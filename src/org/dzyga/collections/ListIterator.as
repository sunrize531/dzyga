package org.dzyga.collections {
    public class ListIterator implements IStripIterator {
        protected var _list:List;
        protected var _current:IBinaryNode;

        public function ListIterator (list:List) {
            _list = list;
            _current = _list._first;
        }

        public function hasNext ():Boolean {
            if (!_list.size()) {
                return false;
            }
            return _current && _current.right !== null;
        }

        public function hasPrev ():Boolean {
            if (!_list.size()) {
                return false;
            }
            return _current && _current.left !== null;
        }

        public function next ():* {
            var value:* = _current.value;
            _current = _current.right;
            return value;
        }

        public function current ():* {
            return _current && _current.value;
        }

        public function prev ():* {
            var value:* = _current.value;
            _current = _current.left;
            return value;

        }

        public function reset ():void {
            _current = _list._first;
        }

        public function end ():* {
            _current = _list._last;
        }

        public function remove ():Boolean {
            return _list._nodeRemove(_current);
        }
    }
}
