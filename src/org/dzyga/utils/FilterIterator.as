package org.dzyga.utils {
    import org.as3commons.collections.framework.IIterator;

    internal class FilterIterator implements IIterator {
        private var _sourceIterator:IIterator;
        private var _function:Function;
        private var _next:*;


        public function FilterIterator (sourceIterator:IIterator, f:Function) {
            _sourceIterator = sourceIterator;
            _function = f;
        }

        public function next ():* {
            var re:* = _next;
            _next = undefined;
            return re;
        }

        public function hasNext ():Boolean {
            if (_next != undefined) {
                return true;
            }
            while (_sourceIterator.hasNext()) {
                var item:* = _sourceIterator.next();
                if (_function(item)) {
                    _next = item;
                    return true;
                }
            }
            return false;
        }
    }
}
