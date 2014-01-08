package org.dzyga.collections {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class SetTest {
        protected var _set:ISet;

        [Before]
        public function setInit ():void {
            _set = new Set();
            _set.update(['1', 2, null]);
        }

        [Test]
        public function testRemove ():void {
            _set.remove('1');
            assertEquals(2, _set.size());
            assertFalse(_set.has('1'));

            _set.remove(2);
            assertEquals(1, _set.size());
            assertFalse(_set.has(2));

            _set.remove(null);
            assertEquals(0, _set.size());
            assertFalse(_set.has(null));
        }


        [Test]
        public function testAdd ():void {
            assertTrue(_set.add(1));
            assertTrue(_set.has(1));
            assertTrue(_set.has('1'));
            assertEquals(4, _set.size());
            assertFalse(_set.add(2));
        }

        [Test]
        public function testIterator ():void {
            var iterator:ISequenceIterator = _set.iterator() as ISequenceIterator;
            var count:int = 0;
            while (iterator.hasNext()) {
                var item:* = iterator.next();
                if (item === 2) {
                    iterator.remove();
                }
                count++;
            }
            assertEquals(3, count);
            assertEquals(2, _set.size());
            assertFalse(_set.has(2));
        }

        [Test]
        public function testUpdate ():void {
            assertTrue(_set.update([1, 2, null]));
            assertEquals(4, _set.size());
        }

        [Test]
        public function testSubtract ():void {
            assertTrue(_set.subtract([1, 2, null]));
            assertEquals(1, _set.size());
            assertTrue(_set.has('1'));
        }

        [Test]
        public function testIntersect ():void {
            assertTrue(_set.intersect([1, 2, null]));
            assertEquals(2, _set.size());
            assertTrue(_set.has(2));
            assertTrue(_set.has(null));
        }
    }
}
