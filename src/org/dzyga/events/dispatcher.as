package org.dzyga.events {
    import flash.events.IEventDispatcher;

    /**
     * Helper to easily chain events operations on dispatcher.
     *
     * @example Chained event operations.
     * <listing>
     *     function mouseEventListener (e:MouseEvent):void {
     *         trace(e);
     *     }
     *
     *     function initView (e:Event, message:String=''):void {
     *         trace(message);
     *     }
     *
     *     var onClick:Function = mouseEventListener;
     *     var onAnotherClick:Function = mouseEventListener;
     *     var onOver:Function = mouseEventListener;
     *     var onOut:Function = mouseEventListener;
     *
     *     var d:Sprite = new Sprite();
     *
     *     // Note! Created DispatcherProxies will be cached.
     *     dispatcher(d) === dispatcher(d); // true
     *
     *     // Assign multiple listeners to dispatcher.
     *     dispatcher(d)
     *         .listen(MouseEvent.CLICK, onClick)
     *         .listen(MouseEvent.CLICK, onAnotherClick)
     *         .listen(MouseEvent.ROLL_OVER, onOver)
     *         .listen(MouseEvent.ROLL_OUT, onOut)
     *         .listen(MouseEvent.MOUSE_OUT, onOut)
     *         .listen(Event.ADDED_TO_STAGE, initView, true, null, ['target init']); // Remove callback after first run.
     *
     *
     *     var o:Sprite = new Sprite();
     *     // Assign listeners to external dispatcher and store them in DispatcherProxy.
     *     dispatcher(d)
     *         .listenTo(o, MouseEvent.CLICK, onClick)
     *         .listenTo(o, Event.ADDED_TO_STAGE, initView, false, null, ['external init']);
     *
     *     // Remove listeners from target dispatcher
     *     dispatcher(d)
     *         .stopListening(MouseEvent.CLICK, onClick) // Remove onClick listeners
     *         .stopListening(MouseEvent.CLICK) // Remove all listeners registered for MouseEvent.CLICK event.
     *         .stopListening('', onOut) // Remove onOut listener from both MouseEvent.ROLL_OUT and MouseEvent.MOUSE_OUT events
     *         .stopListening() // Remove all listeners.

     *
     * @param target
     * @param ProxyClass
     * @return
     */
    public function dispatcher (target:IEventDispatcher, ProxyClass:Class = null):DispatcherProxy {
        var proxy:DispatcherProxy = DispatcherProxy.dispatcherProxyHash[target];
        if (!proxy) {
            if (ProxyClass) {
                proxy = new ProxyClass(target);
            } else {
                proxy = new DispatcherProxy(target);
            }
            DispatcherProxy.dispatcherProxyHash[target] = proxy;
        }
        return proxy;
    }
}