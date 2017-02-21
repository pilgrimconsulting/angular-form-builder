angular.module('app', ['builder', 'builder.components', 'validator.rules']).controller('PaginController', [
    '$scope', '$builder', '$validator', function ($scope, $builder, $validator) {
        return $scope.pages = [$builder.forms['default']];
    }
]);