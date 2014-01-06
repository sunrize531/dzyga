package org.dzyga.collections {
    public interface IHashable {
        function hash ():*;
        function compare (other:*):int;
    }
}