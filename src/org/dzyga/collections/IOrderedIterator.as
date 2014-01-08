package org.dzyga.collections {
    public interface IOrderedIterator extends IIterator {
        function hasPrev ():Boolean;
        function prev ():*;
        function end ():*;
    }
}
