package org.dzyga.collections {
    public interface ISet extends ICollection, IIterable {
        function update (iterable:*):Boolean;

        function subtract (iterable:*):Boolean;

        function intersect (iterable:*):Boolean;

        function isSubSet (iterable:*):Boolean;

        function isSuperSet (iterable:*):Boolean;
    }
}
