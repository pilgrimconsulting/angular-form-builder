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
 footer, align, style, components]', ->
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
			formObject.components = $scope.components
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
				components: $scope.components
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
			$scope.components = @model.components

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
#		console.log(component.group, component.name)
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
#	console.log($builder.forms)

#	$scope.pages = []
#	$scope.pages = $builder.forms
#	$scope.currentPage = $builder.currentForm
#	$scope.pageCount = 0
	$scope.prev = false
	$scope.next = false

	$scope.updatePage = () ->
#		console.log('update')
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
		if typeof forms.length == 'number' #if Array
			forms.splice(pageNumber, 1)
		else #if Object
			delete forms[pageNumber]
			for page, pageObj of forms
				if page > pageNumber
					forms[page - 1] = forms[page]
			delete forms[$scope.pageCount - 1]
		$builder.currentForm = if current > pageNumber then pageNumber else current
		$scope.currentPage = false
		$scope.currentPage = pageNumber

	$scope.goPage = (page) ->
#		console.log('GO PAGE',page,$builder.currentForm,$builder.forms)
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


# ----------------------------------------
# builder.directive
# ----------------------------------------
angular.module 'builder.directive', [
	'builder.provider'
	'builder.controller'
	'builder.drag'
	'validator'
]




# ----------------------------------------
# fb-builder
# ----------------------------------------
.directive 'fbBuilder', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	$drag = $injector.get '$drag'
	restrict: 'A'
	scope:
		fbBuilder: '='
		fbObject: '='
	template:
		"""
		<div class='form-horizontal' fb-page={{currentPage}}>
			<div class='fb-form-object-editable '
				ng-repeat="object in formObjects"
				fb-form-object-editable="object"
				fb-component-name='object.component'
				fb-draggable='allow'
				fb-indexIn='indexIn'
				current-page='currentPage'
				parent-section='false'
			></div>
		</div>
		"""
	controller: 'PaginationController'
	link: (scope, element, attrs) ->
		# ----------------------------------------
		# valuables
		# ----------------------------------------
		scope.formNumber = attrs.fbPage || $builder.currentForm
		$builder.forms[scope.formNumber] ?= []
		scope.formObjects = $builder.forms[scope.formNumber]
		beginMove = yes
		scope.currentPage = 0
#		console.log('---------',scope.formObjects )

		scope.$watchGroup [() ->
#			$builder.currentForm
			$builder.forms[$builder.currentForm]
		,() ->
#			scope.currentPage
			$builder.forms.length
		], (current, prev) ->
#			console.log(arguments, 'page change -> change pagin', $builder.currentForm)
			scope.formNumber = $builder.currentForm
			scope.currentPage = $builder.currentForm
			scope.formObjects = $builder.forms[scope.formNumber]
#		, yes

		$(element).addClass 'fb-builder'

		allowKey = 'Alt'
		keyHold = ''
		KeyDown = (e) =>
			KeyID = if window.event then event.keyCode else e.keyCode;
			switch KeyID
				when 18 then keyName = "Alt"
				when 17 then keyName = "Ctrl"
			keyHold = keyName
#			console.log(keyHold)

		KeyUp = (e) =>
			KeyID = if window.event then event.keyCode else e.keyCode;
			switch KeyID
				when 18 then keyName = "Alt"
				when 17 then keyName = "Ctrl"
			if keyHold == keyName then keyHold = ""
