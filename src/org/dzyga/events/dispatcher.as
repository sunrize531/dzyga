package org.dzyga.events {
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;

    /**
     * Helper to easily chain events operations on dispatcher.
     *
     * @example Chained event operations.
     * <listing>
     *     function mouseEventListener (e:Event):void {
     *         trace(e.type);
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
     *     // Note! DispatcherProxies cached with weak reference on target.
     *     assertEquals(dispatcher(d), dispatcher(d)); // true

     *     // Assign multiple listeners to dispatcher.
     *     dispatcher(d)
     *         .listen(MouseEvent.CLICK, onClick)
     *         .listen(MouseEvent.CLICK, onAnotherClick) // Nothing changed here, cause onClick and onAnotherClick is actually the same function.
     *         .listen(MouseEvent.ROLL_OVER, onOver)
     *         .listen(MouseEvent.ROLL_OUT, onOut)
     *         .listen(MouseEvent.MOUSE_OUT, onOut)
     *         .listen(Event.ADDED_TO_STAGE, initView, true, null, ['target init']); // Remove callback after first run.
     *
     *     var o:Sprite = new Sprite();
     *     // Assign listeners to external dispatcher and store them in DispatcherProxy.
     *     dispatcher(d)
     *         .listenTo(o, MouseEvent.CLICK, onClick)
     *         .listenTo(o, Event.ADDED_TO_STAGE, initView, false, null, ['external init']);
     *
     *     // Trigger some events on d
     *     trace('Triggering events on d...');
     *     dispatcher(d)
     *         .trigger(MouseEvent.CLICK) // 'click' traced
     *         .trigger(MouseEvent.ROLL_OVER) // 'rollOver' traced
     *         .trigger(Event.ADDED_TO_STAGE) // 'target init' traced
     *         .trigger(Event.ADDED_TO_STAGE); // Nothing traced, cause initView removed after first run
     *
     *     // Trigger some events on o
     *     trace('Triggering events on o...');
     *     dispatcher(d)
     *         .triggerTo(o, MouseEvent.CLICK) // 'click' traced
     *         .triggerTo(o, Event.ADDED_TO_STAGE) // 'external init' traced
     *         .triggerTo(o, Event.ADDED_TO_STAGE); // 'external init' traced
     *
     *    // Remove listeners from target dispatcher
     *    trace('Removing callbacks on d...');
     *    dispatcher(d)
     *        .stopListening(MouseEvent.CLICK, onClick) // Remove onClick listeners
     *        .trigger(MouseEvent.CLICK) // Nothing traced
     *        .stopListening(MouseEvent.CLICK) // Remove all listeners registered for MouseEvent.CLICK event.
     *        .trigger(MouseEvent.CLICK) // Nothing traced
     *        .stopListening('', onOut) // Remove all listeners for mouseEventListener function, which is onOut value
     *        .trigger(MouseEvent.ROLL_OVER) // Nothing traced
     *        .trigger(MouseEvent.ROLL_OUT) // Nothing traced
     *        .trigger(MouseEvent.MOUSE_OUT); // Nothing traced
     *
     *    assertFalse(dispatcher(d).isListening()); // Currently listening nothing on d...
     *    assertTrue(dispatcher(d).isListeningTo(o)); // But there is still something on o...
     *
     *    // Removing all callbacks
     *    dispatcher(d)
     *        .listen(Event.ADDED_TO_STAGE, initView)
     *        .stopListeningTo() // Clear all event listeners on both d and o...
     *        .trigger(Event.ADDED_TO_STAGE); // Nothing traced
     *
     *    assertFalse(dispatcher(d).isListeningTo()); // Nothing.
     *
     * @param target
     * @param ProxyClass
     * @return
     */
    public function dispatcher (target:IEventDispatcher, ProxyClass:Class = null):IDispatcherProxy {
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