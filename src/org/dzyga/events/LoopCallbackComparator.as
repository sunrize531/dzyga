package org.dzyga.events {
    import org.as3commons.collections.framework.IComparator;
    import org.as3commons.collections.utils.NumericComparator;
    import org.as3commons.collections.utils.StringComparator;

    internal class LoopCallbackComparator extends NumericComparator {
        override public function compare (item1:*, item2:*):int {
            var c1:ILoopCallback = ILoopCallback(item1);
            var c2:ILoopCallback = ILoopCallback(item2);
            return super.compare(c1.priority, c2.priority);
        }
    }
}
