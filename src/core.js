var form = null;
var path = null;

(function() {
    form = window.formModel;
    path = window.controller;
    if (path === null)
        path = '';

    window.dev = true;

    angular.module('app', ['builder', 'builder.components', 'validator.rules', 'ngAnimate', 'transcription', 'formService', 'ngRoute'])

        .constant("appSettings", {
            "apiUrl": "http://louise.sunbay-ukraine.com:4000/Mpa/FormDesigner"
        })
        .run([
            '$builder', '$drag', '$window', '$transcription', '$routeParams', '$formService', '$rootScope',
            function($builder, $drag, $window, $transcription, $routeParams, $formService, $rootScope) {
                var config;
                config = { section: true };
                $drag.setConfig(config);

                var parentId    = $routeParams.parentId || 1,
                    id          = $routeParams.id;

                $formService.getForm(parentId, id)
                    .then(function(res) {
                        console.log('RESPONSE: ', res);

                        var formData = res.data ? res.data.result : {};

                        $builder.receivedForm = formData;
                        $builder.formData = $transcription.getFormData(formData);
                        $builder.json = $transcription.translate(formData);
                        $rootScope.pages = $builder.json;

                        $builder.json.map((function(_this) {
                            return function(page, pageIndex) {
                                return page["elements"].map(function(component) {
                                    return $builder.addFormObject(pageIndex, component);
                                });
                            };
                        })(this));
                    }, function(err) {
                        console.log('ERROR: ', err);
                    })
            }
        ])
        .controller('DemoController', [
            '$scope', '$builder', '$validator', '$location', '$routeParams', '$formService', '$transcription',
            function($scope, $builder, $validator, $location, $routeParams, $formService, $transcription) {

                $scope.jsonString = $builder.forms;

                $scope.submit = function() {
                    return $validator.validate($scope, 'default').success(function() {

                        if($builder.receivedForm) {
                            var form = $transcription.translateBackwards($builder.receivedForm, $builder.forms);
                            $formService.saveForm(form);

                        } else {
                            alert('Server Error')
                        }
                    }).error(function() {
                        return console.log('error');
                    });
                };
            }
        ]);

}).call(this);