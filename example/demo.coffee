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
					},
					{
						"Item1": "FullPSN",
						"Item2": "1"
					},
					{
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
	"Pages":[
		{
			"Id": "7",
			"Name": null,
			"Title": "Page0",
			"ShowTitle": true,
			"ExtraProperties": {},
			"Elements":[
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
						},
						{
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
								},
								{
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
				},
				{
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
						},
						{
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
								},
								{
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
		},
		{
			"Id": "7",
			"Name": null,
			"Title": "Page0",
			"ShowTitle": true,
			"ExtraProperties": {},
			"Elements":[
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
						},
						{
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
								},
								{
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
}

window.dev = true

window.json = [[{"id":"divider","component":"divider","editable":true,"index":0,"label":"Building elevation A","description":"","placeholder":"","options":[],"required":false,"inline":false,"validation":"/.*/","text":"","header":"","footer":"","align":[],"style":""},{"id":"radio0","component":"radio","editable":true,"index":1,"label":"What is the condition of the sign can?","description":"","placeholder":"placeholder","options":["1","2","3","4","5"],"required":false,"inline":true,"validation":"/.*/","text":"","header":"","footer":"","align":[],"style":""},{"id":"radio1","component":"radio","editable":true,"index":2,"label":"What is the condition of the sign face?","description":"","placeholder":"placeholder","options":["1","2","3","4","5"],"required":false,"inline":true,"validation":"/.*/","text":"","header":"","footer":"","align":[],"style":""},{"id":"radio2","component":"radio","editable":true,"index":3,"label":"Observed while illumination on?","description":"","placeholder":"placeholder","options":["Yes","No"],"required":false,"inline":true,"validation":"/.*/","text":"","header":"","footer":"","align":[],"style":""},{"id":"radio2","component":"radio","editable":true,"index":4,"label":"If yes, were there any problems with illumination?","description":"","placeholder":"placeholder","options":["Yes","No"],"required":false,"inline":true,"validation":"/.*/","text":"","header":"","footer":"","align":[],"style":""}], [{"id":"radio2","component":"radio","editable":true,"index":4,"label":"If yes, were there any problems with illumination?","description":"","placeholder":"placeholder","options":["Yes","No"],"required":false,"inline":true,"validation":"/.*/","text":"","header":"","footer":"","align":[],"style":""}]]

json =  window.json

angular.module 'app', ['builder', 'builder.components', 'validator.rules', 'ngAnimate', 'transcription']

.run ['$builder', '$drag', '$window', '$transcription', ($builder, $drag, $window, $transcription) ->

#	$builder.json = $window.jsonString

#	$builder.config.propertiesPlacement = 'popover'

	config =
		section: true
	$drag.setConfig config

	$builder.json = $transcription.translate($window.jsonString)

#	$builder.registerComponent 'sampleInput',
#		group: 'Additional'
#		label: 'Sample'
#		show_label: yes
#		description: 'From html template'
#		placeholder: 'placeholder'
#		required: no
#		validationOptions: [
#			{label: 'none', rule: '/.*/'}
#			{label: 'number', rule: '[number]'}
#			{label: 'email', rule: '[email]'}
#			{label: 'url', rule: '[url]'}
#		]
#		templateUrl: 'example/template.html'
#		popoverTemplateUrl: 'example/popoverTemplate.html'

	# ----------------------------------------
	# two text input
	# ----------------------------------------
#	$builder.registerComponent 'name',
#		group: 'Default'
#		label: 'Name'
#		required: no
#		arrayToText: yes
#		template:
#			"""
#      <div class="form-group">
#          <label for="{{formName+index}}" class="col-md-4 control-label" ng-class="{'fb-required':required}">{{label}}</label>
#          <div class="col-md-8">
#              <input type='hidden' ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}"/>
#              <div class="col-sm-6" style="padding-left: 0;">
#                  <input type="text"
#                      ng-model="inputArray[0]"
#                      class="form-control" id="{{formName+index}}-0"/>
#                  <p class='help-block'>First name</p>
#              </div>
#              <div class="col-sm-6" style="padding-left: 0;">
#                  <input type="text"
#                      ng-model="inputArray[1]"
#                      class="form-control" id="{{formName+index}}-1"/>
#                  <p class='help-block'>Last name</p>
#              </div>
#          </div>
#      </div>
#      """
#		popoverTemplate:
#			"""
#      <form>
#          <div class="form-group">
#              <label class='control-label'>Label</label>
#              <input type='text' ng-model="label" validator="[required]" class='form-control'/>
#          </div>
#          <div class="checkbox">
#              <label>
#                  <input type='checkbox' ng-model="required" />
#                  Required
#              </label>
#          </div>
#
#          <hr/>
#          <div class='form-group'>
#              <input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
#              <input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
#              <input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
#          </div>
#      </form>
#      """
]



.controller 'DemoController', ['$scope', '$builder', '$validator', ($scope, $builder, $validator) ->
# ----------------------------------------
# builder
# ----------------------------------------


#	textbox = $builder.addFormObject 'default',
#		id: 'textbox'
#		component: 'textInput'
#		label: 'Name'
#		description: 'Your name'
#		placeholder: 'Your name'
#		required: yes
#   editable: no

#	$scope.oneAtATime = true
#	$scope.groups = [
#		{
#			title: 'Dynamic Group Header - 1'
#			content: 'Dynamic Group Body - 1'
#		}
#		{
#			title: 'Dynamic Group Header - 2'
#			content: 'Dynamic Group Body - 2'
#		}
#	]
#	$scope.items = [
#		'Item 1'
#		'Item 2'
#		'Item 3'
#	]

#	$scope.addItem = ->
#		newItemNo = $scope.items.length + 1
#		$scope.items.push 'Item ' + newItemNo
#		return
#
#	$scope.status =
#		isCustomHeaderOpen: false
#		isFirstOpen: true
#		isFirstDisabled: false
#
#	$scope.pages = []


	$builder.json.map((page, pageIndex)=>
		page.map((component) =>
			$builder.addFormObject pageIndex, component
		)
	)

	###divider = $builder.addFormObject 'default',
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
###

	###	divider = $builder.addFormObject 'default',
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
###


	#    $builder.addFormObject 'default',
	#        component: 'sampleInput'
	# formObjects
#	$scope.form = $builder.forms[$builder.currentForm]
	$scope.jsonString = $builder.forms

	# ----------------------------------------
	# form
	# ----------------------------------------
	# user input value
#	$scope.input = []
#	$scope.defaultValue = {}
	# formObjectId: default value
#	$scope.defaultValue[textbox.id] = 'default value'
#	$scope.defaultValue[checkbox.id] = [yes, yes]

	$scope.submit = ->
		$validator.validate $scope, 'default'
		.success -> console.log 'success'
		.error -> console.log 'error'
]