package org.dzyga {
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;
    import org.dzyga.events.IDispatcherProxy;

    public class Dz {
        public static function dispatcher (target:IEventDispatcher, ProxyClass:Class = null):IDispatcherProxy {
            return org.dzyga.events.dispatcher(target);
        }

        public static function display (view:DisplayObject):IDispatcherProxy {
            return org.dzyga.display.display(view);
        }
    }
}
