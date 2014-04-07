package org.dzyga.events {
    import flash.events.IEventDispatcher;

    import org.dzyga.collections.IHashable;
    import org.dzyga.collections.SetOrdered;

    public class TargetListenerSet extends SetOrdered implements IHashable {
        private var _target:IEventDispatcher;
        private var _event:String;
        private var _targetHash:String;

        public function TargetListenerSet (target:IEventDispatcher, event:String, targetHash:String = null) {
            _target = target;
            _event = event;
            _targetHash = targetHash || DispatcherProxy.targetHashGenerate(target, event);
        }

        public function get target ():IEventDispatcher {
            return _target;
        }

        public function get event ():String {
            return _event;
        }

        public function hash ():* {
            return _targetHash;
        }
    }
}
