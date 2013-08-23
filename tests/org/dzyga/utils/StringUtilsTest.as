package org.dzyga.utils {
    import flash.utils.getTimer;

    import org.flexunit.asserts.assertEquals;

    import org.flexunit.asserts.assertFalse;

    public class StringUtilsTest {
        public static const ITERATIONS:int = 100000;

        public function StringUtilsTest () {
        }

        [Test]
        public function testUniqueID ():void {
            var hash:Object = {};
            var t:Number = getTimer();
            for (var i:int = 0; i <= ITERATIONS; i++) {
                var id:String = StringUtils.uniqueID();
                assertFalse(hash.hasOwnProperty(id));
                hash[id] = true;
            }
            trace(StringUtils.uniqueID());
            trace('Time elapsed: ' + (getTimer() - t));
        }

        [Test]
        public function testChecksum ():void {
            var s:String = StringUtils.uniqueID();
            trace(StringUtils.checksum(s));
            assertEquals(StringUtils.checksum(s), StringUtils.checksum(s));
        }
    }
}
