package org.dzyga.utils {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;

    public class HashTest {
        [Test]
        public function testPrimitive ():void {
            var object:Object = {};
            assertEquals(ObjectUtils.hash(object), ObjectUtils.hash(object));
            assertEquals(ObjectUtils.hash(1), ObjectUtils.hash(1.0));

            assertFalse(ObjectUtils.hash(1) == ObjectUtils.hash('1'));
            assertFalse(ObjectUtils.hash(undefined) == ObjectUtils.hash(null));
            assertFalse(ObjectUtils.hash(undefined) == ObjectUtils.hash(false));
            assertFalse(ObjectUtils.hash(undefined) == ObjectUtils.hash(''));
            assertFalse(ObjectUtils.hash(undefined) == ObjectUtils.hash(0));
        }

        [Test]
        public function testHashable ():void {
            assertEquals(ObjectUtils.hash(new HashableTestClass(1)), ObjectUtils.hash(new HashableTestClass(1)));
        }
    }
}

import org.dzyga.collections.IHashable;

class HashableTestClass implements IHashable {
    private var _primitive:*;

    public function HashableTestClass (primitive:*) {
        _primitive = primitive;
    }

    public function hash ():* {
        return _primitive;
    }

    public function compare (other:*):int {
        return (_primitive == other.hash()) ? 0: 1;
    }
}
