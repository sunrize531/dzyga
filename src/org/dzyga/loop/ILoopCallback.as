package org.dzyga.loop {
    import org.dzyga.callback.ICallback;

    public interface ILoopCallback extends ICallback {
        function get loop ():Loop;
        function get priority ():Number;
        function get timeout ():Number;
    }
}
