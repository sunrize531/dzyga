package org.dzyga.collections {
    import flash.errors.IllegalOperationError;

    use namespace dz_collections;

    public class ListAbstract implements ISequence, ISized {
        dz_collections function get _firstNode ():IBinaryNode {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function get _lastNode ():IBinaryNode {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodeInit (item:*):IBinaryNode {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodeAppend (node:IBinaryNode):void {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodePrepend (node:IBinaryNode):void {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodeRemove (node:IBinaryNode):Boolean {
            throw new IllegalOperationError('Not implemented');
        }

        public function add (item:*):Boolean {
            throw new IllegalOperationError('Not implemented');
        }

        public function remove (item:*):Boolean {
            throw new IllegalOperationError('Not implemented');
        }

        public function size ():int {
            throw new IllegalOperationError('Not implemented');
        }
    }
}
