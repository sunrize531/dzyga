package org.dzyga.collections {
    public interface IBinaryNode extends IHashable {
        function get left ():IBinaryNode;

        function set left (v:IBinaryNode):void;

        function get right ():IBinaryNode;

        function set right (v:IBinaryNode):void;

        function get value ():*;

        function set value (v:*):void;
    }
}