#			console.log('UP', keyHold)

		document.onkeydown = KeyDown
		document.onkeyup = KeyUp
		$drag.droppable $(element),
			move: (e) ->
				if beginMove
					# hide all popovers
					$("div.fb-form-object-editable").popover 'hide'
					beginMove = no

				if keyHold != allowKey then return
				$formObjects = $(element).find '.fb-form-object-editable:not(.empty,.dragging)'
				if $formObjects.length is 0
					# there are no components in the builder.
					if $(element).find('.fb-form-object-editable.empty').length is 0
						$(element).find('>div:first').append $("<div class='fb-form-object-editable empty'></div>")
					return

				# the positions could added .empty div.
				positions = []
				# first
				positions.push -1000
				for index in [0...$formObjects.length] by 1
					$formObject = $($formObjects[index])
					offset = $formObject.offset()
					height = $formObject.height()
					positions.push offset.top + height / 2
				positions.push positions[positions.length - 1] + 1000   # last

				# search where should I insert the .empty
				for index in [1...positions.length] by 1
					if e.pageY > positions[index - 1] and e.pageY <= positions[index]
						# you known, this one
						$(element).find('.empty').remove()
						$empty = $ "<div class='fb-form-object-editable empty'></div>"
						if index - 1 < $formObjects.length
							$empty.insertBefore $($formObjects[index - 1])
						else
							$empty.insertAfter $($formObjects[index - 2])
						break
				return
			out: ->
				if beginMove
					# hide all popovers
					$("div.fb-form-object-editable").popover 'hide'
					beginMove = no

				$(element).find('.empty').remove()
			up: (e, isHover, draggable) ->
				beginMove = yes
				if keyHold != allowKey then return
				if not $drag.isMouseMoved()
					# click event
					$(element).find('.empty').remove()
					return

				if not isHover and draggable.mode is 'drag'
					console.log('DRAG OUT', draggable.object.formObject)
					# remove the form object by draggin out
					formObject = draggable.object.formObject
					if formObject.editable
						console.log('removeFormObject', attrs.fbBuilder, formObject.index)
						$builder.removeFormObject attrs.fbBuilder, formObject.index
				else if isHover
					if draggable.mode is 'mirror'
						# insert a form object
						$builder.insertFormObject scope.formNumber, $(element).find('.empty').index('.fb-form-object-editable'),
							component: draggable.object.componentName
					if draggable.mode is 'drag'
						# update the index of form objects
						oldIndex = draggable.object.formObject.index
						newIndex = $(element).find('.empty').index('.fb-form-object-editable')
						newIndex-- if oldIndex < newIndex
						$builder.updateFormObjectIndex scope.formNumber, oldIndex, newIndex
				$(element).find('.empty').remove()

]

# ----------------------------------------
# fb-form-object-editable
# ----------------------------------------
.directive 'fbFormObjectEditable', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	$drag = $injector.get '$drag'
	$compile = $injector.get '$compile'
	$validator = $injector.get '$validator'

	restrict: 'A'
	controller: 'fbFormObjectEditableController'
	scope:
		isOpen: '=?isOpen'
		formObject: '=fbFormObjectEditable'
		sectionIndex: '=sectionIndex'
		componentName: '=fbComponentName'
		currentPage: '='
	link: (scope, element) ->
		scope.inputArray = [] # just for fix warning
		scope.formNumber = scope.$parent.formNumber
		scope.componentIndex = scope.$parent.$index
		scope.simpleView = $builder.simplePreview
		# get component
		scope.$component = $builder.components[scope.formObject.component]
		# setup scope
		scope.setupScope scope.formObject, scope.componentName, scope.formNumber, scope.currentPage, scope.simpleView

		# methods
#		scope.collapse = (event, isOpen, id, index) =>
#			event.stopPropagation()
#			action = if isOpen then 'hide' else 'show'
#			$("##{id}_#{index}").collapse(action)

		# compile formObject
		scope.$watch '$component.template', (template) ->
			return if not template
			view = $compile(template) scope
#			if scope.componentName == 'section'
#				$(view).addClass('inside-section')
			$(element).html view
			console.log('Component change')

		scope.$watch '$parent.$index', () ->
			scope.componentIndex = scope.$parent.$index

		scope.$watch () ->
			$builder.simplePreview
		, () ->
#			console.log('z',$builder.simplePreview)
			scope.simpleView = $builder.simplePreview

		# disable click event
		$(element).on 'click', -> no

#		console.log($(element).attr('fb-draggable'))

#		if $(element).attr('fb-draggable') == !'allow'
		# draggable

#		console.log(scope.$component.name, scope.isOpen)
#		allow = if scope.$component.name == 'section' then no else yes
		$drag.draggable $(element),
#			allow: allow
			object:
				formObject: scope.formObject

		# do not setup bootstrap popover
		# !!! WARINING - must be uncomented
		# Trouble: element des'nt have editable, but must be
