package org.dzyga.callback {
    public interface IHandle {
        /**
         * Registered callback.
         */
        function get callback ():Function;

        /**
         * Context to apply callback on.
         */
        function get thisArg ():*;

        /**
         * Callback arguments.
         */
        function get argsArray ():Array;

        /**
         * Unique hash for this Handle instance.
         */
        function get hash ():String;

        /**
         * True if handle is canceled.
         */
        function get canceled ():Boolean;

        /**
         * Run callback. args will be appended to Handle's args.
         * @param args
         * @return
         * @throws flash.errors.IllegalOperationError if handle is canceled
         */
        function call (... args):*;

        /**
         * Returns callback execution result.
         */
        function get result ():*;

        /**
         * Cancel handle.
         */
        function cancel ():Boolean;
    }
}
