var copyObjectToScope,
    __indexOf = [].indexOf || function (item) {
            for (var i = 0, l = this.length; i < l; i++) {
                if (i in this && this[i] === item) return i;
            }
            return -1;
        };

copyObjectToScope = function (object, scope) {
    /*
     Copy object (ng-repeat="object in objects") to scope without `hashKey`.
     */
    var key, value;
    for (key in object) {
        value = object[key];
        if (key !== '$$hashKey') {
            scope[key] = value;
        }
    }
};

angular.module('builder.controller', ['builder.provider'])
    .controller('fbFormObjectEditableController', [
        '$scope', '$injector', function ($scope, $injector) {
            var $builder;
            $builder = $injector.get('$builder');

            $scope.repeatSection = function(currentPage, componentIndex) {
                console.log(currentPage, componentIndex, $builder.forms);
            };

            $scope.removeSection = function(currentPage, componentIndex) {
                console.log(currentPage, componentIndex, $builder.forms);
            };

            $scope.setupScope = function (formObject) {
                /*
                 1. Copy origin formObject (ng-repeat="object in formObjects") to scope.
                 2. Setup optionsText with formObject.options.
                 3. Watch scope.label, .show_label .description, .placeholder, .required, .inline, .options then copy to origin formObject.
                 4. Watch scope.optionsText then convert to scope.options.
                 5. setup validationOptions
                 */

                var component;
                copyObjectToScope(formObject, $scope);
                $scope.optionsText = formObject.options.join('\n');

//TODO: зміна любого елемента форми
                $scope.$watch('[label, show_label, repeatable, collapsable, description, placeholder, required, inline, options, validation, text, header, footer, align, style, components]', function () {
                    formObject.label = $scope.label;
                    formObject.show_label = $scope.show_label;
                    formObject.description = $scope.description;
                    formObject.placeholder = $scope.placeholder;
                    formObject.required = $scope.required;
                    formObject.inline = $scope.inline;
                    formObject.options = $scope.options;
                    formObject.validation = $scope.validation;
                    formObject.text = $scope.text;
                    formObject.header = $scope.header;
                    formObject.footer = $scope.footer;
                    formObject.align = $scope.align;
                    formObject.style = $scope.style;
                    formObject.components = $scope.components;
                    formObject.repeatable = $scope.repeatable;
                    formObject.collapsable = $scope.collapsable;
                }, true);


//TODO: зміна оптіонів в селекті
                $scope.$watch('optionsText', function (text) {
                    var x;
                    $scope.options = (function () {
                        var _i, _len, _ref, _results;
                        _ref = text.split('\n');
                        _results = [];
                        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                            x = _ref[_i];
                            if (x.length > 0) {
                                _results.push(x);
                            }
                        }
                        return _results;
                    })();

                    return $scope.inputText = $scope.options[0];
                });
                component = $builder.components[formObject.component];
                return $scope.validationOptions = component.validationOptions;
            };

            return $scope.data = {
                model: null,
                backup: function () {

                    /*
                     Backup input value.
                     */
                    return this.model = {
                        label: $scope.label,
                        show_label: $scope.show_label,
                        description: $scope.description,
                        placeholder: $scope.placeholder,
                        required: $scope.required,
                        inline: $scope.inline,
                        optionsText: $scope.optionsText,
                        validation: $scope.validation,
                        text: $scope.text,
                        header: $scope.header,
                        footer: $scope.footer,
                        align: $scope.align,
                        style: $scope.style,
                        components: $scope.components
                    };
                },
                rollback: function () {

                    /*
                     Rollback input value.
                     */
                    if (!this.model) {
                        return;
                    }
                    $scope.label = this.model.label;
                    $scope.show_label = this.model.show_label;
                    $scope.description = this.model.description;
                    $scope.placeholder = this.model.placeholder;
                    $scope.required = this.model.required;
                    $scope.inline = this.model.inline;
                    $scope.optionsText = this.model.optionsText;
                    $scope.validation = this.model.validation;
                    $scope.text = this.model.text;
                    $scope.header = this.model.header;
                    $scope.footer = this.model.footer;
                    $scope.align = this.model.align;
                    $scope.style = this.model.style;
                    return $scope.components = this.model.components;
                }
            };
        }
    ])


    .controller('fbComponentsController', [
        '$scope', '$injector', function ($scope, $injector) {
            var $builder;
            $builder = $injector.get('$builder');

//TODO: зміна вкладки компоненту Default/Image/Special
            $scope.selectGroup = function ($event, group) {
                var component, name, _ref, _results;
                if ($event != null) {
                    $event.preventDefault();
                }
                $scope.activeGroup = group;
                $scope.components = [];
                _ref = $builder.components;
                _results = [];
                for (name in _ref) {
                    component = _ref[name];
                    if (component.group === group) {
                        _results.push($scope.components.push(component));
                    }
                }

                return _results;
            };

//TODO: зелена кнопка даодати компонент
            $scope.addComponentToEnd = function ($event, component) {
                if ($event != null) {
                    $event.preventDefault();
                }
                $builder = null;
                $builder = $injector.get('$builder');
                return $builder.addFormObject($builder.currentForm || 0, {
                    component: component.name
                });
            };
            $scope.groups = $builder.groups;

            $scope.activeGroup = $scope.groups[0];
            $scope.allComponents = $builder.components;
            return $scope.$watch('allComponents', function () {
                return $scope.selectGroup(null, $scope.activeGroup);
            });
        }
    ])


