package org.dzyga.collections {
    public interface ICollection {
        function add (...args):Boolean;
        function remove (...args):Boolean;
        function size ():int;
        function clear ():Boolean;
    }
}
