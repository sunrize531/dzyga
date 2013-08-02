package org.dzyga.events {
    import flash.events.IEventDispatcher;

    import org.as3commons.collections.framework.IMap;

    internal final class ListenerIterator implements IStripIterator {
        private var _iterator:IStripIterator;

        public function ListenerIterator (listenerMap:IMap, target:IEventDispatcher = null, event:String = '', callback:Function = null) {
            if (target && event) {
                var _targetHash:String = EventBridge.targetHashGenerate(target, event);
                if (callback != null) {
                    var _listenerHash:String = EventBridge.listenerHashGenerate(target, event, callback);
                    _iterator = new DistinctListenerIterator(listenerMap, _targetHash, _listenerHash);
                } else {
                    _iterator = new EventListenerIterator(listenerMap, _targetHash);
                }
            } else {
                _iterator = new EventListenerFilteredIterator(listenerMap, target, event, callback);
            }
        }

        public function hasNext ():Boolean {
            return _iterator.hasNext();
        }

        public function next ():* {
            return _iterator.next();
        }

        public function remove ():Boolean {
            return _iterator.remove();
        }
    }
}

import flash.events.IEventDispatcher;

import org.as3commons.collections.framework.ICollectionIterator;
import org.as3commons.collections.framework.IMap;
import org.as3commons.collections.iterators.CollectionFilterIterator;
import org.as3commons.collections.iterators.FilterIterator;
import org.dzyga.events.EventListener;
import org.dzyga.events.IStripIterator;
import org.dzyga.events.TargetListenerMap;

/**
 * Iterate through one (yeah) event with specified _listenerHash
 */
class DistinctListenerIterator implements IStripIterator {
    private var _targetHash:String;
    private var _listenerHash:String;
    private var _listenerMap:IMap;
    private var _targetListenerMap:TargetListenerMap;
    private var _next:EventListener;
    private var _current:EventListener;

    public function DistinctListenerIterator (listenerMap:IMap, targetHash:String, listenerHash:String) {
        _listenerMap = listenerMap;
        _targetHash = targetHash;
        _listenerHash = listenerHash;
    }

    public function hasNext ():Boolean {
        if (_current) {
            return false;
        }
        _targetListenerMap = _listenerMap.itemFor(_targetHash) as TargetListenerMap;
        if (_targetListenerMap == undefined) {
            return false;
        } else {
            _next = _targetListenerMap.itemFor(_listenerHash);
            return Boolean(_next);
        }
    }

    public function next ():* {
        if (_next || hasNext()) {
            _current = _next;
        } else {
            _current = undefined;
        }
        return _current;
    }

    public function remove ():Boolean {
        if (_next || hasNext()) {
            _targetListenerMap.removeKey(_listenerHash);
            _current = undefined;
            return true;
        }
        return false;
    }
}

/**
 * Iterate through all events for specified targetHash
 */
class EventListenerIterator implements IStripIterator {
    private var _listenerMap:IMap;
    private var _targetHash:String;
    private var _targetListenerIterator:ICollectionIterator;


    public function EventListenerIterator (listenerMap:IMap, targetHash:String) {
        _listenerMap = listenerMap;
        _targetHash = targetHash;
    }

    public function hasNext ():Boolean {
        if (!_targetListenerIterator) {
            var targetListenerMap:TargetListenerMap = _listenerMap.itemFor(_targetHash);
            if (!targetListenerMap) {
                return false;
            } else {
                _targetListenerIterator = targetListenerMap.iterator() as ICollectionIterator;
            }
        }
        return _targetListenerIterator.hasNext();
    }

    public function next ():* {
        if (_targetListenerIterator) {
            return _targetListenerIterator.next();
        }
        return undefined;
    }

    public function remove ():Boolean {
        if (_targetListenerIterator !== undefined) {
            return _targetListenerIterator.remove();
        }
        return false;
    }
}

/**
 * Filter matched event listeners
 */
class EventListenerFilteredIterator implements IStripIterator {
    private var _target:IEventDispatcher;
    private var _event:String;
    private var _callback:Function;
    private var _listenerMap:IMap;
    private var _targetIterator:FilterIterator;
    private var _targetListenerIterator:CollectionFilterIterator;

    public function EventListenerFilteredIterator (listenerMap:IMap, target:IEventDispatcher, event:String, callback:Function) {
        _target = target;
        _event = event;
        _callback = callback;
        _listenerMap = listenerMap;
    }

    public function hasNext ():Boolean {
        if (_targetListenerIterator) {
            // Just pass to current _targetListenerIterator.
            if (_targetListenerIterator.hasNext()) {
                return true;
            }
        }
        if (!_targetIterator) {
            // First call here...
            _targetIterator = new FilterIterator(_listenerMap, targetListenerFilter);
        }
        while (_targetIterator.hasNext()) {
            _targetListenerIterator = new CollectionFilterIterator(_targetIterator.next(), eventListenerFilter);
            if (_targetListenerIterator.hasNext()) {
                // We have matched events here...
                return true;
            }
        }
        return false;
    }

    public function next ():* {
        if (_targetListenerIterator || hasNext()) {
            return _targetListenerIterator.next();
        }
        return undefined;
    }

    public function remove ():Boolean {
        if (_targetListenerIterator) {
            return _targetListenerIterator.remove();
        }
        return false;
    }

    private function targetListenerFilter (targetListener:TargetListenerMap):Boolean {
        return (!_target || targetListener.target == _target) &&
            (!_event || targetListener.event == _event);
    }

    private function eventListenerFilter (eventListener:EventListener):Boolean {
        return _callback == null || eventListener.callback == _callback;
    }
}
