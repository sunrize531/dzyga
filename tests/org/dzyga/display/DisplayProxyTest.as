package org.dzyga.display {
    import flash.display.Sprite;

    import org.flexunit.asserts.assertEquals;

    public class DisplayProxyTest {
        public var _main:Sprite;
        public var _first:Sprite;
        public var _second:Sprite;
        public var _third:Sprite;

        [Before]
        public function spritesInit ():void {
            _main = new Sprite();
            _first = new Sprite();
            _second = new Sprite();
            _third = new Sprite();
        }

        [Test]
        public function childIndexTest ():void {
            display(_main)
                .addChild(_first, -1)
                .addChild(_second, 0)
                .addChild(_third, -1);

            assertEquals(1, _main.getChildIndex(_first));
            assertEquals(0, _main.getChildIndex(_second));
            assertEquals(2, _main.getChildIndex(_third));
        }
    }
}
