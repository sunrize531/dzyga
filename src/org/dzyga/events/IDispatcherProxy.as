package org.dzyga.events {
    import flash.events.IEventDispatcher;

    public interface IDispatcherProxy extends IEventDispatcher {
        /**
         * Add listener to current proxy target.
         *
         * @param eventType Event type to listen
         * @param callback Function to call.
         * @param once Remove callback after first run.
         * @param thisArg Apply callback to specified context.
         * @param argArray Execute callback with additional arguments. Arguments will be appended to event.
         * @return this
         */
        function listen (
            eventType:String, callback:Function, once:Boolean = false,
            thisArg:* = null, argArray:Array = null):IDispatcherProxy;

        /**
         * Add listener to target.
         *
         * @param target Event dispatcher
         * @param eventType Event type to listen.
         * @param callback Function to call.
         * @param once Remove callback after first run.
         * @param thisArg Apply callback to specified context.
         * @param argArray Execute callback with additional arguments. Arguments will be appended to event.
         * @return this
         */
        function listenTo (
            target:IEventDispatcher, eventType:String, callback:Function, once:Boolean = false,
            thisArg:* = null, argArray:Array = null):IDispatcherProxy;

        /**
         * Return true if current DispatcherProxy instance listening eventType and/or callback on current target.
         *
         * @param eventType Event type to check. Pass an empty string to check all event types.
         * @param callback Check for callback. Pass null to check all callbacks.
         * @return true if there are matching listeners.
         */
        function isListening (eventType:String = '', callback:Function = null):Boolean;

        /**
         * Return true if current DispatcherProxy instance listening eventType and/or callback on current target.
         *
         * @param target Target to check. Pass null here to check all targets.
         * @param eventType Event type to check. Pass an empty string to check all event types.
         * @param callback Check for callback. Pass null to check all callbacks.
         * @return true if there are matching listeners.
         */
        function isListeningTo (
            target:IEventDispatcher = null, eventType:String = '',
            callback:Function = null):Boolean;

        /**
         * Remove matching callbacks from current target.
         *
         * @param eventType Event type to check. Pass an empty string to remove callbacks for all event types.
         * @param callback Check for callback. Pass null to remove all callbacks.
         * @return this
         */
        function stopListening (eventType:String = '', callback:Function = null):IDispatcherProxy;

        /**
         * Remove matching callbacks from target.
         *
         * @param target Target to check. Pass null here to check all targets.
         * @param eventType Event type to check. Pass an empty string to remove callbacks for all event types.
         * @param callback Check for callback. Pass null to remove all callbacks.
         * @return this
         */
        function stopListeningTo (
            target:IEventDispatcher = null, eventType:String = '',
            callback:Function = null):IDispatcherProxy;

        /**
         * Create an Event instance with specified eventType and dispatch it on current target.
         *
         * @param event Event. Can be string or Event itself. If String - default Event will be instantiated.
         * @param data Data to send with event.
         * @return this
         */
        function trigger (event:*, data:* = null):IDispatcherProxy;

        /**
         * Create an Event instance with specified eventType and dispatch it on target.
         *
         * @param target Target to dispatch event on.
         * @param event Event. Can be string or Event itself. If String - default Event will be instantiated.
         * @param data Data to send with event.
         * @return this
         */
        function triggerTo (target:IEventDispatcher, event:*, data:* = null):IDispatcherProxy;
    }
}
