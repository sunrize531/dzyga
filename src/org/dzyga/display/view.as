package org.dzyga.display {
    import flash.display.DisplayObject;

    /**
     * Helper to easily chain view operations on some DisplayObject.
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
     *     // Add first and second to sprite, add sprite to parent,
     *     // set sprite's opacity to 0.5, scale it and move.
     *     view(sprite)
     *         .addChild(first)
     *         .addChild(second)
     *         .insertTo(parent)
     *         .alpha(0.5).scale(2).moveTo(100, 100);
     *
     *     // Broken chain
     *     // Hide child in sprite named 'first' and return it as Sprite.
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
    public function view (view:DisplayObject):IViewProxy {
        return new ViewProxy(view);
    }
}