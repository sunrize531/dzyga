package org.dzyga.collections {
    public class ListIterator implements IStripIterator {
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
            if (hasNext()) {
                var value:* = _cursor.value;
                _cursor = _cursor.right;
                return value;
            }
        }

        public function reset ():void {
            _cursor = null;
        }

        public function remove ():Boolean {
            return _list._nodeRemove(_cursor);
        }
    }
}
