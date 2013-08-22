package org.dzyga.utils {

    import org.as3commons.collections.ArrayList;
    import org.as3commons.collections.framework.IIterator;
    import org.as3commons.collections.iterators.ArrayIterator;
    import org.as3commons.collections.utils.Lists;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class IterUtilsTest {
        private var _a:Array = [1, 0];
        private var _s:ArrayList = new ArrayList();

        [Before]
        public function setInit ():void {
            _s.clear();
            Lists.addFromArray(_s, _a);
        }

        private static function f (o:*):Boolean {
            return Boolean(o);
        }


        [Test]
        public function testFilter ():void {
            assertFalse(IterUtils.filter(false, f).hasNext());

            var filtered:IIterator = IterUtils.filter(new ArrayIterator(_a), f);
            assertTrue(filtered.hasNext());
            filtered.next();
            assertFalse(filtered.hasNext());

            filtered = IterUtils.filter(_s, f);
            assertTrue(filtered.hasNext());
            filtered.next();
            assertFalse(filtered.hasNext());
        }

        [Test]
        public function testMap ():void {
            assertFalse(IterUtils.map(0, f).next());

            var mapped:IIterator = IterUtils.map(new ArrayIterator(_a), f);
            assertTrue(mapped.hasNext());
            assertTrue(mapped.next());
            assertTrue(mapped.hasNext());
            assertFalse(mapped.next());

            mapped = IterUtils.map(_s, f);
            assertTrue(mapped.hasNext());
            assertTrue(mapped.next());
            assertTrue(mapped.hasNext());
            assertFalse(mapped.next());
        }
    }
}
