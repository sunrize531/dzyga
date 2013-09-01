package org.dzyga.eventloop {
    import org.as3commons.collections.utils.NumericComparator;

    internal class LoopCallbackDelayedComparator extends NumericComparator {

        override public function compare (item1:*, item2:*):int {
            var c1:ILoopCallback = ILoopCallback(item1);
            var c2:ILoopCallback = ILoopCallback(item2);
            return super.compare(c1.timeout, c2.timeout) ||
                super.compare(c1.priority, c2.priority);
        }
    }
}
