###
	component:
		It is like a class.
		The base components are textInput, textArea, select, check, radio.
		User can custom the form with components.
	formObject:
		It is like an object (an instance of the component).
		User can custom the label, description, required and validation of the input.
	form:
		This is for end-user. There are form groups int the form.
		They can input the value to the form.
###

angular.module 'builder.provider', []

.provider '$builder', ->
	$injector = null
	$http = null
	$templateCache = null

	@config =
		section: true
		propertiesPlacement: 'sidebar' # 'popover' || 'sidebar'
		popoverPlacement: 'right'
	# all components
	@components = {}
	# all groups of components
	@groups = []
	@broadcastChannel =
		updateInput: '$updateInput'

	# forms
	#   builder mode: `fb-builder` you could drag and drop to build the form.
	#   form mode: `fb-form` this is the form for end-user to input value.
	# Variant with Object - Associative array (Object {0,1..})
#	@defaultForm = 0
	@currentForm = 0
#	@forms = {}
#	@forms[@defaultForm] = []
	# old Variant
#	@forms =
#		0: []
	# Variant with Associative array of arrays ( [[...], [...]] )
	@forms = []
	@forms['0'] = []


	# ----------------------------------------
	#	Options
	# ----------------------------------------
	@simplePreview = false
	@simpleComponentView = true


	# ----------------------------------------
	# private functions
	# ----------------------------------------
	@convertComponent = (name, component) ->
		result =
			name: name
			group: component.group ? 'Default'
			label: component.label ? ''
			show_label: component.show_label ? yes
			description: component.description ? ''
			placeholder: component.placeholder ? ''
			text: component.text ? ''
			header: component.header ? ''
			footer: component.footer ? ''
			style: component.style ? ''
			editable: component.editable ? yes
			required: component.required ? no
			inline: component.inline ? no
			validation: component.validation ? '/.*/'
			validationOptions: component.validationOptions ? []
			options: component.options ? []
			align: component.align ? []
			arrayToText: component.arrayToText ? no
			template: component.template
			templateUrl: component.templateUrl
			popoverTemplate: component.popoverTemplate
			popoverTemplateUrl: component.popoverTemplateUrl
			components: component.components ? []
		if not result.template and not result.templateUrl
			console.error "The template is empty."
		if not result.popoverTemplate and not result.popoverTemplateUrl
			console.error "The popoverTemplate is empty."
		result

	@convertFormObject = (name, formObject={}) ->
		component = @components[formObject.component]
		throw "The component #{formObject.component} was not registered." if not component?
		result =
			id: formObject.id
			component: formObject.component
			editable: formObject.editable ? component.editable
			index: formObject.index ? 0
			label: formObject.label ? component.label
			show_label: formObject.show_label ? component.show_label
			description: formObject.description ? component.description
			placeholder: formObject.placeholder ? component.placeholder
			options: formObject.options ? component.options
			required: formObject.required ? component.required
			inline: formObject.inline ? component.inline
			validation: formObject.validation ? component.validation
			text: formObject.text ? component.text
			header: formObject.header ? component.header
			footer: formObject.footer ? component.footer
			align: formObject.align ? component.align
			style: formObject.style ? component.style
			components: formObject.components ? component.components
		result

	@reindexFormObject = (formIndex) =>
		formObjects = @forms[formIndex]
		for index in [0...formObjects.length] by 1
			formObjects[index].index = index
		return

	@reindexSectionObject = (name, sectionIndex) =>
		sectionObjects = @forms[name][sectionIndex].components
		for index in [0...sectionObjects.length] by 1
			sectionObjects[index].index = index
		return

	@setupProviders = (injector) =>
		$injector = injector
		$http = $injector.get '$http'
		$templateCache = $injector.get '$templateCache'

	@loadTemplate = (component) ->
		###
		Load template for components.
		@param component: {object} The component of $builder.
		###
		if not component.template?
			$http.get component.templateUrl,
				cache: $templateCache
			.success (template) ->
				component.template = template
		if not component.popoverTemplate?
			$http.get component.popoverTemplateUrl,
				cache: $templateCache
			.success (template) ->
				component.popoverTemplate = template

	# ----------------------------------------
	# public functions
	# ----------------------------------------
	@registerComponent = (name, component={}) =>
		###
		Register the component for form-builder.
		@param name: The component name.
		@param component: The component object.
			group: {string} The component group.
			label: {string} The label of the input.
			description: {string} The description of the input.
			placeholder: {string} The placeholder of the input.
			editable: {bool} Is the form object editable?
			required: {bool} Is the form object required?
			inline: {bool} Is the form object inline?
			validation: {string} angular-validator. "/regex/" or "[rule1, rule2]". (default is RegExp(.*))
			validationOptions: {array} [{rule: angular-validator, label: 'option label'}] the options for the validation. (default is [])
			options: {array} The input options.
			arrayToText: {bool} checkbox could use this to convert input (default is no)
			template: {string} html template
			templateUrl: {string} The url of the template.
			popoverTemplate: {string} html template
			popoverTemplateUrl: {string} The url of the popover template.
		###
		if not @components[name]?
			# regist the new component
			newComponent = @convertComponent name, component
			@components[name] = newComponent
			@loadTemplate(newComponent) if $injector?
			if newComponent.group not in @groups
				@groups.push newComponent.group
		else
			console.error "The component #{name} was registered."
		return

	@addFormObject = (formIndex, formObject={}) =>
		###
		Insert the form object into the form at last.
		###
		@forms[formIndex] ?= []
		@insertFormObject formIndex, @forms[formIndex].length, formObject


	@insertFormObject = (formIndex, index, formObject={}) =>
		###
		Insert the form object into the form at {index}.
		@param formIndex: The form formIndex.
		@param index: The form object index.
		@param form: The form object.
			id: The form object id.
			component: {string} The component name
			editable: {bool} Is the form object editable? (default is yes)
			label: {string} The form object label.
			description: {string} The form object description.
			placeholder: {string} The form object placeholder.
			options: {array} The form object options.
			required: {bool} Is the form object required? (default is no)
			inline: {bool} Is the form object inline? (default is no)
			validation: {string} angular-validator. "/regex/" or "[rule1, rule2]".
			[index]: {int} The form object index. It will be updated by $builder.
		@return: The form object.
		###
		@forms[formIndex] ?= []
		if index > @forms[formIndex].length then index = @forms[formIndex].length
		else if index < 0 then index = 0
		@forms[formIndex].splice index, 0, @convertFormObject(formIndex, formObject)
		@reindexFormObject formIndex
		@forms[formIndex][index]

	@removeFormObject = (formIndex, index) =>
		###
		Remove the form object by the index.
		@param formIndex: The form formIndex.
		@param index: The form object index.
		###
		formObjects = @forms[formIndex]
		formObjects.splice index, 1
		@reindexFormObject formIndex

	@updateFormObjectIndex = (formIndex, oldIndex, newIndex) =>
		###
		Update the index of the form object.
		@param formIndex: The form formIndex.
		@param oldIndex: The old index.
		@param newIndex: The new index.
		###
		return if oldIndex is newIndex
		formObjects = @forms[formIndex]
		formObject = formObjects.splice(oldIndex, 1)[0]
		formObjects.splice newIndex, 0, formObject
		@reindexFormObject formIndex


	###Sections###

	@getSectionObjects = (sectionIndex, formIndex = @currentForm) =>
		console.log('@getSectionObjects',sectionIndex,formIndex,@forms[formIndex][sectionIndex].components)
		if @forms[formIndex][sectionIndex]
			@forms[formIndex][sectionIndex].components
		else []

	@insertSectionObject = ( formIndex, sectionIndex, index, formObject={}) =>
		###
		Insert the form object into the form at {index}.
		@param  formIndex: The form  formIndex.
		@param index: The form object index.
		@param form: The form object.
			id: The form object id.
			component: {string} The component name
			editable: {bool} Is the form object editable? (default is yes)
			label: {string} The form object label.
			description: {string} The form object description.
			placeholder: {string} The form object placeholder.
			options: {array} The form object options.
			required: {bool} Is the form object required? (default is no)
			inline: {bool} Is the form object inline? (default is no)
			validation: {string} angular-validator. "/regex/" or "[rule1, rule2]".
			[index]: {int} The form object index. It will be updated by $builder.
		@return: The form object.
		###
		section = @forms[formIndex][sectionIndex]
		console.log(formIndex, sectionIndex, '=====')
		section.components ?= []
		if index > section.components.length then index = section.components.length
		else if index < 0 then index = 0
		section.components.splice index, 0, @convertFormObject(formIndex, formObject)
		@reindexSectionObject formIndex, sectionIndex
		section.components[index]

	@removeSectionObject = (formIndex = @currentForm, sectionIndex, index) =>
		###
		Remove the form object by the index.
		@param formIndex: The form formIndex.
		@param index: The form object index.
		###
		sectionObjects = @forms[formIndex][sectionIndex].components
