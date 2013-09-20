package org.dzyga.utils {
    public final class FunctionUtils {
        /**
         * If f is Function run it, otherwise return it.
         *
         * @param f Some value or function
         * @param thisArg The object to which the function is applied.
         * @param args Arguments
         * @return
         */
        public static function result (f:*, thisArg:* = null, ...args):* {
            if (f is Function) {
                return f.apply(thisArg, args);
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
         * Arguments will be appended to function argument list when calling.
         * Very useful for mapping.
         *
         * @param f
         * @param args args to define
         * @return new function
         */
        public static function partial (f:Function, ... args):Function {
            return function (... partialArgs):* {
                return f.apply(null, ArrayUtils.add(partialArgs, args));
            }
        }

        /**
         * Create function which is calls function with some predefined arguments.
         * Arguments will be appended to function argument list when calling.
         * Also you can provide thisArg for the function.
         * Very useful for mapping.
         *
         * @param f
         * @param thisArg bind f to this
         * @param args args to define
         * @return new function
         */
        public static function bind (f:Function, thisArg:* = null, ... args):Function {
            return function (... partialArgs):* {
                return f.apply(thisArg, ArrayUtils.add(partialArgs, args));
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

        /**
         * This is very useful function for maps and filters. Just returns it's first argument. :)
         *
         * @param value value to return
         * @param args
         * @return value
         */
        public static function identity (value:* = null, ... args):* {
            return value;
        }


        /**
         * Get the property in the object named field. If it's function - run it, otherwise return it.
         *
         * @param object
         * @param field
         * @param thisArg
         * @param args
         * @return
         */
        public static function field (object:Object, field:String, thisArg:* = null, ... args):* {
            return result.apply(null, ArrayUtils.add([object[field], thisArg], args));
        }
    }
}
