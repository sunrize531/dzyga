package org.dzyga.collections {
    import org.dzyga.utils.FunctionUtils;

    public class SetSortedTest extends SetTest{

        [Before]
        override public function setInit ():void {
            _set = new SetSorted(FunctionUtils.compareAsHash);
            _set.update(['1', 2, null]);
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
