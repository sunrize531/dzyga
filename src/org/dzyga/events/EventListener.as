package org.dzyga.events {
    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import org.dzyga.callback.Callback;

    public class EventListener extends Callback {
        protected var _target:IEventDispatcher;
        protected var _event:String;
        protected var _useCapture:*;

        public function EventListener (
                target:IEventDispatcher, event:String, callback:Function,
                once:Boolean = false, thisArg:* = null, argArray:Array = null,
                useCapture:* = undefined, hash:String = undefined) {
            super(callback, once, thisArg, argArray, hash);
            _target = target;
            _event = event;
            _useCapture = useCapture;
            _hash = hash || DispatcherProxy.listenerHashGenerate(target, event, callback, useCapture);
        }

        override public function hashGenerate ():String {
            return DispatcherProxy.listenerHashGenerate(_target, _event, _callback, _useCapture);
        }

        public function listen (priority:Number = 0, useWeakReference:Boolean = true):EventListener {
            _target.addEventListener(_event, onEvent, useCapture, priority, useWeakReference);
            return this;
        }

        public function destroy ():EventListener {
            _target.removeEventListener(_event, onEvent, useCapture);

            // Release links for gc...
            _target = null;
            _event = null;
            _callback = null;
            _thisArg = null;
            _argsArray = null;

            return this;
        }

        private function onEvent(e:Event):void {
            call(e);
        }

        public function get target ():IEventDispatcher {
            return _target;
        }

        public function get event ():String {
            return _event;
        }


        public function get useCapture ():Boolean {
            return _useCapture;
        }
    }
}
