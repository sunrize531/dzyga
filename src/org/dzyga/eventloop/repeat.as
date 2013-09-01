package org.dzyga.eventloop {
    import org.dzyga.callbacks.ITask;

    public function repeat (callback:Function, priority:Number = 1,
                            thisArg:* = null, argsArray:Array = []):ITask {
        return new Repeater(callback, priority, thisArg, argsArray);
    }
}