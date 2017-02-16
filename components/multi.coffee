#angular.module 'builder.components', ['builder', 'validator.rules']

#.config ['$builderProvider', ($builderProvider) ->

Global = this

!Global.__fbComponents && (Global.__fbComponents = {})

Global.__fbComponents.multiple = ($builderProvider) ->

	# ----------------------------------------
	# select
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
				<label for="{{formName+index}}" class="col-sm-4 control-label" ng-class="{'fb-required':required}" ng-hide='!show_label'>{{label}}</label>
				<div class="col-sm-8" ng-class="{'col-sm-offset-4': !show_label}">
					<select multiple ng-options="value for value in options" id="{{formName+index}}" class="form-control"
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
				<div class="form-group" >
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
