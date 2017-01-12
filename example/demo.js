(function() {
  angular.module('app', ['builder', 'builder.components', 'validator.rules']).run([
    '$builder', function($builder) {
      return $builder.registerComponent('sampleInput', {
        group: 'Additional',
        label: 'Sample',
        description: 'From html template',
        placeholder: 'placeholder',
        required: false,
        validationOptions: [
          {
            label: 'none',
            rule: '/.*/'
          }, {
            label: 'number',
            rule: '[number]'
          }, {
            label: 'email',
            rule: '[email]'
          }, {
            label: 'url',
            rule: '[url]'
          }
        ],
        templateUrl: 'example/template.html',
        popoverTemplateUrl: 'example/popoverTemplate.html'
      });
    }
  ]).controller('DemoController', [
    '$scope', '$builder', '$validator', function($scope, $builder, $validator) {
      var divider, radio;
      $scope.pages = [];
      divider = $builder.addFormObject('default', {
        id: 'divider',
        component: 'divider',
        label: 'Building elevation A'
      });
      radio = $builder.addFormObject('default', {
        id: 'radio0',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign can?',
        description: '',
        options: ['1', '2', '3', '4', 5]
      });
      radio = $builder.addFormObject('default', {
        id: 'radio1',
        component: 'radio',
        inline: true,
        label: 'What is the condition of the sign face?',
        description: '',
        options: [1, 2, 3, 4, 5]
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'Observed while illumination on?',
        description: '',
        options: ['Yes', 'No']
      });
      radio = $builder.addFormObject('default', {
        id: 'radio2',
        component: 'radio',
        inline: true,
        label: 'If yes, were there any problems with illumination?',
        description: '',
        options: ['Yes', 'No']
      });

      /*	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Building elevation B'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign can?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Building elevation C'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign can?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      
      
      	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Building elevation D'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign can?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      
      	divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Site signage'
      	radio = $builder.addFormObject 'default',
      		id: 'radio0'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign support?'
      		description: ''
      		options: ['1', '2', '3', '4', 5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio1'
      		component: 'radio'
      		inline: yes
      		label: 'What is the condition of the sign face?'
      		description: ''
      		options: [1,2,3,4,5]
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'Observed while illumination on?'
      		description: ''
      		options: ['Yes', 'No']
      	radio = $builder.addFormObject 'default',
      		id: 'radio2'
      		component: 'radio'
      		inline: yes
      		label: 'If yes, were there any problems with illumination?'
      		description: ''
      		options: ['Yes', 'No']
      	button = $builder.addFormObject 'default',
      		id: 'button'
      		component: 'button'
      		label: 'ADD A SIGN'
      		description: 'primary'
       */
      $scope.form = $builder.forms['default'];
      $scope.input = [];
      $scope.defaultValue = {};
      return $scope.submit = function() {
        return $validator.validate($scope, 'default').success(function() {
          return console.log('success');
        }).error(function() {
          return console.log('error');
        });
      };
    }
  ]);

}).call(this);
