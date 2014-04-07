package org.dzyga.collections {
    public interface IMappingIterator extends ISequenceIterator {
        function nextKey ():*;
        function nextItem ():KeyValue;
    }
}
