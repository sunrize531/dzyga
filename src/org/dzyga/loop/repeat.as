package org.dzyga.loop {
    import org.dzyga.callback.ITask;

    public function repeat (callback:Function, priority:Number = 1,
                            thisArg:* = null, argsArray:Array = []):ITask {
        return new Repeater(callback, priority, thisArg, argsArray);
    }
}