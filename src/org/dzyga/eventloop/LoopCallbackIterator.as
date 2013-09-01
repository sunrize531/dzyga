package org.dzyga.eventloop {
    import org.as3commons.collections.LinkedList;
    import org.as3commons.collections.framework.ICollection;
    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterator;
    import org.dzyga.utils.IStripIterator;

    internal class LoopCallbackIterator implements IStripIterator {
        private var callbackCollectionList:LinkedList = new LinkedList();
        private var callbackCollectionIterator:IIterator;
        private var callbackIterator:ICollectionIterator;

        public function setCallbackCollection (...args):void {
            callbackCollectionList.clear();
            for each (var i:ICollection in args) {
                callbackCollectionList.add(i);
            }
            callbackCollectionIterator = callbackCollectionList.iterator();
            callbackIterator = null;
        }

        private function nextCollectionIterator ():ICollectionIterator {
            return ICollection(callbackCollectionIterator.next()).iterator() as ICollectionIterator;
        }

        public function hasNext ():Boolean {
            // Some ugly repetitions here to avoid redundant calls.
            if (!callbackIterator) {
                while (callbackCollectionIterator.hasNext()) {
                    callbackIterator = nextCollectionIterator();
                    if (callbackIterator.hasNext()) {
                        return true;
                    }
                }
                return false;
            } else if (callbackIterator.hasNext()) {
                return true;
            } else {
                while (callbackCollectionIterator.hasNext()) {
                    callbackIterator = nextCollectionIterator();
                    if (callbackIterator.hasNext()) {
                        return true;
                    }
                }
                return false;
            }
        }

        public function next ():* {
            return callbackIterator.next();
        }

        public function remove ():Boolean {
            return callbackIterator.remove();
        }
    }
}
