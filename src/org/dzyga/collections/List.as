package org.dzyga.collections {
    import org.dzyga.utils.IterUtils;

    public class List extends ListSimple implements IList {
        public function has (item:*):Boolean {
            if (!_size) {
                return false;
            }

            _iteratorLocal ||= new ListIterator(this);
            var _re:Boolean = false;
            while (_iteratorLocal.hasNext()) {
                if (_iteratorLocal.next() === item) {
                    _re = true;
                    break;
                }
            }
            _iteratorLocal.reset();
            return _re;
        }

        public function extend (iterable:*):Boolean {
            var iterator:IIterator = IterUtils.iterator(iterable);
            var _re:Boolean = false;
            while (iterator.hasNext()) {
                _re = add(iterator.next()) || _re;
            }
            return _re;
        }
    }
}
