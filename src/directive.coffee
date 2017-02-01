
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
					console.lo
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
		isOpen: '=isOpen'
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