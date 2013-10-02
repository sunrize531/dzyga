/**
 * Created with IntelliJ IDEA.
 * User: sunrize
 * Date: 31.07.13
 * Time: 9:43
 * To change this template use File | Settings | File Templates.
 */
package org.dzyga.display {
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.text.TextField;

    import org.dzyga.events.IDispatcherProxy;
    import org.dzyga.geom.Rect;

    public class DisplayProxy implements IDisplayProxy {
        protected var _view:DisplayObject;

        public function DisplayProxy (view:DisplayObject) {
            _view = view;
        }

        /**
         * Get view of this proxy.
         */
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
         * Get DispatcherProxy for current view. Note, that all instances of ViewProxy for same view will share
         * the same DispatcherProxy. Override this getter if different behavior is needed.
         */
        public function get dispatcher ():IDispatcherProxy {
            return org.dzyga.events.dispatcher(_view);
        }

        /**
         * Set name for view.
         *
         * @param name
         * @return this
         */
        public function nameSet (name:String):IDisplayProxy {
            view.name = name;
            return this;
        }

        /**
         * Move view to specified coordinates.
         *
         * @param x X coordinate
         * @param y Y coordinate
         * @param truncate floor coordinates to integer value before applying
         * @return org.dzyga.display.display
         */
        public function moveTo (x:Number, y:Number, truncate:Boolean = false):IDisplayProxy {
            DisplayUtils.moveTo(_view, x, y, truncate);
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
        public function offset (dx:Number, dy:Number, truncate:Boolean = false):IDisplayProxy {
            DisplayUtils.offset(_view, dx, dy, truncate);
            return this;
        }

        /**
         * Scale view. If scaleY not specified, will perform uniform scale.
         *
         * @param scaleX
         * @param scaleY
         * @return self
         */
        public function scale (scaleX:Number, scaleY:Number=NaN):IDisplayProxy {
            DisplayUtils.scale(_view, scaleX, scaleY);
            return this;
        }

        /**
         * Copy transform from target to view.
         *
         * @param target DisplayObject to copy transform
         * @return self
         */
        public function match (target:DisplayObject):IDisplayProxy {
            DisplayUtils.match(_view, target);
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
        public function addChild (child:DisplayObject, level:int = int.MAX_VALUE):IDisplayProxy {
            DisplayUtils.addChild(container, child, level);
            return this;
        }

        /**
         * Insert view into target DisplayObjectContainer. level works the
         * same way as in addChildTo function (actually just calls it).
         *
         * @param target DisplayObjectContainer where to place view.
         * @param level level in target
         * @return this
         */
        public function insertTo (target:DisplayObjectContainer, level:int = int.MAX_VALUE):IDisplayProxy {
            DisplayUtils.insertTo(view, target, level);
            return this;
        }

        /**
         * Get ViewProxy for child of view.
         *
         * @param name Name of child
         * @return new ViewProxy instance
         */
        public function getChild (name:String):IDisplayProxy {
            return new DisplayProxy(container.getChildByName(name));
        }

        /**
         * Remove child from view.
         *
         * @param child
         * @return this
         */
        public function removeChild (child:DisplayObject):IDisplayProxy {
            DisplayUtils.removeChild(container, child);
            return this;
        }

        /**
         * Remove all children from view.
         *
         * @return this
         */
        public function clear ():IDisplayProxy {
            if (container) {
                DisplayUtils.clear(container);
            }
            return this;
        }

        /**
         * Remove view from it's parent.
         *
         * @return this
         */
        public function detach ():IDisplayProxy {
            DisplayUtils.detach(view);
            return this;
        }

        // Hittesting

        /**
         * Get view's bounds in local space. Returns null if view is not on stage yet.
         *
         * @return view's bounds or null
         */
        public function getBounds ():Rect {
            return DisplayUtils.getBounds(view);
        }

        /**
         * Hittest view with point. Point should be in global coordinates space.
         * Method will check, if view's bounds contains point first, before actual hittesting.
         *
         * @param globalY
         * @param globalX
         * @param checkContainer
         * @return
         */
        public function hitTest (globalX:int, globalY:int):Boolean {
            return DisplayUtils.hitTest(view, globalX, globalY);
        }

        // Visibility

        /**
         * Make view visible.
         *
         * @return this
         */
        public function show ():IDisplayProxy {
            DisplayUtils.show(view);
            return this;
        }

        /**
         * Hide view and return it for chaining.
         *
         * @return this
         */
        public function hide ():IDisplayProxy {
            DisplayUtils.hide(view);
            return this;
        }

        /**
         * Toggle view's visibility and return it for chaining.
         *
         * @return this
         */
        public function toggle ():IDisplayProxy {
            DisplayUtils.toggle(view);
            return this;
        }

        /**
         * Set view's alpha and return view for chaining.
         *
         * @param alpha
         * @return this
         */
        public function alpha (alpha:Number = 1):IDisplayProxy {
            DisplayUtils.alpha(view, alpha);
            return this;
        }

        /**
         * Set mouseEnabled and mouseChildren properties of view to false. Returns view.
         *
         * @return this
         */
        public function mouseDisable ():IDisplayProxy {
            DisplayUtils.mouseDisable(interactive);
            return this;
        }

        /**
         * Set mouseEnabled and mouseChildren properties of view to true. Returns view.
         *
         * @return this
         */
        public function mouseEnable ():IDisplayProxy {
            DisplayUtils.mouseEnable(interactive);
            return this;
        }

        /**
         * Toggle mouseEnabled property and set mouseChildren property to the same value. Returns view.
         *
         * @return org.dzyga.display.display
         */
        public function mouseToggle ():IDisplayProxy {
            DisplayUtils.mouseToggle(interactive);
            return this;
        }

        // IDispatcherProxy implementation
        public function listen (
                eventType:String, callback:Function, once:Boolean = false,
                thisArg:* = null, argArray:Array = null):IDispatcherProxy {
            dispatcher.listen(eventType, callback, once, thisArg, argArray);
            return this;
        }

        public function listenTo (
                target:IEventDispatcher, eventType:String, callback:Function, once:Boolean = false,
                thisArg:* = null, argArray:Array = null):IDispatcherProxy {
            dispatcher.listenTo(target, eventType, callback, once, thisArg, argArray);
            return this;
        }

        public function isListening (eventType:String = null, callback:Function = null):Boolean {
            return dispatcher.isListening(eventType, callback);
        }

        public function isListeningTo (
                target:IEventDispatcher = null, eventType:String = '', callback:Function = null):Boolean {
            return dispatcher.isListeningTo(target, eventType, callback);
        }

        public function stopListening (eventType:String = '', callback:Function = null):IDispatcherProxy {
            dispatcher.stopListening(eventType, callback);
            return this;
        }

        public function stopListeningTo (
                target:IEventDispatcher = null, eventType:String = '', callback:Function = null):IDispatcherProxy {
            dispatcher.stopListeningTo(target, eventType, callback);
            return this;
        }

        public function trigger (eventType:String):IDispatcherProxy {
            dispatcher.trigger(eventType);
            return this;
        }

        public function triggerTo (target:IEventDispatcher, eventType:String):IDispatcherProxy {
            dispatcher.triggerTo(target, eventType);
            return this;
        }

        public function addEventListener (
                type:String, listener:Function, useCapture:Boolean = false,
                priority:int = 0, useWeakReference:Boolean = false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
        }

        public function dispatchEvent (event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }

        public function hasEventListener (type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }

        public function willTrigger (type:String):Boolean {
            return dispatcher.willTrigger(type);
        }
    }
}
