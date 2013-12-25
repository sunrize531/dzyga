package org.dzyga.collections {
    public interface IList extends ICollection {
        function first ():*;

        function last ():*;

        function pop ():*;

        function shift ():*;

        function append (item:*):int;

        function prepend (item:*):int;

        function has (item:*):Boolean;
    }
}
