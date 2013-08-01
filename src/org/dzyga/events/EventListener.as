package org.dzyga.events {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    import org.dzyga.utils.StringUtils;

    public class EventListener {
        private var _target:EventDispatcher;
        private var _event:String;
        private var _callback:Function;
        private var _thisArg:*;
        private var _args:Array;

        private static var _hashTable:Dictionary = new Dictionary(true);

        public function EventListener (target:EventDispatcher, event:String, callback:Function,
                                       thisArg:* = null, argArray:Array = null) {
            _target = target;
            _event = event;
            _callback = callback;
            _thisArg = thisArg;
            _args = argArray;
        }

        public function listen ():EventListener {
            _target.addEventListener(_event, call, false, 0, true);
            return this;
        }

        public function destroy ():EventListener {
            _target.removeEventListener(_event, call);

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
            if (_args) {
                callbackArgs.concat(_args);
            }
            _callback.apply(_thisArg, callbackArgs);
        }

        public function get target ():EventDispatcher {
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

        private static function getHash (object:Object):String {
            var hash:String = _hashTable[object];
            if (!hash) {
                hash = StringUtils.uniqueID();
                _hashTable[object] = hash;
            }
            return hash;
        }

        public static function listenerHash (target:EventDispatcher, callback:Function):String {
            var targetHash:String = getHash(target);
            var callbackHash:String = getHash(callback);
            return StringUtils.fillleft(Number(targetHash) + Number(callbackHash).toFixed(16), 16, '0');
        }
    }
}
