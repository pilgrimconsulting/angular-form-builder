
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
# fb-section
# ----------------------------------------
.directive 'fbSection', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	$drag = $injector.get '$drag'

	restrict: 'A'
	scope:
		fbSection: '='
	template:
#				ng-repeat="object in formObjects"
		"""
		<div class='fb-section-object-editable'
				fb-section-object-editable="object">
			<p>section</p><br/><br/>
		</div>
		"""
	link: (scope, element, attr) ->
		$(element).addClass 'fb-section'
		$drag.droppable $(element),
			move: (e) ->
				if beginMove
					# hide all popovers
					$("div.fb-section-object-editable").popover 'hide'
					beginMove = no

				$formObjects = $(element).find '.fb-section-object-editable:not(.empty,.dragging)'
				if $formObjects.length is 0
					# there are no components in the builder.
					if $(element).find('.fb-section-object-editable.empty').length is 0
						$(element).find('>div:first').append $("<div class='fb-section-object-editable empty'></div>")
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
						$empty = $ "<div class='fb-section-object-editable empty'></div>"
						if index - 1 < $formObjects.length
							$empty.insertBefore $($formObjects[index - 1])
						else
							$empty.insertAfter $($formObjects[index - 2])
						break
				return
			out: ->
				if beginMove
					# hide all popovers
					$("div.fb-section-object-editable").popover 'hide'
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
					if formObject.editable
						$builder.removeFormObject attrs.fbBuilder, formObject.index
				else if isHover
					if draggable.mode is 'mirror'
						# insert a form object
						$builder.insertFormObject scope.formNumber, $(element).find('.empty').index('.fb-section-object-editable'),
							component: draggable.object.componentName
					if draggable.mode is 'drag'
						# update the index of form objects
						oldIndex = draggable.object.formObject.index
						newIndex = $(element).find('.empty').index('.fb-section-object-editable')
						newIndex-- if oldIndex < newIndex
						$builder.updateFormObjectIndex scope.formNumber, oldIndex, newIndex
				$(element).find('.empty').remove()
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
	template:
		"""
		<div class='form-horizontal' fb-page={{currentPage}}>
			<div class='fb-form-object-editable ' ng-repeat="object in formObjects"
				fb-form-object-editable="object" fb-draggable='allow'></div>
		</div>
		"""
	controller: 'PaginationController'
	link: (scope, element, attrs) ->
		# ----------------------------------------
		# valuables
		# ----------------------------------------
#		scope.formNumber = attrs.fbBuilder
#		scope.formNumber = attrs.fbPage
		scope.formNumber = attrs.fbPage || $builder.currentForm
		$builder.forms[scope.formNumber] ?= []
		scope.formObjects = $builder.forms[scope.formNumber]
		beginMove = yes
		scope.currentPage = 1

		scope.$watch () ->
			$builder.currentForm
		, (current, prev) ->
			console.log(arguments, 'page change')
			scope.formNumber = current
			scope.formObjects = $builder.forms[scope.formNumber]
#		, yes

		$(element).addClass 'fb-builder'
		$drag.droppable $(element),
			move: (e) ->
				if beginMove
					# hide all popovers
					$("div.fb-form-object-editable").popover 'hide'
					beginMove = no

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
				if not $drag.isMouseMoved()
					# click event
					$(element).find('.empty').remove()
					return

				if not isHover and draggable.mode is 'drag'
					# remove the form object by draggin out
					formObject = draggable.object.formObject
					if formObject.editable
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
		formObject: '=fbFormObjectEditable'
	link: (scope, element) ->
		scope.inputArray = [] # just for fix warning
		# get component
		scope.$component = $builder.components[scope.formObject.component]
		# setup scope
		scope.setupScope scope.formObject

		# compile formObject
		scope.$watch '$component.template', (template) ->
			return if not template
			view = $compile(template) scope
			$(element).html view

		# disable click event
		$(element).on 'click', -> no

#		console.log($(element).attr('fb-draggable'))

#		if $(element).attr('fb-draggable') == !'allow'
		# draggable
		$drag.draggable $(element),
			object:
				formObject: scope.formObject

		# do not setup bootstrap popover
		return if not scope.formObject.editable

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

				$builder.removeFormObject scope.$parent.formNumber, scope.$parent.$index
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
		$(element).on 'show.bs.popover', ->
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
# fb-section-object-editable
# ----------------------------------------
.directive 'fbSectionObjectEditable', ['$injector', ($injector) ->
	# providers
	$builder = $injector.get '$builder'
	$drag = $injector.get '$drag'
	$compile = $injector.get '$compile'
	$validator = $injector.get '$validator'

	restrict: 'A'
	controller: 'fbFormObjectEditableController'
	scope:
		formObject: '=fbFormObjectEditable'
	link: (scope, element) ->
		scope.inputArray = [] # just for fix warning
		# get component
		scope.$component = $builder.components[scope.formObject.component]
		# setup scope
		scope.setupScope scope.formObject

		# compile formObject
		scope.$watch '$component.template', (template) ->
			return if not template
			view = $compile(template) scope
			$(element).html view

		# disable click event
		$(element).on 'click', -> no

		console.log($(element).attr('fb-draggable'))

		if $(element).attr('fb-draggable') == 'allow'
			# draggable
			$drag.draggable $(element),
				object:
					formObject: scope.formObject

		# do not setup bootstrap popover
		return if not scope.formObject.editable

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

				$builder.removeFormObject scope.$parent.formNumber, scope.$parent.$index
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
		$(element).on 'show.bs.popover', ->
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
#	$builder = $injector.get '$builder'
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
					<div class="col-sm-1">{{component.name}}
						<button type='button' class='btn btn-success btn-sm'
								ng-click='addComponentToEnd($event, component)'>+</button>
					</div>
					<div class="col-sm-11">
						<div class='fb-component' fb-component="component" ng-component="{{component.name}}"></div>
					</div>
			</div>
		</div>
		"""
	controller: 'fbComponentsController'
#	link: (scope, element) ->
#		 providers
#		$builder = $injector.get '$builder'

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
		scope.copyObjectToScope scope.component

		$drag.draggable $(element),
			mode: 'mirror'
			defer: no
			object:
				componentName: scope.component.name

		scope.$watch 'component.template', (template) ->
			return if not template
			view = $compile(template) scope
			$(element).html view
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
			console.log(arguments, 'page change')
			scope.formNumber = current
			$builder.forms[scope.formNumber] ?= []
			scope.form = $builder.forms[scope.formNumber]

		# get the form for controller
		$builder.forms[scope.formNumber] ?= []
		scope.form = $builder.forms[scope.formNumber]
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
#	$builder = $injector.get '$builder'
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
			<span class="panel-title" ng-init="currentPage=0">
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
]