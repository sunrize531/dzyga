package org.dzyga.utils {
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class FunctionUtilsTest {
        public function FunctionUtilsTest () {
        }

        [Test]
        public function testPartial ():void {
            var k:int = 0;
            var j:int = 0;
            var f:Function = FunctionUtils.partial(function (a:int, b:int):int {
                k = a;
                j = b;
                return a + b;
            }, 1);
            var value:int = f(5);
            assertEquals(5, k);
            assertEquals(1, j);
            assertEquals(6, value);
        }

        [Test]
        public function testBind ():void {
            var obj:Object = {
                'a': 5
            };

            var f:Function = FunctionUtils.bind(function (a:int, b:int):int {
                this.a += b;
                return a + b;
            }, obj, 1);
            var value:int = f(5);
            assertEquals(6, obj.a);
            assertEquals(6, value);
        }

        [Test]
        public function testResult ():void {
            var f:Function = function ():int {
                return 1;
            };
            assertEquals(1, FunctionUtils.result(f));
        }

        private var _onceRun:Boolean = false;

        [Test]
        public function testOnce ():void {
            var f:Function = FunctionUtils.once(function ():int {
                assertFalse(_onceRun);
                _onceRun = true;
                return 1;
            });
            assertEquals(1, f());
            assertEquals(1, f());
        }

        [Test]
        public function testCompose ():void {
            var setID:Function = function (obj:Object, prefix:String = ''):Object {
                obj.id = String(obj.id);
                return obj;
            };

            var setName:Function = function (obj:Object):Object {
                obj.name = obj.id;
                return obj;
            };

            var validate:Function = function (obj:Object):Object {
                assertEquals(obj.id, obj.name);
                obj.valid = true;
                return obj;
            };

            var composition:Function = FunctionUtils.compose(setID, setName, validate);
            var obj:Object = {id: 1};
            composition(obj);
            assertEquals('1', obj.id);
            assertTrue(obj.valid);
        }

        [Test]
        public function testWrap ():void {
            var obj:Object = {};

            var setID:Function = function (obj:Object, id:String, prefix:String = ''):Object {
                obj.id = prefix + id;
                obj.name = obj.id;
                return obj;
            };

            var wrapper:Function = function (setter:Function, obj:Object, value:String):Object {
                setter(obj, value, 'prefix_');
                assertEquals(obj.id, obj.name);
                return obj;
            };

            var wrappedSetter:Function = FunctionUtils.wrap(setID, wrapper);
            wrappedSetter(obj, '001');
            assertEquals('prefix_001', obj.id);
        }

        [Test]
        public function testField ():void {
            var obj:Object = {
                'genericField': 'field',
                'methodField': FunctionUtils.identity
            };
            assertEquals('field', FunctionUtils.field(obj, 'genericField'));
            assertEquals(1, FunctionUtils.field(obj, 'methodField', null, 1));
        }
    }
}
