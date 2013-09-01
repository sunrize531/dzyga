package org.dzyga.eventloop {
    import flash.utils.getTimer;

    public function wait (time:Number):void {
        var ts:Number = getTimer();
        while (true) {
            if (getTimer() - ts > time) {
                break;
            }
        }
    }
}
