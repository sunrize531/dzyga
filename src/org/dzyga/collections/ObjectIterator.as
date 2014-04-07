package org.dzyga.collections {
    import org.dzyga.utils.ObjectUtils;

    public class ObjectIterator implements IMappingIterator {
        protected var _object:Object;
        protected var _keys:Array;
        protected var _current:int = -1;

        public function ObjectIterator (object:Object) {
            _object = object;
            reset();
        }

        public function hasNext ():Boolean {
            return _current < _keys.length - 1;
        }

        public function next ():* {
            return _object[nextKey()];
        }

        public function nextKey ():* {
            return _keys[++_current];
        }

        public function nextItem ():KeyValue {
            var key:* = nextKey();
            return new KeyValue(key, _object[key]);
        }

        public function remove ():Boolean {
            if (_current == -1) {
                if (_keys.length) {
                    delete _object[_keys.shift()];
                    return true;
                } else {
                    return false;
                }
            } else if (_current < _keys.length) {
                delete _object[_keys[_current]];
                _keys.splice(_current--, 1);
                return true;
            }
            return false;
        }

        public function reset ():void {
            _keys = ObjectUtils.keys(_object);
            _current = -1;
        }
    }
}