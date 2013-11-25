package org.dzyga.geom {
    public class Side {
        public var left:Number;
        public var right:Number;

        public function Side (left:Number=0, right:Number=0) {
        }

        public function get middle ():Number {
            return left + (right - left) / 2;
        }

        public function get width ():Number {
            return right - left;
        }

        public function set width (v:Number):void {
            right = left + v;
        }

        public function align (alignment:uint):Number {
            switch (alignment) {
                case 1: {
                    return left;
                }
                case 2: {
                    return middle;
                }
                case 3: {
                    return right;
                }
            }
            throw new ArgumentError('Invalid alignment value: ' + alignment);
        }
    }
}
