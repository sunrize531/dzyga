package org.dzyga.collections {
    public interface IOrdered {
        function first ():*;
        function last ():*;
        function prepend (item:*):Boolean;
        function pop ():*;
        function shift ():*;
        // TODO: reverse
    }
}
