
Global = this

!Global.__fbComponents && (Global.__fbComponents = {})

Global.__fbComponents.divider = ($builderProvider) ->
#	return

# ----------------------------------------
# Header
# ----------------------------------------
	$builderProvider.registerComponent 'header',
		group: 'Default'
		label: 'Header'
		show_label: yes
		placeholder: 'placeholder'
		required: no
		template:
			"""
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<div class="col-sm-12">
						<div class="panel-body header-text">
							{{label}}
						</div>
				</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="form-group">
					<label class='control-label'>Header</label>
					<textarea type='text' ng-model="label" validator="[required]" class='form-control'/>
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
	# Text Divider
	# ----------------------------------------
	$builderProvider.registerComponent 'text',
		group: 'Default'
		label: 'Text'
		template:
			"""
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default panel-spec">
						<div class="panel-body">
							{{label}}
						</div>
					</div>
				</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="form-group">
					<label class='control-label'>Text</label>
					<textarea type='text' ng-model="label" validator="[required]" class='form-control'/>
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
	# Hint
	# ----------------------------------------
	$builderProvider.registerComponent 'hint',
		group: 'Default'
		label: 'Hint'
		description: 'Hint'
		labelColor: 'black'
		labelWeight: 500
		labelSize: 	'14px'
		template:
			"""
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}"
					class="control-label"
					ng-class="{'fb-required':required, 'col-sm-4': show_label}"
					ng-hide='!show_label'
					ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
				<div ng-class="{'col-sm-12': !show_label, 'col-sm-8': show_label}">
					<div class="panel panel-default panel-spec">
						<div class="panel-body hint-text">
							Hint: {{description}}
						</div>
					</div>
				</div>

			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group">
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
				<div class="form-group">
					<label class='control-label'>Description</label>
					<input type='text' ng-model="description" class='form-control'/>
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
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
				<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
					<input type="text" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" placeholder="{{placeholder}}"/>
					<p class='help-block'>{{description}}</p>
				</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
				<div class="form-group">
					<label class='control-label'>Description</label>
					<input type='text' ng-model="description" class='form-control'/>
				</div>
				<div class="form-group">
					<label class='control-label'>Placeholder</label>
					<input type='text' ng-model="placeholder" class='form-control'/>
				</div>
				<div class="fb-checkbox">
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
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
				<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
					<textarea type="text" ng-model="inputText" validator-required="{{required}}" validator-group="{{formName}}" id="{{formName+index}}" class="form-control" rows='6' placeholder="{{placeholder}}"/>
					<p class='help-block'>{{description}}</p>
				</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
				<div class="form-group">
					<label class='control-label'>Description</label>
					<input type='text' ng-model="description" class='form-control'/>
				</div>
				<div class="form-group">
					<label class='control-label'>Placeholder</label>
					<input type='text' ng-model="placeholder" class='form-control'/>
				</div>
				<div class="fb-checkbox">
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
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
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
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
				<div class="form-group">
					<label class='control-label'>Description</label>
					<input type='text' ng-model="description" class='form-control'/>
				</div>
				<div class="form-group">
					<label class='control-label'>Options</label>
					<textarea class="form-control" rows="3" ng-model="optionsText"/>
				</div>
				<div class="fb-checkbox">
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
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
				<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
					<div ng-repeat="item in options track by $index" ng-class="{'radio-inline':inline}">
						<label class="radio-label-text"><input name='{{formName+index}}' ng-model="$parent.inputText" validator-group="{{formName}}" value='{{item}}' type='radio'/>
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
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
				<div class="form-group">
					<label class='control-label'>Description</label>
					<input type='text' ng-model="description" class='form-control'/>
				</div>
				<div class="form-group">
					<label class='control-label'>Options</label>
					<textarea class="form-control" rows="3" ng-model="optionsText"/>
				</div>
				<div class="fb-checkbox">
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
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
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
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
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
	# Multiple select
	# ----------------------------------------
	$builderProvider.registerComponent 'multiple',
		group: 'Default'
		label: 'Multiple Select'
		show_label: yes
		description: 'description'
		placeholder: 'placeholder'
		required: no
		options: ['value one', 'value two']
		template:
			"""
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
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
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
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
	# Underline
	# ----------------------------------------
	$builderProvider.registerComponent 'underline',
		group: 'Default'
		label: 'Underline'
		template:
			"""
			<div class="form-group">
				<hr class="underline" color="#5cb85c" size="2">
			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class='form-group'>
					<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
					<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
					<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
				</div>
			</form>
			"""

Global.__fbComponents.image = ($builderProvider) ->
	# ----------------------------------------
	# image
	# ----------------------------------------
	$builderProvider.registerComponent 'image',
		group: 'Images'
		label: 'Image'
		show_label: yes
		required: no
		template:
			"""
			<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<label for="{{formName+index}}" class="col-sm-4 control-label"
					ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
				<div class='col-sm-8' ng-class="{'col-sm-offset-4': !show_label}">
					<img class='img-thumbnail' ng-src='https://placeholdit.imgix.net/~text?txtsize=28&bg=cccccc&txt=200%C3%97200&w=200&h=200'/>
				</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
				<hr/>
				<div class='form-group'>
					<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
					<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
					<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
				</div>
			</form>
			"""

