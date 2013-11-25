package org.dzyga.events {
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    import org.as3commons.collections.LinkedList;
    import org.as3commons.collections.Map;
    import org.as3commons.collections.framework.core.MapIterator;
    import org.dzyga.utils.ObjectUtils;
    import org.dzyga.utils.StringUtils;

    /**
     * This class created to extend IEventDispatcher functionality with custom methods listen, listenTo,
     * stopListening and stopListeningTo.
     *
     * - All event listeners will be removed from target(s) when clear method called, including those, which added
     *   with addEventListener methods.
     * - Event listeners added with listen and listenTo methods will be executed in insertion order.
     * - Event listeners added with listen and listenTo methods can be executed with additional arguments array
     *   and with another content (this).
     * - Each callback can be added with listen and listenTo as listener only once for each target.
     */
    public class DispatcherProxy implements IDispatcherProxy {
        protected var _target:IEventDispatcher;
        protected var _listenerMap:Map = new Map();
        protected var _directListenerList:LinkedList = new LinkedList();

        public function DispatcherProxy (target:IEventDispatcher) {
            _target = target;
        }


        /**
         * @inheritDoc
         */
        public function listen (
                eventType:String, callback:Function, once:Boolean = false,
                thisArg:* = null, argArray:Array = null):IDispatcherProxy {
            return listenTo(_target, eventType, callback, once, thisArg, argArray);
        }

        /**
         * @inheritDoc
         */
        public function listenTo (
                target:IEventDispatcher, eventType:String, callback:Function, once:Boolean = false,
                thisArg:* = null, argArray:Array = null):IDispatcherProxy {
            var targetHash:String = targetHashGenerate(target, eventType);
            var listenerHash:String = listenerHashGenerate(target, eventType, callback);
            var targetListenerMap:TargetListenerMap;
            if (!_listenerMap.hasKey(targetHash)) {
                targetListenerMap = new TargetListenerMap(target, eventType, targetHash);
                _listenerMap.add(targetHash, targetListenerMap);
                target.addEventListener(eventType, eventListenerRun, false, 0, true);
            } else {
                targetListenerMap = _listenerMap.itemFor(targetHash) as TargetListenerMap;
                if (targetListenerMap.hasKey(listenerHash)) {
                    // Listener did not passed uniqueness check. Maybe even throw something here...
                    return this;
                }
            }
            targetListenerMap.listenerPut(new EventListener(
                target, eventType, callback, once, thisArg, argArray, false, listenerHash));
            return this;
        }

        /**
         * @inheritDoc
         */
        public function isListening (eventType:String = '', callback:Function = null):Boolean {
            return isListeningTo(_target, eventType, callback);
        }

        /**
         * @inheritDoc
         */
        public function isListeningTo (
                target:IEventDispatcher = null, eventType:String = '',
                callback:Function = null):Boolean {
            var re:Boolean = true;
            if (target && eventType && callback == null) {
                re = target.hasEventListener(eventType);
            } else {
                var listenerIterator:ListenerIterator = new ListenerIterator(_listenerMap, target, eventType, callback);
                re = listenerIterator.hasNext();
            }
            if (!re) {
                var directListenerIterator:DirectListenerFilterIterator = new DirectListenerFilterIterator(
                    _directListenerList, target, eventType, callback);
                if (directListenerIterator.hasNext()) {
                    return true;
                }
            }
            return re;
        }

        /**
         * @inheritDoc
         */
        public function stopListening (eventType:String = '', callback:Function = null):IDispatcherProxy {
            return stopListeningTo(_target, eventType, callback);
        }

        /**
         * @inheritDoc
         */
        public function stopListeningTo (
                target:IEventDispatcher = null, eventType:String = '',
                callback:Function = null):IDispatcherProxy {

            // First remove matching listeners.
            var listenerIterator:ListenerIterator = new ListenerIterator(_listenerMap, target, eventType, callback);
            while (listenerIterator.hasNext()) {
                listenerIterator.next();
                listenerIterator.remove();
            }

            // Remove empty target listeners.
            emptyTargetsCleanUp();

            // Now remove direct listeners.
            var directListenerIterator:DirectListenerFilterIterator = new DirectListenerFilterIterator(
                _directListenerList, target, eventType, callback);
            while (directListenerIterator.hasNext()) {
                var eventListener:EventListener = directListenerIterator.next();
                eventListener.destroy();
                directListenerIterator.remove();
            }
            return this;
        }

        /**
         * @inheritDoc
         */
        public function trigger (eventType:String):IDispatcherProxy {
            return triggerTo(_target, eventType);
        }

        /**
         * @inheritDoc
         */
        public function triggerTo (target:IEventDispatcher, eventType:String):IDispatcherProxy {
            target.dispatchEvent(new Event(eventType));
            return this;
        }

        /**
         * @inheritDoc
         */
        public function clear ():IDispatcherProxy {
            // TODO: Can do it faster. Just iterate through all targets, remove listeners and clear collections.
            return stopListeningTo();
        }

        private function emptyTargetsCleanUp ():void {
            var targetIterator:MapIterator = _listenerMap.iterator() as MapIterator;
            while (targetIterator.hasNext()) {
                var targetListenerMap:TargetListenerMap = targetIterator.next() as TargetListenerMap;
                if (!targetListenerMap.size) {
                    targetListenerMap.target.removeEventListener(targetListenerMap.event, eventListenerRun);
                    targetIterator.remove();
                }
            }
        }

        /**
         * Will run EventListeners registered for current event.
         *
         * @param event
         */
        private function eventListenerRun (event:Event):void {
            var eventTarget:IEventDispatcher = event.currentTarget as IEventDispatcher;
            var eventType:String = event.type;
            var listenerIterator:ListenerIterator = new ListenerIterator(_listenerMap, eventTarget, eventType);
            var listenerRemoved:Boolean = false;
            while (listenerIterator.hasNext()) {
                var listener:EventListener = listenerIterator.next() as EventListener;
                listener.call(event);
                if (listener.once) {
                    listenerRemoved = listenerRemoved || listenerIterator.remove();
                }
            }
            if (listenerRemoved) {
                emptyTargetsCleanUp();
            }
        }

        /**
         * @inheritDoc
         */
        public function addEventListener (
                type:String, listener:Function, useCapture:Boolean = false,
                priority:int = 0, useWeakReference:Boolean = false):void {
            var eventListener:EventListener = new EventListener(
                _target, type, listener, false, null, null, useCapture);
            eventListener.listen(priority, useWeakReference);
            _directListenerList.add(eventListener);
        }

        /**
         * @inheritDoc
         */
        public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void {
            _target.removeEventListener(type, listener, useCapture);
            var directListenerIterator:DirectListenerFilterIterator = new DirectListenerFilterIterator(
                _directListenerList, _target, type, listener, useCapture);
            while (directListenerIterator.hasNext()) {
                var eventListener:EventListener = directListenerIterator.next();
                eventListener.destroy();
                directListenerIterator.remove();
            }
        }

        /**
         * @inheritDoc
         */
        public function dispatchEvent (event:Event):Boolean {
            return _target.dispatchEvent(event);
        }

        /**
         * @inheritDoc
         */
        public function hasEventListener (type:String):Boolean {
            return _target.hasEventListener(type);
        }

        /**
         * @inheritDoc
         */
        public function willTrigger (type:String):Boolean {
            return _target.willTrigger(type);
        }

        /**
         * @inheritDoc
         */
        public static function listenerHashGenerate (
                target:IEventDispatcher, event:String,
                callback:Function, useCapture:Boolean = false):String {

            return StringUtils.fillleft(StringUtils.checksum(
                event + ObjectUtils.hash(target) + ObjectUtils.hash(callback)).toFixed(0), 16, '0');
        }

        /**
         * @inheritDoc
         */
        public static function targetHashGenerate (target:IEventDispatcher, event:String):String {
            return event + ObjectUtils.hash(target);
        }

        private static var _dispatcherProxyHash:Dictionary = new Dictionary(true);
        internal static function get dispatcherProxyHash ():Dictionary {
            return _dispatcherProxyHash;
        }
    }
}