#		return if not scope.formObject.editable

		# ----------------------------------------
		# bootstrap popover
		# ----------------------------------------
		popover = {}
		scope.$watch '$component.popoverTemplate', (template) ->
			return if not template
			$(element).removeClass popover.id
			popover =
				id: "fb-#{Math.random().toString().substr(2)}"
				isClickedSave: no # If didn't click save then rollback
				view: null
				html: template
			popover.html = $(popover.html).addClass popover.id
			# compile popover
			popover.view = $compile(popover.html) scope
			$(element).addClass popover.id
			$(element).popover
				html: yes
				title: scope.$component.label
				content: popover.view
				container: 'body'
				placement: $builder.config.popoverPlacement
		scope.popover =
			save: ($event) ->
				###
				The save event of the popover.
				###
				$event.preventDefault()
				$validator.validate(scope).success ->
					popover.isClickedSave = yes
					$(element).popover 'hide'
				return
			remove: ($event) ->
				###
				The delete event of the popover.
				###
				$event.preventDefault()

				# Delete by $parent - detect is inside Section ?
				if scope.$parent.fbSection == 'section'
					$builder.removeSectionObject scope.$parent.formNumber, scope.componentIndex, scope.$parent.$index
				else
					$builder.removeFormObject scope.$parent.formNumber, scope.componentIndex
				$(element).popover 'hide'
				return
			shown: ->
				###
				The shown event of the popover.
				###
				scope.data.backup()
				popover.isClickedSave = no
			cancel: ($event) ->
				###
				The cancel event of the popover.
				###
				scope.data.rollback()
				if $event
					# clicked cancel by user
					$event.preventDefault()
					$(element).popover 'hide'
				return
		# ----------------------------------------
		# popover.show
		# ----------------------------------------
		$(element).on 'show.bs.popover', (e) ->
			console.log('Click to Popover')
			e.stopPropagation()

			return no if $drag.isMouseMoved()
			# hide other popovers
			$("div.fb-form-object-editable:not(.#{popover.id})").popover 'hide'

			$popover = $("form.#{popover.id}").closest '.popover'
			if $popover.length > 0
				# fixed offset
				elementOrigin = $(element).offset().top + $(element).height() / 2
				popoverTop = elementOrigin - $popover.height() / 2
				$popover.css
					position: 'absolute'
					top: popoverTop

				$popover.show()
				setTimeout ->
					$popover.addClass 'in'
					$(element).triggerHandler 'shown.bs.popover'
				, 0
				no
		# ----------------------------------------
		# popover.shown
		# ----------------------------------------
		$(element).on 'shown.bs.popover', ->
			# select the first input
			$(".popover .#{popover.id} input:first").select()
			scope.$apply -> scope.popover.shown()
			return
		# ----------------------------------------
		# popover.hide
		# ----------------------------------------
		$(element).on 'hide.bs.popover', ->
			# do not remove the DOM
			$popover = $("form.#{popover.id}").closest '.popover'
			if not popover.isClickedSave
				# eval the cancel event
				if scope.$$phase or scope.$root.$$phase
					scope.popover.cancel()
				else
					scope.$apply -> scope.popover.cancel()
			$popover.removeClass 'in'
			setTimeout ->
				$popover.hide()
			, 300
			no
]

# ----------------------------------------
# fb-components
# ----------------------------------------
.directive 'fbComponents', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	restrict: 'A'
	template:
		"""
		<ul ng-if="groups.length > 1" class="nav nav-tabs nav-justified">
			<li ng-repeat="group in groups" ng-class="{active:activeGroup==group}">
				<a href='#' ng-click="selectGroup($event, group)">{{group}}</a>
			</li>
		</ul>
		<div class='form-horizontal col-sm-12 elementList'>
			<div ng-repeat="component in components">
				<div class="form-group element-wrapper">
					<div class="col-sm-1">
						<button type='button' class='btn btn-success btn-sm'
								ng-click='addComponentToEnd($event, component)'>+</button>
					</div>
					<div class="col-sm-11">
						<div class='fb-component' fb-component="component" ng-component="{{component.name}}" ng-if='!_$builder.simplePreview'></div>
						<!--div class="col-sm-12 fb-component" ng-if='$builder.simplePreview'>
							<div class="panel panel-default">
								<div class="panel-body text-center">
									{{component.name}}
								</div>
							</div>
						</div-->
					</div>
			</div>
		</div>
		"""
	controller: 'fbComponentsController'

]

# ----------------------------------------
# fb-component
# ----------------------------------------
.directive 'fbComponent', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	$drag = $injector.get '$drag'
	$compile = $injector.get '$compile'

	restrict: 'A'
	scope:
		component: '=fbComponent'
	controller: 'fbComponentController'
	link: (scope, element) ->
		scope.simpleView = $builder.simpleComponentView
		scope.copyObjectToScope scope.component, scope.simpleView
		# scope.setupScope scope.simpleView

		$drag.draggable $(element),
			mode: 'mirror'
			defer: no
			object:
				componentName: scope.component.name

		scope.$watch 'component.template', (template) ->
			return if not template
			view = $compile(template) scope
			$(element).html view

		#		scope.setupScope scope.simpleView

		scope.$watch () ->
			$builder.simpleComponentView
		, () ->
			scope.simpleView = $builder.simpleComponentView
			console.log('x',scope.simpleView)
]

