package org.dzyga.callbacks {
    public interface ICallback extends IHandle {
        /**
         * Run callback once.
         */
        function get once ():Boolean;
    }
}
