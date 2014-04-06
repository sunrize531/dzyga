package org.dzyga.callbacks {
    import org.dzyga.collections.ISequenceIterator;

    /**
     * Promise that does nothing and never resolves. Totally irresponsible.
     */
    public class Never implements IPromise {
        public function get callbackCollection ():LinkedSet {
            return null;
        }

        public function callbackRegister (
                callback:Function, once:Boolean = false, thisArg:* = null, argsArray:Array = null):IPromise {
            return this;
        }

        public function callbackRemove (callback:Function = null):IPromise {
            return this;
        }

        public function callbackIterator (callback:Function = null):ISequenceIterator {
            return null;
        }

        public function resolve (...args):IPromise {
            return this;
        }

        public function clear ():IPromise {
            return this;
        }

        public function iterator (cursor:* = null):IIterator {
            return null;
        }
    }
}