Global.__fbComponents.carousel = ($builderProvider) ->
	# ----------------------------------------
	# carousel
	# ----------------------------------------
	$builderProvider.registerComponent 'carousel',
		group: 'Images'
		label: 'Carousel'
		show_label: yes
		required: no
		template:
			"""<div class="form-group" ng-if='simpleView'>
				<div class="col-sm-12">
					<div class="panel panel-default">
						<div class="panel-body text-center">
							{{componentName ? componentName +' - '+ label : label}}
						</div>
					</div>
				</div>
			</div>
			<div class="form-group" ng-if='!simpleView'>
				<div class='clearfix text-center margin-bottom-15'>
					<label for="{{formName+index}}" class="col-sm-12" ng-class="{'fb-required':required}" ng-hide='!show_label' ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{label}}</label>
				</div>
				<div class='clearfix'>
					<div class='col-sm-4 text-center'>
						<img class='img-thumbnail' ng-src='https://placeholdit.imgix.net/~text?txtsize=28&bg=cccccc&txt=200%C3%97200&w=200&h=200'/>
					</div>
					<div class='col-sm-4 text-center'>
						<img class='img-thumbnail' ng-src='https://placeholdit.imgix.net/~text?txtsize=28&bg=cccccc&txt=200%C3%97200&w=200&h=200'/>
					</div>
					<div class='col-sm-4 text-center'>
						<img class='img-thumbnail' ng-src='https://placeholdit.imgix.net/~text?txtsize=28&bg=cccccc&txt=200%C3%97200&w=200&h=200'/>
					</div>
				</div>
				<div class='clearfix'>
					<div class='col-sm-12'><hr></div>
				</div>

				<div class='clearfix'>
					<div class='col-sm-6 text-right'>
						<button class='btn btn-success' disabled>Take a picture</button>
					</div>
					<div class='col-sm-6 text-left'>
						<button class='btn btn-success' disabled>Add from gallery</button>
					</div>
				</div>
			</div>
			"""
		popoverTemplate:
			"""
			<form>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
				<hr/>
				<div class='form-group'>
					<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
					<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
					<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
				</div>
			</form>
			"""

Global.__fbComponents.section = ($builderProvider) ->
	# ----------------------------------------
	# section
	# {{componentIndex}}|{{componentName}}|{{currentPage}}|{{formNumber}}|{{previewMode}}
	# ----------------------------------------
	$builderProvider.registerComponent 'section',
		group: 'Special'
		label: 'Collapsed section'
		show_label: yes
		required: no
		components: []
		repeatable: true
		collapsable: true
		repited: no
		template:
			"""
			<div ng-class='{"section-open": isOpen, "fb-selected-frame": selected}'>
				<div ng-show="repeatable" class='form-group section-actions-container'>
					<input type='button' ng-click="repeatSection(currentPage, componentIndex)" class='btn btn-primary' value='Repeat'/>
					<input ng-show="repited" type='button' ng-click="removeSection(currentPage, componentIndex)" class='btn btn-danger' value='Delete'/>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading">
						<h4 class="panel-title"><!-- collapse($event, isOpen, 'collapse', componentIndex);-->
							<a role="button" ng-init='isOpen=true' is-open='true' style='cursor: pointer'
								ng-click="isOpen = !isOpen; $event.stopPropagation();">
								<span ng-style="{color: labelColor, fontWeight: labelWeight, fontSize: labelSize}">{{show_label ? label : null}}</span>
								<i class="pull-right glyphicon"
									ng-show="collapsable"
									ng-class="{'glyphicon-chevron-down': !isOpen, 'glyphicon-chevron-up': isOpen}"
									ng-style="{top: show_label ? '0' : '-8px'}"></i>
							</a>
						</h4>
					</div>
					<div id="collapse_{{componentIndex}}" class="panel-collapse collapse " ng-class="{'in': collapsable ? isOpen : true}"
							fb-section='componentName' preview-mode='previewMode' component-index='componentIndex' ng-show='collapsable ? isOpen : true'
							current-page='currentPage' form-number='formNumber'></div>
					</div>
				</div>
			</div>
  		"""

		popoverTemplate:
			"""
			<form>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='show_label' />
						Show label
					</label>
				</div>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='repeatable' />
						Repeatable
					</label>
				</div>
				<div class="fb-checkbox">
					<label>
						<input type='checkbox' ng-model='collapsable' />
						Collapsable
					</label>
				</div>
				<div class="form-group" >
					<label class='control-label'>Label</label>
					<input type='text' ng-model="label" validator="{{show_label ? '[required]' : ''}}" class='form-control'/>
					<div label-styles label-color="labelColor" label-weight="labelWeight" label-size="labelSize"></div>
				</div>
					<hr/>
				<div class='form-group'>
					<input type='submit' ng-click="popover.save($event)" class='btn btn-primary' value='Save'/>
					<input type='button' ng-click="popover.cancel($event)" class='btn btn-default' value='Cancel'/>
					<input type='button' ng-click="popover.remove($event)" class='btn btn-danger' value='Delete'/>
				</div>
			</form>
			"""

Global.__fbComponents.panel = ($builderProvider) ->
	return
	# ----------------------------------------
	# Text Panel
	# ----------------------------------------
	$builderProvider.registerComponent 'panel',
		group: 'Special'
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

#components = [
#	'divider',
#	'default',
#	'button'
#]

config = ($builderProvider) ->
#	Global.components.map (component) ->
	for component of Global.__fbComponents
#		console.log component
#		Global[component].$inject = ['$builderProvider']
#		Global[component]($builderProvider)
		Global.__fbComponents[component].$inject = ['$builderProvider']
		Global.__fbComponents[component]($builderProvider)

angular.module 'builder.components', ['builder', 'validator.rules']
.config config
