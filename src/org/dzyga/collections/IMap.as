package org.dzyga.collections {
    public interface IMap extends ICollection {
        function has (key:*):Boolean;

        function set (attributes:Object):Boolean;

        function get (key:*):*;

        function keys ():IIterator;

        function values ():IIterator;
    }
}
