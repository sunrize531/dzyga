package org.dzyga.eventloop {
    public class TweenBasic extends Tween {

        public function TweenBasic (object:*, property:String, time:Number, value:Number) {
            var values:Object = {};
            values[property] = value;
            super(object, time, values);
        }
    }
}