(function() {
  var copyObjectToScope;

  copyObjectToScope = function(object, scope) {

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

  angular.module('builder.controller', ['builder.provider']).controller('fbFormObjectEditableController', [
    '$scope', '$injector', function($scope, $injector) {
      var $builder;
      $builder = $injector.get('$builder');
      $scope.setupScope = function(formObject) {

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
        $scope.$watch('[label, show_label, description, placeholder, required, inline, options, validation, text, header, footer, align, style, components]', function() {
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
          return formObject.components = $scope.components;
        }, true);
        $scope.$watch('optionsText', function(text) {
          var x;
          $scope.options = (function() {
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
        backup: function() {

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
        rollback: function() {

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
  ]).controller('fbComponentsController', [
    '$scope', '$injector', function($scope, $injector) {
      var $builder;
      $builder = $injector.get('$builder');
      $scope.selectGroup = function($event, group) {
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
      $scope.addComponentToEnd = function($event, component) {
        if ($event != null) {
          $event.preventDefault();
        }
        console.log(component.group, component.name);
        return $builder.addFormObject($builder.currentForm || 0, {
          component: component.name
        });
      };
      $scope.groups = $builder.groups;
      $scope.activeGroup = $scope.groups[0];
      $scope.allComponents = $builder.components;
      return $scope.$watch('allComponents', function() {
        return $scope.selectGroup(null, $scope.activeGroup);
      });
    }
  ]).controller('fbComponentController', [
    '$scope', function($scope) {
      return $scope.copyObjectToScope = function(object) {
        return copyObjectToScope(object, $scope);
      };
    }
  ]).controller('fbFormController', [
    '$scope', '$injector', function($scope, $injector) {
      var $builder, $timeout;
      $builder = $injector.get('$builder');
      $timeout = $injector.get('$timeout');
      $scope.currentForm = $builder.currentForm;
      if ($scope.input == null) {
        $scope.input = [];
      }
      return $scope.$watch('form', function() {
        if ($scope.input.length > $scope.form.length) {
          $scope.input.splice($scope.form.length);
        }
        return $timeout(function() {
          return $scope.$broadcast($builder.broadcastChannel.updateInput);
        });
      }, true);
    }
  ]).controller('fbFormObjectController', [
    '$scope', '$injector', function($scope, $injector) {
      var $builder;
      $builder = $injector.get('$builder');
      $scope.copyObjectToScope = function(object) {
        return copyObjectToScope(object, $scope);
      };
      return $scope.updateInput = function(value) {

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
  ]).controller('PaginationController', [
    '$scope', '$injector', function($scope, $injector) {
      var $builder;
      $builder = $injector.get('$builder');
      console.log($builder.forms);
      $scope.prev = false;
      $scope.next = false;
      $scope.updatePage = function() {
        var count, forms, page;
        console.log('update');
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
        return $scope.next = $scope.pageCount > ($builder.currentForm + 1) ? true : false;
      };
      $scope.addPage = function(pageCount) {
        $builder.forms[$scope.pageCount] = [];
        return $scope.updatePage();
      };
      $scope.deletePage = function(pageNumber) {
        var current, forms, page, pageObj;
        forms = $builder.forms;
        current = forms[pageNumber + 1] ? pageNumber + 1 : pageNumber - 1;
        console.log(pageNumber, forms, current);
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
      };
      $scope.goPage = function(page) {
        console.log('GO PAGE', page, $builder.currentForm, $builder.forms);
        if ($builder.forms[page]) {
          $builder.currentForm = page;
          $scope.updatePage();
          return true;
        } else {
          return false;
        }
      };
      $scope.goF = function() {
        var pageNumber;
        pageNumber = $builder.currentForm + 1;
        return $scope.goPage(pageNumber);
      };
      $scope.goB = function() {
        var pageNumber;
        pageNumber = $builder.currentForm - 1;
        return $scope.goPage(pageNumber);
      };
      return $scope.updatePage();
    }
  ]);

}).call(this);

(function() {
  angular.module('builder.directive', ['builder.provider', 'builder.controller', 'builder.drag', 'validator']).directive('fbSection', [
    '$injector', function($injector) {
      var $builder, $drag;
      $builder = $injector.get('$builder');
      $drag = $injector.get('$drag');
      return {
        restrict: 'A',
        scope: {
          fbSection: '=',
          fbSectionObjectEditable: '='
        },
        template: "<div class='fb-section-object-editable'>\n	<div class='fb-section-object-editable' ng-repeat=\"object in sectionObjects\" fb-form-object-editable=\"object\" >\n	</div>\n</div>",
        link: function(scope, element, attr) {
          var uuid;
          $(element).addClass('fb-section');
          uuid = $(element).closest(".fb-form-object-editable").index();
          scope.sectionObjects = $builder.getSectionObjects(uuid);
          return $drag.droppable($(element), {
            move: function(e) {
              var $empty, $formObject, $formObjects, beginMove, height, index, offset, positions, _i, _j, _ref, _ref1;
              if (beginMove) {
                $("div.fb-section-object-editable").popover('hide');
                beginMove = false;
              }
              $formObjects = $(element).find('.fb-section-object-editable:not(.empty,.dragging)');
              if ($formObjects.length === 0) {
                if ($(element).find('.fb-section-object-editable.empty').length === 0) {
                  $(element).find('>div:first').append($("<div class='fb-section-object-editable empty'></div>"));
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
                  $empty = $("<div class='fb-section-object-editable empty'></div>");
                  if (index - 1 < $formObjects.length) {
                    $empty.insertBefore($($formObjects[index - 1]));
                  } else {
                    $empty.insertAfter($($formObjects[index - 2]));
                  }
                  break;
                }
              }
            },
            out: function() {
              var beginMove;
              if (beginMove) {
                $("div.fb-section-object-editable").popover('hide');
                beginMove = false;
              }
              return $(element).find('.empty').remove();
            },
            up: function(e, isHover, draggable) {
              var beginMove, formObject, newIndex, oldIndex;
              beginMove = true;
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
                  $builder.insertSectionObject($builder.currentForm, uuid, $(element).find('.empty').index('.fb-section-object-editable'), {
                    component: draggable.object.componentName
                  });
                  scope.sectionObjects = $builder.getSectionObjects(uuid);
                }
                if (draggable.mode === 'drag') {
                  oldIndex = draggable.object.formObject.index;
                  newIndex = $(element).find('.empty').index('.fb-section-object-editable');
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
  ]).directive('fbBuilder', [
    '$injector', function($injector) {
      var $builder, $drag;
      $builder = $injector.get('$builder');
      $drag = $injector.get('$drag');
      return {
        restrict: 'A',
        scope: {
          fbBuilder: '='
        },
        template: "<div class='form-horizontal' fb-page={{currentPage}}>\n	<div class='fb-form-object-editable ' ng-repeat=\"object in formObjects\"\n		fb-form-object-editable=\"object\" fb-draggable='allow'></div>\n</div>",
        controller: 'PaginationController',
        link: function(scope, element, attrs) {
          var KeyDown, KeyUp, allowKey, beginMove, keyHold, _base, _name;
          scope.formNumber = attrs.fbPage || $builder.currentForm;
          if ((_base = $builder.forms)[_name = scope.formNumber] == null) {
            _base[_name] = [];
          }
          scope.formObjects = $builder.forms[scope.formNumber];
          beginMove = true;
          scope.currentPage = 1;
          scope.$watchGroup([
            function() {
              return $builder.forms[$builder.currentForm];
            }, function() {
              return $builder.forms.length;
            }
          ], function(current, prev) {
            console.log(arguments, 'page change -> change pagin', $builder.currentForm);
            scope.formNumber = $builder.currentForm;
            scope.currentPage = $builder.currentForm;
            return scope.formObjects = $builder.forms[scope.formNumber];
          });
          $(element).addClass('fb-builder');
          allowKey = 'Alt';
          keyHold = '';
          KeyDown = (function(_this) {
            return function(e) {
              var KeyID, keyName;
              KeyID = window.event ? event.keyCode : e.keyCode;
              switch (KeyID) {
                case 18:
                  keyName = "Alt";
                  break;
                case 17:
                  keyName = "Ctrl";
              }
              keyHold = keyName;
              return console.log(keyHold);
            };
          })(this);
          KeyUp = (function(_this) {
            return function(e) {
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
                keyHold = "";
              }
              return console.log('UP', keyHold);
            };
          })(this);
          document.onkeydown = KeyDown;
          document.onkeyup = KeyUp;
          return $drag.droppable($(element), {
            move: function(e) {
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
            out: function() {
              if (beginMove) {
                $("div.fb-form-object-editable").popover('hide');
                beginMove = false;
              }
              return $(element).find('.empty').remove();
            },
            up: function(e, isHover, draggable) {
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
  ]).directive('fbFormObjectEditable', [
    '$injector', function($injector) {
      var $builder, $compile, $drag, $validator;
      $builder = $injector.get('$builder');
      $drag = $injector.get('$drag');
      $compile = $injector.get('$compile');
      $validator = $injector.get('$validator');
      return {
        restrict: 'A',
        controller: 'fbFormObjectEditableController',
        scope: {
          isOpen: '=isOpen',
          formObject: '=fbFormObjectEditable'
        },
        link: function(scope, element) {
          var allow, popover;
          scope.inputArray = [];
          scope.$component = $builder.components[scope.formObject.component];
          scope.setupScope(scope.formObject);
          scope.$watch('$component.template', function(template) {
            var view;
            if (!template) {
              return;
            }
            view = $compile(template)(scope);
            $(element).html(view);
            return console.log('Component change');
          });
          $(element).on('click', function() {
            return false;
          });
          console.log(scope.$component.name, scope.isOpen);
          allow = scope.$component.name === 'section' ? false : true;
          $drag.draggable($(element), {
            object: {
              formObject: scope.formObject
            }
          });
          if (!scope.formObject.editable) {
            return;
          }
          popover = {};
          scope.$watch('$component.popoverTemplate', function(template) {
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
            return $(element).popover({
              html: true,
              title: scope.$component.label,
              content: popover.view,
              container: 'body',
              placement: $builder.config.popoverPlacement
            });
          });
          scope.popover = {
            save: function($event) {

              /*
              				The save event of the popover.
               */
              $event.preventDefault();
              $validator.validate(scope).success(function() {
                popover.isClickedSave = true;
                return $(element).popover('hide');
              });
            },
            remove: function($event) {

              /*
              				The delete event of the popover.
               */
              $event.preventDefault();
              $builder.removeFormObject(scope.$parent.formNumber, scope.$parent.$index);
              $(element).popover('hide');
            },
            shown: function() {

              /*
              				The shown event of the popover.
               */
              scope.data.backup();
              return popover.isClickedSave = false;
            },
            cancel: function($event) {

              /*
              				The cancel event of the popover.
               */
              scope.data.rollback();
              if ($event) {
                $event.preventDefault();
                $(element).popover('hide');
              }
            }
          };
          $(element).on('show.bs.popover', function() {
            var $popover, elementOrigin, popoverTop;
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
              setTimeout(function() {
                $popover.addClass('in');
                return $(element).triggerHandler('shown.bs.popover');
              }, 0);
              return false;
            }
          });
          $(element).on('shown.bs.popover', function() {
            $(".popover ." + popover.id + " input:first").select();
            scope.$apply(function() {
              return scope.popover.shown();
            });
          });
          return $(element).on('hide.bs.popover', function() {
            var $popover;
            $popover = $("form." + popover.id).closest('.popover');
            if (!popover.isClickedSave) {
              if (scope.$$phase || scope.$root.$$phase) {
                scope.popover.cancel();
              } else {
                scope.$apply(function() {
                  return scope.popover.cancel();
                });
              }
            }
            $popover.removeClass('in');
            setTimeout(function() {
              return $popover.hide();
            }, 300);
            return false;
          });
        }
      };
    }
  ]).directive('fbSectionObjectEditable', [
    '$injector', function($injector) {
      var $builder, $compile, $drag, $validator;
      $builder = $injector.get('$builder');
      $drag = $injector.get('$drag');
      $compile = $injector.get('$compile');
      $validator = $injector.get('$validator');
      return {
        restrict: 'A',
        controller: 'fbFormObjectEditableController',
        scope: {
          formObject: '=fbFormObjectEditable'
        },
        link: function(scope, element) {
          var popover;
          scope.inputArray = [];
          scope.$component = $builder.components[scope.formObject.component];
          scope.setupScope(scope.formObject);
          scope.$watch('$component.template', function(template) {
            var view;
            if (!template) {
              return;
            }
            view = $compile(template)(scope);
            return $(element).html(view);
          });
          $(element).on('click', function() {
            return false;
          });
          console.log($(element).attr('fb-draggable'));
          if ($(element).attr('fb-draggable') === 'allow') {
            $drag.draggable($(element), {
              object: {
                formObject: scope.formObject
              }
            });
          }
          if (!scope.formObject.editable) {
            return;
          }
          popover = {};
          scope.$watch('$component.popoverTemplate', function(template) {
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
            return $(element).popover({
              html: true,
              title: scope.$component.label,
              content: popover.view,
              container: 'body',
              placement: $builder.config.popoverPlacement
            });
          });
          scope.popover = {
            save: function($event) {

              /*
              				The save event of the popover.
               */
              $event.preventDefault();
              $validator.validate(scope).success(function() {
                popover.isClickedSave = true;
                return $(element).popover('hide');
              });
            },
            remove: function($event) {

              /*
              				The delete event of the popover.
               */
              $event.preventDefault();
              $builder.removeFormObject(scope.$parent.formNumber, scope.$parent.$index);
              $(element).popover('hide');
            },
            shown: function() {

              /*
              				The shown event of the popover.
               */
              scope.data.backup();
              return popover.isClickedSave = false;
            },
            cancel: function($event) {

              /*
              				The cancel event of the popover.
               */
              scope.data.rollback();
              if ($event) {
                $event.preventDefault();
                $(element).popover('hide');
              }
            }
          };
          $(element).on('show.bs.popover', function() {
            var $popover, elementOrigin, popoverTop;
            if ($drag.isMouseMoved()) {
              return false;
            }
            $("div.fb-section-object-editable:not(." + popover.id + ")").popover('hide');
            $popover = $("form." + popover.id).closest('.popover');
            if ($popover.length > 0) {
              elementOrigin = $(element).offset().top + $(element).height() / 2;
              popoverTop = elementOrigin - $popover.height() / 2;
              $popover.css({
                position: 'absolute',
                top: popoverTop
              });
              $popover.show();
              setTimeout(function() {
                $popover.addClass('in');
                return $(element).triggerHandler('shown.bs.popover');
              }, 0);
              return false;
            }
          });
          $(element).on('shown.bs.popover', function() {
            $(".popover ." + popover.id + " input:first").select();
            scope.$apply(function() {
              return scope.popover.shown();
            });
          });
          return $(element).on('hide.bs.popover', function() {
            var $popover;
            $popover = $("form." + popover.id).closest('.popover');
            if (!popover.isClickedSave) {
              if (scope.$$phase || scope.$root.$$phase) {
                scope.popover.cancel();
              } else {
                scope.$apply(function() {
                  return scope.popover.cancel();
                });
              }
            }
            $popover.removeClass('in');
            setTimeout(function() {
              return $popover.hide();
            }, 300);
            return false;
          });
        }
      };
    }
  ]).directive('fbComponents', [
    '$injector', function($injector) {
      return {
        restrict: 'A',
        template: "<ul ng-if=\"groups.length > 1\" class=\"nav nav-tabs nav-justified\">\n	<li ng-repeat=\"group in groups\" ng-class=\"{active:activeGroup==group}\">\n		<a href='#' ng-click=\"selectGroup($event, group)\">{{group}}</a>\n	</li>\n</ul>\n<div class='form-horizontal col-sm-12 elementList'>\n	<div ng-repeat=\"component in components\">\n		<div class=\"form-group element-wrapper\">\n			<div class=\"col-sm-1\">{{component.name}}\n				<button type='button' class='btn btn-success btn-sm'\n						ng-click='addComponentToEnd($event, component)'>+</button>\n			</div>\n			<div class=\"col-sm-11\">\n				<div class='fb-component' fb-component=\"component\" ng-component=\"{{component.name}}\"></div>\n			</div>\n	</div>\n</div>",
        controller: 'fbComponentsController'
      };
    }
  ]).directive('fbComponent', [
    '$injector', function($injector) {
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
        link: function(scope, element) {
          scope.copyObjectToScope(scope.component);
          $drag.draggable($(element), {
            mode: 'mirror',
            defer: false,
            object: {
              componentName: scope.component.name
            }
          });
          return scope.$watch('component.template', function(template) {
            var view;
            if (!template) {
              return;
            }
            view = $compile(template)(scope);
            return $(element).html(view);
          });
        }
      };
    }
  ]).directive('fbForm', [
    '$injector', function($injector) {
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
        link: function(scope, element, attrs) {
          var $builder, _base, _name;
          $builder = $injector.get('$builder');
          scope.$watch(function() {
            return $builder.currentForm;
          }, function(current, prev) {
            var _base, _name;
            console.log(arguments, 'page change');
            scope.formNumber = current;
            if ((_base = $builder.forms)[_name = scope.formNumber] == null) {
              _base[_name] = [];
            }
            scope.form = $builder.forms[scope.formNumber];
            return scope.jsonString = $builder.forms;
          });
          if ((_base = $builder.forms)[_name = scope.formNumber] == null) {
            _base[_name] = [];
          }
          scope.form = $builder.forms[scope.formNumber];
          return scope.jsonString = $builder.forms;
        }
      };
    }
  ]).directive('fbFormObject', [
    '$injector', function($injector) {
      var $builder, $compile, $parse;
      $builder = $injector.get('$builder');
      $compile = $injector.get('$compile');
      $parse = $injector.get('$parse');
      return {
        restrict: 'A',
        controller: 'fbFormObjectController',
        link: function(scope, element, attrs) {
          scope.formObject = $parse(attrs.fbFormObject)(scope);
          scope.$component = $builder.components[scope.formObject.component];
          scope.$on($builder.broadcastChannel.updateInput, function() {
            return scope.updateInput(scope.inputText);
          });
          if (scope.$component.arrayToText) {
            scope.inputArray = [];
            scope.$watch('inputArray', function(newValue, oldValue) {
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
          scope.$watch('inputText', function() {
            return scope.updateInput(scope.inputText);
          });
          scope.$watch(attrs.fbFormObject, function() {
            return scope.copyObjectToScope(scope.formObject);
          }, true);
          scope.$watch('$component.template', function(template) {
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
          return scope.$watch("default['" + scope.formObject.id + "']", function(value) {
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
  ]).directive('fbPages', [
    '$injector', function($injector) {
      var $builder;
      $builder = $injector.get('$builder');
      return {
        restrict: 'A',
        template: "<div class=\"fb-builderPagination\">\n	<div class=\"pull-left\">\n		<button type=\"button\" class=\"btn btn-primary btn-small _pull-right\"\n				ng-class=\"{disabled: !currentPage}\" ng-click=\"goB()\"><</button>\n		<button type=\"button\" class=\"btn btn-primary btn-small _pull-right\"\n				ng-class=\"{disabled: !next}\" ng-click=\"goF()\">></button>\n		<div class=\"btn-group\">\n			<button type=\"button\" class=\"btn btn-primary dropdown-toggle\" data-toggle=\"dropdown\"\n					aria-expanded=\"false\" aria-haspopup=\"true\">Page\n				<span class=\"caret\"></span>\n				<span class=\"sr-only\">Toggle Dropdown</span>\n			</button>\n			<ul class=\"dropdown-menu\" >\n				<li ng-repeat=\"(key, value) in pages\"><a ng-click=\"goPage(+key)\">{{+key+1}}</a></li>\n			</ul>\n		</div>\n	</div>\n	<span class=\"panel-title\" >\n		Page <b>\#<span ng-model=\"page\">{{currentPage+1}}</span></b> / {{pageCount}}\n	</span>\n\n	<div class=\"pull-right\">\n		<button type=\"button\" class=\"btn btn-danger btn-small _pull-right disabled\"\n				ng-class=\"{disabled: pageCount == 1}\" ng-click=\"deletePage(currentPage)\">-</button>\n		<!-- Split button -->\n		<div class=\"btn-group\">\n			<button type=\"button\" class=\"btn btn-success\" ng-click=\"addPage(pageCount)\">Add</button>\n			<button type=\"button\" class=\"btn btn-success dropdown-toggle\" data-toggle=\"dropdown\"\n					aria-haspopup=\"true\" aria-expanded=\"false\">\n				<span class=\"caret\"></span>\n				<span class=\"sr-only\">Toggle Dropdown</span>\n			</button>\n			<ul class=\"dropdown-menu\">\n				<li><a href=\"\" ng-click=\"addPage(pageCount)\">Page</a></li>\n				<li role=\"separator\" class=\"divider\"></li>\n				<li><a href=\"\">Section</a></li>\n				<li><a href=\"\">Component</a></li>\n			</ul>\n		</div>\n	</div>\n\n	<div class=\"clearfix\"></div>\n</div>",
        controller: 'PaginationController',
        link: function(scope, element, attrs) {
          return scope.$watch(function() {
            return $builder.forms.length;
          }, function() {
            console.log(arguments, 'change pagination');
            scope.pageCount = $builder.forms.length;
            scope.pages = $builder.forms;
            return scope.currentPage = $builder.currentForm;
          });
        }
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('builder.drag', []).provider('$drag', function() {
    var $injector, $rootScope, delay;
    $injector = null;
    $rootScope = null;
    this.data = {
      draggables: {},
      droppables: {}
    };
    this.mouseMoved = false;
    this.isMouseMoved = (function(_this) {
      return function() {
        return _this.mouseMoved;
      };
    })(this);
    this.hooks = {
      down: {},
      move: {},
      up: {}
    };
    this.innerDropHover = false;
    this.eventMouseMove = function() {};
    this.eventMouseUp = function() {};
    $((function(_this) {
      return function() {
        $(document).on('mousedown', function(e) {
          var func, key, _ref;
          _this.mouseMoved = false;
          _ref = _this.hooks.down;
          for (key in _ref) {
            func = _ref[key];
            func(e);
          }
        });
        $(document).on('mousemove', function(e) {
          var func, key, _ref;
          _this.mouseMoved = true;
          _ref = _this.hooks.move;
          for (key in _ref) {
            func = _ref[key];
            func(e);
          }
        });
        return $(document).on('mouseup', function(e) {
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
    this.getNewId = (function(_this) {
      return function() {
        return "" + (_this.currentId++);
      };
    })(this);
    this.setupEasing = function() {
      return jQuery.extend(jQuery.easing, {
        easeOutQuad: function(x, t, b, c, d) {
          return -c * (t /= d) * (t - 2) + b;
        }
      });
    };
    this.setupProviders = function(injector) {

      /*
      Setup providers.
       */
      $injector = injector;
      return $rootScope = $injector.get('$rootScope');
    };
    this.isHover = (function(_this) {
      return function($elementA, $elementB) {

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
    delay = function(ms, func) {
      return setTimeout(function() {
        return func();
      }, ms);
    };
    this.autoScroll = {
      up: false,
      down: false,
      scrolling: false,
      scroll: (function(_this) {
        return function() {
          _this.autoScroll.scrolling = true;
          if (_this.autoScroll.up) {
            $('html, body').dequeue().animate({
              scrollTop: $(window).scrollTop() - 50
            }, 100, 'easeOutQuad');
            return delay(100, function() {
              return _this.autoScroll.scroll();
            });
          } else if (_this.autoScroll.down) {
            $('html, body').dequeue().animate({
              scrollTop: $(window).scrollTop() + 50
            }, 100, 'easeOutQuad');
            return delay(100, function() {
              return _this.autoScroll.scroll();
            });
          } else {
            return _this.autoScroll.scrolling = false;
          }
        };
      })(this),
      start: (function(_this) {
        return function(e) {
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
      stop: (function(_this) {
        return function() {
          _this.autoScroll.up = false;
          return _this.autoScroll.down = false;
        };
      })(this)
    };
    this.dragMirrorMode = (function(_this) {
      return function($element, defer, object) {
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
        $element.on('mousedown', function(e) {
          var $clone;
          e.preventDefault();
          $clone = $element.clone();
          result.element = $clone[0];
          $clone.addClass("fb-draggable form-horizontal prepare-dragging");
          _this.hooks.move.drag = function(e, defer) {
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
          _this.hooks.up.drag = function(e) {
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
    this.dragDragMode = (function(_this) {
      return function($element, defer, object) {
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
        $element.on('mousedown', function(e) {
          e.preventDefault();
          if ($element.hasClass('dragging')) {
            return;
          }
          $element.addClass('prepare-dragging');
          _this.hooks.move.drag = function(e, defer) {
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
          _this.hooks.up.drag = function(e) {
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
    this.dropMode = (function(_this) {
      return function($element, options) {
        var result;
        result = {
          id: _this.getNewId(),
          element: $element[0],
          move: function(e, draggable) {
            return $rootScope.$apply(function() {
              return typeof options.move === "function" ? options.move(e, draggable) : void 0;
            });
          },
          up: function(e, isHover, draggable) {
            return $rootScope.$apply(function() {
              return typeof options.up === "function" ? options.up(e, isHover, draggable) : void 0;
            });
          },
          out: function(e, draggable) {
            return $rootScope.$apply(function() {
              return typeof options.out === "function" ? options.out(e, draggable) : void 0;
            });
          }
        };
        return result;
      };
    })(this);
    this.draggable = (function(_this) {
      return function($element, options) {
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
    this.droppable = (function(_this) {
      return function($element, options) {
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
    this.get = function($injector) {
      this.setupEasing();
      this.setupProviders($injector);
      return {
        isMouseMoved: this.isMouseMoved,
        data: this.data,
        draggable: this.draggable,
        droppable: this.droppable,
        innerDropHover: this.innerDropHover
      };
    };
    this.get.$inject = ['$injector'];
    this.$get = this.get;
  });

}).call(this);

(function() {
  angular.module('builder', ['builder.directive']);

}).call(this);

(function() {
  angular.module('app', ['builder', 'builder.components', 'validator.rules']).controller('PaginController', [
    '$scope', '$builder', '$validator', function($scope, $builder, $validator) {
      return $scope.pages = [$builder.forms['default']];
    }
  ]);

}).call(this);


/*
	component:
		It is like a class.
		The base components are textInput, textArea, select, check, radio.
		User can custom the form with components.
	formObject:
		It is like an object (an instance of the component).
		User can custom the label, description, required and validation of the input.
	form:
		This is for end-user. There are form groups int the form.
		They can input the value to the form.
 */

(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('builder.provider', []).provider('$builder', function() {
    var $http, $injector, $templateCache;
    $injector = null;
    $http = null;
    $templateCache = null;
    this.config = {
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
    this.convertComponent = function(name, component) {
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
    this.convertFormObject = function(name, formObject) {
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
    this.reindexFormObject = (function(_this) {
      return function(formIndex) {
        var formObjects, index, _i, _ref;
        formObjects = _this.forms[formIndex];
        for (index = _i = 0, _ref = formObjects.length; _i < _ref; index = _i += 1) {
          formObjects[index].index = index;
        }
      };
    })(this);
    this.reindexSectionObject = (function(_this) {
      return function(name, sectionIndex) {
        var index, sectionObjects, _i, _ref;
        sectionObjects = _this.forms[name][sectionIndex].components;
        for (index = _i = 0, _ref = sectionObjects.length; _i < _ref; index = _i += 1) {
          sectionObjects[index].index = index;
        }
      };
    })(this);
    this.setupProviders = (function(_this) {
      return function(injector) {
        $injector = injector;
        $http = $injector.get('$http');
        return $templateCache = $injector.get('$templateCache');
      };
    })(this);
    this.loadTemplate = function(component) {

      /*
      		Load template for components.
      		@param component: {object} The component of $builder.
       */
      if (component.template == null) {
        $http.get(component.templateUrl, {
          cache: $templateCache
        }).success(function(template) {
          return component.template = template;
        });
      }
      if (component.popoverTemplate == null) {
        return $http.get(component.popoverTemplateUrl, {
          cache: $templateCache
        }).success(function(template) {
          return component.popoverTemplate = template;
        });
      }
    };
    this.registerComponent = (function(_this) {
      return function(name, component) {
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
    this.addFormObject = (function(_this) {
      return function(formIndex, formObject) {
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
    this.insertSectionObject = (function(_this) {
      return function(formIndex, sectionIndex, index, formObject) {
        var _base;
        if (formObject == null) {
          formObject = {};
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
        if ((_base = _this.forms[formIndex][sectionIndex]).components == null) {
          _base.components = [];
        }
        if (index > _this.forms[formIndex][sectionIndex].components.length) {
          index = _this.forms[formIndex][sectionIndex].components.length;
        } else if (index < 0) {
          index = 0;
        }
        _this.forms[formIndex][sectionIndex].components.splice(index, 0, _this.convertFormObject(formIndex, formObject));
        _this.reindexSectionObject(formIndex, sectionIndex);
        return _this.forms[formIndex][sectionIndex].components[index];
      };
    })(this);
    this.getSectionObjects = (function(_this) {
      return function(sectionIndex) {
        if (_this.forms[_this.currentForm][sectionIndex]) {
          return _this.forms[_this.currentForm][sectionIndex].components;
        } else {
          return [];
        }
      };
    })(this);
    this.insertFormObject = (function(_this) {
      return function(formIndex, index, formObject) {
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
    this.removeFormObject = (function(_this) {
      return function(formIndex, index) {

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
    this.updateFormObjectIndex = (function(_this) {
      return function(formIndex, oldIndex, newIndex) {

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
    this.$get = [
      '$injector', (function(_this) {
        return function($injector) {
          var component, name, _ref;
          _this.setupProviders($injector);
          _ref = _this.components;
          for (name in _ref) {
            component = _ref[name];
            _this.loadTemplate(component);
          }
          return {
            config: _this.config,
            components: _this.components,
            groups: _this.groups,
            forms: _this.forms,
            currentForm: _this.currentForm,
            broadcastChannel: _this.broadcastChannel,
            registerComponent: _this.registerComponent,
            addFormObject: _this.addFormObject,
            insertFormObject: _this.insertFormObject,
            removeFormObject: _this.removeFormObject,
            updateFormObjectIndex: _this.updateFormObjectIndex,
            getSectionObjects: _this.getSectionObjects,
            insertSectionObject: _this.insertSectionObject
          };
        };
      })(this)
    ];
  });

}).call(this);
