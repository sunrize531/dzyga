package org.dzyga.utils {
    import flash.utils.Dictionary;

    public final class FunctionUtils {
        /**
         * If f is Function run it, otherwise return it.
         *
         * @param f
         * @return
         */
        public static function result (f:*):* {
            if (f is Function) {
                return f();
            } else {
                return f;
            }
        }

        /**
         * Create version of f which is runs only once. For subsequent calls first run result returned.
         *
         * @param f
         * @return
         */
        public static function once (f:Function):Function {
            var ran:Boolean = false;
            var memo:*;
            return function ():* {
                if (ran) {
                    return memo;
                } else {
                    ran = true;
                    memo = f.apply(this, arguments);
                    f = null;
                    return memo;
                }
            };
        }

        /**
         * Create composition function of provided functions.
         *
         * @param args list of functions to compose
         * @return composition
         */
        public static function compose (... args):Function {
            var functions:Array = args.reverse();
            return function (... args):* {
                for (var i:int = functions.length - 1; i >= 0; i--) {
                    args = [functions[i].apply(this, args)];
                }
                return args[0];
            };
        }

        /**
         * Create function which is calls function with some predefined arguments.
         *
         * @param f
         * @param thisArg bind f to this
         * @param args args to define
         * @return new function
         */
        public static function partial (f:Function, thisArg:* = null, ... args):Function {
            return function (... partialArgs):* {
                args = args.concat(partialArgs);
                return f.apply(thisArg, args);
            }
        }


        /**
         * Create function which wraps f with wrapper.
         *
         * @param f function to wrap
         * @param wrapper wrapper function
         * @return new function
         */
        public static function wrap (f:Function, wrapper:Function):Function {
            return function (... args):* {
                var wrapperArgs:Array = [f].concat(args);
                wrapper.apply(this, wrapperArgs);
            };
        }
    }
}
