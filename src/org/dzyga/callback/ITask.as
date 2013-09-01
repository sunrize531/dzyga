package org.dzyga.callback {
    public interface ITask {
        // Promises
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
         * Task state. One of TaskState.STARTED, TaskState.RESOLVED, TaskState.REJECTED or TaskState.IDLE.
         */
        function get state ():String;

        // State switches
        /**
         * Set state to TaskState.STARTED, resolve start callback with args prepended with task instance.
         *
         * @param args
         * @return
         * @throw IllegalOperationError if task is not in TaskState.IDLE state.
         */
        function start (... args):ITask;

        /**
         * Resolve progress promise with args, prepended with task instance.
         *
         * @param args
         * @return
         * @throw IllegalOperationError if task is not in TaskState.STARTED state.
         */
        function notify (... args):ITask;

        /**
         * Set state to TaskState.RESOLVED, resolve done and finished callback with args, prepended with task instance,
         * than set state to TaskState.IDLE.
         *
         * @param args
         * @return this
         */
        function resolve (... args):ITask;

        /**
         * Set state to TaskState.REJECTED, resolve failed and finished callback with args, prepended with task instance,
         * than set state to TaskState.IDLE.
         *
         * @param args
         * @return this
         */
        function reject (... args):ITask;

        /**
         * Clear all promises. Set state to TaskState.IDLE.
         *
         * @return this
         */
        function clear ():ITask;
    }
}