# ----------------------------------------
# fb-form
# ----------------------------------------
.directive 'fbForm', ['$injector', ($injector) ->
	restrict: 'A'
	require: 'ngModel'  # form data (end-user input value)
	scope:
		# input model for scops in ng-repeat
		formNumber: '@fbForm'
		input: '=ngModel'
		default: '=fbDefault'
	template:
		"""
		<div class='fb-form-object' ng-repeat="object in form" fb-form-object="object"></div>
		"""
	controller: 'fbFormController'
	link: (scope, element, attrs) ->
		# providers
		$builder = $injector.get '$builder'
#		scope.currentForm = $builder.currentForm

		scope.$watch () ->
			$builder.currentForm
		, (current, prev) ->
#			console.log(arguments, 'page change')
			scope.formNumber = current
			$builder.forms[scope.formNumber] ?= []
			scope.form = $builder.forms[scope.formNumber]
			scope.jsonString = $builder.forms

		# get the form for controller
		$builder.forms[scope.formNumber] ?= []
		scope.form = $builder.forms[scope.formNumber]
		scope.jsonString = $builder.forms
]

# ----------------------------------------
# fb-form-object
# ----------------------------------------
.directive 'fbFormObject', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	$compile = $injector.get '$compile'
	$parse = $injector.get '$parse'

	restrict: 'A'
	controller: 'fbFormObjectController'
	link: (scope, element, attrs) ->
		# ----------------------------------------
		# variables
		# ----------------------------------------
		scope.formObject = $parse(attrs.fbFormObject) scope
		scope.$component = $builder.components[scope.formObject.component]

		# ----------------------------------------
		# scope
		# ----------------------------------------
		# listen (formObject updated
		scope.$on $builder.broadcastChannel.updateInput, -> scope.updateInput scope.inputText
		if scope.$component.arrayToText
			scope.inputArray = []
			# watch (end-user updated input of the form
			scope.$watch 'inputArray', (newValue, oldValue) ->
				# array input, like checkbox
				return if newValue is oldValue
				checked = []
				for index of scope.inputArray when scope.inputArray[index]
					checked.push scope.options[index] ? scope.inputArray[index]
				scope.inputText = checked.join ', '
			, yes
		scope.$watch 'inputText', -> scope.updateInput scope.inputText
		# watch (management updated form objects
		scope.$watch attrs.fbFormObject, ->
			scope.copyObjectToScope scope.formObject
		, yes

		scope.$watch '$component.template', (template) ->
			return if not template
			$template = $(template)
			# add validator
			$input = $template.find "[ng-model='inputText']"
			$input.attr
				validator: '{{validation}}'
			# compile
			view = $compile($template) scope
			$(element).html view

		# select the first option
		if not scope.$component.arrayToText and scope.formObject.options.length > 0
			scope.inputText = scope.formObject.options[0]

		# set default value
		scope.$watch "default['#{scope.formObject.id}']", (value) ->
			return if not value
			if scope.$component.arrayToText
				scope.inputArray = value
			else
				scope.inputText = value
]

# ----------------------------------------
# fb-pages
# ----------------------------------------
.directive 'fbPages', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	restrict: 'A'
	template:
		"""
		<div class="fb-builderPagination">
			<div class="pull-left">
				<button type="button" class="btn btn-primary btn-small _pull-right"
						ng-class="{disabled: !currentPage}" ng-click="goB()"><</button>
				<button type="button" class="btn btn-primary btn-small _pull-right"
						ng-class="{disabled: !next}" ng-click="goF()">></button>
				<div class="btn-group">
					<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown"
							aria-expanded="false" aria-haspopup="true">Page
						<span class="caret"></span>
						<span class="sr-only">Toggle Dropdown</span>
					</button>
					<ul class="dropdown-menu" >
						<li ng-repeat="(key, value) in pages"><a ng-click="goPage(+key)">{{+key+1}}</a></li>
					</ul>
				</div>
			</div>
			<span class="panel-title" >
				Page <b>\#<span ng-model="page">{{currentPage+1}}</span></b> / {{pageCount}}
			</span>

			<div class="pull-right">
				<button type="button" class="btn btn-danger btn-small _pull-right disabled"
						ng-class="{disabled: pageCount == 1}" ng-click="deletePage(currentPage)">-</button>
				<!-- Split button -->
				<div class="btn-group">
					<button type="button" class="btn btn-success" ng-click="addPage(pageCount)">Add</button>
					<button type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown"
							aria-haspopup="true" aria-expanded="false">
						<span class="caret"></span>
						<span class="sr-only">Toggle Dropdown</span>
					</button>
					<ul class="dropdown-menu">
						<li><a href="" ng-click="addPage(pageCount)">Page</a></li>
						<li role="separator" class="divider"></li>
						<li><a href="">Section</a></li>
						<li><a href="">Component</a></li>
					</ul>
				</div>
			</div>

			<div class="clearfix"></div>
		</div>
		"""
	controller: 'PaginationController'
	link: (scope, element, attrs) ->
		scope.$watch () ->
			$builder.forms.length
		, () ->
