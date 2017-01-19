# ----------------------------------------
# Shared functions
# ----------------------------------------
copyObjectToScope = (object, scope) ->
	###
	Copy object (ng-repeat="object in objects") to scope without `hashKey`.
	###
	for key, value of object when key isnt '$$hashKey'
# copy object.{} to scope.{}
		scope[key] = value
	return


# ----------------------------------------
# builder.controller
# ----------------------------------------
angular.module 'builder.controller', ['builder.provider']

# ----------------------------------------
# fbFormObjectEditableController
# ----------------------------------------
.controller 'fbFormObjectEditableController', ['$scope', '$injector', ($scope, $injector) ->
	$builder = $injector.get '$builder'

	$scope.setupScope = (formObject) ->
		###
		1. Copy origin formObject (ng-repeat="object in formObjects") to scope.
		2. Setup optionsText with formObject.options.
		3. Watch scope.label, .show_label .description, .placeholder, .required, .inline, .options then copy to origin formObject.
		4. Watch scope.optionsText then convert to scope.options.
		5. setup validationOptions
		###
		copyObjectToScope formObject, $scope

		$scope.optionsText = formObject.options.join '\n'

		$scope.$watch '[label, show_label, description, placeholder, required, inline, options, validation, text, header,
 footer, align, style]', ->
			formObject.label = $scope.label
			formObject.show_label = $scope.show_label
			formObject.description = $scope.description
			formObject.placeholder = $scope.placeholder
			formObject.required = $scope.required
			formObject.inline = $scope.inline
			formObject.options = $scope.options
			formObject.validation = $scope.validation
			formObject.text = $scope.text
			formObject.header = $scope.header
			formObject.footer = $scope.footer
			formObject.align = $scope.align
			formObject.style = $scope.style
		, yes

		$scope.$watch 'optionsText', (text) ->
			$scope.options = (x for x in text.split('\n') when x.length > 0)
			$scope.inputText = $scope.options[0]

		component = $builder.components[formObject.component]
		$scope.validationOptions = component.validationOptions

	$scope.data =
		model: null
		backup: ->
			###
			Backup input value.
			###
			@model =
				label: $scope.label
				show_label: $scope.show_label
				description: $scope.description
				placeholder: $scope.placeholder
				required: $scope.required
				inline: $scope.inline
				optionsText: $scope.optionsText
				validation: $scope.validation
				text: $scope.text
				header: $scope.header
				footer: $scope.footer
				align: $scope.align
				style: $scope.style
		rollback: ->
			###
			Rollback input value.
			###
			return if not @model
			$scope.label = @model.label
			$scope.show_label = @model.show_label
			$scope.description = @model.description
			$scope.placeholder = @model.placeholder
			$scope.required = @model.required
			$scope.inline = @model.inline
			$scope.optionsText = @model.optionsText
			$scope.validation = @model.validation
			$scope.text = @model.text
			$scope.header = @model.header
			$scope.footer = @model.footer
			$scope.align = @model.align
			$scope.style = @model.style
]


# ----------------------------------------
# fbComponentsController
# ----------------------------------------
.controller 'fbComponentsController', ['$scope', '$injector', ($scope, $injector) ->
# providers
	$builder = $injector.get '$builder'

	# action
	$scope.selectGroup = ($event, group) ->
		$event?.preventDefault()
		$scope.activeGroup = group
		$scope.components = []
		for name, component of $builder.components when component.group is group
			$scope.components.push component

	$scope.addComponentToEnd = ($event, component) ->
		$event?.preventDefault()
		console.log(component.group, component.name)
		$builder.addFormObject( $builder.currentForm || 0,
			component: component.name
		)

	$scope.groups = $builder.groups
	$scope.activeGroup = $scope.groups[0]
	$scope.allComponents = $builder.components
	$scope.$watch 'allComponents', -> $scope.selectGroup null, $scope.activeGroup
]


# ----------------------------------------
# fbComponentController
# ----------------------------------------
.controller 'fbComponentController', ['$scope', ($scope) ->
	$scope.copyObjectToScope = (object) -> copyObjectToScope object, $scope
]


