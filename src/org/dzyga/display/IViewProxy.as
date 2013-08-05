package org.dzyga.display {
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.text.TextField;

    import org.dzyga.events.IDispatcherProxy;
    import org.dzyga.geom.Rect;

    public interface IViewProxy extends IDispatcherProxy {
        function get view ():DisplayObject;
        function get container ():DisplayObjectContainer;
        function get interactive ():InteractiveObject;
        function get sprite ():Sprite;
        function get shape ():Shape;
        function get bitmap ():Bitmap;
        function get textField ():TextField;
        function get dispatcher ():IDispatcherProxy;
        function get graphics ():Graphics;


        function name (name:String):IViewProxy;
        function moveTo (x:Number, y:Number, truncate:Boolean = false):IViewProxy;
        function offset (dx:Number, dy:Number, truncate:Boolean = false):IViewProxy;
        function scale (scaleX:Number, scaleY:Number=NaN):IViewProxy;
        function match (target:DisplayObject):IViewProxy;
        function addChild (child:DisplayObject, level:int = int.MAX_VALUE):IViewProxy;
        function insertTo (target:DisplayObjectContainer, level:int = int.MAX_VALUE):IViewProxy;
        function getChild (name:String):IViewProxy;
        function removeChildFrom (child:DisplayObject):IViewProxy;
        function clear ():IViewProxy;
        function detach ():IViewProxy;
        function show ():IViewProxy;
        function hide ():IViewProxy;
        function alpha (alpha:Number = 1):IViewProxy;
        function mouseDisable ():IViewProxy;
        function mouseEnable ():IViewProxy;
        function mouseToggle ():IViewProxy;


        function getBounds ():Rect;
        function hitTest (point:Point):Boolean;
    }
}
