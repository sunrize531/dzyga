package org.dzyga.callbacks {
    import org.dzyga.collections.IIterable;
    import org.dzyga.collections.ISequenceIterator;
    import org.dzyga.collections.SetOrdered;

    public interface IPromise extends IIterable {
        function get callbackCollection ():SetOrdered;

        /**
         * Add callback to run when promise resolved.
         *
         * @param callback Function to call.
         * @param once Remove callback after first run.
         * @param thisArg Apply callback to specified context.
         * @param argsArray Execute callback with additional arguments. Arguments will be appended to event.
         * @return this
         */
        function callbackRegister (callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise;

        /**
         * Remove all callbacks from promise.
         *
         * @param callback Function to call.
         * @return this
         */
        function callbackRemove (callback:Function = null):IPromise;

        /**
         * Iterate through all handles in promise. If callback argument specified will iterate only
         * through handles for specified callbacks.
         *
         * @param callback
         * @return
         */
        function callbackIterator (callback:Function = null):ISequenceIterator;

        /**
         * Resolve promise and execute all registered callbacks.
         *
         * @param args Arguments will be passed to callback. If callback registered with argsArray,
         * they will be appended to resolve arguments,
         * @return this
         */
        function resolve (... args):IPromise;

        /**
         * Remove all callbacks from promise.
         *
         * @return this
         */
        function clear ():IPromise;
    }
}
