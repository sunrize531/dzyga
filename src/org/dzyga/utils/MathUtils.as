package org.dzyga.utils {
    /**
     * Utils for math.
     */
    public class MathUtils {
        public static function xor (value1:Boolean, value2:Boolean):Boolean {
            return !(value1 && value2) && (value1 || value2);
        }

        public static function summ (... args):Number {
            var out:Number = 0;
            for each (var i:Number in args) {
                out += i;
            }
            return out;
        }

        public static function mean (... args):Number {
            return summ.apply(null, args) / args.length;
        }

        public static function median (... args):Number {
            var index:int = Math.round(args.length / 2);
            return args[index];
        }

        /**
         * Based on http://arduino.cc/en/reference/map#.Uy2gRvmm9zo
         * Implemented by https://github.com/thenitro
         * Original source https://github.com/thenitro/ngine/blob/master/source/ngine/math/TMath.as
         *
         * @param pNumber
         * @param pMinValue
         * @param pMaxValue
         * @param pTargetMin
         * @param pTargetMax
         * @return
         */
        public static function map(pNumber:Number,
                                   pMinValue:Number, pMaxValue:Number,
                                   pTargetMin:Number, pTargetMax:Number):Number {
            var index:Number = (pMaxValue - pMinValue) / pNumber;

            return (pTargetMax - pTargetMin) / index;
        };
}
}
