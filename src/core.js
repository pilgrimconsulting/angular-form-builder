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
            "apiUrl": "http://louise.sunbay-ukraine.com:4000/Mpa/FormDesigner/Get"
        })
        .run([
            '$builder', '$drag', '$window', '$transcription', '$routeParams', '$formService', '$rootScope',
            function($builder, $drag, $window, $transcription, $routeParams, $formService, $rootScope) {
                var config;
                config = { section: false };
                $drag.setConfig(config);

                var parentId    = $routeParams.parentId || 1,
                    id          = $routeParams.id;

                $formService.getForm(parentId, id)
                    .then(function(res) {
                        var formData = res.data.result;

                        $builder.formData = $transcription.getFormData(formData);
                        $builder.json = $transcription.translate(formData);
                        $rootScope.pages = $builder.json;

                        console.log('FORM: ', $builder.json);

                        $builder.json.map((function(_this) {
                            return function(page, pageIndex) {
                                return page.map(function(component) {
                                    return $builder.addFormObject(pageIndex, component);
                                });
                            };
                        })(this));
                    }, function(err) {
                        console.log(err);
                    })
            }
        ])
        .controller('DemoController', [
            '$scope', '$builder', '$validator', '$location', '$routeParams', '$formService', '$transcription', '$window',
            function($scope, $builder, $validator, $location, $routeParams, $formService, $transcription, $window) {

                $scope.jsonString = $builder.forms;

                $scope.submit = function() {
                    return $validator.validate($scope, 'default').success(function() {
                        //TODO: There will be save form functionality.
                        //$transcription.translateBackwards($window.jsonString.result, $builder.forms);

                        return console.log('success');
                    }).error(function() {
                        return console.log('error');
                    });
                };
            }
        ]);

}).call(this);