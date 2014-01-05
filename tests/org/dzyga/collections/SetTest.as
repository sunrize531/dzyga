package org.dzyga.collections {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class SetTest {
        public var _set:Set;

        [Before]
        public function setInit ():void {
            _set = new Set('1', 2, undefined);
        }

        [Test]
        public function testRemove ():void {
            _set.remove('1');
            assertEquals(2, _set.size());
            assertFalse(_set.has('1'));

            _set.remove(2);
            assertEquals(1, _set.size());
            assertFalse(_set.has(2));

            _set.remove(undefined);
            assertEquals(0, _set.size());
            assertFalse(_set.has(undefined));
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
        public function testUpdate ():void {
            assertTrue(_set.update([1, 2, undefined]));
            assertEquals(4, _set.size());
        }

        [Test]
        public function testIterator ():void {
            var iterator:SetIterator = _set.iterator() as SetIterator;
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
    }
}
