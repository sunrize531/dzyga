package org.dzyga.utils {
    import org.as3commons.collections.framework.IIterator;
    import org.dzyga.callbacks.Handle;

    internal class FilterIterator implements IIterator {
        private var _sourceIterator:IIterator;
        private var _handle:Handle;
        private var _function:Function;
        private var _thisArg:*;
        private var _argsArray:Array;
        private var _next:*;


        public function FilterIterator (
                sourceIterator:IIterator, f:Function, thisArg:* = null, argsArray:Array = null) {
            _sourceIterator = sourceIterator;
            _handle = new Handle(f, thisArg, argsArray);
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
                if (_handle.call(item)) {
                    _next = item;
                    return true;
                }
            }
            return false;
        }
    }
}
