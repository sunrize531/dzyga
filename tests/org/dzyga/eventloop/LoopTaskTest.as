package org.dzyga.eventloop {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import org.flexunit.async.Async;

    public class LoopTaskTest {
        private var _loopTask:LoopTask;

        private static var _dispatcher:IEventDispatcher = new EventDispatcher();
        private static var _loop:Loop;

        private static function frameEnterTrigger (count:int = 1):void {
            for (var i:int = 0; i < count; i++) {
                _dispatcher.dispatchEvent(new Event(Event.ENTER_FRAME));
            }
        }

        [BeforeClass]
        public static function loopInit ():void {
            _dispatcher = new EventDispatcher();
            LoopSubclass.initLoop(_dispatcher, 25);
            _loop = new LoopSubclass();
        }

        [Before]
        public function loopTaskInit ():void {
            _loopTask = new LoopTaskSubclass(_loop);
        }

        [After]
        public function loopTaskClear ():void {
            _loopTask.clear();
        }

        private static const RESOLVE_EVENT:String = 'resolve';

        private static function resolveCallback ():void {
            _dispatcher.dispatchEvent(new Event(RESOLVE_EVENT));
        }

        [Test(async, timeout=2000)]
        public function resolveTest ():void {
            Async.proceedOnEvent(this, _dispatcher, RESOLVE_EVENT);
            _loopTask.doneCallbackRegister(resolveCallback, true);
            _loopTask.start();
            frameEnterTrigger(15);
        }
    }
}

import org.dzyga.eventloop.Loop;
import org.dzyga.eventloop.LoopTask;
import org.dzyga.eventloop.wait;

class LoopTaskSubclass extends LoopTask {
    private var _counter:int = 0;
    private var _iterations:int = 0;

    public function LoopTaskSubclass(loop:Loop = null, iterations:int = 10) {
        super(loop);
        _iterations = iterations;
    }


    public function run ():void {
        wait(100);
        if (_counter++ >=  _iterations) {
            resolve();
        } else {
            notify();
        }
    }
}

