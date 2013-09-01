package org.dzyga.callback {
    public interface ICallback extends IHandle {
        /**
         * Run callback once.
         */
        function get once ():Boolean;
    }
}
