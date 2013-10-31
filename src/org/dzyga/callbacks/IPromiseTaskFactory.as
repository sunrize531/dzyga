package org.dzyga.callbacks {
    public interface IPromiseTaskFactory {
        /**
         * Resolves when task started
         */
        function get started ():IPromise;

        /**
         * Resolves when task resolved
         */
        function get done ():IPromise;

        /**
         * Resolves when task rejected
         */
        function get failed ():IPromise;

        /**
         * Resolves when task resolved or rejected
         */
        function get finished ():IPromise;

        /**
         * Resolves when notify() method called
         */
        function get progress ():IPromise;

        /**
         * Clear all promises.
         * @return this
         */
        function clear():IPromiseTaskFactory;

        /**
         * Prepare promises for reusing if needed.
         * @return this
         */
        function reset():IPromiseTaskFactory;
    }
}
