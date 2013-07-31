package org.dzyga.display {
    import org.dzyga.utils.*;
    import flash.display.DisplayObject;

    /**
     * Helper to easily chain ViewUtils operations on some view.
     *
     * @example Chained calls example:
     *
     * <listing version="3.0">
     *     var sprite:Sprite = new Sprite();
     *     var parent:Sprite = new Sprite();
     *     var first:Sprite = new Sprite();
     *     var second:Sprite = new Sprite();
     *
     *     view(first).name('first').moveTo(20, 0);
     *
     *     // Display object tree manipulation.
     *     view(sprite)
     *         .addChild(first)
     *         .addChild(second)
     *         .insertTo(parent)
     *         .alpha(0.5).scale(2).moveTo(100, 100);
     *
     *     // Broken chain
     *     var hidden:Sprite = view(sprite)
     *         .getChild('first')
     *         .hide()
     *         .sprite;
     *
     *
     * </listing>
     *
     * @param view
     * @return
     */
    public function view (view:DisplayObject):ViewProxy {
        return new ViewProxy(view);
    }
}