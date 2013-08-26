package org.dzyga.utils {
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class ArrayUtilsTest {
        public function ArrayUtilsTest () {
        }

        /**
         * Generate array with random entries, copy it and test ArrayUtils.equals method.
         */
        [Test]
        public function testEquals ():void {
            var length:int = 1000;
            var first:Array = [];
            for (var i:int = 0; i < length; i++) {
                if (i % 2) {
                    first.push({});
                } else {
                    first.push(Math.random());
                }
            }
            ArrayUtils.shuffle(first);
            var second:Array = first.concat();
            assertTrue(ArrayUtils.equals(first, second));
            second.shift();
            assertFalse(ArrayUtils.equals(first, second));
        }
    }
}
