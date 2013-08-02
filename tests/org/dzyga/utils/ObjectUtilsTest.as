package org.dzyga.utils {
    import org.flexunit.asserts.assertEquals;

    public class ObjectUtilsTest {
        public function ObjectUtilsTest () {
        }

        [Test]
        public function testHash ():void {
            var object:Object = {};
            assertEquals(ObjectUtils.hash(object), ObjectUtils.hash(object));
        }
    }
}
