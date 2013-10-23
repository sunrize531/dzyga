package org.dzyga.callbacks {
    import org.dzyga.utils.ArrayUtils;

    /**
     * Promise subclass. If resolved will run callbacks immediately after added.
     * Still can be resolved multiple times.
     */
    public class Once extends Promise {
        private var _resolved:Boolean = false;
        private var _resolveArgs:Array;

        public function Once (unique:Boolean = true) {
            super(unique);
        }

        /**
         * If Once is resolved callback will be run immediately. If once argument is false, handle will be created
         * and appended to promise, so it can be still executed on subsequent resolve calls.
         *
         * @param callback Function to call.
         * @param once Remove callback after first run.
         * @param thisArg Apply callback to specified context.
         * @param argsArray Execute callback with additional arguments. Arguments will be appended to event.
         * @return
         */
        override public function callbackRegister (
                callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise {
            if (callback != null) {
                if (_resolved) {
                    callback.apply(thisArg, ArrayUtils.add(_resolveArgs, argsArray));
                    if (once) {
                        return this;
                    }
                }
                super.callbackRegister(callback, once, thisArg, argsArray);
            }
            return this;
        }

        /**
         * @inheritDoc
         */
        override public function resolve (...args):IPromise {
            super.resolve.apply(null, args);
            _resolved = true;
            _resolveArgs = args;
            return this;
        }

        /**
         * Reset this Once instance to set resolved property back to false.
         *
         * @return this
         */
        public function reset ():IPromise {
            _resolved = false;
            _resolveArgs = null;
            return this;
        }

        /**
         * True if resolved at least once.
         */
        public function get resolved ():Boolean {
            return _resolved;
        }

        /**
         * @inheritDoc
         */
        override public function clear ():IPromise {
            reset();
            return super.clear();
        }

    }
}
