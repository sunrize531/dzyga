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
         * If Once is resolved callback will be run immediately.
         *
         * @param callback
         * @param once
         * @param thisArg
         * @param argsArray
         * @return
         */
        override public function callbackRegister (
                callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise {
            if (callback) {
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

        override public function resolve (...args):IPromise {
            super.resolve(args);
            _resolved = true;
            _resolveArgs = args;
            return this;
        }

        public function reset ():IPromise {
            _resolved = false;
            _resolveArgs = null;
            return this;
        }

        override public function clear ():IPromise {
            reset();
            return super.clear();
        }
    }
}
