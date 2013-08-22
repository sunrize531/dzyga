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

        private static var _onceMap:Dictionary = new Dictionary(true);

        /**
         * Create version of f which is runs only once. For subsequent calls first run result returned.
         *
         * @param f
         * @return
         */
        public static function once (f:Function):Function {
            var onceFunction:Function = function (... arguments):* {
                if (onceFunction in _onceMap) {
                    return _onceMap[onceFunction];
                } else {
                    var re:* = onceFunction.apply(this, arguments);
                    _onceMap[onceFunction] = re;
                    return re;
                }
            };
            return onceFunction;
        }

        /**
         * Create composition function of provided functions.
         *
         * @param args list of functions to compose
         * @return composition
         */
        public static function compose (... args):Function {
            var functions:Array = args;
            return function (... args):* {
                for (var i:int = functions.length - 1; i >= 0; i--) {
                    args = [functions[i].apply(this, args)];
                }
                return args[0];
            };
        }
    }
}
