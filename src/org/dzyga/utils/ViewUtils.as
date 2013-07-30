package org.dzyga.utils {
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.geom.Point;

    import org.dzyga.geom.Rect;

    /**
     * Set of utilities for working with flash display objects.
     * Mostly for simplify DO manipulation and enable some chained calls.
     * This class inspired by work of Ivan Shaban.
     */
    public final class ViewUtils {
        /**
         * Move view to specified coordinates. Returns view for chaining.
         *
         * @param view DisplayObject to transform
         * @param x X coordinate
         * @param y Y coordinate
         * @param truncate floor coordinates to integer value before applying
         * @return view
         */
        public static function moveTo (
                view:DisplayObject, x:Number, y:Number, truncate:Boolean = false):DisplayObject {
            view.x = truncate ? Math.round(x) : x;
            view.y = truncate ? Math.round(y) : y;
            return view;
        }

        /**
         * Offset view to specified coordinates. Returns view for chaining.
         *
         * @param view DisplayObject to transform
         * @param dx X coordinate offset
         * @param dy Y coordinate offset
         * @param truncate floor coordinates to integer before applying
         * @return view
         */
        public static function offset (
                view:DisplayObject, dx:Number, dy:Number, truncate:Boolean = false):DisplayObject {
            return moveTo(view, view.x + dx, view.y + dy, truncate);
        }

        /**
         * Scale view. If scaleY not specified, will perform uniform scale. Returns view for chaining.
         *
         * @param view DisplayObject to transform
         * @param scaleX
         * @param scaleY
         * @return view
         */
        public static function scale (view:DisplayObject, scaleX:Number, scaleY:Number=NaN):DisplayObject {
            if (isNaN(scaleY)) {
                scaleY = scaleX;
            }
            view.scaleX = scaleX;
            view.scaleY = scaleY;
            return view;
        }

        /**
         * Copy transform from target to view. Returns view for chaining.
         *
         * @param view DisplayObject to transform
         * @param target DisplayObject to copy transform
         * @return view
         */
        public static function match (view:DisplayObject, target:DisplayObject):DisplayObject {
            view.transform.matrix = target.transform.matrix;
            return view;
        }

        // Manipulation

        /**
         * Add child to view. Returns view for chaining. If level set, addChildTo method will be called,
         * instead of addChild. Value of level can also be negative, in this case child will be added to target on
         * level, counted from numChildren.
         *
         * @param view DisplayObjectContainer where to place a child
         * @param child DisplayObject to add
         * @param level where to add child
         * @return view
         */
        public static function addChildTo (
                view:DisplayObjectContainer, child:DisplayObject, level:int = int.MAX_VALUE):DisplayObjectContainer {
            if (level == int.MAX_VALUE) {
                view.addChild(child);
            } else {
                if (level >= 0) {
                    view.addChildAt(child, Math.min(view.numChildren, level));
                } else {
                    view.addChildAt(child, Math.max(0, view.numChildren - level));
                }
            }
            return view;
        }

        /**
         * Insert child into target DisplayObjectContainer. Returns child, for chained calls. level works the
         * same way as in addChildTo function (actually just calls it).
         *
         * @param view DisplayObject to insert into target
         * @param target DisplayObjectContainer where to place child.
         * @param level level in target
         * @return view
         */
        public static function insertTo (
                view:DisplayObject, target:DisplayObjectContainer, level:int = int.MAX_VALUE):DisplayObject {
            addChildTo(target, view, level);
            return view;
        }

        /**
         * Remove child from view.
         *
         * @param view
         * @param child
         * @return
         */
        public static function removeChildFrom (
                view:DisplayObjectContainer, child:DisplayObject):DisplayObjectContainer {
            if (view.contains(child)) {
                view.removeChild(child);
            }
            return view;
        }

        /**
         * Remove all children from view. Returns view for chaining.
         *
         * @param view DisplayObjectContainer to clear
         * @return view
         */
        public static function clear (view:DisplayObjectContainer):DisplayObjectContainer {
            var numChildren:int = view.numChildren;
            for (var i:int = 0; i < numChildren; i++) {
                view.removeChildAt(0);
            }
            return view;
        }

        /**
         * Remove view from it's parent. Returns view for chaining.
         *
         * @param view
         * @return view
         */
        public static function detach (view:DisplayObject):DisplayObject {
            var parent:DisplayObjectContainer = view.parent;
            if (parent) {
                parent.removeChild(view);
            }
            return view;
        }

        // Hittesting

        /**
         * Get view's bounds in local space. Returns null if view is not on stage yet.
         *
         * @param view
         * @return view's bounds or null
         */
        public static function getBounds (view:DisplayObject):Rect {
            if (!view.stage) {
                return null;
            }
            return Rect.coerce(view.getBounds(view));
        }

        /**
         * Hittest view with point. Point should be in global coordinates space.
         * Method will check, if view's bounds contains point first, before actual hittesting.
         *
         * @param view
         * @param point
         * @return
         */
        public static function hitTest (view:DisplayObject, point:Point):Boolean {
            return getBounds(view).containsPoint(view.globalToLocal(point)) &&
                    view.hitTestPoint(point.x, point.y, true);
        }

        // Visibility
        // This methods just for chaining...

        /**
         * Make view visible and return it for chaining.
         *
         * @param view
         * @return view
         */
        public static function show (view:DisplayObject):DisplayObject {
            view.visible = true;
            return view;
        }

        /**
         * Hide view and return it for chaining.
         *
         * @param view
         * @return view
         */
        public static function hide (view:DisplayObject):DisplayObject {
            view.visible = false;
            return view;
        }

        /**
         * Toggle view's visibility and return it for chaining.
         *
         * @param view
         * @return view
         */
        public static function toggle (view:DisplayObject):DisplayObject {
            view.visible = !view.visible;
            return view;
        }

        /**
         * Set view's alpha and return view for chaining.
         *
         * @param view
         * @param alpha
         * @return view
         */
        public static function alpha (view:DisplayObject, alpha:Number = 1):DisplayObject {
            view.alpha = alpha;
            return view;
        }

        /**
         * Set mouseEnabled and mouseChildren properties of view to false. Returns view.
         *
         * @param view
         * @return view
         */
        public static function mouseDisable (view:InteractiveObject):InteractiveObject {
            view.mouseEnabled = false;
            if (view is DisplayObjectContainer) {
                DisplayObjectContainer(view).mouseChildren = false;
            }
            return view;
        }

        /**
         * Set mouseEnabled and mouseChildren properties of view to true. Returns view.
         *
         * @param view
         * @return view
         */
        public static function mouseEnable (view:InteractiveObject):InteractiveObject {
            view.mouseEnabled = true;
            if (view is DisplayObjectContainer) {
                DisplayObjectContainer(view).mouseChildren = true;
            }
            return view;
        }

        /**
         * Toggle mouseEnabled property and set mouseChildren property to the same value. Returns view.
         *
         * @param view
         * @return view
         */
        public static function mouseToggle (view:InteractiveObject):InteractiveObject {
            view.mouseEnabled = !view.mouseEnabled;
            if (view is DisplayObjectContainer) {
                DisplayObjectContainer(view).mouseChildren = view.mouseEnabled;
            }
            return view;
        }
    }
}
