package org.dzyga.events {
    import flash.events.IEventDispatcher;

    public interface IDispatcherProxy extends IEventDispatcher {
        function listen (
            eventType:String, callback:Function, once:Boolean = false,
            thisArg:* = null, argArray:Array = null):IDispatcherProxy;
        function listenTo (
            target:IEventDispatcher, eventType:String, callback:Function, once:Boolean = false,
            thisArg:* = null, argArray:Array = null):IDispatcherProxy;

        function isListening (eventType:String = null, callback:Function = null):Boolean;
        function isListeningTo (
            target:IEventDispatcher = null, eventType:String = '',
            callback:Function = null):Boolean;

        function stopListening (eventType:String = '', callback:Function = null):IDispatcherProxy;
        function stopListeningTo (
            target:IEventDispatcher = null, eventType:String = '',
            callback:Function = null):IDispatcherProxy;

        function trigger (eventType:String):IDispatcherProxy;
        function triggerTo (target:IEventDispatcher, eventType:String):IDispatcherProxy;
    }
}
