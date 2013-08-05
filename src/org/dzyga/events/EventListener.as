package org.dzyga.events {
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    public class EventListener {
        private var _target:IEventDispatcher;
        private var _event:String;
        private var _callback:Function;
        private var _thisArg:*;
        private var _args:Array;
        private var _once:Boolean = false;
        private var _useCapture:*;
        private var _hash:String;

        private static var _hashTable:Dictionary = new Dictionary(true);

        public function EventListener (
                target:IEventDispatcher, event:String, callback:Function,
                once:Boolean = false, thisArg:* = null, argArray:Array = null,
                useCapture:* = undefined, hash:String = undefined) {
            _target = target;
            _event = event;
            _callback = callback;
            _thisArg = thisArg;
            _args = argArray;
            _once = once;
            _useCapture = useCapture;
            _hash = hash || DispatcherProxy.listenerHashGenerate(target, event, callback, useCapture);
        }

        public function listen (priority:Number = 0, useWeakReference:Boolean = true):EventListener {
            _target.addEventListener(_event, call, useCapture, priority, useWeakReference);
            return this;
        }

        public function destroy ():EventListener {
            _target.removeEventListener(_event, call, useCapture);

            // Release links for gc...
            _target = null;
            _event = null;
            _callback = null;
            _thisArg = null;
            _args = null;

            return this;
        }

        public function call (event:Event):void {
            var callbackArgs:Array = [event];
            for each (var a:* in _args) {
                callbackArgs.push(a);
            }
            _callback.apply(_thisArg, callbackArgs);
        }

        public function get target ():IEventDispatcher {
            return _target;
        }

        public function get event ():String {
            return _event;
        }

        public function get callback ():Function {
            return _callback;
        }

        public function get thisArg ():* {
            return _thisArg;
        }

        public function get args ():Array {
            return _args;
        }

        public function get useCapture ():Boolean {
            return _useCapture;
        }

        public function get hash ():String {
            return _hash;
        }

        public function get once ():Boolean {
            return _once;
        }
    }
}