#			console.log(arguments, 'change pagination')
			scope.pageCount = $builder.forms.length
			scope.pages = $builder.forms
			scope.currentPage = $builder.currentForm
]

# ----------------------------------------
# fb-section
# ----------------------------------------
.directive 'fbSection', ['$injector', '$compile', ($injector, $compile) ->
# providers
	$builder = $injector.get '$builder'
	$drag = $injector.get '$drag'

	restrict: 'A'
	scope:
		fbSection: '=',
		sectionIndex: '=componentIndex',
		currentPage: '=',
		formNumber: '=',
	template:
		"""
		<div class='form-horizontal' >
			<div style="min-height: 100px;"
				class='fb-form-object-editable parent-section'
				ng-repeat="object in sectionObjects"
				fb-form-object-editable="object"
				fb-draggable='allow'
				section-index='sectionIndex'
				parent-section='true'
			>
			</div>
		</div>
		"""
	link: (scope, element, attrs) ->
		if scope.fbSection != 'section' then return
#		element.append $compile(@template)(scope)
		$(element).addClass 'fb-section'
		scope.sectionObjects = $builder.getSectionObjects scope.sectionIndex, scope.formNumber
		console.log('Init Section: ',scope.sectionIndex,scope.sectionObjects )
		# $drag.draggable $(element),

#		scope.$watch () ->
#			$builder.currentForm
#		, () ->
#			console.log('-=- change sectionObjects',$builder.currentForm)
#			scope.sectionObjects = $builder.getSectionObjects scope.componentIndex, $builder.currentForm

#		scope.$watch 'componentIndex', () ->
#			sectionIndex = scope.componentIndex

#		scope.$watchGroup [() ->
#			$builder.forms[$builder.currentForm]
#		, () ->
##			$builder.forms.length
#			sectionIndex = $(element).closest(".fb-form-object-editable").index()
#		], () ->
#			console.log('page Changes -> section position')
#			sectionIndex = $(element).closest(".fb-form-object-editable").index()
#			scope.sectionIndex = sectionIndex
#			scope.sectionObjects = $builder.getSectionObjects sectionIndex

		$drag.droppable $(element),
			move: (e) ->
				if beginMove
					# hide all popovers
					$("div.fb-form-object-editable").popover 'hide'
					beginMove = no

				$formObjects = $(element).find '.parent-section.fb-form-object-editable:not(.empty,.dragging)'
				if $formObjects.length is 0
					# there are no components in the builder.
					if $(element).find('.parent-section.fb-form-object-editable.empty').length is 0
						$(element).find('>div:first').append $("<div class='parent-section fb-form-object-editable empty'></div>")
					# $('.parent-section.fb-form-object-editable.empty').remove()
					return

				# the positions could added .empty div.
				positions = []
				# first
				positions.push -1000
				for index in [0...$formObjects.length] by 1
					$formObject = $($formObjects[index])
					offset = $formObject.offset()
					height = $formObject.height()
					positions.push offset.top + height / 2
				positions.push positions[positions.length - 1] + 1000   # last

				# search where should I insert the .empty
				for index in [1...positions.length] by 1
					if e.pageY > positions[index - 1] and e.pageY <= positions[index]
						# you known, this one
						$(element).find('.empty').remove()
						$empty = $ "<div class='parent-section fb-form-object-editable empty'></div>"
						if index - 1 < $formObjects.length
							$empty.insertBefore $($formObjects[index - 1])
						else
							$empty.insertAfter $($formObjects[index - 2])
						break
				return
			out: ->
				if beginMove
					# hide all popovers
					$("div.fb-form-object-editable").popover 'hide'
					beginMove = no

				$(element).find('.empty').remove()
			up: (e, isHover, draggable) ->
				beginMove = yes
				if not $drag.isMouseMoved()
					# click event
					$(element).find('.empty').remove()
					return

				if not isHover and draggable.mode is 'drag'
					# remove the form object by draggin out
					formObject = draggable.object.formObject
					console.error( draggable.object )
					# if formObject.editable
					console.log('removeSectionObject', attrs.fbBuilder, $builder.currentForm, formObject.index, formObject.editable, formObject, draggable.object.formObject)
#						$(element).find('.fb-form-object-editable')
#					$builder.removeSectionObject attrs.fbBuilder, $builder.currentForm, formObject.index
				else if isHover
					# Add or Sort components
					if draggable.mode is 'mirror'
						# insert a form object
						elementIndex = $(element).find('.empty').index()
						$builder.insertSectionObject $builder.currentForm, scope.sectionIndex, elementIndex,
							component: draggable.object.componentName
						scope.sectionObjects = $builder.getSectionObjects scope.sectionIndex, scope.formNumber
					#						console.log scope.sectionObjects
					if draggable.mode is 'drag'
						# update the index of form objects
						oldIndex = draggable.object.formObject.index
						newIndex = $(element).find('.empty').index()
						console.warn('newIndex',newIndex, element, $(element).find('.empty'))
						newIndex-- if oldIndex < newIndex
						# SORTING - update
						$builder.updateSectionObjectIndex scope.formNumber, scope.sectionIndex, oldIndex, newIndex
				$(element).find('.empty').remove()
]


