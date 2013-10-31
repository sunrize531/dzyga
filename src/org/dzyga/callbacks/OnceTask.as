package org.dzyga.callbacks {
    public class OnceTask extends Task {
        override protected function initPromiseFactory ():IPromiseTaskFactory {
            return new OnceTaskFactory();
        }
    }
}
