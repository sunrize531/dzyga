package org.dzyga.collections {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class ArrayIteratorTest {
        [Test]
        public function testNext ():void {
            var iterator:IIterator = new ArrayIterator([1, 2, 3, 4]);
            assertEquals(1, iterator.next());
            assertEquals(2, iterator.next());
            assertEquals(3, iterator.next());
            assertEquals(4, iterator.next());
            assertFalse(iterator.hasNext());

            iterator.reset();
            assertEquals(1, iterator.next());
        }

        [Test]
        public function testRemove ():void {
            var a:Array = [1, 2, 3, 4];
            var iterator:ArrayIterator = new ArrayIterator(a);
            assertTrue(iterator.remove());
            assertEquals(2, iterator.next());
            assertEquals(3, iterator.next());
            assertTrue(iterator.remove());
            assertEquals(4, iterator.next());
            assertEquals(2, a[0]);
            assertEquals(4, a[1]);
        }
    }
}
