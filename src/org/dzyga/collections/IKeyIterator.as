package org.dzyga.collections {
    public interface IKeyIterator extends IIterator {
        function nextKey ():*;
        function nextItem ():KeyValue;
    }
}