# ----------------------------------------
# fb-simple-preview
# ----------------------------------------
.directive 'fbSimpleView', ['$injector', ($injector) ->
# providers
	$builder = $injector.get '$builder'

	restrict: 'A'
	scope:
		simpleComponentView: '=fbSimpleComponentView'
		simplePreview: '=fbSimplePreview'
	template:
		'''
		<div class="col-xs-6">
			<input type="checkbox" id="simplePreview" ng-model='simplePreview' ng-checked="simplePreview"/>
			<label for="simplePreview">Simple Preview</label>
		</div>
		<div class="col-xs-6">
			<input type="checkbox" id="simpleComponentView" ng-model='simpleComponentView'/>
			<label for="simpleComponentView">Simple Component</label>
		</div>
		'''
	link: (scope, element) ->
#		if !scope.simplePreview
#			$builder.simplePreview = scope.simplePreview
#		else
#			scope.simplePreview = $builder.simplePreview
#
#		if !scope.simpleComponentView
#			$builder.simpleComponentView = scope.simpleComponentView
#		else
#			scope.simpleComponentView = $builder.simpleComponentView
#		console.log('a',scope.simpleComponentView)
		$builder.simplePreview = scope.simplePreview || $builder.simplePreview
		$builder.simpleComponentView = scope.simpleComponentView || $builder.simpleComponentView

		scope.$watch 'simplePreview', () ->
			$builder.simplePreview = scope.simplePreview
			console.log($builder.simplePreview )
		scope.$watch 'simpleComponentView', () ->
			$builder.simpleComponentView = scope.simpleComponentView
			console.log($builder.simpleComponentView )

]
angular.module 'builder.drag', []

