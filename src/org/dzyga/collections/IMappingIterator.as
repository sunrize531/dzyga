package org.dzyga.collections {
    public interface IMappingIterator extends IIterator {
        function nextKey ():*;
        function nextItem ():KeyValue;
    }
}
