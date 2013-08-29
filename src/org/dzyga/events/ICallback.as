package org.dzyga.events {
    public interface ICallback extends IHandle {
        /**
         * Run callback once.
         */
        function get once ():Boolean;
    }
}
