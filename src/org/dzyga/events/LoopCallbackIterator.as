package org.dzyga.events {
    import org.as3commons.collections.LinkedList;
    import org.as3commons.collections.framework.ICollection;
    import org.as3commons.collections.framework.ICollectionIterator;
    import org.as3commons.collections.framework.IIterator;

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

            if (!callbackIterator || !callbackIterator.hasNext()) {
                if (callbackCollectionIterator.hasNext()) {
                    callbackIterator = ICollection(callbackCollectionIterator.next()).iterator() as ICollectionIterator;
                } else {
                    return false;
                }
            }
            return callbackIterator.hasNext();
        }

        public function next ():* {
            return callbackIterator.next();
        }

        public function remove ():Boolean {
            return callbackIterator.remove();
        }
    }
}
