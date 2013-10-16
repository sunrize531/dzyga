/**
 * See visualize:
 * http://hosted.zeh.com.br/tweener/docs/en-us/misc/transitions.html
 */

package org.dzyga.eventloop {
    public class TweenTransitions {
        public static const EASE_NONE:String = "easenone";
        public static const LINEAR:String = "linear";

        public static const EASE_IN_QUAD:String = "easeinquad";
        public static const EASE_OUT_QUAD:String = "easeoutquad";
        public static const EASE_IN_OUT_QUAD:String = "easeinoutquad";
        public static const EASE_OUT_IN_QUAD:String = "easeoutinquad";

        public static const EASE_IN_CUBIC:String = "easeincubic";
        public static const EASE_OUT_CUBIC:String = "easeoutcubic";
        public static const EASE_IN_OUT_CUBIC:String = "easeinoutcubic";
        public static const EASE_OUT_IN_CUBIC:String = "easeoutincubic";

        public static const EASE_IN_QUART:String = "easeinquart";
        public static const EASE_OUT_QUART:String = "easeoutquart";
        public static const EASE_IN_OUT_QUART:String = "easeinoutquart";
        public static const EASE_OUT_IN_QUART:String = "easeoutinquart";

        public static const EASE_IN_QUINT:String = "easeinquint";
        public static const EASE_OUT_QUINT:String = "easeoutquint";
        public static const EASE_IN_OUT_QUINT:String = "easeinoutquint";
        public static const EASE_OUT_IN_QUINT:String = "easeoutinquint";

        public static const EASE_IN_SINE:String = "easeinsine";
        public static const EASE_OUT_SINE:String = "easeoutsine";
        public static const EASE_IN_OUT_SINE:String = "easeinoutsine";
        public static const EASE_OUT_IN_SINE:String = "easeoutinsine";

        public static const EASE_IN_CIRC:String = "easeincirc";
        public static const EASE_OUT_CIRC:String = "easeoutcirc";
        public static const EASE_IN_OUT_CIRC:String = "easeinoutcirc";
        public static const EASE_OUT_IN_CIRC:String = "easeoutincirc";

        public static const EASE_IN_EXPO:String = "easeinexpo";
        public static const EASE_OUT_EXPO:String = "easeoutexpo";
        public static const EASE_IN_OUT_EXPO:String = "easeinoutexpo";
        public static const EASE_OUT_IN_EXPO:String = "easeoutinexpo";

        public static const EASE_IN_ELASTIC:String = "easeinelastic";
        public static const EASE_OUT_ELASTIC:String = "easeoutelastic";
        public static const EASE_IN_OUT_ELASTIC:String = "easeinoutelastic";
        public static const EASE_OUT_IN_ELASTIC:String = "easeoutinelastic";

        public static const EASE_IN_BACK:String = "easeinback";
        public static const EASE_OUT_BACK:String = "easeoutback";
        public static const EASE_IN_OUT_BACK:String = "easeinoutback";
        public static const EASE_OUT_IN_BACK:String = "easeoutinback";

        public static const EASE_IN_BOUNCE:String = "easeinbounce";
        public static const EASE_OUT_BOUNCE:String = "easeoutbounce";
        public static const EASE_IN_OUT_BOUNCE:String = "easeinoutbounce";
        public static const EASE_OUT_IN_BOUNCE:String = "easeoutinbounce";

        public static const HIGHLIGHT:String = "highlight";

        public static function getFunction(easingName:String):Function {
            if (!initialized) {
                init();
            }
            return functions[easingName] || easeNone;
        }

        private static var functions:Object = {};
        private static var initialized:Boolean = false;
        private static function init():void {
            functions[EASE_NONE] =              easeNone;
            functions[LINEAR] =                 easeNone;      // mx.transitions.easing.None.easeNone

            functions[EASE_IN_QUAD] =           easeInQuad;    // mx.transitions.easing.Regular.easeIn
            functions[EASE_OUT_QUAD] =          easeOutQuad;   // mx.transitions.easing.Regular.easeOut
            functions[EASE_IN_OUT_QUAD] =       easeInOutQuad; // mx.transitions.easing.Regular.easeInOut
            functions[EASE_OUT_IN_QUAD] =       easeOutInQuad;

            functions[EASE_IN_CUBIC] =          easeInCubic;
            functions[EASE_OUT_CUBIC] =         easeOutCubic;
            functions[EASE_IN_OUT_CUBIC] =      easeInOutCubic;
            functions[EASE_OUT_IN_CUBIC] =      easeOutInCubic;

            functions[EASE_IN_QUART] =          easeInQuart;
            functions[EASE_OUT_QUART] =         easeOutQuart;
            functions[EASE_IN_OUT_QUART] =      easeInOutQuart;
            functions[EASE_OUT_IN_QUART] =      easeOutInQuart;

            functions[EASE_IN_QUINT] =          easeInQuint;
            functions[EASE_OUT_QUINT] =         easeOutQuint;
            functions[EASE_IN_OUT_QUINT] =      easeInOutQuint;
            functions[EASE_OUT_IN_QUINT] =      easeOutInQuint;

            functions[EASE_IN_SINE] =           easeInSine;
            functions[EASE_OUT_SINE] =          easeOutSine;
            functions[EASE_IN_OUT_SINE] =       easeInOutSine;
            functions[EASE_OUT_IN_SINE] =       easeOutInSine;

            functions[EASE_IN_CIRC] =           easeInCirc;
            functions[EASE_OUT_CIRC] =          easeOutCirc;
            functions[EASE_IN_OUT_CIRC] =       easeInOutCirc;
            functions[EASE_OUT_IN_CIRC] =       easeOutInCirc;

            functions[EASE_IN_EXPO] =           easeInExpo;            // mx.transitions.easing.Strong.easeIn
            functions[EASE_OUT_EXPO] =          easeOutExpo;           // mx.transitions.easing.Strong.easeOut
            functions[EASE_IN_OUT_EXPO] =       easeInOutExpo;         // mx.transitions.easing.Strong.easeInOut
            functions[EASE_OUT_IN_EXPO] =       easeOutInExpo;

            functions[EASE_IN_ELASTIC] =        easeInElastic;         // mx.transitions.easing.Elastic.easeIn
            functions[EASE_OUT_ELASTIC] =       easeOutElastic;        // mx.transitions.easing.Elastic.easeOut
            functions[EASE_IN_OUT_ELASTIC] =    easeInOutElastic;      // mx.transitions.easing.Elastic.easeInOut
            functions[EASE_OUT_IN_ELASTIC] =    easeOutInElastic;

            functions[EASE_IN_BACK] =           easeInBack;            // mx.transitions.easing.Back.easeIn
            functions[EASE_OUT_BACK] =          easeOutBack;           // mx.transitions.easing.Back.easeOut
            functions[EASE_IN_OUT_BACK] =       easeInOutBack;         // mx.transitions.easing.Back.easeInOut
            functions[EASE_OUT_IN_BACK] =       easeOutInBack;

            functions[EASE_IN_BOUNCE] =         easeInBounce;          // mx.transitions.easing.Bounce.easeIn
            functions[EASE_OUT_BOUNCE] =        easeOutBounce;         // mx.transitions.easing.Bounce.easeOut
            functions[EASE_IN_OUT_BOUNCE] =     easeInOutBounce;       // mx.transitions.easing.Bounce.easeInOut
            functions[EASE_OUT_IN_BOUNCE] =     easeOutInBounce;

            functions[HIGHLIGHT] =              highlight;

            initialized = true;
        }

    // ==================================================================================================================================
    // TWEENING EQUATIONS functions -----------------------------------------------------------------------------------------------------
    // (the original equations are Robert Penner's work as mentioned on the disclaimer)

        /**
         * Easing equation function for a simple linear tweening, with no easing.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeNone (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c*t/d + b;
        }

        /**
         * Easing equation function for a quadratic (t^2) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInQuad (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c*(t/=d)*t + b;
        }

        /**
         * Easing equation function for a quadratic (t^2) easing out: decelerating to zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutQuad (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return -c *(t/=d)*(t-2) + b;
        }

        /**
         * Easing equation function for a quadratic (t^2) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutQuad (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if ((t/=d/2) < 1) return c/2*t*t + b;
                return -c/2 * ((--t)*(t-2) - 1) + b;
        }

        /**
         * Easing equation function for a quadratic (t^2) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInQuad (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutQuad (t*2, b, c/2, d, p_params);
                return easeInQuad((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for a cubic (t^3) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInCubic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c*(t/=d)*t*t + b;
        }

        /**
         * Easing equation function for a cubic (t^3) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutCubic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c*((t=t/d-1)*t*t + 1) + b;
        }

        /**
         * Easing equation function for a cubic (t^3) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutCubic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if ((t/=d/2) < 1) return c/2*t*t*t + b;
                return c/2*((t-=2)*t*t + 2) + b;
        }

        /**
         * Easing equation function for a cubic (t^3) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInCubic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutCubic (t*2, b, c/2, d, p_params);
                return easeInCubic((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for a quartic (t^4) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInQuart (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c*(t/=d)*t*t*t + b;
        }

        /**
         * Easing equation function for a quartic (t^4) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutQuart (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return -c * ((t=t/d-1)*t*t*t - 1) + b;
        }

        /**
         * Easing equation function for a quartic (t^4) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutQuart (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
                return -c/2 * ((t-=2)*t*t*t - 2) + b;
        }

        /**
         * Easing equation function for a quartic (t^4) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInQuart (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutQuart (t*2, b, c/2, d, p_params);
                return easeInQuart((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for a quintic (t^5) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInQuint (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c*(t/=d)*t*t*t*t + b;
        }

        /**
         * Easing equation function for a quintic (t^5) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutQuint (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c*((t=t/d-1)*t*t*t*t + 1) + b;
        }

        /**
         * Easing equation function for a quintic (t^5) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutQuint (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
                return c/2*((t-=2)*t*t*t*t + 2) + b;
        }

        /**
         * Easing equation function for a quintic (t^5) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInQuint (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutQuint (t*2, b, c/2, d, p_params);
                return easeInQuint((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for a sinusoidal (sin(t)) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInSine (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
        }

        /**
         * Easing equation function for a sinusoidal (sin(t)) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutSine (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c * Math.sin(t/d * (Math.PI/2)) + b;
        }

        /**
         * Easing equation function for a sinusoidal (sin(t)) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutSine (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
        }

        /**
         * Easing equation function for a sinusoidal (sin(t)) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInSine (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutSine (t*2, b, c/2, d, p_params);
                return easeInSine((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for an exponential (2^t) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInExpo (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b - c * 0.001;
        }

        /**
         * Easing equation function for an exponential (2^t) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutExpo (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return (t==d) ? b+c : c * 1.001 * (-Math.pow(2, -10 * t/d) + 1) + b;
        }

        /**
         * Easing equation function for an exponential (2^t) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutExpo (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t==0) return b;
                if (t==d) return b+c;
                if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
                return c/2 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
        }

        /**
         * Easing equation function for an exponential (2^t) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInExpo (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutExpo (t*2, b, c/2, d, p_params);
                return easeInExpo((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for a circular (sqrt(1-t^2)) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInCirc (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
        }

        /**
         * Easing equation function for a circular (sqrt(1-t^2)) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutCirc (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
        }

        /**
         * Easing equation function for a circular (sqrt(1-t^2)) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutCirc (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
                return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
        }

        /**
         * Easing equation function for a circular (sqrt(1-t^2)) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInCirc (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutCirc (t*2, b, c/2, d, p_params);
                return easeInCirc((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for an elastic (exponentially decaying sine wave) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param a             Amplitude.
         * @param p             Period.
         * @return              The correct value.
         */
        private static function easeInElastic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t==0) return b;
                if ((t/=d)==1) return b+c;
                var p:Number = !Boolean(p_params) || isNaN(p_params.period) ? d*.3 : p_params.period;
                var s:Number;
                var a:Number = !Boolean(p_params) || isNaN(p_params.amplitude) ? 0 : p_params.amplitude;
                if (!Boolean(a) || a < Math.abs(c)) {
                        a = c;
                        s = p/4;
                } else {
                        s = p/(2*Math.PI) * Math.asin (c/a);
                }
                return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
        }

        /**
         * Easing equation function for an elastic (exponentially decaying sine wave) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param a             Amplitude.
         * @param p             Period.
         * @return              The correct value.
         */
        private static function easeOutElastic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t==0) return b;
                if ((t/=d)==1) return b+c;
                var p:Number = !Boolean(p_params) || isNaN(p_params.period) ? d*.3 : p_params.period;
                var s:Number;
                var a:Number = !Boolean(p_params) || isNaN(p_params.amplitude) ? 0 : p_params.amplitude;
                if (!Boolean(a) || a < Math.abs(c)) {
                        a = c;
                        s = p/4;
                } else {
                        s = p/(2*Math.PI) * Math.asin (c/a);
                }
                return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
        }

        /**
         * Easing equation function for an elastic (exponentially decaying sine wave) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param a             Amplitude.
         * @param p             Period.
         * @return              The correct value.
         */
        private static function easeInOutElastic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t==0) return b;
                if ((t/=d/2)==2) return b+c;
                var p:Number = !Boolean(p_params) || isNaN(p_params.period) ? d*(.3*1.5) : p_params.period;
                var s:Number;
                var a:Number = !Boolean(p_params) || isNaN(p_params.amplitude) ? 0 : p_params.amplitude;
                if (!Boolean(a) || a < Math.abs(c)) {
                        a = c;
                        s = p/4;
                } else {
                        s = p/(2*Math.PI) * Math.asin (c/a);
                }
                if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
                return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
        }

        /**
         * Easing equation function for an elastic (exponentially decaying sine wave) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param a             Amplitude.
         * @param p             Period.
         * @return              The correct value.
         */
        private static function easeOutInElastic (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutElastic (t*2, b, c/2, d, p_params);
                return easeInElastic((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param s             Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
         * @return              The correct value.
         */
        private static function easeInBack (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                var s:Number = !Boolean(p_params) || isNaN(p_params.overshoot) ? 1.70158 : p_params.overshoot;
                return c*(t/=d)*t*((s+1)*t - s) + b;
        }

        /**
         * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param s             Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
         * @return              The correct value.
         */
        private static function easeOutBack (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                var s:Number = !Boolean(p_params) || isNaN(p_params.overshoot) ? 1.70158 : p_params.overshoot;
                return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
        }

        /**
         * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param s             Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
         * @return              The correct value.
         */
        private static function easeInOutBack (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                var s:Number = !Boolean(p_params) || isNaN(p_params.overshoot) ? 1.70158 : p_params.overshoot;
                if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
                return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
        }

        /**
         * Easing equation function for a back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param s             Overshoot ammount: higher s means greater overshoot (0 produces cubic easing with no overshoot, and the default value of 1.70158 produces an overshoot of 10 percent).
         * @return              The correct value.
         */
        private static function easeOutInBack (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutBack (t*2, b, c/2, d, p_params);
                return easeInBack((t*2)-d, b+c/2, c/2, d, p_params);
        }

        /**
         * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in: accelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInBounce (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                return c - easeOutBounce (d-t, 0, c, d) + b;
        }

        /**
         * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out: decelerating from zero velocity.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutBounce (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if ((t/=d) < (1/2.75)) {
                        return c*(7.5625*t*t) + b;
                } else if (t < (2/2.75)) {
                        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
                } else if (t < (2.5/2.75)) {
                        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
                } else {
                        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
                }
        }

        /**
         * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing in/out: acceleration until halfway, then deceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeInOutBounce (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeInBounce (t*2, 0, c, d) * .5 + b;
                else return easeOutBounce (t*2-d, 0, c, d) * .5 + c*.5 + b;
        }

        /**
         * Easing equation function for a bounce (exponentially decaying parabolic bounce) easing out/in: deceleration until halfway, then acceleration.
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @return              The correct value.
         */
        private static function easeOutInBounce (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
                if (t < d/2) return easeOutBounce (t*2, b, c/2, d, p_params);
                return easeInBounce((t*2)-d, b+c/2, c/2, d, p_params);
        }


        /**
         * Highlighting by loop in/out some times
         *
         * @param t             Current time (in frames or seconds).
         * @param b             Starting value.
         * @param c             Change needed in value.
         * @param d             Expected easing duration (in frames or seconds).
         * @param loop          Number of loop
         * @return              The correct value.
         */
        private static function highlight (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
            var loop:Number = !Boolean(p_params) || isNaN(p_params.loop) ? 3 : p_params.loop;
            return c * (1 + Math.cos(3 + 5.25 * loop * t/d)) / 2 + b;
        }
    }
}