.provider '$drag', ->
    # ----------------------------------------
    # provider
    # ----------------------------------------
    $injector = null
    $rootScope = null


    # ----------------------------------------
    # properties
    # ----------------------------------------
    @data =
        # all draggable objects
        draggables: {}
        # all droppable objects
        droppables: {}


    # ----------------------------------------
    # event hooks
    # ----------------------------------------
    @mouseMoved = no
    @isMouseMoved = => @mouseMoved
    @hooks =
        down: {}
        move: {}
        up: {}
    @innerDropHover = false
    @eventMouseMove = ->
    @eventMouseUp = ->
    $ =>
        $(document).on 'mousedown', (e) =>
            @mouseMoved = no
            func(e) for key, func of @hooks.down
            return
        $(document).on 'mousemove', (e) =>
            @mouseMoved = yes
            func(e) for key, func of @hooks.move
            return
        $(document).on 'mouseup', (e) =>
            func(e) for key, func of @hooks.up
            return


    # ----------------------------------------
    # private methods
    # ----------------------------------------
    @currentId = 0
    @getNewId = => "#{@currentId++}"


    @setupEasing = ->
        jQuery.extend jQuery.easing,
            easeOutQuad: (x, t, b, c, d) -> -c * (t /= d) * (t - 2) + b


    @setupProviders = (injector) ->
        ###
        Setup providers.
        ###
        $injector = injector
        $rootScope = $injector.get '$rootScope'


    @isHover = ($elementA, $elementB) =>
        ###
        Is element A hover on element B?
        @param $elementA: jQuery object
        @param $elementB: jQuery object
        ###
        offsetA = $elementA.offset()
        offsetB = $elementB.offset()
        sizeA =
            width: $elementA.width()
            height: $elementA.height()
        sizeB =
            width: $elementB.width()
            height: $elementB.height()
        isHover =
            x: no
            y: no
        # x
        isHover.x = offsetA.left > offsetB.left and offsetA.left < offsetB.left + sizeB.width
        isHover.x = isHover.x or offsetA.left + sizeA.width > offsetB.left and offsetA.left + sizeA.width < offsetB.left + sizeB.width
        return no if not isHover
        # y
        isHover.y = offsetA.top > offsetB.top and offsetA.top < offsetB.top + sizeB.height
        isHover.y = isHover.y or offsetA.top + sizeA.height > offsetB.top and offsetA.top + sizeA.height < offsetB.top + sizeB.height
        isHover.x and isHover.y


    delay = (ms, func) ->
        setTimeout ->
            func()
        , ms
    @autoScroll =
        up: no
        down: no
        scrolling: no
        scroll: =>
            @autoScroll.scrolling = yes
            if @autoScroll.up
                $('html, body').dequeue().animate
                    scrollTop: $(window).scrollTop() - 50
                , 100, 'easeOutQuad'
                delay 100, => @autoScroll.scroll()
            else if @autoScroll.down
                $('html, body').dequeue().animate
                    scrollTop: $(window).scrollTop() + 50
                , 100, 'easeOutQuad'
                delay 100, => @autoScroll.scroll()
            else
                @autoScroll.scrolling = no
        start: (e) =>
            if e.clientY < 50
                # up
                @autoScroll.up = yes
                @autoScroll.down = no
                @autoScroll.scroll() if not @autoScroll.scrolling
            else if e.clientY > $(window).innerHeight() - 50
                # down
                @autoScroll.up = no
                @autoScroll.down = yes
                @autoScroll.scroll() if not @autoScroll.scrolling
            else
                @autoScroll.up = no
                @autoScroll.down = no
        stop: =>
            @autoScroll.up = no
            @autoScroll.down = no


    @dragMirrorMode = ($element, defer=yes, object) =>
        result =
            id: @getNewId()
            mode: 'mirror'
            maternal: $element[0]
            element: null
            object: object

        $element.on 'mousedown', (e) =>
            e.preventDefault()

            $clone = $element.clone()
            result.element = $clone[0]
            $clone.addClass "fb-draggable form-horizontal prepare-dragging"
            @hooks.move.drag = (e, defer) =>
                if $clone.hasClass 'prepare-dragging'
                    $clone.css
                        width: $element.width()
                        height: $element.height()
                    $clone.removeClass 'prepare-dragging'
                    $clone.addClass 'dragging'
                    return if defer

                $clone.offset
                    left: e.pageX - $clone.width() / 2
                    top: e.pageY - $clone.height() / 2

                @autoScroll.start e

                # execute callback for droppables
                for id, droppable of @data.droppables
                    if @isHover $clone, $(droppable.element)
                        droppable.move e, result
                    else
                        droppable.out e, result
            @hooks.up.drag = (e) =>
                # execute callback for droppables
                for id, droppable of @data.droppables
                    isHover = @isHover $clone, $(droppable.element)
                    droppable.up e, isHover, result
                delete @hooks.move.drag
                delete @hooks.up.drag
                result.element = null
                $clone.remove()
                @autoScroll.stop()
            $('body').append $clone
            # setup left & top of the element
            @hooks.move.drag(e, defer) if not defer
        result


    @dragDragMode = ($element, defer=yes, object) =>
        result =
            id: @getNewId()
            mode: 'drag'
            maternal: null
            element: $element[0]
            object: object

        $element.addClass 'fb-draggable'
        $element.on 'mousedown', (e) =>
            e.preventDefault()
            if $($element).find('.panel-open').length
              return


            return if $element.hasClass 'dragging'

            $element.addClass 'prepare-dragging'
            @hooks.move.drag = (e, defer) =>
                if $element.hasClass 'prepare-dragging'
                    $element.css
                        width: $element.width()
                        height: $element.height()
                    $element.removeClass 'prepare-dragging'
                    $element.addClass 'dragging'
                    return if defer

                $element.offset
                    left: e.pageX - $element.width() / 2
                    top: e.pageY - $element.height() / 2

                @autoScroll.start e

                # execute callback for droppables
                for id, droppable of @data.droppables
                    if @isHover $element, $(droppable.element)
                        droppable.move e, result
                    else
                        droppable.out e, result
                return
            @hooks.up.drag = (e) =>
                # execute callback for droppables
                for id, droppable of @data.droppables
                    isHover = @isHover $element, $(droppable.element)
                    droppable.up e, isHover, result

                delete @hooks.move.drag
                delete @hooks.up.drag
                $element.css
                    width: '', height: ''
                    left: '', top: ''
                $element.removeClass 'dragging defer-dragging'
                @autoScroll.stop()
            # setup left & top of the element
            @hooks.move.drag(e, defer) if not defer
        result


    @dropMode = ($element, options) =>
        result =
            id: @getNewId()
            element: $element[0]
            move: (e, draggable) ->
                $rootScope.$apply -> options.move?(e, draggable)
            up: (e, isHover, draggable) ->
                $rootScope.$apply -> options.up?(e, isHover, draggable)
            out: (e, draggable) ->
                $rootScope.$apply -> options.out?(e, draggable)
        result
    # ----------------------------------------
    # public methods
    # ----------------------------------------
    @draggable = ($element, options={}) =>
        ###
        Make the element able to drag.
        @param element: The jQuery element.
        @param options: Options
            mode: 'drag' [default], 'mirror'
            defer: yes/no. defer dragging
            object: custom information
            allow: yes/no - allow dragging at the current time
        ###
        result = []
