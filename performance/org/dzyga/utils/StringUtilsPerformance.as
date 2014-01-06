package org.dzyga.utils {
    import com.gskinner.performance.PerformanceTest;

    import flash.utils.ByteArray;
    import flash.utils.getTimer;

    import org.flexunit.asserts.assertEquals;

    /**
     * You will need gskinner's performance test to run this.
     */
    public class StringUtilsPerformance {
        public static const ITERATIONS:int = 10;
        public static const LOOPS:int = 5000;


        private static var _bytes:ByteArray = new ByteArray();
        private static var _counter:int = 0;

        private function uniqueIDByteArray ():String {
            _bytes.writeUnsignedInt(getTimer());
            _bytes.writeInt(_counter++);
            _bytes.writeByte(Math.random() * 256);
            var re:String = StringUtils.hex(_bytes.toString());
            _bytes.clear();
            return re;
        }

        private function uniqueIDBinary ():String {
            var t:String = ((getTimer() & 0xffffff) | 0x1000000).toString(16).substr(1);
            var c:String = (((_counter++ & 0xffff) << 8) | (Math.random() * 0xff) | 0x1000000).toString(16).substr(1);
            return t + c;
        }

        [Test]
        public function testUniqueID ():void {
            trace(PerformanceTest.run(uniqueIDBinary, 'uniqueID Buffer', ITERATIONS, LOOPS));
            trace(PerformanceTest.run(uniqueIDByteArray, 'uniqueID ByteArray', ITERATIONS, LOOPS));
            trace(StringUtils.uniqueID());
            trace('Done');
        }


        [Test]
        public function testChecksum ():void {
            var s:String = StringUtils.uniqueID();
            trace(PerformanceTest.run(StringUtils.checksum, 'checksum', ITERATIONS, LOOPS, [s]));
            trace('Done')
        }


        private function fillLeftClassic (str:String, len:int, fillChar:String = ' '):String {
            var length:int = str.length;
            if (length < len) {
                for (var i:int = len - length; i > 0; i--) {
                    str = fillChar + str;
                }
            }
            return str;
        }

        private function fillLeftBuffer (str:String, len:int, fillChar:String = ' '):String {
            var length:int = str.length;
            if (length < len) {
                var d:int = len - length;
                var _buffer:Vector.<String> = StringUtils._initBuffer(d + 1);
                _buffer.length = d + 1;
                for (var i:uint = 0; i < d; i++) {
                    _buffer[i] = fillChar;
                }
                _buffer[d] = str;
                return StringUtils._flushBuffer();
            }
            return str;
        }

        [Test]
        public function testFillLeft ():void {
            var s:String = '1234567890';
            var padded:String = fillLeftClassic(s, 16, '0');
            assertEquals(padded, fillLeftBuffer(s, 16, '0'));

            trace(PerformanceTest.run(fillLeftClassic, 'Concat 16', ITERATIONS, LOOPS, [s, 16, '0']));
            trace(PerformanceTest.run(fillLeftBuffer, 'Buffer 16', ITERATIONS, LOOPS, [s, 16, '0']));

            trace(PerformanceTest.run(fillLeftClassic, 'Concat 128', ITERATIONS, LOOPS, [s, 128, '0']));
            trace(PerformanceTest.run(fillLeftBuffer, 'Buffer 128', ITERATIONS, LOOPS, [s, 128, '0']));

            trace('Done')
        }
    }
}
