package org.dzyga.events {
    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterable;

    public interface IPromise extends IIterable {
        function callbackRegister (callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise;
        function callbackRemove (callback:Function = null):IPromise;
        function callbackIterator (callback:Function = null):ICollectionIterator;
        function resolve (... args):IPromise;
        function clear ():IPromise;
    }
}
