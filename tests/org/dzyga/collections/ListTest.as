package org.dzyga.collections {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertStrictlyEquals;
    import org.flexunit.asserts.assertTrue;

    public class ListTest {
        private var _list:List;

        [Before]
        public function setInit ():void {
            _list = new List();
            _list.extend(['1', 2, null]);
        }


        [Test]
        public function testRemove ():void {
            var l:List = new List();
        }

        [Test]
        public function testAdd ():void {
            assertStrictlyEquals('1', _list.first());
            assertStrictlyEquals(undefined, _list.last());
            assertEquals(3, _list.size());
        }

        [Test]
        public function testHas ():void {
            assertTrue(_list.has(2));
            assertFalse(_list.has('3'));
        }

        [Test]
        public function testAppend ():void {
            _list.add('value');
            assertEquals('value', _list.last());
            assertEquals(4, _list.size());
        }

        [Test]
        public function testPrepend ():void {
            _list.prepend('value');
            assertEquals('value', _list.first());
            assertEquals(4, _list.size());
        }

        [Test]
        public function testIterator ():void {
            var iterator:ISequenceIterator = _list.iterator() as ISequenceIterator;
            var count:int = 0;
            while (iterator.hasNext()) {
                var item:* = iterator.next();
                if (item === 2) {
                    iterator.remove();
                }
                count++;
            }
            assertEquals(3, count);
            assertEquals(2, _list.size());
        }
    }
}
