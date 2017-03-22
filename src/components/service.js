'use strict';

angular.module('formService', [])
    .service('$formService',
    [ '$http', 'appSettings', function ($http, appSettings) {
        this.getForm = (function () {
            return function(parentId, id) {
                var parentIdParam   = '?parentId=' + (parentId ? parentId : 1),
                    idParam         = id ? '&id=' + id : ''; //'&id=' + 4

                console.log(parentIdParam, idParam);

                return $http({
                    method: 'GET',
                    url:  appSettings.apiUrl + '/Get' + parentIdParam + idParam
                })
                    .then(function (response) {
                        return response;
                    }, function (errResponse) {
                        return errResponse;
                    })
                    .finally(function () {

                    });
            }
        })(this);

        this.saveForm = (function () {
            return function(data) {

                console.log('TEST: ', data);

                return $http({
                    method: 'POST',
                    url:  appSettings.apiUrl + '/Save',
                    data: data
                })
                    .then(function (response) {
                        console.log('Res: ', response);

                        return response;
                    }, function (errResponse) {
                        console.log('Res: ', errResponse);

                        return errResponse;
                    })
                    .finally(function () {

                    });
            }
        })(this);

        this.$get = [
            '$injector', (function (_this) {
                return function () {
                    return {
                        getForm: _this.getForm,
                        saveForm: _this.saveForm
                    };
                };
            })(this)
        ];
    }]);