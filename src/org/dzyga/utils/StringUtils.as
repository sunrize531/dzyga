package org.dzyga.utils {
    import flash.utils.ByteArray;
    import flash.utils.getTimer;

    public final class StringUtils {
        private static const SF_VAR:RegExp = /\{([^:{}]*)(:[^{}]*)?\}/g;
        private static const SF_FLOAT:RegExp = /^:(\+?)(\d*)(?:\.(\d+))?f$/;
        private static const SF_INT:RegExp = /^:(\+?)(\d*)d$/;
        private static const SF_STRING:RegExp = /^:(\-?)(\d*)s$/;
        private static const SF_CHECK_INT:RegExp = /^\d+$/;
        private static const HOURS_PATTERN:RegExp = /\d+h/;
        private static const MINUTES_PATTERN:RegExp = /\d+m/;
        private static const SECONDS_PATTERN:RegExp = /\d+s/;
        private static const CHECK_LETTER_PATTERN:RegExp = /[h|m|s]/;

        private static var sf_index:int;
        private static var sf_args:Array;

        private static const _buffer:Vector.<String> = new <String>[];

        internal static function _initBuffer (length:uint = 0):Vector.<String> {
            _buffer.length = length;
            return _buffer;
        }

        internal static function _flushBuffer ():String {
            var s:String = _buffer.join('');
            _buffer.length = 0;
            return s;
        }

        private static function stringFormat (val:String, name:String, fmt:String, ...args):String {
            var value:*;
            var result:String;
            var prop:Object;
            if (name) {
                var parts:Array = name.split('.');
                var key:String = parts[0];
                if (key) {
                    if (StringUtils.SF_CHECK_INT.test(key)) {
                        value = StringUtils.sf_args[int(key)]
                    }
                    else {
                        value = StringUtils.sf_args[0][key];
                    }
                }
                else {
                    value = StringUtils.sf_args[StringUtils.sf_index++];
                }
                if (parts.length > 1) {
                    for each (key in parts) {
                        value = value[key];
                    }
                }
            }
            else {
                value = StringUtils.sf_args[StringUtils.sf_index++];
            }
            if (fmt) {
                switch (fmt.substr(-1)) {
                    case 'd':
                        prop = StringUtils.SF_INT.exec(fmt);
                        if (!prop) {
                            throw "Wrong format '" + fmt + "'";
                        }
                        result = StringUtils.numFormat(value, prop[1], prop[2], 0);
                        break;
                    case 'f':
                        prop = StringUtils.SF_FLOAT.exec(fmt);
                        if (!prop) {
                            throw "Wrong format '" + fmt + "'";
                        }
                        result = StringUtils.numFormat(value, prop[1], prop[2], prop[3]);
                        break;
                    case 's':
                        prop = StringUtils.SF_STRING.exec(fmt);
                        if (!prop) {
                            throw "Wrong format '" + fmt + "'";
                        }
                        if (prop[2]) {
                            if (prop[1]) {
                                result = StringUtils.fillright(value, prop[2]);
                            }
                            else {
                                result = StringUtils.fillleft(value, prop[2]);
                            }
                        } else {
                            result = value;
                        }
                        break;
                    case 'r':
                        result = ObjectUtils.repr(value);
                        break;
                    default:
                        throw "Wrong format '" + fmt + "'";
                }
            }
            else {
                result = value;
            }
            return result;

        }

        private static const NF_PLUS:String = '+';
        private static const NF_MINUS:String = '-';
        private static const NF_ZERO:String = '0';
        private static const NF_DOT:String = '.';

        private static function numFormat (value:Number, sign:String, len:String, prec:int):String {
            var result:String = value.toFixed(prec);
            var length:int = int(len);
            if (prec <= 0 && result.charAt(result.length - 1) == StringUtils.NF_DOT) {
                result = result.substr(0, result.length - 1);
            }
            if (length && len.charAt(0) == StringUtils.NF_ZERO) {
                if (value >= 0) {
                    if (sign) {
                        result = StringUtils.NF_PLUS +
                            StringUtils.fillLeft(result, length - 1, StringUtils.NF_ZERO);
                    }
                    else {
                        result =
                            StringUtils.fillLeft(result, length, StringUtils.NF_ZERO);
                    }
                }
                else {
                    result = StringUtils.NF_MINUS +
                        StringUtils.fillLeft(result.substr(1), length - 1, StringUtils.NF_ZERO);
                }
            }
            else {
                if (sign && value >= 0) {
                    result = StringUtils.NF_PLUS + result;
                }
                result = fillleft(result, length);
            }
            return result;
        }

        public static function format (pattern:String, ...args):String {
            StringUtils.sf_index = 0;
            StringUtils.sf_args = args;
            var result:String = pattern.replace(StringUtils.SF_VAR, StringUtils.stringFormat);
            StringUtils.sf_args = null;
            return result;
        }

        public static function formatArray (pattern:String, arguments:Array):String {
            sf_index = 0;
            sf_args = arguments;
            var result:String = pattern.replace(StringUtils.SF_VAR, StringUtils.stringFormat);
            sf_args = null;
            return result;
        }

        public static function startswith (str:String, prefix:String):Boolean {
            return (str.substr(0, prefix.length) == prefix);
        }

        public static function endswith (str:String, suffix:String):Boolean {
            return (str.substr(-suffix.length) == suffix);
        }

        /**
         * Alias for fillLeft.
         *
         * @deprecated
         */
        public static function fillleft (str:String, len:int, fillchar:String = ' '):String {
            return fillLeft(str, len, fillchar);
        }

        /**
         * Pad string to specified length filling with fillChar from left.
         *
         * @param str String to pad.
         * @param len Desired string length.
         * @param fillChar Character to fill with. Default to space.
         * @return New padded String or str itself, if it's length greater or equal than len.
         */
        public static function fillLeft (str:String, len:int, fillChar:String = ' '):String {
            var length:int = str.length;
            if (length < len) {
                var d:int = len - length;
                _buffer.length = d + 1;
                for (var i:uint = 0; i < d; i++) {
                    _buffer[i] = fillChar;
                }
                _buffer[d] = str;
                return _flushBuffer();
            }
            return str;
        }

        /**
         * Alias for fillRight
         *
         * @deprecated
         */
        public static function fillright (str:String, len:int, fillchar:String = ' '):String {
            var length:int = str.length;
            if (length < len) {
                for (var i:int = len - length; i > 0; i--) {
                    str = str + fillchar;
                }
            }
            return str;
        }

        public static function fillRight (str:String, len:int, fillChar:String = ' '):String {
            var length:int = str.length;
            if (length < len) {
                var d:int = len - length;
                _buffer.length = d + 1;
                _buffer[0] = str;
                for (var i:uint = 0; i < d; i++) {
                    _buffer[i + 1] = fillChar;
                }
                return _flushBuffer();
            }
            return str;
        }

        private static const TRIM_CHECK:RegExp = /(^\s+)|(\s+$)|(\r)/g;

        public static function trim (str:String):String {
            return str.replace(StringUtils.TRIM_CHECK, '');
        }

        public static function random (length:int = 5):String {
            var ret:String = Math.random().toFixed(length + 2);
            return ret.substr(2, length);
        }

        public static function hex (s:String):String {
            var length:int = s.length;
            _buffer.length = length << 1;
            for (var i:uint = 0; i < length; i++) {
                var c:String = s.charCodeAt(i).toString(16);
                var bi:int = i << 1;
                if (c.length == 1) {
                    _buffer[bi] = ZERO;
                    _buffer[bi + 1] = c;
                } else {
                    _buffer[bi] = c.charAt(0);
                    _buffer[bi + 1] = c.charAt(1);
                }
            }
            return _flushBuffer();
        }

        private static const ADLER_NMAX:int = 5552;
        private static const ADLER_BASE:int = 65521;

        /**
         * Calculate checksum for String with Adler32 algorithm.
         *
         * @param buffer String to process
         * @return checksum
         */
        public static function checksum (buffer:String):uint {
            var length:int = buffer.length;
            var l:int;
            var i:int = 0;
            var a:int = 1;
            var b:int = 0;
            while (length) {
                l = (length > ADLER_NMAX) ? ADLER_NMAX : length;
                length -= l;
                do {
                    a += buffer.charCodeAt(i++);
                    b += a;
                } while (--l);
                a = (a & 0xFFFF) + (a >> 16) * 15;
                b = (b & 0xFFFF) + (b >> 16) * 15;
            }
            if (a >= ADLER_BASE) {
                a -= ADLER_BASE;
            }
            b = (b & 0xFFFF) + (b >> 16) * 15;
            if (b >= ADLER_BASE) {
                b -= ADLER_BASE;
            }
            return (b << 16) | a;
        }

        private static var _counter:int = 0;
        private static const ZERO:String = '0';

        public static function uniqueID ():String {
            var buffer:Vector.<String> = StringUtils._initBuffer(2);
            buffer[0] = ((getTimer() & 0xffffff) | 0x1000000).toString(16).substr(1);
            buffer[1] = (((_counter++ & 0xffff) << 8) | (Math.random() * 0xff) | 0x1000000).toString(16).substr(1);
            return StringUtils._flushBuffer();
        }

        private static const TEMPLATE_INTERPOLATE:RegExp = /\{\{\s*(.+?)\s*\}\}/g;
        private static const UNDEFINED_CONTEXT:String = '***';
        private static var _templateContext:Object;

        public static function template (template:String, context:Object):String {
            StringUtils._templateContext = context;
            return template.replace(TEMPLATE_INTERPOLATE, StringUtils._processTemplate);
        }

        private static function _processTemplate (subj:String, key:String, ...args):String {
            var context:Object = StringUtils._templateContext;
            if (context.hasOwnProperty(key)) {
                return context[key];
            }
            else {
                return UNDEFINED_CONTEXT;
            }
        }

        /**
         * Convert object to string. Useful for mapping.
         *
         * @param object
         * @return string representation of the object
         */
        public static function repr (object:*):String {
            return String(object);
        }

        /**
         * Parse string to convert time formatted like "4m20s", "5m", "2h1s", etc. to seconds.
         *
         */
        public static function parseTime (value:String):int {
            value = value.replace(" ", "");
            if (value.search(CHECK_LETTER_PATTERN) != -1) {
                var h:int = 0;
                var m:int = 0;
                var s:int = 0;
                var str:String = HOURS_PATTERN.exec(value);
                if (str) {
                    h = int(str.substr(0, str.length - 1));
                }
                str = MINUTES_PATTERN.exec(value);
                if (str) {
                    m = int(str.substr(0, str.length - 1));
                    //calc hours
                    h += int(m / 60);
                    m = m % 60;
                }
                str = SECONDS_PATTERN.exec(value);
                if (str) {
                    s = int(str.substr(0, str.length - 1));
                    //calc minutes
                    m += int(s / 60);
                    s = s % 60;

                    //calc hours
                    h += int(m / 60);
                    m = m % 60;
                }
                return s + m * 60 + h * 3600;
            }
            return int(value);
        }

        public static function formatTime (value:int):String {
            var h:int = value / 3600;
            var m:int = (value / 60) % 60;
            var s:int = value % 60;
            return format("{0}h{1}m{2}s", h, m, s);
        }
    }
}