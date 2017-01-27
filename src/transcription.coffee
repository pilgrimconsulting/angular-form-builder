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

	@translate = (json) =>
		if typeof json == 'string'
			json = JSON.parse(json)
		else if typeof json == 'object' and !json.length
			json = json
		else
			if json.length
				type = 'array'
			else
				type = typeof json
			return throw new Error("Input data format is not supported. \n Expecting Object or JSON String, but receive #{type}")

		builder = []
		pages = json["Pages"]
		if !pages
			builder
		for page, pageIndex in pages
			console.log('!!!',page)
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
		console.log('FINISH',builder)
		builder

	# ----------------------------------------
	# $get
	# ----------------------------------------
	@$get = ['$injector', ($injector) =>
		@setupProviders($injector)

		translate: @translate
	]
	return