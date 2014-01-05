package org.dzyga.collections {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertStrictlyEquals;
    import org.flexunit.asserts.assertTrue;

    public class ListTest {
        public function ListTest () {
        }

        [Test]
        public function testRemove ():void {
            var l:List = new List();
        }

        [Test]
        public function testAdd ():void {
            var l:List = new List('1', 2, undefined);
            assertStrictlyEquals('1', l.first());
            assertStrictlyEquals(undefined, l.last());
            assertEquals(3, l.size());
        }

        [Test]
        public function testHas ():void {
            var l:List = new List('1', 2, undefined);
            assertTrue(l.has(2));
            assertFalse(l.has('3'));
        }

        [Test]
        public function testAppend ():void {
            var l:List = new List('1', 2, undefined);
            l.append('value');
            assertEquals('value', l.last());
            assertEquals(4, l.size());
        }

        [Test]
        public function testPrepend ():void {
            var l:List = new List('1', 2, undefined);
            l.prepend('value');
            assertEquals('value', l.first());
            assertEquals(4, l.size());
        }

    }
}
