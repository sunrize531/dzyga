package org.dzyga.collections {
    public interface IList extends ICollection, ISequence, IOrdered {
        function extend (iterable:*):Boolean;

        /*
        TODO: implement
        function reversed ():IIterator;
        function reverse ():IIterator;
        */

    }
}
