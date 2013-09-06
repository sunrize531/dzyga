package org.dzyga.eventloop {
    import flash.display.DisplayObject;
    import flash.errors.IllegalOperationError;
    import flash.utils.getTimer;

    import org.dzyga.callbacks.ITask;

    public class TweenAbstract extends FrameEnterTask {
        protected var _object:*;
        protected var _timeStart:Number;
        protected var _timeTotal:Number;
        protected var _value:Number;
        protected var _valueInitial:Number;
        protected var _valueCurrent:Number;

        public function TweenAbstract (object:*, time:Number, value:Number, loop:Loop = null) {
            super(loop);
            _object = object;
            _timeTotal = time;
            _value = value;
        }

        /**
         * Get value of property which should be tweened.
         *
         * @return
         */
        protected function getValue ():Number {
            throw new IllegalOperationError('Not implemented');
        }

        /**
         * Set value of target property. Called internally each frame.
         *
         * @param value Current property's value
         * @return
         */
        protected function setValue (value:Number):Number {
            throw new IllegalOperationError('Not implemented');
        }

        /**
         * Current tween position.
         *
         * @return
         */
        protected function getPosition ():Number {
            return (getTimer() - _timeStart) / _timeTotal;
        }

        public function get object ():Object {
            return _object;
        }

        public function run ():* {
            var position:Number = getPosition();
            if (position >= 1) {
                super.resolve();
                return _value;
            } else {
                _valueCurrent = _valueInitial + (_value - _valueInitial) * position;
                return setValue(_valueCurrent);
            }
        }

        override public function start (...args):ITask {
            _timeStart = getTimer();
            _valueInitial = getValue();
            super.start.apply(this, args);
            return this;
        }

        override public function resolve (...args):ITask {
            setValue(_value);
            return super.resolve.apply(this, args);
        }

        override public function reject (...args):ITask {
            setValue(_valueInitial);
            return super.reject.apply(this, args);
        }
    }
}
