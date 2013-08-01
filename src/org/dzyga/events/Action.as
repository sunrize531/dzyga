package org.dzyga.events {
    import org.dzyga.pool.IReusable;

    public class Action implements IReusable {
        public var priority:int;
        public var action:*;
        public var thisObject:*;
        public var args:Array;
        public var name:String;
        public var instruct:IInstruct;

        public function Action (priority:int = 0, action:Function = null, thisObject:* = null, ...args) {
            this.priority = priority;
            this.action = action;
            this.thisObject = thisObject;
            this.args = args;
        }

        public function run ():* {
            if (instruct) {
                var finish:Boolean = instruct.execute();
                if (finish) {
                    instruct.finish();
                    if (this is Thread) {
                        EnterFrame.removeThread(this as Thread);
                    } else {
                        EnterFrame.removeAction(this);
                    }
                    instruct = null;
                }
                return finish;
            } else if (action) {
                return action.apply(thisObject, args);
            }
        }

        public function get reflection ():Class {
            return Action;
        }

        public function reset ():void {
            priority = 0;
            action = null;
            thisObject = null;
            args = null;
            instruct = null;
            name = null;
        }

        public function toString ():String {
            return "[Action: " + priority + "]";
        }
    }
}
