package org.dzyga.display {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import org.dzyga.events.dispatcher;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class DisplayProxyExampleTest {
        [Test]
        public function exampleTest ():void {
            var sprite:Sprite = new Sprite();
            var parent:Sprite = new Sprite();
            var first:Sprite = new Sprite();
            var second:Sprite = new Sprite();

            // Each view call creates new instance of ViewProxy for view.
            assertTrue(display(sprite) != display(sprite));
            assertEquals(display(sprite).view == display(sprite).view);

            display(first).nameSet('first').moveTo(20, 0);

            assertEquals(first.x, 20);
            assertEquals(first.y, 0);

            // Display object tree manipulation.
            // Add first and second to sprite, add sprite to parent,
            // set sprite's opacity to 0.5, scale it and move.
            display(sprite)
                .addChild(first)
                .addChild(second)
                .insertTo(parent)
                .alpha(0.5).scale(2).moveTo(100, 100);

            assertEquals(sprite.parent, parent);
            assertEquals(first.parent, sprite);
            assertEquals(second.parent, sprite);
            assertEquals(sprite.alpha, 0.5);
            assertEquals(sprite.scaleX, 2);
            assertEquals(sprite.scaleY, 2);

            // Broken chain
            // Hide child in sprite named 'first' and return it as Sprite.
            var hidden:Sprite = display(sprite)
                .getChild('first')
                .hide()
                .sprite;

            assertEquals(hidden, first);
            assertEquals(hidden.visible, false);

            // DispatcherProxy...
            // All ViewProxy instances shares same DispatcherProxy. Also ViewProxy is not a DispatcherProxy.
            assertTrue(display(sprite) != dispatcher(sprite));
            assertEquals(display(sprite).dispatcher, dispatcher(sprite));

            // Chains, just like in DispatcherProxy
            function mouseEventListener (e:Event):void {
                trace(e.type);
            }
            display(sprite)
                .listen(MouseEvent.CLICK, mouseEventListener)
                .listen(MouseEvent.MOUSE_DOWN, mouseEventListener, true)
                .trigger(MouseEvent.CLICK) // 'click' traced
                .trigger(MouseEvent.MOUSE_DOWN) // 'mouseDown' traced
                .trigger(MouseEvent.MOUSE_DOWN); // nothing traced, cause MOUSE_DOWN listener added with once argument set to true.

            assertTrue(display(sprite).isListening(MouseEvent.CLICK));
            assertFalse(display(sprite).isListening(MouseEvent.MOUSE_DOWN));

            // Same for dispatcher
            assertTrue(display(sprite).dispatcher.isListening(MouseEvent.CLICK));
            assertTrue(dispatcher(sprite).isListening(MouseEvent.CLICK));
        }
    }
}
