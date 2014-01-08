package org.dzyga.collections {
    public interface IList extends IListSimple, ICollection {
        function extend (iterable:*):Boolean;
    }
}
