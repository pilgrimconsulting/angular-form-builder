(function() {
  var json;

  window.jsonString = {
    "Id": "12",
    "Name": null,
    "Title": "input",
    "ShowTitle": true,
    "Description": "FormDescription",
    "Instructions": "FormInstructions",
    "ExtraProperiesDef": {
      "Form": [
        {
          "Title": "Company Program Id",
          "Name": "CompanyProgramId",
          "Type": "Int64",
          "ReadOnly": true,
          "Hidden": true
        }
      ],
      "Page": [],
      "Section": [
        {
          "Title": "Branding Package Type",
          "Name": "BrandingPackageType",
          "Type": "Int32",
          "ReadOnly": false,
          "Hidden": false,
          "Variants": [
            {
              "Item1": "Default",
              "Item2": "0"
            }, {
              "Item1": "FullPSN",
              "Item2": "1"
            }, {
              "Item1": "NAVOnly",
              "Item2": "2"
            }
          ]
        }
      ],
      "Item": []
    },
    "ExtraProperties": {
      "CompanyProgramId": {
        "Name": "CompanyProgramId",
        "Value": "1"
      }
    },
    "Pages": [
      {
        "Id": "7",
        "Name": null,
        "Title": "Page0",
        "ShowTitle": true,
        "ExtraProperties": {},
        "Elements": [
          {
            "Id": "7",
            "Name": null,
            "Title": "Section00",
            "ShowTitle": true,
            "IsMultipleSection": false,
            "ExtraProperties": {
              "BrandingPackageType": {
                "Name": "BrandingPackageType",
                "Value": 1
              }
            },
            "Items": [
              {
                "Id": "3",
                "Name": "input000",
                "Title": "Input000",
                "ShowTitle": true,
                "ExtraProperties": {},
                "Description": "InputDesc",
                "InputType": "Text",
                "IsRequired": false,
                "VisibilityConditions": ""
              }, {
                "Id": "4",
                "Name": "input001",
                "Title": "Input001",
                "ShowTitle": true,
                "ExtraProperties": {},
                "Description": "InputDesc",
                "InputType": "DropDown",
                "IsRequired": false,
                "VisibilityConditions": "",
                "IsMultipleSelection": false,
                "Variants": [
                  {
                    "Id": "5",
                    "Name": "var1",
                    "Title": "Variant 1",
                    "ShowTitle": true,
                    "ExtraProperties": {},
                    "Value": "1"
                  }, {
                    "Id": "6",
                    "Name": "var2",
                    "Title": "Variant 2",
                    "ShowTitle": true,
                    "ExtraProperties": {},
                    "Value": "2"
                  }
                ]
              }
            ]
          }, {
            "Id": "7",
            "Name": null,
            "Title": "Section01",
            "ShowTitle": true,
            "IsMultipleSection": false,
            "ExtraProperties": {
              "BrandingPackageType": {
                "Name": "BrandingPackageType",
                "Value": 1
              }
            },
            "Items": [
              {
                "Id": "3",
                "Name": "input002",
                "Title": "Input002",
                "ShowTitle": true,
                "ExtraProperties": {},
                "Description": "InputDesc",
                "InputType": "Text",
                "IsRequired": false,
                "VisibilityConditions": ""
              }, {
                "Id": "4",
                "Name": "input003",
                "Title": "Input003",
                "ShowTitle": true,
                "ExtraProperties": {},
                "Description": "InputDesc",
                "InputType": "DropDown",
                "IsRequired": false,
                "VisibilityConditions": "",
                "IsMultipleSelection": false,
                "Variants": [
                  {
                    "Id": "5",
                    "Name": "var1",
                    "Title": "Variant 1",
                    "ShowTitle": true,
                    "ExtraProperties": {},
                    "Value": "1"
                  }, {
                    "Id": "6",
                    "Name": "var2",
                    "Title": "Variant 2",
                    "ShowTitle": true,
                    "ExtraProperties": {},
                    "Value": "2"
                  }
                ]
              }
            ]
          }
        ]
      }, {
        "Id": "7",
        "Name": null,
        "Title": "Page0",
        "ShowTitle": true,
        "ExtraProperties": {},
        "Elements": [
          {
            "Id": "7",
            "Name": null,
            "Title": "Section10",
            "ShowTitle": true,
            "IsMultipleSection": false,
            "ExtraProperties": {
              "BrandingPackageType": {
                "Name": "BrandingPackageType",
                "Value": 1
              }
            },
            "Items": [
              {
                "Id": "3",
                "Name": "input010",
                "Title": "Input010",
                "ShowTitle": true,
                "ExtraProperties": {},
                "Description": "InputDesc",
                "InputType": "Text",
                "IsRequired": false,
                "VisibilityConditions": ""
              }, {
                "Id": "4",
                "Name": "input011",
                "Title": "Input011",
                "ShowTitle": true,
                "ExtraProperties": {},
                "Description": "InputDesc",
                "InputType": "DropDown",
                "IsRequired": false,
                "VisibilityConditions": "",
                "IsMultipleSelection": false,
                "Variants": [
                  {
                    "Id": "5",
                    "Name": "var1",
                    "Title": "Variant 1",
                    "ShowTitle": true,
                    "ExtraProperties": {},
                    "Value": "1"
                  }, {
                    "Id": "6",
                    "Name": "var2",
                    "Title": "Variant 2",
                    "ShowTitle": true,
                    "ExtraProperties": {},
                    "Value": "2"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  };

  window.dev = true;

  window.json = [
    [
      {
        "id": "divider",
        "component": "divider",
        "editable": true,
        "index": 0,
        "label": "Building elevation A",
        "description": "",
        "placeholder": "",
        "options": [],
        "required": false,
        "inline": false,
        "validation": "/.*/",
        "text": "",
        "header": "",
        "footer": "",
        "align": [],
        "style": ""
      }, {
        "id": "radio0",
        "component": "radio",
        "editable": true,
        "index": 1,
        "label": "What is the condition of the sign can?",
        "description": "",
        "placeholder": "placeholder",
        "options": ["1", "2", "3", "4", "5"],
        "required": false,
        "inline": true,
        "validation": "/.*/",
        "text": "",
        "header": "",
        "footer": "",
        "align": [],
        "style": ""
      }, {
        "id": "radio1",
        "component": "radio",
        "editable": true,
        "index": 2,
        "label": "What is the condition of the sign face?",
        "description": "",
        "placeholder": "placeholder",
        "options": ["1", "2", "3", "4", "5"],
        "required": false,
        "inline": true,
        "validation": "/.*/",
        "text": "",
        "header": "",
        "footer": "",
        "align": [],
        "style": ""
      }, {
        "id": "radio2",
        "component": "radio",
        "editable": true,
        "index": 3,
        "label": "Observed while illumination on?",
        "description": "",
        "placeholder": "placeholder",
        "options": ["Yes", "No"],
        "required": false,
        "inline": true,
        "validation": "/.*/",
        "text": "",
        "header": "",
        "footer": "",
        "align": [],
        "style": ""
      }, {
        "id": "radio2",
        "component": "radio",
        "editable": true,
        "index": 4,
        "label": "If yes, were there any problems with illumination?",
        "description": "",
        "placeholder": "placeholder",
        "options": ["Yes", "No"],
        "required": false,
        "inline": true,
        "validation": "/.*/",
        "text": "",
        "header": "",
        "footer": "",
        "align": [],
        "style": ""
      }
    ], [
      {
        "id": "radio2",
        "component": "radio",
        "editable": true,
        "index": 4,
        "label": "If yes, were there any problems with illumination?",
        "description": "",
        "placeholder": "placeholder",
        "options": ["Yes", "No"],
        "required": false,
        "inline": true,
        "validation": "/.*/",
        "text": "",
        "header": "",
        "footer": "",
        "align": [],
        "style": ""
      }
    ]
  ];

  json = window.json;

  angular.module('app', ['builder', 'builder.components', 'validator.rules', 'ngAnimate', 'transcription']).run([
    '$builder', '$window', '$transcription', function($builder, $window, $transcription) {
      return $builder.json = $transcription.translate($window.jsonString);
    }
  ]).controller('DemoController', [
    '$scope', '$builder', '$validator', function($scope, $builder, $validator) {
      $builder.json.map((function(_this) {
        return function(page, pageIndex) {
          return page.map(function(component) {
            return $builder.addFormObject(pageIndex, component);
          });
        };
      })(this));

      /*divider = $builder.addFormObject 'default',
      		id: 'divider'
      		component: 'divider'
      		label: 'Building elevation A'
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
       */

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
      $scope.jsonString = $builder.forms;
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

//# sourceMappingURL=demo.js.map
