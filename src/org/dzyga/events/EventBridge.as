package org.dzyga.events {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

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
     * - Each event will be cloned for each callback (in native EventDispatcher the first Event object will be passed
     *   to the first listener as is, for following dispatchers it will be cloned).
     */
    public class EventBridge implements IEventDispatcher {
        protected var _target:EventDispatcher;
        protected var _listenerMap:Map = new Map();
        protected var _directListenerList:LinkedList = new LinkedList();

        public function EventBridge (target:EventDispatcher) {
            _target = target;
        }


        /**
         * Add listener for bridge's target.
         *
         * @param eventType - Event type to listen
         * @param callback - callback function
         * @param once - remove callback after first run
         * @param thisArg - bind callback to thisArgs
         * @param argArray - pass additional arguments to callback
         * @return this
         */
        public function listen (
                eventType:String, callback:Function, once:Boolean = false,
                thisArg:* = null, argArray:Array = null):EventBridge {
            return listenTo(_target, eventType, callback, once, thisArg, argArray);
        }

        /**
         * Add listener for target.
         *
         * @param target
         * @param eventType
         * @param callback
         * @param thisArg
         * @param argArray
         * @return
         */
        public function listenTo (
                target:IEventDispatcher, eventType:String, callback:Function, once:Boolean = false,
                thisArg:* = null, argArray:Array = null):EventBridge {
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

        public function isListening (eventType:String = null, callback:Function = null):Boolean {
            return isListeningTo(_target, eventType, callback);
        }

        public function isListeningTo (
                target:IEventDispatcher = null, eventType:String = '',
                callback:Function = null):Boolean {
            var re:Boolean = true;
            if (callback == null) {
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

        public function stopListening (eventType:String = '', callback:Function = null):EventBridge {
            return stopListeningTo(_target, eventType, callback);
        }

        public function stopListeningTo (
                target:IEventDispatcher = null, eventType:String = '',
                callback:Function = null):EventBridge {

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

        public function clear ():EventBridge {
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
                listener.call(event.clone());
                if (listener.once) {
                    listenerRemoved = listenerIterator.remove();
                }
            }
            if (listenerRemoved) {
                emptyTargetsCleanUp();
            }
        }

        public function addEventListener (
                type:String, listener:Function, useCapture:Boolean = false,
                priority:int = 0, useWeakReference:Boolean = false):void {
            var eventListener:EventListener = new EventListener(
                _target, type, listener, false, null, null, useCapture);
            eventListener.listen(priority, useWeakReference);
            _directListenerList.add(eventListener);
        }

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

        public function dispatchEvent (event:Event):Boolean {
            return _target.dispatchEvent(event);
        }

        public function hasEventListener (type:String):Boolean {
            return _target.hasEventListener(type);
        }

        public function willTrigger (type:String):Boolean {
            return _target.willTrigger(type);
        }

        public static function listenerHashGenerate (target:IEventDispatcher, event:String, callback:Function, useCapture:Boolean = false):String {
            var targetHash:String = ObjectUtils.hash(target);
            var callbackHash:String = ObjectUtils.hash(callback);
            return event + StringUtils.fillleft(
                (Number(targetHash) + Number(callbackHash) + Number(useCapture)).toFixed(0), 16, '0');
        }

        public static function targetHashGenerate (target:IEventDispatcher, event:String):String {
            return event + ObjectUtils.hash(target);
        }
    }
}