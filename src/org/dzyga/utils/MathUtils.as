package org.dzyga.utils {
    /**
     * Utils for math.
     */
    public class MathUtils {
        public static function xor (value1:Boolean, value2:Boolean):Boolean {
            return !(value1 && value2) && (value1 || value2);
        }
    }
}
