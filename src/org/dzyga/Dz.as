package org.dzyga {
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;

    import org.dzyga.display.DisplayProxy;
    import org.dzyga.events.IDispatcherProxy;

    public class Dz {
        public static function dispatcher (target:IEventDispatcher, ProxyClass:Class = null):IDispatcherProxy {
            return org.dzyga.events.dispatcher(target);
        }

        public static function display (view:DisplayObject):IDispatcherProxy {
            return new DisplayProxy(view);
        }
    }
}
