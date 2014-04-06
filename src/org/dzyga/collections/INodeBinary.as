package org.dzyga.collections {
    public interface INodeBinary extends IHashable {
        function get left ():INodeBinary;

        function set left (v:INodeBinary):void;

        function get right ():INodeBinary;

        function set right (v:INodeBinary):void;

        function get item ():*;
    }
}
