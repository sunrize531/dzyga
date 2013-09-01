package org.dzyga.eventloop {
    import org.dzyga.callbacks.ICallback;

    public interface ILoopCallback extends ICallback {
        function get loop ():Loop;
        function get priority ():Number;
        function get timeout ():Number;
    }
}
