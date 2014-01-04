package org.dzyga.collections {
    public class ListIterator implements IIterator {
        protected var _list:List;
        protected var _cursor:IBinaryNode;

        public function ListIterator (list:List) {
            _list = list;
        }

        public function hasNext ():Boolean {
            if (!_list.size()) {
                return false;
            }
            if (!_cursor) {
                _cursor = _list._first;
            }
            return _cursor.right !== null;
        }

        public function next ():* {
            return null;
        }

        public function reset ():void {
            return false;
        }
    }
}
