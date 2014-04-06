package org.dzyga.collections {
    import flash.errors.IllegalOperationError;

    use namespace dz_collections;

    public class ListAbstract implements ISequence, ISized {
        dz_collections function get _firstNode ():INodeBinary {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function get _lastNode ():INodeBinary {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodeInit (item:*):INodeBinary {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodeAppend (node:INodeBinary):void {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodePrepend (node:INodeBinary):void {
            throw new IllegalOperationError('Not implemented');
        }

        dz_collections function _nodeRemove (node:INodeBinary):Boolean {
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
