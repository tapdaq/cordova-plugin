(function(){
    'use strict';

    /**
     * Basic events bus, without implementation for now
     * @constructor
     */
    var EventsBus = function () {
        this.listeners = {};
    };

    EventsBus.prototype.on = function (type, callback, scope, context) {
        var args = [];
        scope = scope || this;
        context = context || this;
        
        if(typeof this.listeners[type] != "undefined") {
            this.listeners[type].push({scope:scope, context: context, callback:callback});
        } else {
            this.listeners[type] = [{scope:scope, context:context, callback:callback}];
        }
    };

    EventsBus.prototype.once = function (event, callback, scope) {
        var _this = this;
        scope = scope || _this;
        (function(event){
            var h = function(){
                _this.off(event, h, scope);
                callback.apply(this, arguments);
            };
            _this.on(event, h, scope);
        })(event);
    };

    EventsBus.prototype.hasListener = function(type, callback, scope){
        if(typeof this.listeners[type] != "undefined") {
            var numOfCallbacks = this.listeners[type].length;
            if(callback === undefined && scope === undefined){
                return numOfCallbacks > 0;
            }
            scope = scope || this;
            for(var i=0; i<numOfCallbacks; i++) {
                var listener = this.listeners[type][i];
                if((scope ? listener.scope == scope : true) && listener.callback == callback) {
                    return true;
                }
            }
        }
        return false;
    };

    EventsBus.prototype.off = function (type, callback, scope) {
        var _this = this;
        scope = scope || this;
        if(typeof this.listeners[type] != "undefined") {
            var hash = scope.getHash();
            var handlers = [];
            this.listeners[type].forEach(function(handler){
                if(handler.scope.getHash() === hash){
                    handlers.push(handler);
                }
            });
            var remove = [];
            var numOfCallbacks = handlers.length;
            if(typeof callback !== 'undefined'){
                for(var i=0; i<numOfCallbacks; i++) {
                    var listener = handlers[i];
                    if(listener.callback === callback) {
                        remove.push(listener);
                    }
                }
            }else{
                remove = [];
            }
            remove.forEach(function(handler){
                var index = _this.listeners[type].indexOf(handler);
                _this.listeners[type].splice(index, 1);
            });
        }
    };

    EventsBus.prototype.dispatchEvent = function (type, eventData) {
        var createHashFromEventData = function(data){
            if(data && data.adType !== undefined && data.tag !== undefined){
                return data.adType + "-" + data.tag;
            }else if(data && data.adType !== undefined && data.tag === undefined){
                return data.adType + "-";
            }else {
                return "";
            }
        };
        var event = {
            type: type,
            target:null,
            data: eventData
        };               
        if(typeof this.listeners[type] != "undefined") {
            var numOfCallbacks = this.listeners[type].length;
            for(var i = 0; i<numOfCallbacks; i++) {
                var listener = this.listeners[type][i];
                if(listener && listener.callback && createHashFromEventData(eventData) === listener.scope.getHash()) {                    
                    event.target = listener.scope;
                    var context = listener.context ? listener.context : listener.scope;                
                    listener.callback.call(context, event);
                }
            }
        }
    };

    if(!EventsBus.instance){
        var eventsBus = new EventsBus();
        EventsBus.instance = eventsBus;
    }

    module.exports = EventsBus.instance;
})();
