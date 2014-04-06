package org.dzyga.collections {
    import org.dzyga.callbacks.Handle;

    public class FilterIterator implements IIterator {
        protected var _sourceIterator:IIterator;
        private var _handle:Handle;
        private var _next:*;


        public function FilterIterator (
                sourceIterator:IIterator, f:Function, thisArg:* = null, argsArray:Array = null) {
            _sourceIterator = sourceIterator;
            _handle = new Handle(f, thisArg, argsArray);
        }

        public function next ():* {
            if (hasNext()) {
                var re:* = _next;
                _next = undefined;
                return re;
            }
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

        public function reset ():void {
            _sourceIterator.reset();
        }
    }
}