//TODO: при зміні вкладки компоненту Default/Image/Special заповнення правої частини даними:
    .controller('fbComponentController', [
        '$scope', function ($scope) {
            return $scope.copyObjectToScope = function (object) {
                return copyObjectToScope(object, $scope);
            };
        }
    ])


//TODO: при друкуванні в любому полі
    .controller('fbFormController', [
        '$scope', '$injector', function ($scope, $injector) {
            var $builder, $timeout;
            $builder = $injector.get('$builder');
            $timeout = $injector.get('$timeout');
            $scope.currentForm = $builder.currentForm;
            if ($scope.input == null) {
                $scope.input = [];
            }
            return $scope.$watch('form', function () {
                if ($scope.input.length > $scope.form.length) {
                    $scope.input.splice($scope.form.length);
                }
                return $timeout(function () {
                    return $scope.$broadcast($builder.broadcastChannel.updateInput);
                });
            }, true);
        }
    ])


//TODO: при друкуванні в любому полі ^^^
    .controller('fbFormObjectController', [
        '$scope', '$injector', function ($scope, $injector) {
            var $builder;
            $builder = $injector.get('$builder');
            $scope.copyObjectToScope = function (object) {
                return copyObjectToScope(object, $scope);
            };
            return $scope.updateInput = function (value) {

                /*
                 Copy current scope.input[X] to $parent.input.
                 @param value: The input value.
                 */
                var input;
                input = {
                    id: $scope.formObject.id,
                    label: $scope.formObject.label,
                    show_label: $scope.formObject.show_label,
                    value: value != null ? value : ''
                };

                return $scope.$parent.input.splice($scope.$index, 1, input);
            };
        }
    ])


//TODO: весь функціонал додавання/видалення і т. д. сторінок
    .controller('PaginationController', [
        '$rootScope', '$scope', '$injector', function ($rootScope, $scope, $injector) {
            var $builder;
            $builder = $injector.get('$builder');
            $scope.prev = false;
            $scope.next = false;
            $scope.updatePage = function () {
                var count, forms, page;
                count = 0;
                forms = $builder.forms;
                if (typeof forms.length === 'number') {
                    count = forms.length;
                } else {
                    for (page in forms) {
                        if (forms.hasOwnProperty(page)) {
                            ++count;
                        }
                    }
                }
                $scope.pageCount = count;
                $scope.pages = forms;
                $scope.currentPage = $builder.currentForm;
                $scope.prev = $builder.currentForm > 0 ? true : false;
                $scope.next = $scope.pageCount > ($builder.currentForm + 1) ? true : false;
            };
            $scope.addPage = function (pageCount) {
                $builder.forms[$scope.pageCount] = [];
                return $scope.updatePage();
            };
            $scope.deletePage = function (pageNumber) {
                var current, forms, page, pageObj;
                forms = $builder.forms;

                if(forms.length>1) {
                    current = forms[pageNumber + 1] ? pageNumber + 1 : pageNumber - 1;
                    if (typeof forms.length === 'number') {
                        forms.splice(pageNumber, 1);
                    } else {
                        delete forms[pageNumber];
                        for (page in forms) {
                            pageObj = forms[page];
                            if (page > pageNumber) {
                                forms[page - 1] = forms[page];
                            }
                        }
                        delete forms[$scope.pageCount - 1];
                    }
                    $builder.currentForm = current > pageNumber ? pageNumber : current;
                    $scope.currentPage = false;
                    return $scope.currentPage = pageNumber;
                }

            };
            $scope.goPage = function (page) {
                if ($builder.forms[page]) {
                    $builder.currentForm = page;
                    $scope.updatePage();
                    return true;
                } else {
                    return false;
                }
            };
            $scope.goF = function () {   //TODO: page foreward
                var pageNumber;
                pageNumber = $builder.currentForm + 1;
                return $scope.goPage(pageNumber);
            };
            $scope.goB = function () {   //TODO: page back
                var pageNumber;
                pageNumber = $builder.currentForm - 1;
                return $scope.goPage(pageNumber);
            };
            $rootScope.hoverFormData = [];
            return $scope.updatePage();
        }
    ]);