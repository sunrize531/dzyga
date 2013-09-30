package org.dzyga.display {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;

    import org.dzyga.geom.Rect;

    /**
     * Set of utilities for working with flash display objects.
     * Mostly for simplify DO manipulation and enable some chained calls.
     * This class inspired by work of Ivan Shaban.
     */
    public final class DisplayUtils {
        /**
         * Move view to specified coordinates.
         *
         * @param view DisplayObject to transform
         * @param x X coordinate
         * @param y Y coordinate
         * @param truncate floor coordinates to integer value before applying
         * @return org.dzyga.display.display
         */
        public static function moveTo (
                view:DisplayObject, x:Number, y:Number, truncate:Boolean = false):DisplayObject {
            view.x = truncate ? Math.round(x) : x;
            view.y = truncate ? Math.round(y) : y;
            return view;
        }

        /**
         * Offset view to specified coordinates.
         *
         * @param view DisplayObject to transform
         * @param dx X coordinate offset
         * @param dy Y coordinate offset
         * @param truncate floor coordinates to integer before applying
         * @return org.dzyga.display.display
         */
        public static function offset (
                view:DisplayObject, dx:Number, dy:Number, truncate:Boolean = false):DisplayObject {
            return moveTo(view, view.x + dx, view.y + dy, truncate);
        }

        /**
         * Scale view. If scaleY not specified, will perform uniform scale.
         *
         * @param view DisplayObject to transform
         * @param scaleX
         * @param scaleY
         * @return org.dzyga.display.display
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
         * Copy transform from target to view.
         *
         * @param view DisplayObject to transform
         * @param target DisplayObject to copy transform
         * @return org.dzyga.display.display
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
         * @param index where to add child
         * @return org.dzyga.display.display
         */
        public static function addChild (
                view:DisplayObjectContainer, child:DisplayObject, index:int = int.MAX_VALUE):DisplayObjectContainer {
            if (index == int.MAX_VALUE) {
                view.addChild(child);
            } else {
                var numChildren:int = view.numChildren;
                if (!numChildren) {
                    index = 0;
                } else if (index >= 0) {
                    index = Math.min(numChildren, index);
                } else {
                    index = Math.max(0, numChildren + index + 1);
                }
                view.addChildAt(child, index);
            }
            return view;
        }

        /**
         * Insert child into target DisplayObjectContainer. level works the
         * same way as in addChildTo function (actually just calls it).
         *
         * @param view DisplayObject to insert into target
         * @param target DisplayObjectContainer where to place child.
         * @param level level in target
         * @return org.dzyga.display.display
         */
        public static function insertTo (
                view:DisplayObject, target:DisplayObjectContainer, level:int = int.MAX_VALUE):DisplayObject {
            addChild(target, view, level);
            return view;
        }

        /**
         * Remove child from view.
         *
         * @param view
         * @param child
         * @return
         */
        public static function removeChild (
                view:DisplayObjectContainer, child:DisplayObject):DisplayObjectContainer {
            if (view.contains(child)) {
                view.removeChild(child);
            }
            return view;
        }

        /**
         * Remove all children from view.
         *
         * @param view DisplayObjectContainer to clear
         * @return org.dzyga.display.display
         */
        public static function clear (view:DisplayObjectContainer):DisplayObjectContainer {
            var numChildren:int = view.numChildren;
            for (var i:int = 0; i < numChildren; i++) {
                view.removeChildAt(0);
            }
            return view;
        }

        /**
         * Remove view from it's parent.
         *
         * @param view
         * @return org.dzyga.display.display
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
         * @return
         * @param checkBounds
         * @param globalY
         * @param globalX
         */
        public static function hitTest(view:DisplayObject, globalX:int, globalY:int, checkBounds:Boolean = true):Boolean {
            _HIT_POINT.x = globalX;
            _HIT_POINT.y = globalY;
            if (checkBounds){
                if((!view is Bitmap) && !getBounds(view).containsPoint(view.globalToLocal(new Point(globalX, globalY)))){
                    return false;
                }
            }
            var localPoint:Point = DisplayObject(view).globalToLocal(_HIT_POINT);
            if (checkBounds) {
                if(localPoint.x < 0 || localPoint.y < 0 || localPoint.x >= view.width || localPoint.y >= view.height){
                    return false;
                }
            }
            if (view is Bitmap) {
                return hitTestBitmap(view as Bitmap, localPoint.x, localPoint.y);
            }
            if (view is Sprite) {
                return view.hitTestPoint(globalX, globalY, true);
            } else {
                return hitTestShape(view, localPoint.x, localPoint.y);
            }
        }

        private static const _HIT_TEST_HELPER_BD:BitmapData = new BitmapData(1, 1, true, 0);
        private static const _HIT_TEST_MATRIX:Matrix = new Matrix();
        private static const _HIT_POINT:Point = new Point();

        private static function hitTestShape(target:DisplayObject, localX:Number, localY:Number):Boolean {
            _HIT_TEST_MATRIX.tx = -localX;
            _HIT_TEST_MATRIX.ty = -localY;

            _HIT_TEST_HELPER_BD.setPixel32(0, 0, 0x1000000 - 100);
            _HIT_TEST_HELPER_BD.draw(target, _HIT_TEST_MATRIX);

            return _HIT_TEST_HELPER_BD.getPixel32(0, 0) > 0x1000000;
        }

        private static function hitTestBitmap(bitmap:Bitmap, localX:int, localY:int):Boolean {
            if (bitmap) {
                var bitmapData:BitmapData = bitmap.bitmapData;
                if (localX < bitmap.width && localX >= 0 && localY < bitmap.height && localY >= 0) {
                    if (bitmapData.getPixel32(localX, localY) > 0x1000000) return true;
                }
            }
            return false;
        }

        // Visibility

        /**
         * Make view visible and return it for chaining.
         *
         * @param view
         * @return org.dzyga.display.display
         */
        public static function show (view:DisplayObject):DisplayObject {
            view.visible = true;
            return view;
        }

        /**
         * Hide view and return it for chaining.
         *
         * @param view
         * @return org.dzyga.display.display
         */
        public static function hide (view:DisplayObject):DisplayObject {
            view.visible = false;
            return view;
        }

        /**
         * Toggle view's visibility and return it for chaining.
         *
         * @param view
         * @return org.dzyga.display.display
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
         * @return org.dzyga.display.display
         */
        public static function alpha (view:DisplayObject, alpha:Number = 1):DisplayObject {
            view.alpha = alpha;
            return view;
        }

        /**
         * Set mouseEnabled and mouseChildren properties of view to false. Returns view.
         *
         * @param view
         * @return org.dzyga.display.display
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
         * @return org.dzyga.display.display
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
         * @return org.dzyga.display.display
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
