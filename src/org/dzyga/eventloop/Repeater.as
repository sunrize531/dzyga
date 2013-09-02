package org.dzyga.eventloop {
    public class Repeater extends LoopTask {
        protected var _callback:Function;
        protected var _priority:Number;
        protected var _thisArg:*;
        protected var _argsArray:Array;


        public function Repeater (
                callback:Function, priority:Number = 1, thisArg:* = null, argsArray:Array = []) {
            super();
            _callback = callback;
            _priority = priority;
            _thisArg = thisArg;
            _argsArray = argsArray;
        }

        override public function get callback ():Function {
            return _callback;
        }

        override public function get thisArg ():* {
            return _thisArg;
        }

        override public function get argsArray ():Array {
            return _argsArray;
        }

        override public function get priority ():Number {
            return _priority;
        }
    }
}
