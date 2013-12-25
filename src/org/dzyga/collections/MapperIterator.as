package org.dzyga.collections {
    import org.as3commons.collections.framework.IIterator;
    import org.dzyga.callbacks.Handle;

    internal class MapperIterator implements IIterator {
        private var _sourceIterator:IIterator;
        private var _handle:Handle;

        public function MapperIterator (
                sourceIterator:IIterator, f:Function, thisArg:* = null, argsArray:Array = null) {
            _sourceIterator = sourceIterator;
            _handle = new Handle(f, thisArg, argsArray);
        }

        public function next ():* {
            return _handle.call(_sourceIterator.next());
        }

        public function hasNext ():Boolean {
            return _sourceIterator.hasNext();
        }
    }
}
