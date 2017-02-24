angular.module('builder.provider', [])
    .provider('$builder', function () {
        var $http, $injector, $templateCache;
        $injector = null;
        $http = null;
        $templateCache = null;
        this.config = {
            section: true,
            propertiesPlacement: 'sidebar',
            popoverPlacement: 'right'
        };
        this.components = {};
        this.groups = [];
        this.broadcastChannel = {
            updateInput: '$updateInput'
        };
        this.currentForm = 0;
        this.forms = [];
        this.forms['0'] = [];
        this.simplePreview = false;
        this.simpleComponentView = true;
        this.convertComponent = function (name, component) {
            var result, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref17, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
            result = {
                name: name,
                group: (_ref = component.group) != null ? _ref : 'Default',
                label: (_ref1 = component.label) != null ? _ref1 : '',
                show_label: (_ref2 = component.show_label) != null ? _ref2 : true,
                description: (_ref3 = component.description) != null ? _ref3 : '',
                placeholder: (_ref4 = component.placeholder) != null ? _ref4 : '',
                text: (_ref5 = component.text) != null ? _ref5 : '',
                header: (_ref6 = component.header) != null ? _ref6 : '',
                footer: (_ref7 = component.footer) != null ? _ref7 : '',
                style: (_ref8 = component.style) != null ? _ref8 : '',
                editable: (_ref9 = component.editable) != null ? _ref9 : true,
                required: (_ref10 = component.required) != null ? _ref10 : false,
                inline: (_ref11 = component.inline) != null ? _ref11 : false,
                validation: (_ref12 = component.validation) != null ? _ref12 : '/.*/',
                validationOptions: (_ref13 = component.validationOptions) != null ? _ref13 : [],
                options: (_ref14 = component.options) != null ? _ref14 : [],
                align: (_ref15 = component.align) != null ? _ref15 : [],
                arrayToText: (_ref16 = component.arrayToText) != null ? _ref16 : false,
                template: component.template,
                templateUrl: component.templateUrl,
                popoverTemplate: component.popoverTemplate,
                popoverTemplateUrl: component.popoverTemplateUrl,
                components: (_ref17 = component.components) != null ? _ref17 : []
            };
            if (!result.template && !result.templateUrl) {
                console.error("The template is empty.");
            }
            if (!result.popoverTemplate && !result.popoverTemplateUrl) {
                console.error("The popoverTemplate is empty.");
            }
            return result;
        };
        this.convertFormObject = function (name, formObject) {
            var component, result, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
            if (formObject == null) {
                formObject = {};
            }
            component = this.components[formObject.component];

            if (component == null) {
                throw "The component " + formObject.component + " was not registered.";
            }
            result = {
                id: formObject.id,
                component: formObject.component,
                editable: (_ref = formObject.editable) != null ? _ref : component.editable,
                index: (_ref1 = formObject.index) != null ? _ref1 : 0,
                label: (_ref2 = formObject.label) != null ? _ref2 : component.label,
                show_label: (_ref3 = formObject.show_label) != null ? _ref3 : component.show_label,
                description: (_ref4 = formObject.description) != null ? _ref4 : component.description,
                placeholder: (_ref5 = formObject.placeholder) != null ? _ref5 : component.placeholder,
                options: (_ref6 = formObject.options) != null ? _ref6 : component.options,
                required: (_ref7 = formObject.required) != null ? _ref7 : component.required,
                inline: (_ref8 = formObject.inline) != null ? _ref8 : component.inline,
                validation: (_ref9 = formObject.validation) != null ? _ref9 : component.validation,
                text: (_ref10 = formObject.text) != null ? _ref10 : component.text,
                header: (_ref11 = formObject.header) != null ? _ref11 : component.header,
                footer: (_ref12 = formObject.footer) != null ? _ref12 : component.footer,
                align: (_ref13 = formObject.align) != null ? _ref13 : component.align,
                style: (_ref14 = formObject.style) != null ? _ref14 : component.style,
                components: (_ref15 = formObject.components) != null ? _ref15 : component.components
            };
            return result;
        };
        this.reindexFormObject = (function (_this) {
            return function (formIndex) {
                var formObjects, index, _i, _ref;
                formObjects = _this.forms[formIndex];
                for (index = _i = 0, _ref = formObjects.length; _i < _ref; index = _i += 1) {
                    formObjects[index].index = index;
                }
            };
        })(this);
        this.reindexSectionObject = (function (_this) {
            return function (name, sectionIndex) {
                var index, sectionObjects, _i, _ref;
                sectionObjects = _this.forms[name][sectionIndex].components;
                for (index = _i = 0, _ref = sectionObjects.length; _i < _ref; index = _i += 1) {
                    sectionObjects[index].index = index;
                }
            };
        })(this);
        this.setupProviders = (function (_this) {
            return function (injector) {
                $injector = injector;
                $http = $injector.get('$http');
                return $templateCache = $injector.get('$templateCache');
            };
        })(this);
        this.loadTemplate = function (component) {

            /*
             Load template for components.
             @param component: {object} The component of $builder.
             */
            if (component.template == null) {
                $http.get(component.templateUrl, {
                    cache: $templateCache
                }).success(function (template) {
                    return component.template = template;
                });
            }
            if (component.popoverTemplate == null) {
                return $http.get(component.popoverTemplateUrl, {
                    cache: $templateCache
                }).success(function (template) {
                    return component.popoverTemplate = template;
                });
            }
        };
        this.registerComponent = (function (_this) {
            return function (name, component) {
                var newComponent, _ref;
                if (component == null) {
                    component = {};
                }

                /*
                 Register the component for form-builder.
                 @param name: The component name.
                 @param component: The component object.
                 group: {string} The component group.
                 label: {string} The label of the input.
                 description: {string} The description of the input.
                 placeholder: {string} The placeholder of the input.
                 editable: {bool} Is the form object editable?
                 required: {bool} Is the form object required?
                 inline: {bool} Is the form object inline?
                 validation: {string} angular-validator. "/regex/" or "[rule1, rule2]". (default is RegExp(.*))
                 validationOptions: {array} [{rule: angular-validator, label: 'option label'}] the options for the validation. (default is [])
                 options: {array} The input options.
                 arrayToText: {bool} checkbox could use this to convert input (default is no)
                 template: {string} html template
                 templateUrl: {string} The url of the template.
                 popoverTemplate: {string} html template
                 popoverTemplateUrl: {string} The url of the popover template.
                 */
                if (_this.components[name] == null) {
                    newComponent = _this.convertComponent(name, component);
                    _this.components[name] = newComponent;
                    if ($injector != null) {
                        _this.loadTemplate(newComponent);
                    }
                    if (_ref = newComponent.group, __indexOf.call(_this.groups, _ref) < 0) {
                        _this.groups.push(newComponent.group);
                    }
                } else {
                    console.error("The component " + name + " was registered.");
                }
            };
        })(this);
        this.addFormObject = (function (_this) {
            return function (formIndex, formObject) {
                var _base;
                if (formObject == null) {
                    formObject = {};
                }

                /*
                 Insert the form object into the form at last.
                 */
                if ((_base = _this.forms)[formIndex] == null) {
                    _base[formIndex] = [];
                }
                return _this.insertFormObject(formIndex, _this.forms[formIndex].length, formObject);
            };
        })(this);
        this.insertFormObject = (function (_this) {
            return function (formIndex, index, formObject) {
                var _base;
                if (formObject == null) {
                    formObject = {};
                }

                /*
                 Insert the form object into the form at {index}.
                 @param formIndex: The form formIndex.
                 @param index: The form object index.
                 @param form: The form object.
                 id: The form object id.
                 component: {string} The component name
                 editable: {bool} Is the form object editable? (default is yes)
                 label: {string} The form object label.
                 description: {string} The form object description.
                 placeholder: {string} The form object placeholder.
                 options: {array} The form object options.
                 required: {bool} Is the form object required? (default is no)
                 inline: {bool} Is the form object inline? (default is no)
                 validation: {string} angular-validator. "/regex/" or "[rule1, rule2]".
                 [index]: {int} The form object index. It will be updated by $builder.
                 @return: The form object.
                 */
                if ((_base = _this.forms)[formIndex] == null) {
                    _base[formIndex] = [];
                }
                if (index > _this.forms[formIndex].length) {
                    index = _this.forms[formIndex].length;
                } else if (index < 0) {
                    index = 0;
                }
                _this.forms[formIndex].splice(index, 0, _this.convertFormObject(formIndex, formObject));
                _this.reindexFormObject(formIndex);
                return _this.forms[formIndex][index];
            };
        })(this);
        this.removeFormObject = (function (_this) {
            return function (formIndex, index) {

                /*
                 Remove the form object by the index.
                 @param formIndex: The form formIndex.
                 @param index: The form object index.
                 */
                var formObjects;
                formObjects = _this.forms[formIndex];
                formObjects.splice(index, 1);
                return _this.reindexFormObject(formIndex);
            };
        })(this);
        this.updateFormObjectIndex = (function (_this) {
            return function (formIndex, oldIndex, newIndex) {

                /*
                 Update the index of the form object.
                 @param formIndex: The form formIndex.
                 @param oldIndex: The old index.
                 @param newIndex: The new index.
                 */
                var formObject, formObjects;
                if (oldIndex === newIndex) {
                    return;
                }
                formObjects = _this.forms[formIndex];
                formObject = formObjects.splice(oldIndex, 1)[0];
                formObjects.splice(newIndex, 0, formObject);
                return _this.reindexFormObject(formIndex);
            };
        })(this);

        /*Sections */
        this.getSectionObjects = (function (_this) {
            return function (sectionIndex, formIndex) {
                if (formIndex == null) {
                    formIndex = _this.currentForm;
                }
                if (_this.forms[formIndex][sectionIndex]) {
                    return _this.forms[formIndex][sectionIndex].components;
                } else {
                    return [];
                }
            };
        })(this);
        this.insertSectionObject = (function (_this) {
            return function (formIndex, sectionIndex, index, formObject) {
                var section;
                if (formObject == null || formObject.component == 'section') {
                    formObject = {};
                    return;
                }

                /*
                 Insert the form object into the form at {index}.
                 @param  formIndex: The form  formIndex.
                 @param index: The form object index.
                 @param form: The form object.
                 id: The form object id.
                 component: {string} The component name
                 editable: {bool} Is the form object editable? (default is yes)
                 label: {string} The form object label.
                 description: {string} The form object description.
                 placeholder: {string} The form object placeholder.
                 options: {array} The form object options.
                 required: {bool} Is the form object required? (default is no)
                 inline: {bool} Is the form object inline? (default is no)
                 validation: {string} angular-validator. "/regex/" or "[rule1, rule2]".
                 [index]: {int} The form object index. It will be updated by $builder.
                 @return: The form object.
                 */
                section = _this.forms[formIndex][sectionIndex];
                if (section.components == null) {
                    section.components = [];
                }
                if (index > section.components.length) {
                    index = section.components.length;
                } else if (index < 0) {
                    index = 0;
                }
                section.components.splice(index, 0, _this.convertFormObject(formIndex, formObject));
                _this.reindexSectionObject(formIndex, sectionIndex);
                return section.components[index];
            };
        })(this);
        this.removeSectionObject = (function (_this) {
            return function (formIndex, sectionIndex, index) {
                var sectionObjects;
                if (formIndex == null) {
                    formIndex = _this.currentForm;
                }

                /*
                 Remove the form object by the index.
                 @param formIndex: The form formIndex.
                 @param index: The form object index.
                 */
                sectionObjects = _this.forms[formIndex][sectionIndex].components;
                return sectionObjects.splice(index, 1);
            };
        })(this);
        this.updateSectionObjectIndex = (function (_this) {
            return function (formIndex, sectionIndex, oldIndex, newIndex) {
                var formObject, sectionObjects;
                if (formIndex == null) {
                    formIndex = _this.currentForm;
                }

                /*
                 Update the index of the form object.
                 @param formIndex: The form formIndex.
                 @param oldIndex: The old index.
                 @param newIndex: The new index.
                 */
                if (oldIndex === newIndex) {
                    return;
                }
                sectionObjects = _this.forms[formIndex][sectionIndex].components;
                formObject = sectionObjects.splice(oldIndex, 1)[0];
                sectionObjects.splice(newIndex, 0, formObject);
                return _this.reindexSectionObject(formIndex, sectionIndex);
            };
        })(this);
        this.selectedPath = [0];
        this.selectFrame = (function (_this) {
            return function (firstIndex, sectionIndex) {
                if (firstIndex === 0) {
                    _this.selectedPath = [0];
                } else {
                    _this.selectedPath = [1, sectionIndex];
                }
                return _this.selectedPath;
            };
        })(this);
        this.$get = [
            '$injector', (function (_this) {
                return function ($injector) {
                    var component, name, _ref;
                    _this.setupProviders($injector);
                    _ref = _this.components;
                    for (name in _ref) {
                        component = _ref[name];
                        _this.loadTemplate(component);
                    }
                    return {
                        config: _this.config,
                        options: _this.options,
                        components: _this.components,
                        groups: _this.groups,
                        forms: _this.forms,
                        currentForm: _this.currentForm,
                        broadcastChannel: _this.broadcastChannel,
                        registerComponent: _this.registerComponent,
                        addFormObject: _this.addFormObject,
                        insertFormObject: _this.insertFormObject,
                        removeFormObject: _this.removeFormObject,
                        removeSectionObject: _this.removeSectionObject,
                        updateFormObjectIndex: _this.updateFormObjectIndex,
                        updateSectionObjectIndex: _this.updateSectionObjectIndex,
                        getSectionObjects: _this.getSectionObjects,
                        insertSectionObject: _this.insertSectionObject,
                        selectFrame: _this.selectFrame,
                        selectedPath: _this.selectedPath
                    };
                };
            })(this)
        ];
    });