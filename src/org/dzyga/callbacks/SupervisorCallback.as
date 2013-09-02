package org.dzyga.callbacks {
    internal final class SupervisorCallback extends Callback {
        public function SupervisorCallback (callback:Function, subject:*) {
            super(callback, false, null, [subject]);
        }

        private var _disabled:Boolean = false;
        internal function disable ():void {
            _disabled = true;
        }

        internal function enable ():void {
            _disabled = false;
        }

        override public function call (...args):* {
            if (!_disabled) {
                return super.call.apply(this, args);
            }
        }
    }
}
