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

  angular.module('app', ['builder', 'builder.components', 'validator.rules', 'ngAnimate', 'transcription']).run([
    '$builder', '$drag', '$window', '$transcription', function($builder, $drag, $window, $transcription) {
      var config;
      config = {
        section: true
      };
      $drag.setConfig(config);
      $builder.formData = $transcription.getFormData($window.jsonString);
      return $builder.json = $transcription.translate($window.jsonString);
    }
  ]).controller('DemoController', [
    '$scope', '$builder', '$validator', '$transcription','$window', function($scope, $builder, $validator, $transcription, $window) {
      $builder.json.map((function(_this) {
        return function(page, pageIndex) {
          return page.map(function(component) {
            return $builder.addFormObject(pageIndex, component);
          });
        };
      })(this));

      $scope.jsonString = $builder.forms;
      return $scope.submit = function() {
        return $validator.validate($scope, 'default')
            .success(function() {
                var jsonData = $transcription.translateBackwards($window.jsonString, $builder.forms);

                console.log(jsonData);

                return console.log('success');
            })
            .error(function() {
              return console.log('error');
            });
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=demo.js.map
