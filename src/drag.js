angular.module('builder.drag', [])
    .provider('$drag', function () {
    var $injector, $rootScope, delay;
    $injector = null;
    $rootScope = null;
    this.data = {
        draggables: {},
        droppables: {}
    };
    this.config = {
        section: true,
        keyForPage: true,
        keyForSection: false,
        keyPage: 18,
        keySection: 17,
        dragAllow: true,
        dragAllowToDefault: true
    };
    this.getConfig = Object.assign({}, this.config);
    this.setConfig = (function (_this) {
        return function (config) {
            var keys;
            keys = {
                'ALT': 18,
                'CTRL': 17,
                'SHIFT': 16,
                'COMMAND': 91
            };
            if (config.section !== void 0) {
                if (config.section === false && _this.config.section !== false) {
                    _this.dragCheck.removeDragCheck(_this.defaultDragCheck.section);
                } else if (config.section === true && _this.config.section !== true) {
                    _this.dragCheck.addDragCheck(_this.defaultDragCheck.section);
                }
            }
            if (config.keyForPage !== void 0 && !parseInt(config.keyForPage)) {
                if (keys[config.keyForPage.toUpperCase()]) {
                    config.keyForPage = keys[config.keyForPage.toUpperCase()];
                }
            }
            if (config.keyForSection !== void 0 && !parseInt(config.keyForSection)) {
                if (keys[config.keyForPage.toUpperCase()]) {
                    config.keyForPage = keys[config.keyForPage.toUpperCase()];
                }
            }
            return _this.config = Object.assign(_this.config, config);
        };
    })(this);
    this.dragPermissions = [];
    this.dragCheck = {
        addDragCheck: (function (_this) {
            return function (callback) {
                return _this.dragPermissions.push(callback);
            };
        })(this),
        removeDragCheck: (function (_this) {
            return function (callbackToRemove) {
                var tempArray;
                tempArray = [];
                _this.dragPermissions.map(function (callback, index) {
                    if (callbackToRemove !== callback) {
                        return tempArray.push(callback);
                    }
                });
                return _this.dragPermissions = tempArray;
            };
        })(this),
        clearDragCheck: (function (_this) {
            return function () {
                return _this.dragPermissions = [];
            };
        })(this),
        setDragAllow: (function (_this) {
            return function (cond) {
                return _this.config.dragAllow = cond;
            };
        })(this),
        setDragAllowToDefault: (function (_this) {
            return function (cond) {
                return _this.dragConfig.setDragAllowToDefault = cond;
            };
        })(this)
    };
    this.checkDragPermission = (function (_this) {
        return function (element, event) {
            var check;
            if (!_this.config.dragAllow) {
                if (_this.config.dragAllowToDefault) {
                    _this.config.dragAllow = true;
                }
                false;
            }
            check = true;
            _this.dragPermissions.map(function (callback, index) {
                if (!callback(element, event, index)) {
                    return check = false;
                }
            });
            return check;
        };
    })(this);
    this.defaultDragCheck = {
        section: (function (_this) {
            return function (element, event, index) {
                console.log('test', $(element).find('.section-open').length);

                if ($(element).find('.section-open').length) {
                    return false;
                } else {
                    return true;
                }
            };
        })(this)
    };
    this.mouseMoved = false;
    this.isMouseMoved = (function (_this) {
        return function () {
            return _this.mouseMoved;
        };
    })(this);
    this.hooks = {
        down: {},
        move: {},
        up: {}
    };
    this.innerDropHover = false;
    this.eventMouseMove = function () {
    };
    this.eventMouseUp = function () {
    };
    $((function (_this) {
        return function () {
            $(document).on('mousedown', function (e) {
                var func, key, _ref;
                _this.mouseMoved = false;
                _ref = _this.hooks.down;
                for (key in _ref) {
                    func = _ref[key];
                    func(e);
                }
            });
            $(document).on('mousemove', function (e) {
                var func, key, _ref;
                _this.mouseMoved = true;
                _ref = _this.hooks.move;
                for (key in _ref) {
                    func = _ref[key];
                    func(e);
                }
            });
            return $(document).on('mouseup', function (e) {
                var func, key, _ref;
                _ref = _this.hooks.up;
                for (key in _ref) {
                    func = _ref[key];
                    func(e);
                }
            });
        };
    })(this));
    this.currentId = 0;
    this.getNewId = (function (_this) {
        return function () {
            return "" + (_this.currentId++);
        };
    })(this);
    this.setupEasing = function () {
        if (this.config.section === true) {
            this.dragCheck.addDragCheck(this.defaultDragCheck.section);
        }
        return jQuery.extend(jQuery.easing, {
            easeOutQuad: function (x, t, b, c, d) {
                return -c * (t /= d) * (t - 2) + b;
            }
        });
    };
    this.setupProviders = function (injector) {

        /*
         Setup providers.
         */
        $injector = injector;
        return $rootScope = $injector.get('$rootScope');
    };
    this.isHover = (function (_this) {
        return function ($elementA, $elementB) {

            /*
             Is element A hover on element B?
             @param $elementA: jQuery object
             @param $elementB: jQuery object
             */
            var isHover, offsetA, offsetB, sizeA, sizeB;
            offsetA = $elementA.offset();
            offsetB = $elementB.offset();
            sizeA = {
                width: $elementA.width(),
                height: $elementA.height()
            };
            sizeB = {
                width: $elementB.width(),
                height: $elementB.height()
            };
            isHover = {
                x: false,
                y: false
            };
            isHover.x = offsetA.left > offsetB.left && offsetA.left < offsetB.left + sizeB.width;
            isHover.x = isHover.x || offsetA.left + sizeA.width > offsetB.left && offsetA.left + sizeA.width < offsetB.left + sizeB.width;
            if (!isHover) {
                return false;
            }
            isHover.y = offsetA.top > offsetB.top && offsetA.top < offsetB.top + sizeB.height;
            isHover.y = isHover.y || offsetA.top + sizeA.height > offsetB.top && offsetA.top + sizeA.height < offsetB.top + sizeB.height;
            return isHover.x && isHover.y;
        };
    })(this);
    delay = function (ms, func) {
        return setTimeout(function () {
            return func();
        }, ms);
    };
    this.autoScroll = {
        up: false,
        down: false,
        scrolling: false,
        scroll: (function (_this) {
            return function () {
                _this.autoScroll.scrolling = true;
                if (_this.autoScroll.up) {
                    $('html, body').dequeue().animate({
                        scrollTop: $(window).scrollTop() - 50
                    }, 100, 'easeOutQuad');
                    return delay(100, function () {
                        return _this.autoScroll.scroll();
                    });
                } else if (_this.autoScroll.down) {
                    $('html, body').dequeue().animate({
                        scrollTop: $(window).scrollTop() + 50
                    }, 100, 'easeOutQuad');
                    return delay(100, function () {
                        return _this.autoScroll.scroll();
                    });
                } else {
                    return _this.autoScroll.scrolling = false;
                }
            };
        })(this),
        start: (function (_this) {
            return function (e) {
                if (e.clientY < 50) {
                    _this.autoScroll.up = true;
                    _this.autoScroll.down = false;
                    if (!_this.autoScroll.scrolling) {
                        return _this.autoScroll.scroll();
                    }
                } else if (e.clientY > $(window).innerHeight() - 50) {
                    _this.autoScroll.up = false;
                    _this.autoScroll.down = true;
                    if (!_this.autoScroll.scrolling) {
                        return _this.autoScroll.scroll();
                    }
                } else {
                    _this.autoScroll.up = false;
                    return _this.autoScroll.down = false;
                }
            };
        })(this),
        stop: (function (_this) {
            return function () {
                _this.autoScroll.up = false;
                return _this.autoScroll.down = false;
            };
        })(this)
    };
    this.dragMirrorMode = (function (_this) {
        return function ($element, defer, object) {
            var result;
            if (defer == null) {
                defer = true;
            }
            result = {
                id: _this.getNewId(),
                mode: 'mirror',
                maternal: $element[0],
                element: null,
                object: object
            };
            $element.on('mousedown', function (e) {
                var $clone;
                e.preventDefault();
                if (!_this.checkDragPermission($element, e)) {
                    return;
                }
                $clone = $element.clone();
                result.element = $clone[0];
                $clone.addClass("fb-draggable form-horizontal prepare-dragging");
                _this.hooks.move.drag = function (e, defer) {
                    var droppable, id, _ref, _results;
                    if ($clone.hasClass('prepare-dragging')) {
                        $clone.css({
                            width: $element.width(),
                            height: $element.height()
                        });
                        $clone.removeClass('prepare-dragging');
                        $clone.addClass('dragging');
                        if (defer) {
                            return;
                        }
                    }
                    $clone.offset({
                        left: e.pageX - $clone.width() / 2,
                        top: e.pageY - $clone.height() / 2
                    });
                    _this.autoScroll.start(e);
                    _ref = _this.data.droppables;
                    _results = [];
                    for (id in _ref) {
                        droppable = _ref[id];
                        if (_this.isHover($clone, $(droppable.element))) {
                            _results.push(droppable.move(e, result));
                        } else {
                            _results.push(droppable.out(e, result));
                        }
                    }
                    return _results;
                };
                _this.hooks.up.drag = function (e) {
                    var droppable, id, isHover, _ref;
                    _ref = _this.data.droppables;
                    for (id in _ref) {
                        droppable = _ref[id];
                        isHover = _this.isHover($clone, $(droppable.element));
                        droppable.up(e, isHover, result);
                    }
                    delete _this.hooks.move.drag;
                    delete _this.hooks.up.drag;
                    result.element = null;
                    $clone.remove();
                    return _this.autoScroll.stop();
                };
                $('body').append($clone);
                if (!defer) {
                    return _this.hooks.move.drag(e, defer);
                }
            });
            return result;
        };
    })(this);
    this.dragDragMode = (function (_this) {
        return function ($element, defer, object) {
            var result;
            if (defer == null) {
                defer = true;
            }
            result = {
                id: _this.getNewId(),
                mode: 'drag',
                maternal: null,
                element: $element[0],
                object: object
            };
            $element.addClass('fb-draggable');
            $element.on('mousedown', function (e) {
                e.preventDefault();
                if (!_this.checkDragPermission($element, e)) {
                    return;
                }
                if ($element.hasClass('dragging')) {
                    return;
                }
                $element.addClass('prepare-dragging');
                _this.hooks.move.drag = function (e, defer) {
                    var droppable, id, _ref;
                    if ($element.hasClass('prepare-dragging')) {
                        $element.css({
                            width: $element.width(),
                            height: $element.height()
                        });
                        $element.removeClass('prepare-dragging');
                        $element.addClass('dragging');
                        if (defer) {
                            return;
                        }
                    }
                    $element.offset({
                        left: e.pageX - $element.width() / 2,
                        top: e.pageY - $element.height() / 2
                    });
                    _this.autoScroll.start(e);
                    _ref = _this.data.droppables;
                    for (id in _ref) {
                        droppable = _ref[id];
                        if (_this.isHover($element, $(droppable.element))) {
                            droppable.move(e, result);
                        } else {
                            droppable.out(e, result);
                        }
                    }
                };
                _this.hooks.up.drag = function (e) {
                    var droppable, id, isHover, _ref;
                    _ref = _this.data.droppables;
                    for (id in _ref) {
                        droppable = _ref[id];
                        isHover = _this.isHover($element, $(droppable.element));
                        droppable.up(e, isHover, result);
                    }
                    delete _this.hooks.move.drag;
                    delete _this.hooks.up.drag;
                    $element.css({
                        width: '',
                        height: '',
                        left: '',
                        top: ''
                    });
                    $element.removeClass('dragging defer-dragging');
                    return _this.autoScroll.stop();
                };
                if (!defer) {
                    return _this.hooks.move.drag(e, defer);
                }
            });
            return result;
        };
    })(this);
    this.dropMode = (function (_this) {
        return function ($element, options) {
            var result;
            result = {
                id: _this.getNewId(),
                element: $element[0],
                move: function (e, draggable) {
                    return $rootScope.$apply(function () {
                        return typeof options.move === "function" ? options.move(e, draggable) : void 0;
                    });
                },
                up: function (e, isHover, draggable) {
                    return $rootScope.$apply(function () {
                        return typeof options.up === "function" ? options.up(e, isHover, draggable) : void 0;
                    });
                },
                out: function (e, draggable) {
                    return $rootScope.$apply(function () {
                        return typeof options.out === "function" ? options.out(e, draggable) : void 0;
                    });
                }
            };
            return result;
        };
    })(this);
    this.draggable = (function (_this) {
        return function ($element, options) {
            var draggable, element, result, _i, _j, _len, _len1;
            if (options == null) {
                options = {};
            }

            /*
             Make the element able to drag.
             @param element: The jQuery element.
             @param options: Options
             mode: 'drag' [default], 'mirror'
             defer: yes/no. defer dragging
             object: custom information
             allow: yes/no - allow dragging at the current time
             */
            result = [];
            if (options.mode === 'mirror') {
                for (_i = 0, _len = $element.length; _i < _len; _i++) {
                    element = $element[_i];
                    draggable = _this.dragMirrorMode($(element), options.defer, options.object);
                    result.push(draggable.id);
                    _this.data.draggables[draggable.id] = draggable;
                }
            } else {
                for (_j = 0, _len1 = $element.length; _j < _len1; _j++) {
                    element = $element[_j];
                    draggable = _this.dragDragMode($(element), options.defer, options.object);
                    result.push(draggable.id);
                    _this.data.draggables[draggable.id] = draggable;
                }
            }
            return result;
        };
    })(this);
    this.droppable = (function (_this) {
        return function ($element, options) {
            var droppable, element, result, _i, _len;
            if (options == null) {
                options = {};
            }

            /*
             Make the element coulde be drop.
             @param $element: The jQuery element.
             @param options: The droppable options.
             move: The custom mouse move callback. (e, draggable)->
             up: The custom mouse up callback. (e, isHover, draggable)->
             out: The custom mouse out callback. (e, draggable)->
             */
            result = [];
            for (_i = 0, _len = $element.length; _i < _len; _i++) {
                element = $element[_i];
                droppable = _this.dropMode($(element), options);
                result.push(droppable);
                _this.data.droppables[droppable.id] = droppable;
            }
            return result;
        };
    })(this);
    this.get = function ($injector) {
        this.setupEasing();
        this.setupProviders($injector);
        return {
            isMouseMoved: this.isMouseMoved,
            data: this.data,
            draggable: this.draggable,
            droppable: this.droppable,
            innerDropHover: this.innerDropHover,
            config: this.config,
            getConfig: this.getConfig,
            setConfig: this.setConfig,
            dragCheck: this.dragCheck
        };
    };
    this.get.$inject = ['$injector'];
    this.$get = this.get;
});