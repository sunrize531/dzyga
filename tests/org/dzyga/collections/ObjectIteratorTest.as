package org.dzyga.collections {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;

    public class ObjectIteratorTest {
        [Test]
        public function testNextKey ():void {
            var object:Object = {
                'text': 'plain_value',
                'number': 2,
                'list': [1, 2, 3]
            };
            var iterator:ObjectIterator = new ObjectIterator(object);
            var counter:int = 0;

            while (iterator.hasNext()) {
                assertTrue(object.hasOwnProperty(iterator.nextKey()));
                counter++;
            }
            assertEquals(3, counter);
        }

        [Test]
        public function testNextItem ():void {
            var object:Object = {
                'text': 'plain_value',
                'number': 2,
                'list': [1, 2, 3]
            };
            var iterator:ObjectIterator = new ObjectIterator(object);
            var counter:int = 0;

            while (iterator.hasNext()) {
                var item:KeyValue = iterator.nextItem();
                assertEquals(object[item.key], item.value);
                counter++;
            }
            assertEquals(3, counter);
        }
    }
}
