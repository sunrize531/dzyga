package org.dzyga.eventloop {
    import flash.utils.getTimer;

    import org.dzyga.callbacks.ITask;
    import org.dzyga.utils.ObjectUtils;

    public class Tween extends FrameEnterTask {
        protected var _object:*;
        protected var _timeStart:Number;
        protected var _timeTotal:Number;
        protected var _valuesObject:Object;
        protected var _valuesInitial:Object;
        protected var _valuesDifference:Object;
        protected var _transitionParams:Object;
        protected var _tweenFunction:Function;

        public function Tween (object:*, time:Number, values:Object, transition:String = null, loop:Loop = null) {
            super(loop);
            _object = object;
            _timeTotal = time * 1000;
            _valuesObject = values;
            _tweenFunction = TweenTransitions.getFunction(transition);
        }

        /**
         * Additional parameters to be passed to the transition equation. Some transition equations,
         * specially custom transitions, can optionally receive additional parameters that change
         * aspects of the transition equation; they're defined on this parameter.
         *
         * *_ELASTIC transitions can have params:
         *      transitionParams.period -- ?? default: time * 0.3
         *      transitionParams.amplitude -- ?? default: 0
         *
         * *_BACK transitions can have params:
         *      transitionParams.overshoot -- percent of overshoot; default: 1.70158
         *
         * */
        public function setTransitionParams(transitionParams:Object):void {
            _transitionParams = transitionParams;
        }

        /**
         * Set value of target property. Called internally each frame.
         *
         * @param valuesObject Current properties
         * @return
         */
        protected function setValues (valuesObject:Object):void {
            ObjectUtils.update(_object, valuesObject);
        }

        public function get object ():Object {
            return _object;
        }

        override public function run (args:Array):* {
            var time:Number = getTimer() - _timeStart;
            if (time >= _timeTotal) {
                resolve();
            } else {
                var progress:Number = _tweenFunction(time, 0, 1, _timeTotal, _transitionParams);
                for (var prop:String in _valuesDifference) {
                    _object[prop] = _valuesInitial[prop] + _valuesDifference[prop] * progress;
                }
            }
        }

        override public function start (...args):ITask {
            _timeStart = getTimer();
            _valuesInitial = {};
            _valuesDifference = {};
            for (var prop:String in _valuesObject) {
                var value:* = _object[prop];
                _valuesInitial[prop] = value;
                _valuesDifference[prop] = _valuesObject[prop] - value;
            }
            loopCallbackRegister();
            return super.start.apply(this, args);
        }

        override public function resolve (...args):ITask {
            setValues(_valuesObject);
            return super.resolve.apply(this, args);
        }
    }
}
