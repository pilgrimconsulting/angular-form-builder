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
            "apiUrl": "http://formbuilder.sunbay-ukraine.com/Mpa/FormDesigner"
        })
        .run([
            '$builder', '$drag', '$window', '$transcription', '$routeParams', '$formService', '$rootScope',
            function($builder, $drag, $window, $transcription, $routeParams, $formService, $rootScope) {
                var config;
                config = { section: true };
                $drag.setConfig(config);

                var parentId    = $routeParams.parentId || 1,
                    id          = $routeParams.id;

                //console.log(parentId, id);

                $formService.getForm(parentId, id)
                    .then(function(res) {
                        var formData = res.data ? res.data : {};

                        //console.log('FORM: ', formData);

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

var btnSaveClick = function () {
    debugger;
    $.ajax({
        url: path + 'GetMock',
        type: 'GET',
        contentType: "application/json; charset=utf-8",
        success: function (data) {
            debugger;
            $.ajax({
                url: path + 'Save',
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                data: JSON.stringify(data),
                success: function (data) {
                    window.location = path + data.result;
                }
            });
        }
    });

}