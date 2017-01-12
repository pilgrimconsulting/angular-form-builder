
Global = this

!Global.__fbComponents && (Global.__fbComponents = {})

Global.__fbComponents.divider = ($builderProvider) ->

	# ----------------------------------------
	# Text Divider
	# ----------------------------------------
	$builderProvider.registerComponent 'divider',
		group: 'Default'
		label: 'Divider'
		template:
			"""
			<div class="panel panel-default">
					<div class="panel-body">
							{{label}}
					</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
					<div class="form-group">
							<label class='control-label'>Label</label>
							<input type='text' ng-model="label" validator="[required]" class='form-control'/>
					</div>


					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
			</form>
			"""

Global.__fbComponents.default = ($builderProvider) ->
	# ----------------------------------------
	# text input
	# ----------------------------------------
	$builderProvider.registerComponent 'textInput',
		group: 'Default'
		label: 'Text Input'
		show_label: yes
		description: 'description'
		placeholder: 'placeholder'
		required: no
		validationOptions: [
			{label: 'none', rule: '/.*/'}
			{label: 'number', rule: '[number]'}
			{label: 'email', rule: '[email]'}
			{label: 'url', rule: '[url]'}
		]
		template:
			"""
			<div class="form-group">
					<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label'>{{label}}</label>
					<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
							<input type="text" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" placeholder="{{placeholder}}"/>
							<p class='help-block'>{{description}}</p>
					</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model='show_label' />
									Show label
							</label>
					</div>
					<div class="form-group" ng-hide='!show_label'>
							<label class='control-label'>Label</label>
							<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Description</label>
							<input type='text' ng-model="description" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Placeholder</label>
							<input type='text' ng-model="placeholder" class='form-control'/>
					</div>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model="required" />
									Required</label>
					</div>
					<div class="form-group" ng-if="validationOptions.length > 0">
							<label class='control-label'>Validation</label>
							<select ng-model="$parent.validation" class='form-control' ng-options="option.rule as option.label for option in validationOptions"></select>
					</div>

					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
			</form>
			"""

	# ----------------------------------------
	# Text area
	# ----------------------------------------
	$builderProvider.registerComponent 'textArea',
		group: 'Default'
		label: 'Text Area'
		show_label: yes
		description: 'description'
		placeholder: 'placeholder'
		required: no
		template:
			"""
			<div class="form-group">
					<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label'>{{label}}</label>
					<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
							<textarea type="text" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" rows='6' placeholder="{{placeholder}}"/>
							<p class='help-block'>{{description}}</p>
					</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model='show_label' />
									Show label
							</label>
					</div>
					<div class="form-group" ng-hide='!show_label'>
							<label class='control-label'>Label</label>
							<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Description</label>
							<input type='text' ng-model="description" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Placeholder</label>
							<input type='text' ng-model="placeholder" class='form-control'/>
					</div>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model="required" />
									Required</label>
					</div>

					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
			</form>
			"""

	# ----------------------------------------
	# checkbox
	# ----------------------------------------
	$builderProvider.registerComponent 'checkbox',
		group: 'Default'
		label: 'Checkbox'
		show_label: yes
		description: 'description'
		placeholder: 'placeholder'
		required: no
		options: ['value one', 'value two']
		arrayToText: yes
		template:
			"""
			<div class="form-group">
					<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label'>{{label}}</label>
					<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
							<input type='hidden' ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}"/>
							<div class='checkbox' ng-repeat="item in options track by $index">
									<label><input type='checkbox' ng-model="$parent.inputArray[$index]" value='item'/>
											{{item}}
									</label>
							</div>
							<p class='help-block'>{{description}}</p>
					</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model='show_label' />
									Show label
							</label>
					</div>
					<div class="form-group" ng-hide='!show_label'>
							<label class='control-label'>Label</label>
							<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Description</label>
							<input type='text' ng-model="description" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Options</label>
							<textarea class="form-control" rows="3" ng-model="optionsText"/>
					</div>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model="required" />
									Required
							</label>
					</div>

					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
			</form>
			"""

	# ----------------------------------------
	# radio
	# ----------------------------------------
	$builderProvider.registerComponent 'radio',
		group: 'Default'
		label: 'Radio'
		show_label: yes
		description: 'description'
		placeholder: 'placeholder'
		required: no
		inline: no
		options: ['value one', 'value two']
		template:
			"""
			<div class="form-group">
					<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label'>{{label}}</label>
					<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
							<div class='radio' ng-repeat="item in options track by $index" ng-class="{'radio-inline':inline}">
									<label><input name='{{formName+index}}' ng-model="$parent.inputText" validator-group="{{formName}}" value='{{item}}' type='radio'/>
											{{item}}
									</label>
							</div>
							<p class='help-block'>{{description}}</p>
					</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model='show_label' />
									Show label
							</label>
					</div>
					<div class="form-group" ng-hide='!show_label'>
							<label class='control-label'>Label</label>
							<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Description</label>
							<input type='text' ng-model="description" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Options</label>
							<textarea class="form-control" rows="3" ng-model="optionsText"/>
					</div>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model="inline" />
									radio-inline
							</label>
					</div>

					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
			</form>
			"""

	# ----------------------------------------
	# select
	# ----------------------------------------
	$builderProvider.registerComponent 'select',
		group: 'Default'
		label: 'Select'
		show_label: yes
		description: 'description'
		placeholder: 'placeholder'
		required: no
		options: ['value one', 'value two']
		template:
			"""
			<div class="form-group">
					<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label'>{{label}}</label>
					<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
							<select ng-options="value for value in options" id="{{formName+index}}" class="form-control"
									ng-model="inputText" ng-init="inputText = options[0]"/>
							<p class='help-block'>{{description}}</p>
					</div>
			</div>
			"""
		popoverTemplate:
			"""
				<form>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model='show_label' />
									Show label
							</label>
					</div>
					<div class="form-group" ng-hide='!show_label'>
							<label class='control-label'>Label</label>
								<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Description</label>
							<input type='text' ng-model="description" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Options</label>
							<textarea class="form-control" rows="3" ng-model="optionsText"/>
					</div>

					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
				</form>
				"""


	# ----------------------------------------
	# image
	# ----------------------------------------
	$builderProvider.registerComponent 'image',
		group: 'Default'
		label: 'Image'
		show_label: yes
		required: no
		template:
			"""
			<div class="form-group">
					<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label'>{{label}}</label>
					<div class='col-sm-8' ng-class="{'col-sm-offset-4': !show_label}">
							<img class='img-thumbnail' ng-src='https://placeholdit.imgix.net/~text?txtsize=28&bg=cccccc&txt=200%C3%97200&w=200&h=200'/>
					</div>
			</div>
			"""
		popoverTemplate:
			"""
				<form>
					<div class="checkbox">
							<label>
									<input type='checkbox' ng-model='show_label' />
									Show label
							</label>
					</div>
					<div class="form-group" ng-hide='!show_label'>
							<label class='control-label'>Label</label>
								<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					</div>
					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
				</form>
			"""

	# ----------------------------------------
	# Text Panel
	# ----------------------------------------
	$builderProvider.registerComponent 'panel',
		group: 'Default'
		label: 'Panel title'
		header: 'Panel title'
		description: 'Panel content'
		style: 'default'
		options: ['default', 'primary', 'success', 'warning', 'danger']
		template:
			"""
			<div class="panel panel-{{style}}">
					<div class="panel-heading">
							<h3 class="panel-title">{{header}}</h3>
				  </div>
					<div class="panel-body">
						{{description}}
					</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
					<div class="form-group">
							<label class='control-label'>Panel title</label>
							<input type='text' ng-model="header" validator="[required]" class='form-control'/>
					</div>
					<div class="form-group">
							<label class='control-label'>Panel content</label>
							<input type='text' ng-model="description" class='form-control'/>
					</div>
					<div class="form-group">
              <label class='control-label'>Style</label>
							<select ng-options="value for value in options" id="{{formName+index}}" class="form-control"
									ng-model="style" ng-init="style = options[0]"/>
					</div>


					<hr/>
					<div class='form-group'>
							<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
							<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
							<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
					</div>
			</form>
			"""

components = [
	'divider',
	'default',
	'button'
]

config = ($builderProvider) ->
#	Global.components.map (component) ->
	for component of Global.__fbComponents
		console.log component
#		Global[component].$inject = ['$builderProvider']
#		Global[component]($builderProvider)
		Global.__fbComponents[component].$inject = ['$builderProvider']
		Global.__fbComponents[component]($builderProvider)

angular.module 'builder.components', ['builder', 'validator.rules']
.config config
