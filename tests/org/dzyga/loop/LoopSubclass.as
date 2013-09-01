package org.dzyga.loop {
    import org.dzyga.events.*;
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import org.dzyga.loop.Loop;

    public class LoopSubclass extends Loop {
        protected static var _fps:Number;

        public static function initLoop (eventDispatcher:IEventDispatcher, fps:Number):void {
            _dispatcher = dispatcher(eventDispatcher)
                .listen(Event.ENTER_FRAME, frameEnterHandler)
                .listen(Event.EXIT_FRAME, frameExitHandler);

            _fps = fps;
        }

        public static function get fps ():Number {
            return _fps;
        }

        protected static function frameEnterHandler (e:Event):void {
            frameEnterProcess(1000 / fps * FRAME_ENTER_THRESHOLD);
        }

        protected static function frameExitHandler (e:Event):void {
            frameExitProcess(1000 / fps * FRAME_EXIT_THRESHOLD);
        }
    }
}
