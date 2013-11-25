package org.dzyga {
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;

    import org.dzyga.display.DisplayProxy;
    import org.dzyga.display.IDisplayProxy;
    import org.dzyga.eventloop.Loop;
    import org.dzyga.events.IDispatcherProxy;

    public class Dz {
        public static function dispatcher (target:IEventDispatcher, ProxyClass:Class = null):IDispatcherProxy {
            return org.dzyga.events.dispatcher(target);
        }

        public static function display (view:DisplayObject):IDisplayProxy {
            return new DisplayProxy(view);
        }

        private static var _loop:Loop;
        public static function loop ():Loop {
            if (!_loop) {
                _loop = new Loop();
            }
            return _loop;
        }
    }
}
