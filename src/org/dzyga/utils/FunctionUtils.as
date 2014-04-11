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
        public static function compose (...args):Function {
            var functions:Array = args.reverse();
            return function (...args):* {
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
        public static function partial (f:Function, ...args):Function {
            return function (...partialArgs):* {
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
        public static function bind (f:Function, thisArg:* = null, ...args):Function {
            return function (...partialArgs):* {
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
            return function (...args):* {
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
        public static function identity (value:* = null, ...args):* {
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
        public static function field (object:Object, field:String, thisArg:* = null, ...args):* {
            return result.apply(null, ArrayUtils.add([object[field], thisArg], args));
        }

        /**
         * Compare two values by results of its valueOf methods. Can be used as primitive comparator for sorting.
         * Returns positive number if value1 < value2, negative number if value1 > value2
         *
         * @param value1
         * @param value2
         * @return
         */
        public static function compare (value1:*, value2:*):Number {
            return value2.valueOf() - value1.valueOf();
        }

        /**
         * Compare string representations of values. Can be used as primitive comparator for sorting.
         * Returns positive number if value1 < value2, negative number if value1 > value2
         *
         * @param value1
         * @param value2
         * @return
         */
        public static function compareAsString (value1:*, value2:*):Number {
            var string1:String = value1.toString();
            var string2:String = value2.toString();
            if (string1 < string2) {
                return 1;
            } else if (string1 > string2) {
                return -1;
            } else {
                return 0;
            }
        }

        public static function compareAsHash (value1:*, value2:*):Number {
            return compareAsString(ObjectUtils.hash(value1), ObjectUtils.hash(value2));
        }


        /**
         * Compares values using provided comparator. id comparator is null - FunctionUtils.compare method used.
         * Returns value which is considered greater.
         *
         * @param value1
         * @param value2
         * @param comparator Function to compare values
         * @return Greater value
         */
        public static function select (value1:*, value2:*, comparator:Function = null):* {
            if (comparator == null) {
                comparator = compare;
            }
            if (comparator(value1, value2) > 0) {
                return value2;
            } else {
                return value1;
            }
        }
    }
}
