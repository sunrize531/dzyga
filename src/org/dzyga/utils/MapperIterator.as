package org.dzyga.utils {
    import org.as3commons.collections.framework.IIterator;

    internal class MapperIterator implements IIterator {
        private var _sourceIterator:IIterator;
        private var _function:Function;


        public function MapperIterator (sourceIterator:IIterator, f:Function) {
            _sourceIterator = sourceIterator;
            _function = f;
        }

        public function next ():* {
            return _function(_sourceIterator.next());
        }

        public function hasNext ():Boolean {
            return _sourceIterator.hasNext();
        }
    }
}
