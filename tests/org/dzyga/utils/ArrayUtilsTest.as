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

        [Test]
        public function testMap ():void {
            var source:Array = [1, 2, 3, 4];
            var mapped:Array = ArrayUtils.map(source, function (num:int, a:int):int {
                return num + a;
            }, null, 1);
            assertTrue(ArrayUtils.equals(mapped, [2, 3, 4, 5]));

            mapped = ArrayUtils.map(mapped, 'toString');
            assertTrue(ArrayUtils.equals(mapped, ['2', '3', '4', '5']));
        }

        [Test]
        public function testPluck ():void {
            assertTrue(ArrayUtils.equals(
                    ['one', 'two', 'three'],
                    ArrayUtils.pluck([
                        {'id': 'one'},
                        {'id': 'two'},
                        {'id': function ():String { return 'three'; }}], 'id')))
        }
    }
}