#        if (!options.allow)
#            return
        if options.mode is 'mirror'
            for element in $element
                draggable = @dragMirrorMode $(element), options.defer, options.object
                result.push draggable.id
                @data.draggables[draggable.id] = draggable
        else
            for element in $element
                draggable = @dragDragMode $(element), options.defer, options.object
                result.push draggable.id
                @data.draggables[draggable.id] = draggable
        result


    @droppable = ($element, options={}) =>
        ###
        Make the element coulde be drop.
        @param $element: The jQuery element.
        @param options: The droppable options.
            move: The custom mouse move callback. (e, draggable)->
            up: The custom mouse up callback. (e, isHover, draggable)->
            out: The custom mouse out callback. (e, draggable)->
        ###
        result = []
        for element in $element
            droppable = @dropMode $(element), options
            result.push droppable
            @data.droppables[droppable.id] = droppable
        result


    # ----------------------------------------
    # $get
    # ----------------------------------------
    @get = ($injector) ->
        @setupEasing()
        @setupProviders $injector

        isMouseMoved: @isMouseMoved
        data: @data
        draggable: @draggable
        droppable: @droppable
        innerDropHover : @innerDropHover
    @get.$inject = ['$injector']
    @$get = @get
    return

angular.module 'builder', ['builder.directive']
angular.module 'app', ['builder', 'builder.components', 'validator.rules']

.controller 'PaginController', ['$scope', '$builder', '$validator', ($scope, $builder, $validator) ->

	$scope.pages = [$builder.forms['default'],]


]
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
	# $get
	# ----------------------------------------
	@$get = ['$injector', ($injector) =>
		@setupProviders($injector)
		for name, component of @components
			@loadTemplate component

		config: @config
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
	]
	return

###
    transcription Server Data into FormBuilder Data
###

angular.module 'transcription', []

.provider '$transcription', ->
	# ----------------------------------------
	# provider
	# ----------------------------------------
	$injector = null

	@setupProviders = (injector) =>
		$injector = injector

	@vocabulary = {
		'Text': 'textInput'
		'TextArea': 'textArea'
		'DropDown': 'select'
		'Radio': 'checkbox'
		'CheckBox': 'radio'
		'Images': 'image'
		'Images': 'carousel'
		'Hint': 'description'
		'label': 'Title'
	}

	@checkType = (json) =>
		if typeof json == 'string'
			json = JSON.parse(json)
		else if typeof json == 'object' and json.length != 0
			json = json
		else
			if json.length >= 0
				type = 'array'
			else
				type = typeof json
			return throw new Error("Input data format is not supported. \n Expecting Object or JSON String, but receive '#{type}'")

	@translate = (json) =>
		json = @checkType(json)

		builder = []
		pages = json["Pages"]
		if !pages
			builder
		for page, pageIndex in pages
			window.dev && console.log('!!!',page)
			builder[pageIndex] = []
			elements = page["Elements"]
			for element in elements
				tempObj = {
					id: element["Name"] || null
					label: element["Title"] || null
				}
				section = false
				items = element["Items"]
				if items # Section
					tempObj.component = 'section'
					tempObj.components = for item in items
						tempItem = {
							component: @vocabulary[item["InputType"]] || null
							id: item["Name"] || null
							label: item["Title"] || null
							show_label: item["ShowTitle"] || null
							required: item["IsRequired"]
							description: item["Description"] || ''
						}
						options = item["Variants"] || []
						if options
							tempItem.options = for option in options
								if option["Title"] then option["Title"]
						tempItem

				else # Item
					tempObj.component = @vocabulary[element["InputType"]] || null
					tempObj.id = element["Name"] || null
					tempObj.label = element["Title"] || null
					tempObj.show_label = element["ShowTitle"] || null
					tempObj.required = element["IsRequired"]
					tempObj.description = element["Description"] || null

				builder[pageIndex].push(tempObj)
#		window.dev && console.log('FINISH',builder)
		builder

	# ----------------------------------------
	# $get
	# ----------------------------------------
	@$get = ['$injector', ($injector) =>
		@setupProviders($injector)

		translate: @translate
	]
	return