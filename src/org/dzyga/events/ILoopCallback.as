package org.dzyga.events {
    public interface ILoopCallback extends ICallback {
        function get loop ():Loop;
        function get priority ():Number;
        function get timeout ():Number;
    }
}
