package org.dzyga.utils {
    import org.as3commons.collections.framework.IIterator;
    import org.dzyga.callbacks.Handle;

    internal class MapperIterator implements IIterator {
        private var _sourceIterator:IIterator;
        private var _handle:Handle;
        private var _function:Function;
        private var _thisArg:*;
        private var _argsArray:Array;

        public function MapperIterator (
                sourceIterator:IIterator, f:Function, thisArg:* = null, argsArray:Array = null) {
            _sourceIterator = sourceIterator;
            _handle = new Handle(f, thisArg, argsArray);
        }

        public function next ():* {
            return _function.apply(_thisArg, [_sourceIterator.next()].concat(_argsArray));
        }

        public function hasNext ():Boolean {
            return _sourceIterator.hasNext();
        }
    }
}