#		console.log(sectionObjects, sectionIndex, index)
		sectionObjects.splice index, 1

	@updateSectionObjectIndex = (formIndex = @currentForm, sectionIndex, oldIndex, newIndex) =>
		###
		Update the index of the form object.
		@param formIndex: The form formIndex.
		@param oldIndex: The old index.
		@param newIndex: The new index.
		###
		return if oldIndex is newIndex
		sectionObjects = @forms[formIndex][sectionIndex].components
#		console.log(sectionObjects,oldIndex, newIndex)
		formObject = sectionObjects.splice(oldIndex, 1)[0]
		sectionObjects.splice newIndex, 0, formObject
		@reindexSectionObject formIndex, sectionIndex

	# ----------------------------------------
	#
	# ----------------------------------------
	@selectedPath = [0]
	@selectFrame = (firstIndex, sectionIndex) =>
		if firstIndex == 0
#			@selectedFrame = @forms[@currentForm]
			@selectedPath = [0]
		else
#			@selectedFrame = @forms[@currentForm][sectionIndex]
#			@forms[@currentForm][sectionIndex].$selected = true
			@selectedPath = [1, sectionIndex]
		console.log('selectFrame',firstIndex, sectionIndex, @selectedPath)
		@selectedPath


	# ----------------------------------------
	# $get
	# ----------------------------------------
	@$get = ['$injector', ($injector) =>
		@setupProviders($injector)
		for name, component of @components
			@loadTemplate component

		config: @config
		options: @options
		components: @components
		groups: @groups
		forms: @forms
		currentForm: @currentForm
		broadcastChannel: @broadcastChannel
		registerComponent: @registerComponent
		addFormObject: @addFormObject
		insertFormObject: @insertFormObject
		removeFormObject: @removeFormObject
		removeSectionObject: @removeSectionObject
		updateFormObjectIndex: @updateFormObjectIndex
		updateSectionObjectIndex: @updateSectionObjectIndex
		getSectionObjects: @getSectionObjects
		insertSectionObject: @insertSectionObject
		selectFrame: @selectFrame
		selectedPath: @selectedPath
	]
	return
