package org.dzyga.collections {
    public interface ICollection extends IContainer, ISized, IIterable {
        function clear ():Boolean;
        function items ():Array;
    }
}
