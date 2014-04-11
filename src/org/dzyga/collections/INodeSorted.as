package org.dzyga.collections {
    public interface INodeSorted extends INodeBinary {
        function get parent ():INodeSorted;

        function set parent (v:INodeSorted):void;

        function get order ():int;

        function set order (v:int):void;
    }
}
