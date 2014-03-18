package org.dzyga.timer {
    import flash.utils.getTimer;

    import org.dzyga.callbacks.IPromise;
    import org.dzyga.callbacks.ITask;
    import org.dzyga.callbacks.Promise;
    import org.dzyga.eventloop.FrameEnterTask;

    public class TimerTask extends FrameEnterTask {
        private var _time:Number;
        private var _ticksInterval:Number;

        private var _startTime:Number;
        private var _accumulatedTime:Number;

        private var _pausePromise:IPromise;
        private var _resumePromise:IPromise;

        private var _paused:Boolean;
        private var _pauseTime:Number;

        public function TimerTask(pTime:Number, pTicksInterval:Number) {
            _time          = pTime;
            _ticksInterval = pTicksInterval;

            _pausePromise  = new Promise();
            _resumePromise = new Promise();

            super();
        };

        public function get pausePromise():IPromise {
            return _pausePromise;
        };

        public function get resumePromise():IPromise {
            return _resumePromise;
        };

        public function get paused():Boolean {
            return _paused;
        };

        public function get time():Number {
            return _time;
        };

        override public function start(...args):ITask {
            var currentTime:Number = getTimer();

            _startTime       = currentTime;
            _accumulatedTime = currentTime;

            _accumulatedTime = 0;

            return super.start.apply(this, args);
        };

        override public function run(...args):* {
            var currentTime:Number = getTimer();

            var timeDiff:Number         = currentTime - _startTime;
            var accumulationDiff:Number = currentTime - _accumulatedTime;

            if (accumulationDiff >= _ticksInterval) {
                notify(timeDiff);

                _accumulatedTime = currentTime;
            }

            if (timeDiff >= _time) {
                resolve();
            }

            return super.run.apply(this, args);
        };

        override public function clear():ITask {
            _pausePromise.clear();
            _resumePromise.clear();

            _pausePromise  = null;
            _resumePromise = null;

            return super.clear();
        };

        public function pause(...args):ITask {
            _paused    = true;
            _pauseTime = getTimer();

            loopCallbackRemove();
            resolvePromise(pausePromise, args);

            return this;
        };

        public function resume(...args):ITask {
            var timeDiff:Number = getTimer() - _pauseTime;

            _paused = false;

            _startTime       += timeDiff;
            _accumulatedTime += timeDiff;

            loopCallbackRegister();
            resolvePromise(resumePromise, args);

            return this;
        };

        public function addTime(pTime:int):void {
            _time += pTime;
        };
    };
}
