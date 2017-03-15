'use strict';

angular.module('formService', [])
    .service('$formService',
    [ '$http', 'appSettings', function ($http, appSettings) {
        this.getForm = (function () {
            return function(parentId, id) {
                var parentIdParam   = parentId ? '?parentId=' + parentId : '',
                    idParam         = id ? '&id=' + id : '';

                return $http({
                    method: 'GET',
                    url:  appSettings.apiUrl + parentIdParam + idParam
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
            return function(data, parentId, id) {

                console.log('TEST: ', parentId, id);

                return $http({
                    method: 'POST',
                    url:  appSettings.apiUrl + 'Save'
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