package org.dzyga.collections {
    public interface IIterator {
        function hasNext ():Boolean;

        function next ():*;

        function reset ():void;
    }
}
