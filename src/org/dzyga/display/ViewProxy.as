/**
 * Created with IntelliJ IDEA.
 * User: sunrize
 * Date: 31.07.13
 * Time: 9:43
 * To change this template use File | Settings | File Templates.
 */
package org.dzyga.display {
    import org.dzyga.utils.*;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.text.TextField;

    import org.dzyga.geom.Rect;


    public class ViewProxy {
        protected var _view:DisplayObject;

        public function ViewProxy (view:DisplayObject) {
            _view = view;
        }

        public function get view ():DisplayObject {
            return _view;
        }

        /**
         * Get view as DisplayObjectContainer.
         */
        public function get container ():DisplayObjectContainer {
            return _view as DisplayObjectContainer;
        }

        /**
         * Get view as InteractiveObject.
         */
        public function get interactive ():InteractiveObject {
            return _view as InteractiveObject;
        }

        /**
         * Get view as Sprite.
         */
        public function get sprite ():Sprite {
            return _view as Sprite;
        }

        /**
         * Get view as Shape. Raise coercion error if failed.
         */
        public function get shape ():Shape {
            return _view as Shape;
        }

        /**
         * Get view as Bitmap.
         */
        public function get bitmap ():Bitmap {
            return _view as Bitmap;
        }

        /**
         * Get view as TextField.
         */
        public function get textField ():TextField {
            return _view as TextField;
        }

        /**
         * Return Graphics from view, if view is Sprite or Shape.
         */
        public function get graphics ():Graphics {
            if (sprite) {
                return sprite.graphics;
            } else if (shape) {
                return shape.graphics;
            }
            return null;
        }

        /**
         * Set name for view.
         *
         * @param name
         * @return this
         */
        public function name (name:String):ViewProxy {
            view.name = name;
            return this;
        }

        /**
         * Move view to specified coordinates.
         *
         * @param x X coordinate
         * @param y Y coordinate
         * @param truncate floor coordinates to integer value before applying
         * @return org.dzyga.display.view
         */
        public function moveTo (x:Number, y:Number, truncate:Boolean = false):ViewProxy {
            ViewUtils.moveTo(_view, x, y, truncate);
            return this;
        }

        /**
         * Offset view to specified coordinates.
         *
         * @param dx X coordinate offset
         * @param dy Y coordinate offset
         * @param truncate floor coordinates to integer before applying
         * @return self
         */
        public function offset (dx:Number, dy:Number, truncate:Boolean = false):ViewProxy {
            ViewUtils.offset(_view, dx, dy, truncate);
            return this;
        }

        /**
         * Scale view. If scaleY not specified, will perform uniform scale.
         *
         * @param scaleX
         * @param scaleY
         * @return self
         */
        public function scale (scaleX:Number, scaleY:Number=NaN):ViewProxy {
            ViewUtils.scale(_view, scaleX, scaleY);
            return this;
        }

        /**
         * Copy transform from target to view.
         *
         * @param target DisplayObject to copy transform
         * @return self
         */
        public function match (target:DisplayObject):ViewProxy {
            ViewUtils.match(_view, target);
            return this;
        }

        // Manipulation

        /**
         * Add child to view. Returns view for chaining. If level set, addChildTo method will be called,
         * instead of addChild. Value of level can also be negative, in this case child will be added to target on
         * level, counted from numChildren.
         *
         * @param child DisplayObject to add
         * @param level where to add child
         * @return this
         */
        public function addChild (child:DisplayObject, level:int = int.MAX_VALUE):ViewProxy {
            ViewUtils.addChild(container, child, level);
            return this;
        }

        /**
         * Insert view into target DisplayObjectContainer. level works the
         * same way as in addChildTo function (actually just calls it).
         *
         * @param view DisplayObject to insert into target
         * @param target DisplayObjectContainer where to place child.
         * @param level level in target
         * @return this
         */
        public function insertTo (target:DisplayObjectContainer, level:int = int.MAX_VALUE):ViewProxy {
            ViewUtils.insertTo(view, target, level);
            return this;
        }

        public function getChild (name:String):ViewProxy {
            return new ViewProxy(container.getChildByName(name));
        }

        /**
         * Remove child from view.
         *
         * @param child
         * @return
         */
        public function removeChildFrom (child:DisplayObject):ViewProxy {
            ViewUtils.removeChild(container, child);
            return this;
        }

        /**
         * Remove all children from view.
         *
         * @return this
         */
        public function clear ():ViewProxy {
            ViewUtils.clear(container);
            return this;
        }

        /**
         * Remove view from it's parent.
         *
         * @return org.dzyga.display.view
         */
        public function detach ():ViewProxy {
            ViewUtils.detach(view);
            return this;
        }

        // Hittesting

        /**
         * Get view's bounds in local space. Returns null if view is not on stage yet.
         *
         * @return view's bounds or null
         */
        public function getBounds ():Rect {
            return ViewUtils.getBounds(view);
        }

        /**
         * Hittest view with point. Point should be in global coordinates space.
         * Method will check, if view's bounds contains point first, before actual hittesting.
         *
         * @param point
         * @return
         */
        public function hitTest (point:Point):Boolean {
            return ViewUtils.hitTest(view, point);
        }

        // Visibility

        /**
         * Make view visible.
         *
         * @return this
         */
        public function show ():ViewProxy {
            ViewUtils.show(view);
            return this;
        }

        /**
         * Hide view and return it for chaining.
         *
         * @return this
         */
        public function hide ():ViewProxy {
            ViewUtils.hide(view);
            return this;
        }

        /**
         * Toggle view's visibility and return it for chaining.
         *
         * @return this
         */
        public function toggle (view:DisplayObject):ViewProxy {
            ViewUtils.toggle(view);
            return this;
        }

        /**
         * Set view's alpha and return view for chaining.
         *
         * @param alpha
         * @return this
         */
        public function alpha (alpha:Number = 1):ViewProxy {
            ViewUtils.alpha(view, alpha);
            return this;
        }

        /**
         * Set mouseEnabled and mouseChildren properties of view to false. Returns view.
         *
         * @return this
         */
        public function mouseDisable ():ViewProxy {
            ViewUtils.mouseDisable(interactive);
            return this;
        }

        /**
         * Set mouseEnabled and mouseChildren properties of view to true. Returns view.
         *
         * @return this
         */
        public function mouseEnable ():ViewProxy {
            ViewUtils.mouseEnable(interactive);
            return this;
        }

        /**
         * Toggle mouseEnabled property and set mouseChildren property to the same value. Returns view.
         *
         * @return org.dzyga.display.view
         */
        public function mouseToggle ():ViewProxy {
            ViewUtils.mouseToggle(interactive);
            return this;
        }
    }
}
