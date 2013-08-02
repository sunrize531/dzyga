package org.dzyga.utils {
    import org.flexunit.asserts.assertFalse;

    public class StringUtilsTest {
        public static const ITERATIONS:int = 100000;

        public function StringUtilsTest () {
        }

        [Test]
        public function testUniqueID ():void {
            var hash:Object = {};
            for (var i:int = 0; i <= ITERATIONS; i++) {
                var id:String = StringUtils.uniqueID();
                trace(id);
                assertFalse(hash.hasOwnProperty(id));
                hash[id] = true;
            }
        }
    }
}
