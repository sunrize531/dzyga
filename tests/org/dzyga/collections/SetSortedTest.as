package org.dzyga.collections {
    import org.dzyga.collections.IIterator;
    import org.dzyga.utils.FunctionUtils;
    import org.flexunit.asserts.assertEquals;

    public class SetSortedTest extends SetTest{

        [Before]
        override public function setInit ():void {
            _set = new SetSorted(FunctionUtils.compareAsHash);
            _set.update(['1', 2, null]);
        }

        [Test]
        public function testSorted ():void {
            _set = new SetSorted(FunctionUtils.compare);
            _set.update([1, 3, 3, 2, 8, 0]);
            var iterator:IIterator = _set.iterator();
            assertEquals(0, iterator.next());
            assertEquals(1, iterator.next());
            assertEquals(2, iterator.next());
            assertEquals(3, iterator.next());
            assertEquals(8, iterator.next());
        }

        [Test]
        override public function testRemove ():void {
            super.testRemove();
        }


        [Test]
        override public function testAdd ():void {
            super.testAdd();
        }

        [Test]
        override public function testIterator ():void {
            super.testIterator();
        }

        [Test]
        override public function testUpdate ():void {
            super.testUpdate();
        }

        [Test]
        override public function testSubtract ():void {
            super.testSubtract();
        }

        [Test]
        override public function testIntersect ():void {
            super.testIntersect();
        }
    }
}
