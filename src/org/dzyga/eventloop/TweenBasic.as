package org.dzyga.eventloop {
    public class TweenBasic extends TweenAbstract {
        protected var _property:String;

        public function TweenBasic (object:*, property:String, time:Number, value:Number, loop:Loop = null) {
            super(object, time, value, loop);
            _property = property;
        }

        override protected function getValue ():Number {
            return object[_property];
        }

        override protected function setValue (value:Number):Number {
            _object[_property] = value;
            return value;
        }
    }
}
