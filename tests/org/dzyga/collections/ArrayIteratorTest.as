package org.dzyga.collections {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;

    public class ArrayIteratorTest {
        [Test]
        public function testHasNext ():void {
            var iterator:IIterator = new ArrayIterator([1, 2, 3, 4]);
            assertEquals(1, iterator.next());
            assertEquals(2, iterator.next());
            assertEquals(3, iterator.next());
            assertEquals(4, iterator.next());
            assertFalse(iterator.hasNext());

            iterator.reset();
            assertEquals(1, iterator.next());
        }
    }
}
