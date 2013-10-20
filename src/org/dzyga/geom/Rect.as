package org.dzyga.geom {
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * Rectangle, с дополнительным функционалом для упрощения повторного использования.
     */
    public class Rect extends Rectangle {

        public function Rect (x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
            super(x, y, width, height);
        }

        public static function coerce (...args):Rect {
            if (args[0] is Rectangle) {
                var r:Rectangle = args[0] as Rectangle;
                return new Rect(r.x, r.y, r.width, r.height);
            } else if (args[0] is Array || args[0] is Vector) {
                var list:Object = args[0];
                return new Rect(list[0], list[1], list[2], list[3]);
            }
            return new Rect(args[0], args[1], args[2], args[3]);
        }

        /**
         * Площадь прямоугольника. По понятным причинам, всегда положительна.
         */
        public function area ():Number {
            return Math.abs(width * height);
        }

        /**
         * Периметр прямоугольника.
         */
        public function margin ():Number {
            return 2 * (Math.abs(width) + Math.abs(height));
        }

        /**
         * Заполняет инстанс класса соответсвующими значениями.
         * @param x - координата
         * @param y - координата
         * @param width - ширина
         * @param height - длинна
         */
        public function fill (x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):Rect {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
            return this;
        }

        /**
         * Копирует значения x, y, width и height из ректангла в этот.
         * @param toMatch - Rectangle которому надо соответсвовать.
         *
         */
        public function match (toMatch:Rectangle):Rect {
            x = toMatch.x;
            y = toMatch.y;
            width = toMatch.width;
            height = toMatch.height;
            return this;
        }

        /**
         * Выдает Сравнивает ширину и высоту ректов.
         * @param toCompare - Rectangle с которым сравнивать.
         * @return true, если ширина и высота этого ректа такая же, как у
         * toCompare
         *
         */
        public function similars (toCompare:Rectangle):Boolean {
            return width == toCompare.width && height == toCompare.height;

        }

        /**
         * Делает то же, что union, только вместо того чтобы выдавать новый
         * Rectangle, апдейтит текущий инстанс.
         * @param toAdd - Rectangle, который надо добавить в текущему инстансу
         * @see #union()
         */
        public function add (toAdd:Rectangle):Rect {
            if (toAdd.width * toAdd.height != 0) {
                if (width * height == 0) {
                    match(toAdd);
                } else {
                    left = Math.min(left, toAdd.left);
                    top = Math.min(top, toAdd.top);
                    right = Math.max(right, toAdd.right);
                    bottom = Math.max(bottom, toAdd.bottom);
                }
            }
            return this;
        }

        /**
         * Делает то же, что intersect, только вместо того чтобы выдавать новый
         * Rectangle, апдейтит текущий инстанс.
         * @param toOverlap - Rectangle, которым надо кропнуть текущий инстанс
         * @see #intersect()
         */
        public function crop (toOverlap:Rectangle):Rect {
            if (toOverlap.width * toOverlap.height != 0) {
                if (width * height == 0) {
                    clear();
                } else {
                    left = Math.max(left, toOverlap.left);
                    top = Math.max(top, toOverlap.top);
                    right = Math.min(right, toOverlap.right);
                    bottom = Math.min(bottom, toOverlap.bottom);
                }
            }
            return this;
        }

        /**
         * Константа для функций getAnchor и setAnchor. Верхний левый угол
         */
        public static const TOP_LEFT:uint = 0;
        /**
         * Константа для функций getAnchor и setAnchor. Верхний правый угол
         */
        public static const TOP_RIGHT:uint = 2;
        /**
         * Константа для функций getAnchor и setAnchor. Нижний правый угол
         */
        public static const BOTTOM_RIGHT:uint = 3;
        /**
         * Константа для функций getAnchor и setAnchor. Нижний левый угол
         */
        public static const BOTTOM_LEFT:uint = 1;

        private var _anchor:Point;

        /**
         * Выдает точку с координатами угла ректа,
         * соответствующего значению pos. ВНИМАНИЕ! При последовательных вызовах
         * данной функции необходимо иметь ввиду, что инстанс точки для
         * данного ректа - один. То есть при следующем вызове функция выдаст ту
         * же точку, только с другимим координатами.
         * @param pos - одна из констант TOP_LEFT, TOP_RIGHT, BOTTOM_RIGHT,
         * BOTTOM_LEFT
         * @see #setAnchor()
         * @see #TOP_LEFT
         * @see #TOP_RIGHT
         * @see #BOTTOM_RIGHT
         * @see #BOTTOM_LEFT
         */
        public function getAnchor (pos:uint):Point {
            if (!_anchor) {
                _anchor = new Point();
            }
            _anchor.x = x + width * ((pos & 2) >> 1);
            _anchor.y = y + height * (pos & 1);
            return _anchor;
        }

        /**
         * Устанавливает координаты ректа так, чтобы угол, соответствующий
         * значению pos имел координаты x и y. Размеры ректа при этом не
         * изменяются.
         * @param x - координата x
         * @param y - координата y
         * @param pos - одна из констант TOP_LEFT, TOP_RIGHT, BOTTOM_RIGHT,
         * BOTTOM_LEFT
         * @see #getAnchor()
         * @see #TOP_LEFT
         * @see #TOP_RIGHT
         * @see #BOTTOM_RIGHT
         * @see #BOTTOM_LEFT
         */
        public function setAnchor (x:Number, y:Number, pos:uint):void {
            this.x = x - width * ((pos & 2) >> 1);
            this.y = y - height * (pos & 1);
        }

        override public function clone ():Rectangle {
            return new Rect(x, y, width, height);
        }

        public function clear ():Rect {
            x = y = width = height = 0;
            return this;
        }

        public function multiply (value:Number):void {
            x *= value;
            y *= value;
            width *= value;
            height *= value;
        }
    }
}
