/**
 * Created with IntelliJ IDEA.
 * User: sunrize
 * Date: 31.07.13
 * Time: 18:48
 * To change this template use File | Settings | File Templates.
 */
package org.dzyga.events {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    import org.as3commons.collections.Map;

    import org.as3commons.collections.Treap;

    public class EventBridge implements IEventDispatcher {
        protected var _target:EventDispatcher;
        protected var _listeners:Map = new Map();
        protected var _handlers:Map = new Map();

        public function EventBridge (target:EventDispatcher) {
            _target = target;
        }

        public function listen (event:String, callback:Function, thisArg:*, argArray:Array):EventBridge {
            return this;
        }

        public function listenTo (
                target:IEventDispatcher, event:String, callback:Function,
                thisArg:*, argArray:Array):EventBridge {
            return this;
        }

        public function addEventListener (
                type:String, listener:Function, useCapture:Boolean = false,
                priority:int = 0, useWeakReference:Boolean = false):void {
            _target.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void {
            _target.removeEventListener(type, listener, useCapture);
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
    }
}

import flash.events.Event;

// TODO: Rewrite Action to something similar to promise and use here instead.
class EventCallback {
    public var event:String;
    public var callback:Function;
    public var target:*;
    public var args:Array;


    public function EventCallback (event:String, callback:Function, thisArg:* = null, argArray:Array = null) {
        this.event = event;
        this.callback = callback;
        this.target = thisArg;
        this.args = argArray;
    }

    public function call (event:Event):void {
        var callbackArgs:Array = [event];
        if (args) {
            callbackArgs.concat(args);
        }
        callback.apply(target, callbackArgs);
    }
}