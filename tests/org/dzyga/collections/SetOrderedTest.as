package org.dzyga.collections {

    public class SetOrderedTest extends SetTest{

        [Before]
        override public function setInit ():void {
            _set = new SetOrdered();
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
        public function testOrdered ():void {
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
