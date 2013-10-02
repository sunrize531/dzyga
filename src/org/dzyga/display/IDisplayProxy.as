package org.dzyga.display {
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.text.TextField;

    import org.dzyga.events.IDispatcherProxy;
    import org.dzyga.geom.Rect;

    public interface IDisplayProxy extends IDispatcherProxy {
        function get view ():DisplayObject;
        function get container ():DisplayObjectContainer;
        function get interactive ():InteractiveObject;
        function get sprite ():Sprite;
        function get shape ():Shape;
        function get bitmap ():Bitmap;
        function get textField ():TextField;
        function get dispatcher ():IDispatcherProxy;
        function get graphics ():Graphics;


        function nameSet (name:String):IDisplayProxy;
        function moveTo (x:Number, y:Number, truncate:Boolean = false):IDisplayProxy;
        function offset (dx:Number, dy:Number, truncate:Boolean = false):IDisplayProxy;
        function scale (scaleX:Number, scaleY:Number=NaN):IDisplayProxy;
        function match (target:DisplayObject):IDisplayProxy;
        function addChild (child:DisplayObject, level:int = int.MAX_VALUE):IDisplayProxy;
        function insertTo (target:DisplayObjectContainer, level:int = int.MAX_VALUE):IDisplayProxy;
        function getChild (name:String):IDisplayProxy;
        function removeChild (child:DisplayObject):IDisplayProxy;
        function clear ():IDisplayProxy;
        function detach ():IDisplayProxy;
        function show ():IDisplayProxy;
        function hide ():IDisplayProxy;
        function alpha (alpha:Number = 1):IDisplayProxy;
        function mouseDisable ():IDisplayProxy;
        function mouseEnable ():IDisplayProxy;
        function mouseToggle ():IDisplayProxy;


        function getBounds ():Rect;
        function hitTest (globalX:int, globalY:int):Boolean;
    }
}
