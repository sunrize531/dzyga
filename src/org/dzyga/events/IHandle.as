package org.dzyga.events {
    public interface IHandle {
        function get callback ():Function;
        function get once ():Boolean;
        function get thisArg ():*;
        function get args ():Array;
        function get hash ():String;
        function call (... args):*;
        function get result ():*;
    }
}
