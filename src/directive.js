angular.module
('builder.directive', [
    'builder.provider',
    'builder.controller',
    'builder.drag',
    'validator'
])
    .directive('fbBuilder', [
        '$injector', function ($injector) {
            var $builder, $drag;
            $builder = $injector.get('$builder');
            $drag = $injector.get('$drag');
            return {
                restrict: 'A',
                scope: {
                    fbBuilder: '=',
                    fbObject: '='
                },
                template: "<div class='form-horizontal' fb-page={{currentPage}}>\n	" +
                "<div fb-select-checkbox class='fb-select-checkbox'\n fb-select-level='0' ng-init='checked=true'>\n		" +
                "<input type='checkbox' id='fb_select_{{fbSelectLevel}}_{{currentPage}}'\n class=\"fb-select-input\" fb-select-index='currentPage'\n ng-checked='checked' />\n " +
                "<label class='fb-select-checkbox-label'\n for='fb_select_{{fbSelectLevel}}_{{currentPage}}'>" +
                "</label>\n	" +
                "</div>\n	" +
                "<div class='fb-form-object-editable '\n ng-repeat=\"object in formObjects\"\n fb-form-object-editable=\"object\"\n fb-component-name='object.component'\n fb-indexIn='indexIn'\n current-page='currentPage'\n parent-section='false'\n >" +
                "</div>\n" +
                "</div>",
                controller: 'PaginationController',
                link: function (scope, element, attrs) {
                    var KeyDown, KeyUp, allowKey, beginMove, keyHold, _base, _name;
                    scope.formNumber = attrs.fbPage || $builder.currentForm;
                    if ((_base = $builder.forms)[_name = scope.formNumber] == null) {
                        _base[_name] = [];
                    }
                    scope.formObjects = $builder.forms[scope.formNumber];
                    //TODO: CURRENT form

                    beginMove = true;
                    scope.currentPage = 0;
                    scope.component = 'page';
                    scope.$watchGroup([
                        function () {
                            return $builder.forms[$builder.currentForm];
                        }, function () {
                            return $builder.forms.length;
                        }
                    ], function (current, prev) {
                        scope.formNumber = $builder.currentForm;
                        scope.currentPage = $builder.currentForm;

                        //TODO: SET CURRENT form when new page added or page changed
                        return scope.formObjects = $builder.forms[scope.formNumber];
                    });

                    $(element).addClass('fb-builder');
                    allowKey = 'Alt';
                    keyHold = '';
                    KeyDown = (function (_this) {
                        return function (e) {
                            var KeyID, keyName;
                            KeyID = window.event ? event.keyCode : e.keyCode;
                            switch (KeyID) {
                                case 18:
                                    keyName = "Alt";
                                    break;
                                case 17:
                                    keyName = "Ctrl";
                            }
                            return keyHold = keyName;
                        };
                    })(this);
                    KeyUp = (function (_this) {
                        return function (e) {
                            var KeyID, keyName;
                            KeyID = window.event ? event.keyCode : e.keyCode;
                            switch (KeyID) {
                                case 18:
                                    keyName = "Alt";
                                    break;
                                case 17:
                                    keyName = "Ctrl";
                            }
                            if (keyHold === keyName) {
                                return keyHold = "";
                            }
                        };
                    })(this);
                    document.onkeydown = KeyDown;
                    document.onkeyup = KeyUp;
                    return $drag.droppable($(element), {  //TODO: DRAGGABLE ACTIONS form form (left side)
                        move: function (e) {
                            var $empty, $formObject, $formObjects, height, index, offset, positions, _i, _j, _ref, _ref1;
                            if (beginMove) {
                                $("div.fb-form-object-editable").popover('hide');
                                beginMove = false;
                            }
                            if (keyHold !== allowKey) {
                                return;
                            }
                            $formObjects = $(element).find('.fb-form-object-editable:not(.empty,.dragging)');
                            if ($formObjects.length === 0) {
                                if ($(element).find('.fb-form-object-editable.empty').length === 0) {
                                    console.log(111111);

                                    $(element).find('>div:first').append($("<div class='fb-form-object-editable empty'></div>"));
                                }
                                return;
                            }
                            positions = [];
                            positions.push(-1000);
                            for (index = _i = 0, _ref = $formObjects.length; _i < _ref; index = _i += 1) {
                                $formObject = $($formObjects[index]);
                                offset = $formObject.offset();
                                height = $formObject.height();
                                positions.push(offset.top + height / 2);
                            }
                            positions.push(positions[positions.length - 1] + 1000);
                            for (index = _j = 1, _ref1 = positions.length; _j < _ref1; index = _j += 1) {
                                if (e.pageY > positions[index - 1] && e.pageY <= positions[index]) {
                                    $(element).find('.empty').remove();
                                    $empty = $("<div class='fb-form-object-editable empty'></div>");
                                    if (index - 1 < $formObjects.length) {
                                        $empty.insertBefore($($formObjects[index - 1]));
                                    } else {
                                        $empty.insertAfter($($formObjects[index - 2]));
                                    }
                                    break;
                                }
                            }
                        },
                        out: function () {
                            if (beginMove) {
                                $("div.fb-form-object-editable").popover('hide');
                                beginMove = false;
                            }
                            return $(element).find('.empty').remove();
                        },
                        up: function (e, isHover, draggable) {
                            var formObject, newIndex, oldIndex;
                            beginMove = true;
                            if (keyHold !== allowKey) {
                                return;
                            }
                            if (!$drag.isMouseMoved()) {
                                $(element).find('.empty').remove();
                                return;
                            }
                            if (!isHover && draggable.mode === 'drag') {
                                formObject = draggable.object.formObject;
                                if (formObject.editable) {
                                    $builder.removeFormObject(attrs.fbBuilder, formObject.index);
                                }
                            } else if (isHover) {
                                if (draggable.mode === 'mirror') {
                                    console.log('insertFormObject');

                                    $builder.insertFormObject(scope.formNumber, $(element).find('.empty').index('.fb-form-object-editable'), {
                                        component: draggable.object.componentName
                                    });
                                }
                                if (draggable.mode === 'drag') {
                                    oldIndex = draggable.object.formObject.index;
                                    newIndex = $(element).find('.empty').index('.fb-form-object-editable');
                                    if (oldIndex < newIndex) {
                                        newIndex--;
                                    }
                                    $builder.updateFormObjectIndex(scope.formNumber, oldIndex, newIndex);
                                }
                            }
                            return $(element).find('.empty').remove();
                        }
                    });
                }
            };
        }
    ])


    .directive('fbFormObjectEditable', [
        '$injector', function ($injector) {
            var $builder, $compile, $drag, $validator;
            $builder = $injector.get('$builder');
            $drag = $injector.get('$drag');
            $compile = $injector.get('$compile');
            $validator = $injector.get('$validator');
            return {
                restrict: 'A',
                controller: 'fbFormObjectEditableController',
                scope: {
                    isOpen: '=?isOpen',
                    formObject: '=fbFormObjectEditable',
                    sectionIndex: '=sectionIndex',
                    componentName: '=fbComponentName',
                    currentPage: '='
                },
                link: function (scope, element, attrs) {
                    var popover;
                    scope.isOpen = false;
                    scope.inputArray = [];
                    scope.formNumber = scope.$parent.formNumber;
                    scope.componentIndex = scope.$parent.$index;
                    scope.simpleView = $builder.simplePreview;
                    scope.$component = $builder.components[scope.formObject.component];

                    //TODO: use setupScope(copyObjectToScope) from fbFormObjectEditableController controller
                    scope.setupScope(scope.formObject);

                    //TODO: set new data to form components
                    scope.$watch('$component.template', function (template) {
                        var view;
                        if (!template) {
                            return;
                        }
                        view = $compile(template)(scope);
                        $(element).html(view);

                        return;
                    });
                    scope.$watch('$parent.$index', function () {
                        return scope.componentIndex = scope.$parent.$index;
                    });
                    scope.$watch(function () {
                        return $builder.simplePreview;
                    }, function () {
                        return scope.simpleView = $builder.simplePreview;
                    });
                    $(element).on('click', function () {
                        //TODO: select form element
                        var firstIndex, secondIndex;

                        if (scope.component !== 'section') {
                            if (scope.sectionIndex !== void 0) {
                                firstIndex = 1;
                                secondIndex = scope.sectionIndex;
                            } else {
                                firstIndex = 0;
                            }
                        } else {
                            firstIndex = 1;
                            secondIndex = scope.componentIndex;
                        }
                        $builder.selectFrame(firstIndex, secondIndex);
                        $(".fb-selected-frame").removeClass("fb-selected-frame");
                        return $(element).addClass("fb-selected-frame");
                    });

                    /*$(element).on 'click', (e) ->
                     e.preventDefault()
                     if scope.component != 'section'
                     if scope.sectionIndex != undefined
                     firstIndex = 1
                     secondIndex = scope.sectionIndex
                     else
                     firstIndex = 0
                     else
                     firstIndex = 1
                     secondIndex = scope.componentIndex
                     *			scope.selected = true
                     $builder.selectFrame firstIndex, secondIndex
                     console.log('CLICK', firstIndex, secondIndex, $builder.selectedPath, $builder.selectFrame())
                     false
                     */
                    $drag.draggable($(element), {
                        object: {
                            formObject: scope.formObject
                        }
                    });
                    popover = {};

                    //TODO: Setup control panels for every form element

                    scope.$watch('$component.popoverTemplate', function (template) { //TODO: !!!! $component.popoverTemplate - темплейт для сайд панелі
                        if (!template) {
                            return;
                        }
                        $(element).removeClass(popover.id);
                        popover = {
                            id: "fb-" + (Math.random().toString().substr(2)),
                            isClickedSave: false,
                            view: null,
                            html: template
                        };
                        popover.html = $(popover.html).addClass(popover.id);
                        popover.view = $compile(popover.html)(scope);

                        $(element).addClass(popover.id);
                        if ($builder.config.propertiesPlacement === 'sidebar') {
                            $("#fb-property-popover").append($(popover.view).hide().addClass('fb-property-popover-form'));
                            return $(element).on('click', function () {
                                $("#fb-property-popover").show().find('.fb-property-popover-form').hide().end().find('.' + popover.id).show();
                                return scope.$apply(function () {
                                    return scope.popover.shown();
                                });
                            });
                        } else {
                            return $(element).popover({
                                html: true,
                                title: scope.$component.label,
                                content: popover.view,
                                container: '#fb-property-popover',
                                placement: $builder.config.popoverPlacement
                            });
                        }
                    });

                    //TODO: popover(controls) components actions

                    scope.popover = {
                        save: function ($event) {
                            /*
                             The save event of the popover.
                             */
                            $event.preventDefault();
                            $validator.validate(scope).success(function () {
                                popover.isClickedSave = true;
                                if ($builder.config.propertiesPlacement === 'sidebar') {
                                    return $(".fb-property-popover-form." + popover.id).hide();
                                } else {
                                    return $(element).popover('hide');
                                }
                            });
                        },
                        remove: function ($event) {
                            /*
                             The delete event of the popover.
                             */
                            $event.preventDefault();
                            if (scope.$parent.fbSection === 'section') {
                                $builder.removeSectionObject(scope.$parent.formNumber, scope.componentIndex, scope.$parent.$index);
                            } else {
                                $builder.removeFormObject(scope.$parent.formNumber, scope.componentIndex);
                            }
                            if ($builder.config.propertiesPlacement === 'sidebar') {
                                $(".fb-property-popover-form." + popover.id).remove();
                            } else {
                                $(element).popover('hide');
                            }
                        },
                        shown: function () {
                            /*
                             The shown event of the popover.
                             */
                            scope.data.backup();
                            return popover.isClickedSave = false;
                        },
                        cancel: function ($event) {
                            /*
                             The cancel event of the popover.
                             */
                            scope.data.rollback();
                            if ($event) {
                                $event.preventDefault();
                                if ($builder.config.propertiesPlacement === 'sidebar') {
                                    $(".fb-property-popover-form." + popover.id).hide();
                                } else {
                                    $(element).popover('hide');
                                }
                            }
                        }
                    };
                    $(element).on('show.bs.popover', function (e) {
                        var $popover, elementOrigin, popoverTop;
                        e.stopPropagation();
                        if ($drag.isMouseMoved()) {
                            return false;
                        }
                        $("div.fb-form-object-editable:not(." + popover.id + ")").popover('hide');
                        $popover = $("form." + popover.id).closest('.popover');
                        if ($popover.length > 0) {
                            elementOrigin = $(element).offset().top + $(element).height() / 2;
                            popoverTop = elementOrigin - $popover.height() / 2;
                            $popover.css({
                                position: 'absolute',
                                top: popoverTop
                            });
                            $popover.show();
                            setTimeout(function () {
                                $popover.addClass('in');
                                return $(element).triggerHandler('shown.bs.popover');
                            }, 0);
                            return false;
                        }
                    });
                    $(element).on('shown.bs.popover', function () {
                        $(".popover ." + popover.id + " input:first").select();
                        scope.$apply(function () {
                            return scope.popover.shown();
                        });
                    });
                    return $(element).on('hide.bs.popover', function () {
                        var $popover;
                        $popover = $("form." + popover.id).closest('.popover');
                        if (!popover.isClickedSave) {
                            if (scope.$$phase || scope.$root.$$phase) {
                                scope.popover.cancel();
                            } else {
                                scope.$apply(function () {
                                    return scope.popover.cancel();
                                });
                            }
                        }
                        $popover.removeClass('in');
                        setTimeout(function () {
                            return $popover.hide();
                        }, 300);
                        return false;
                    });
                }
            };
        }
    ])

    //TODO: wrapper component for Default/images/special tabs
    .directive('fbComponents', [
        '$injector', function ($injector) {
            var $builder;
            $builder = $injector.get('$builder');

            return {
                restrict: 'A',
                template: "<ul ng-if=\"groups.length > 1\" class=\"nav nav-tabs nav-justified\">\n	<li ng-repeat=\"group in groups\" ng-class=\"{active:activeGroup==group}\">\n		<a href='#' ng-click=\"selectGroup($event, group)\">{{group}}</a>\n	</li>\n</ul>\n<div class='form-horizontal col-sm-12 elementList'>\n	<div ng-repeat=\"component in components\">\n		<div class=\"form-group element-wrapper\">\n			<div class=\"col-sm-1\">\n				<button type='button' class='btn btn-success btn-sm'\n						ng-click='addComponentToEnd($event, component)'>+</button>\n			</div>\n			<div class=\"col-sm-11\">\n				<div class='fb-component' fb-component=\"component\" ng-component=\"{{component.name}}\" ng-if='!_$builder.simplePreview'></div>\n				<!--div class=\"col-sm-12 fb-component\" ng-if='$builder.simplePreview'>\n					<div class=\"panel panel-default\">\n						<div class=\"panel-body text-center\">\n							{{component.name}}\n						</div>\n					</div>\n				</div-->\n			</div>\n	</div>\n</div>",
                controller: 'fbComponentsController',
                scope: false,
                link: function (scope) {
                }
            }
        }
    ])

    //TODO: Populate Default/images/special by it's components
    .directive('fbComponent', [
        '$injector', function ($injector) {
            var $builder, $compile, $drag;
            $builder = $injector.get('$builder');
            $drag = $injector.get('$drag');
            $compile = $injector.get('$compile');
            return {
                restrict: 'A',
                scope: {
                    component: '=fbComponent'
                },
                controller: 'fbComponentController',
                link: function (scope, element) {
                    scope.simpleView = $builder.simpleComponentView;
                    scope.copyObjectToScope(scope.component, scope.simpleView);
                    $drag.draggable($(element), {
                        mode: 'mirror',
                        defer: false,
                        object: {
                            componentName: scope.component.name
                        }
                    });

                    //TODO: Populate Default/images/special by it's components
                    scope.$watch('component.template', function (template) {
                        var view;
                        if (!template) {
                            return;
                        }
                        view = $compile(template)(scope);
                        return $(element).html(view);
                    });
                    return scope.$watch(function () {
                        return $builder.simpleComponentView;
                    }, function () {
                        scope.simpleView = $builder.simpleComponentView;
                        return;
                    });
                }
            };
        }
    ])


    .directive('fbForm', [
        '$injector', function ($injector) {
            return {
                restrict: 'A',
                require: 'ngModel',
                scope: {
                    formNumber: '@fbForm',
                    input: '=ngModel',
                    "default": '=fbDefault'
                },
                template: "<div class='fb-form-object' ng-repeat=\"object in form\" fb-form-object=\"object\"></div>",
                controller: 'fbFormController',
                link: function (scope, element, attrs) {
                    var $builder, _base, _name;
                    $builder = $injector.get('$builder');

                    // TODO: when user select form (left side)
                    scope.$watch(function () {
                        return $builder.currentForm;  // TODO: currentForm - id of form in an array
                    }, function (current, prev) {
                        var _base, _name;
                        scope.formNumber = current;
                        if ((_base = $builder.forms)[_name = scope.formNumber] == null) {
                            _base[_name] = [];
                        }
                        scope.form = $builder.forms[scope.formNumber];
                        scope.jsonString = $builder.forms;

                        return;
                    });
                    if ((_base = $builder.forms)[_name = scope.formNumber] == null) {
                        _base[_name] = [];
                    }
                    scope.form = $builder.forms[scope.formNumber];
                    return scope.jsonString = $builder.forms;
                }
            };
        }
    ])

    // TODO: triggered every time we change page and this page have any section
    .directive('fbFormObject', [
        '$injector', function ($injector) {
            var $builder, $compile, $parse;
            $builder = $injector.get('$builder');
            $compile = $injector.get('$compile');
            $parse = $injector.get('$parse');
            return {
                restrict: 'A',
                controller: 'fbFormObjectController',
                link: function (scope, element, attrs) {
                    scope.formObject = $parse(attrs.fbFormObject)(scope);
                    scope.$component = $builder.components[scope.formObject.component];

                    scope.$on($builder.broadcastChannel.updateInput, function () {
                        return scope.updateInput(scope.inputText);
                    });
                    if (scope.$component.arrayToText) {
                        scope.inputArray = [];
                        scope.$watch('inputArray', function (newValue, oldValue) {
                            //console.log('inputArray', scope.inputArray);

                            var checked, index, _ref;
                            if (newValue === oldValue) {
                                return;
                            }
                            checked = [];
                            for (index in scope.inputArray) {
                                if (scope.inputArray[index]) {
                                    checked.push((_ref = scope.options[index]) != null ? _ref : scope.inputArray[index]);
                                }
                            }
                            return scope.inputText = checked.join(', ');
                        }, true);
                    }
                    scope.$watch('inputText', function () {
                        return scope.updateInput(scope.inputText);
                    });
                    scope.$watch(attrs.fbFormObject, function () {    // TODO 237 str. -  update inputed field

                        return scope.copyObjectToScope(scope.formObject);
                    }, true);
                    scope.$watch('$component.template', function (template) {
                        var $input, $template, view;
                        if (!template) {
                            return;
                        }
                        $template = $(template);
                        $input = $template.find("[ng-model='inputText']");
                        $input.attr({
                            validator: '{{validation}}'
                        });
                        view = $compile($template)(scope);

                        return $(element).html(view);
                    });
                    if (!scope.$component.arrayToText && scope.formObject.options.length > 0) {
                        scope.inputText = scope.formObject.options[0];
                    }
                    return scope.$watch("default['" + scope.formObject.id + "']", function (value) {
                        if (!value) {
                            return;
                        }
                        if (scope.$component.arrayToText) {
                            return scope.inputArray = value;
                        } else {
                            return scope.inputText = value;
                        }
                    });
                }
            };
        }
    ])


    .directive('fbPages', [
        '$injector', function ($injector) {
            var $builder;
            $builder = $injector.get('$builder');
            return {
                restrict: 'A',
                template: "<div class=\"fb-builderPagination\">\n	" +
                "<div class=\"pull-left\">\n		" +
                "<button type=\"button\" class=\"btn btn-primary btn-small _pull-right\"\n ng-class=\"{disabled: !currentPage}\" ng-click=\"goB()\"><" +
                "</button>\n		" +
                "<button type=\"button\" class=\"btn btn-primary btn-small _pull-right\"\n ng-class=\"{disabled: !next}\" ng-click=\"goF()\">>" +
                "</button>\n		" +
                "<div class=\"btn-group\">\n			" +
                "<button type=\"button\" class=\"btn btn-primary dropdown-toggle\" data-toggle=\"dropdown\"\n					aria-expanded=\"false\" aria-haspopup=\"true\">Page\n				<span class=\"caret\"></span>\n				<span class=\"sr-only\">Toggle Dropdown</span>\n			</button>\n			<ul class=\"dropdown-menu\" >\n				<li ng-repeat=\"(key, value) in pages\"><a ng-click=\"goPage(+key)\">{{+key+1}}</a></li>\n			</ul>\n		</div>\n	</div>\n	<span class=\"panel-title\" >\n		Page <b>\#<span ng-model=\"page\">{{currentPage+1}}</span></b> / {{pageCount}}\n	</span>\n\n	<div class=\"pull-right\">\n		<button type=\"button\" class=\"btn btn-danger btn-small _pull-right \"\n				ng-class=\"{disabled: pageCount == 1}\" ng-click=\"deletePage(currentPage)\">-</button>\n		<!-- Split button -->\n		<div class=\"btn-group\">\n			<button type=\"button\" class=\"btn btn-success\" ng-click=\"addPage(pageCount)\">Add</button>\n			<button type=\"button\" class=\"btn btn-success dropdown-toggle\" data-toggle=\"dropdown\"\n					aria-haspopup=\"true\" aria-expanded=\"false\">\n				<span class=\"caret\"></span>\n				<span class=\"sr-only\">Toggle Dropdown</span>\n			</button>\n			<ul class=\"dropdown-menu\">\n				<li><a href=\"\" ng-click=\"addPage(pageCount)\">Page</a></li>\n				<li role=\"separator\" class=\"divider\"></li>\n				<li><a href=\"\">Section</a></li>\n				<li><a href=\"\">Component</a></li>\n			</ul>\n		</div>\n	</div>\n\n	<div class=\"clearfix\"></div>\n</div>",
                controller: 'PaginationController',
                link: function (scope, element, attrs) {
                    return scope.$watch(function () {      //TODO: recount pages when new pade was added
                        return $builder.forms.length;
                    }, function () {
                        scope.pageCount = $builder.forms.length;
                        scope.pages = $builder.forms;

                        return scope.currentPage = $builder.currentForm;
                    });
                }
            };
        }
    ])

    //TODO: move components actions (right side)
    .directive('fbSection', [
        '$injector', '$compile', function ($injector, $compile) {
            var $builder, $drag;
            $builder = $injector.get('$builder');
            $drag = $injector.get('$drag');
            return {
                restrict: 'A',
                scope: {
                    fbSection: '=',
                    sectionIndex: '=componentIndex',
                    currentPage: '=',
                    formNumber: '='
                },
                template: "<div class='form-horizontal' >\n	" +
                    "<div style=\"min-height: 100px;\"\n " +
                        "class='fb-form-object-editable parent-section'\n " +
                        "ng-repeat=\"object in sectionObjects\"\n " +
                        "fb-form-object-editable=\"object\"\n " +
                        "fb-draggable='allow'\n " +
                        "section-index='sectionIndex'\n " +
                        "parent-section='true'\n " +
                        "ng-class='{\"fb-selected-frame\": selected}'\n	>\n " +
                    "</div>\n" +
                "</div>",
                link: function (scope, element, attrs) {
                    if (scope.fbSection !== 'section') {
                        return;
                    }
                    $(element).addClass('fb-section');
                    scope.sectionObjects = $builder.getSectionObjects(scope.sectionIndex, scope.formNumber);
                    return $drag.droppable($(element), {
                        move: function (e) {
                            var $empty, $formObject, $formObjects, beginMove, height, index, offset, positions, _i, _j, _ref, _ref1;
                            if (beginMove) {
                                $("div.fb-form-object-editable").popover('hide');
                                beginMove = false;
                            }
                            $formObjects = $(element).find('.parent-section.fb-form-object-editable:not(.empty,.dragging)');

                            if ($formObjects.length === 0) {
                                if ($(element).find('.parent-section.fb-form-object-editable.empty').length === 0) {
                                    $(element).find('>div:first').append($("<div class='parent-section fb-form-object-editable empty'></div>"));
                                }
                                return;
                            }
                            positions = [];
                            positions.push(-1000);
                            for (index = _i = 0, _ref = $formObjects.length; _i < _ref; index = _i += 1) {
                                $formObject = $($formObjects[index]);
                                offset = $formObject.offset();
                                height = $formObject.height();
                                positions.push(offset.top + height / 2);
                            }
                            positions.push(positions[positions.length - 1] + 1000);
                            for (index = _j = 1, _ref1 = positions.length; _j < _ref1; index = _j += 1) {
                                if (e.pageY > positions[index - 1] && e.pageY <= positions[index]) {
                                    $(element).find('.empty').remove();
                                    $empty = $("<div class='parent-section fb-form-object-editable empty'></div>");
                                    if (index - 1 < $formObjects.length) {
                                        $empty.insertBefore($($formObjects[index - 1]));
                                    } else {
                                        $empty.insertAfter($($formObjects[index - 2]));
                                    }
                                    break;
                                }
                            }
                        },
                        out: function () {
                            var beginMove;
                            if (beginMove) {
                                $("div.fb-form-object-editable").popover('hide');
                                beginMove = false;
                            }
                            return $(element).find('.empty').remove();
                        },
                        up: function (e, isHover, draggable) {
                            var beginMove, elementIndex, formObject, newIndex, oldIndex;
                            beginMove = true;
                            if (!$drag.isMouseMoved()) {
                                $(element).find('.empty').remove();
                                return;
                            }

                            console.log('up', draggable.mode, isHover);

                            if (!isHover && draggable.mode === 'drag') {
                                formObject = draggable.object.formObject;
                            } else if (isHover) {
                                if (draggable.mode === 'mirror') {
                                    elementIndex = $(element).find('.empty').index();
                                    $builder.insertSectionObject($builder.currentForm, scope.sectionIndex, elementIndex, {
                                        component: draggable.object.componentName
                                    });
                                    scope.sectionObjects = $builder.getSectionObjects(scope.sectionIndex, scope.formNumber);
                                }
                                if (draggable.mode === 'drag') {
                                    oldIndex = draggable.object.formObject.index;
                                    newIndex = $(element).find('.empty').index();
                                    if (oldIndex < newIndex) {
                                        newIndex--;
                                    }
                                    $builder.updateSectionObjectIndex(scope.formNumber, scope.sectionIndex, oldIndex, newIndex);
                                }
                            }

                            //console.log(beginMove, elementIndex, formObject, newIndex, oldIndex);

                            return $(element).find('.empty').remove();
                        }
                    });
                }
            };
        }
    ])

    //TODO: Simple Preview & Simple Component actions
    .directive('fbSimpleView', [
        '$injector', function ($injector) {
            var $builder;
            $builder = $injector.get('$builder');
            return {
                restrict: 'A',
                scope: {
                    simpleComponentView: '=fbSimpleComponentView',
                    simplePreview: '=fbSimplePreview'
                },
                template: '<div class="col-xs-6">\n	<input type="checkbox" id="simplePreview" ng-model=\'simplePreview\' ng-checked="simplePreview"/>\n	<label for="simplePreview">Simple Preview</label>\n</div>\n<div class="col-xs-6">\n	<input type="checkbox" id="simpleComponentView" ng-model=\'simpleComponentView\'/>\n	<label for="simpleComponentView">Simple Component</label>\n</div>',
                link: function (scope, element) {
                    $builder.simplePreview = scope.simplePreview || $builder.simplePreview;
                    $builder.simpleComponentView = scope.simpleComponentView || $builder.simpleComponentView;
                    scope.$watch('simplePreview', function () {
                        $builder.simplePreview = scope.simplePreview;
                        return;
                    });
                    return scope.$watch('simpleComponentView', function () {
                        $builder.simpleComponentView = scope.simpleComponentView;
                        return;
                    });
                }
            };
        }
    ])

    // TODO: container for fbPropertyPopover - save/cancel/delete actions container
    .directive('fbControlPanel', [
        '$injector', function ($injector) {
            var $builder;
            $builder = $injector.get('$builder');
            return {
                restrict: 'A',
                template: '<div class="col-xs-12 fb-control-panel">\n	<div class="col-xs-12" fb-property-popover id="fb-property-popover">\n	</div>\n</div>',
                link: function (scope, element) {
                }
            };
        }
    ])


    .directive('fbFormProperties', [
        '$injector', function ($injector) {
            var $builder;
            $builder = $injector.get('$builder');
            return {
                restrict: 'A',
                template: '<div class="col-xs-12 fb-control-panel">' +
                '<form>' +
                '<div class="form-group" >' +
                '<label class="control-label">Title</label>' +
                '<input type="text" ng-model="formData.title" class="form-control"/>' +
                '</div>' +
                '<div class="form-group">' +
                '<label class="control-label">Description</label>' +
                '<input type="text" ng-model="formData.description" class="form-control"/>' +
                '</div>' +
                '<div class="form-group">' +
                '<label class="control-label">Instructions</label>' +
                '<textarea type="text" rows="6" ng-model="formData.instructions" class="form-control"/>' +
                '</div>' +
                '<hr/>' +
                '<div class="form-group">' +
                '<input type="submit" ng-click="saveForm()" class="btn btn-primary" value="Save"/>' +
                ' ' +
                '<input type="button" ng-click="resetForm()" class="btn btn-default" value="Reset"/>' +
                '</div>' +
                '</form>' +
                '</div>',
                link: function (scope) {
                    scope.formData = angular.copy($builder.formData);

                    scope.resetForm = function () {
                        scope.formData = angular.copy($builder.formData);
                    };

                    scope.saveForm = function () {
                        $builder.formData = scope.formData;
                    }
                }
            };
        }
    ]);