package org.dzyga.events {
    import flash.events.IEventDispatcher;

    import org.as3commons.collections.LinkedMap;

    public class TargetListenerMap extends LinkedMap {
        private var _target:IEventDispatcher;
        private var _event:String;
        private var _targetHash:String;

        public function TargetListenerMap (target:IEventDispatcher, event:String, targetHash:String = null) {
            _target = target;
            _event = event;
            _targetHash = targetHash || EventBridge.targetHashGenerate(target, event);
        }

        public function get target ():IEventDispatcher {
            return _target;
        }

        public function get event ():String {
            return _event;
        }

        public function get targetHash ():String {
            return _targetHash;
        }

        public function listenerPut (listener:EventListener):EventListener {
            return add(listener.hash, listener) as EventListener;
        }

        public function listenerRemove (listener:EventListener):EventListener {
            return removeKey(listener.hash);
        }
    }
}