# ----------------------------------------
# fbFormController
# ----------------------------------------
.controller 'fbFormController', ['$scope', '$injector', ($scope, $injector) ->
# providers
	$builder = $injector.get '$builder'
	$timeout = $injector.get '$timeout'

	$scope.currentForm = $builder.currentForm
	# set default for input
	$scope.input ?= []
	$scope.$watch 'form', ->
# remove superfluous input
		if $scope.input.length > $scope.form.length
			$scope.input.splice $scope.form.length
		# tell children to update input value.
		# ! use $timeout for waiting $scope updated.
		$timeout ->
			$scope.$broadcast $builder.broadcastChannel.updateInput
	, yes

]


# ----------------------------------------
# fbFormObjectController
# ----------------------------------------
.controller 'fbFormObjectController', ['$scope', '$injector', ($scope, $injector) ->
# providers
	$builder = $injector.get '$builder'

	$scope.copyObjectToScope = (object) -> copyObjectToScope object, $scope

	$scope.updateInput = (value) ->
		###
		Copy current scope.input[X] to $parent.input.
		@param value: The input value.
		###
		input =
			id: $scope.formObject.id
			label: $scope.formObject.label
			show_label: $scope.formObject.show_label
			value: value ? ''
		$scope.$parent.input.splice $scope.$index, 1, input
]

# ----------------------------------------
# PaginationController
# ----------------------------------------
.controller 'PaginationController', ['$scope', '$injector', ($scope, $injector) ->
# providers
	$builder = $injector.get '$builder'
	console.log($builder.forms)

#	$scope.pages = []
#	$scope.pages = $builder.forms
#	$scope.currentPage = $builder.currentForm
#	$scope.pageCount = 0
	$scope.prev = false
	$scope.next = false

	$scope.updatePage = () ->
		console.log('update')
		count = 0
		forms = $builder.forms
		if typeof forms.length == 'number'
			count = forms.length
		else
			for page of forms
				# console.log(page)
				if (forms.hasOwnProperty(page))
					++count
		$scope.pageCount = count
		$scope.pages = forms
		$scope.currentPage = $builder.currentForm
#		$scope.fbBuilder = $builder.currentForm
		$scope.prev = if ($builder.currentForm > 0) then true else false
		$scope.next = if ($scope.pageCount > ($builder.currentForm+1)) then true else false

#	$scope.$watch 'forms', ->
#		$scope.updatePage()
#		console.log('Change Count')
#	, yes

	$scope.addPage = (pageCount) ->
#		$event?.preventDefault()
		$builder.forms[$scope.pageCount] = []
#		console.log(pageCount, $scope.pageCount, $builder.forms)
		$scope.updatePage()

	$scope.deletePage = (pageNumber) ->
		forms = $builder.forms
		current = if forms[pageNumber+1] then pageNumber+1 else pageNumber-1
		console.log(pageNumber, forms, current)
#		$builder.currentForm = current
#		$scope.goPage(current)
#		$scope.currentPage =  current
#		$scope.current =  current
#		$scope.updatePage()
		if typeof forms.length == 'number' #if Array
			forms.splice(pageNumber, 1)
		else #if Object
			delete forms[pageNumber]
			for page, pageObj of forms
				if page > pageNumber
					forms[page - 1] = forms[page]
			delete forms[$scope.pageCount - 1]
#		$scope.currentPage = if pageNumber then pageNumber else 0
		$builder.currentForm = if current > pageNumber then pageNumber else current
#		$scope.updatePage()
#		console.log($builder.currentForm, current)
		$scope.currentPage = false
		$scope.currentPage = pageNumber

	$scope.goPage = (page) ->
		console.log('GO PAGE',page,$builder.currentForm,$builder.forms)
#		return false if page == $builder.currentForm
		if $builder.forms[page]
			$builder.currentForm = page
			$scope.updatePage()
			true
		else
			false

	$scope.goF = () ->
		pageNumber = $builder.currentForm + 1
		$scope.goPage(pageNumber)

	$scope.goB = () ->
		pageNumber = $builder.currentForm - 1
		$scope.goPage(pageNumber)

	$scope.updatePage()
]