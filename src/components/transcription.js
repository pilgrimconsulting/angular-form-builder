/*
 transcription Server Data into FormBuilder Data
 */

angular.module('transcription', [])
    .provider('$transcription', function () {
        var $injector;
        $injector = null;
        this.setupProviders = (function (_this) {
            return function (injector) {
                return $injector = injector;
            };
        })(this);

        this.vocabulary = {
            'Text': 'textInput',
            'TextArea': 'textArea',
            'DropDown': 'select',
            'Radio': 'checkbox',
            'CheckBox': 'radio',
            'Images': 'image',
            'Images': 'carousel',
            'Hint': 'description',
            'ReadOnlyText': 'text'
        };

        this.vocabularyBackwards = {
            'textInput':    'Text',
            'textArea':     'TextArea',
            'select':       'DropDown',
            'checkbox':     'Radio',
            'radio':        'CheckBox',
            'image':        'Images',
            'carousel':     'Images',
            'description':  'Hint',
            'text':         'ReadOnlyText'
        };

        this.checkType = (function (_this) {
            return function (json) {
                var type;
                if (typeof json === 'string') {
                    return JSON.parse(json);
                } else if (typeof json === 'object') {
                    return json;
                } else {
                    if (json.length >= 0) {
                        type = 'array';
                    } else {
                        type = typeof json;
                    }
                    throw new Error("Input data format is not supported. \n Expecting Object or JSON String, but receive '" + type + "'");
                }
            };
        })(this);

        this.getFormData = (function (_this) {
            return function(json) {
                var json = _this.checkType(json);
                var formData = {
                    title: json["title"],
                    showTitle: json["showTitle"],
                    description: json["description"],
                    instructions: json["instructions"]
                };

                return formData;
            }
        })(this);

        this.translate = (function (_this) {
            return function (json) {
                var builder, element, elements, item, items, option, options, page, pageIndex, pages, section, tempItem, tempObj, _i, _j, _len, _len1, id;
                json = _this.checkType(json);
                builder = [];
                pages = json["pages"];
                if (!pages) {
                    return builder;
                }
                for (pageIndex = _i = 0, _len = pages.length; _i < _len; pageIndex = ++_i) {
                    page = pages[pageIndex];
                    builder[pageIndex] = {
                        id: page.id,
                        title: page.title,
                        name: page.name,
                        showTitle: page.showTitle,
                        elements: []
                    };
                    id = pages[pageIndex].id;

                    //console.log(page, id);

                    elements = page["elements"];
                    for (_j = 0, _len1 = elements.length; _j < _len1; _j++) {
                        element = elements[_j];
                        tempObj = {
                            id: element["name"] || null,
                            label: element["title"] || null
                        };
                        section = false;
                        items = element["items"];
                        if (items) {
                            tempObj.component = 'section';
                            tempObj.components = (function () {
                                var _k, _len2, _results;
                                _results = [];
                                for (_k = 0, _len2 = items.length; _k < _len2; _k++) {
                                    item = items[_k];
                                    tempItem = {
                                        component: this.vocabulary[item["inputType"]] || null,
                                        id: item["id"] || null,
                                        label: item["title"] || null,
                                        show_label: item["showTitle"] || null,
                                        required: item["isRequired"],
                                        description: item["description"] || ''
                                    };
                                    options = item["variants"] || [];
                                    if (options) {
                                        tempItem.options = (function () {
                                            var _l, _len3, _results1;
                                            _results1 = [];
                                            for (_l = 0, _len3 = options.length; _l < _len3; _l++) {
                                                option = options[_l];
                                                if (option["title"]) {
                                                    _results1.push(option["title"]);
                                                } else {
                                                    _results1.push(void 0);
                                                }
                                            }
                                            return _results1;
                                        })();
                                    }
                                    _results.push(tempItem);
                                }
                                return _results;
                            }).call(_this);
                        } else {
                            tempObj.component = _this.vocabulary[element["inputType"]] || null;
                            tempObj.id = element["id"] || null;
                            tempObj.label = element["title"] || null;
                            tempObj.show_label = element["showTitle"] || null;
                            tempObj.required = element["isRequired"];
                            tempObj.description = element["description"] || null;
                        }
                        builder[pageIndex]["elements"].push(tempObj);
                    }
                }

                return builder;
            };
        })(this);


        this.translateBackwards = (function (_this) {
            function setOptions(options) {
                var variants = [];

                options.map(function(value, id) {
                    variants[id] = {
                        "Item1": value,
                        "Item2": id
                    }
                });

                return variants;
            }

            function setType(type) {
                var casualItem  = "FormBuilder.Models.Item, FormBuilder",
                    variantItem = "FormBuilder.Models.ItemVariant, FormBuilder",
                    sectionItem = "FormBuilder.Models.Section, FormBuilder",
                    itemType;

                switch (type) {
                    case 'section':
                        itemType = sectionItem;
                        break;
                    case 'select':
                        itemType = variantItem;
                        break;
                    case 'checkbox':
                        itemType = variantItem;
                        break;
                    case 'radio':
                        itemType = variantItem;
                        break;
                    default:
                        itemType = casualItem;
                        break;
                }
                return itemType;
            }

            return function (jsonData, formData) {
                var item, items, options, formPage, jsonPage, pageIndex, formElement, section, tempItem, tempObj, _i, _j, _len, _len1;

                jsonData["Pages"] = [];

                if (!formData.length) {
                    return jsonData;
                }

                for (pageIndex = _i = 0, _len = formData.length; _i < _len; pageIndex = ++_i) {
                    formPage = formData[pageIndex];
                    jsonPage = {
                        "Id": pageIndex.toString(),
                        "Name": null,
                        "Title": "Page_"+pageIndex,
                        "ShowTitle": true,
                        "Elements": [],
                        "ExtraProperties": {
                            "$type": "System.Collections.Generic.Dictionary`2[[System.String, mscorlib],[FormBuilder.Models.ExtraProperty, FormBuilder]], mscorlib"
                        },
                        "$type": "FormBuilder.Models.Page, FormBuilder"
                    };

                    for (_j = 0, _len1 = formPage.length; _j < _len1; _j++) {
                        formElement = formPage[_j];
                        tempObj = {
                            "Id": formElement.index,
                            "Name": null,
                            "Title": formElement.label || null,
                            "ShowTitle": formElement.show_label,
                            "ExtraProperties": {
                                "$type": "System.Collections.Generic.Dictionary`2[[System.String, mscorlib],[FormBuilder.Models.ExtraProperty, FormBuilder]], mscorlib"
                            },
                            "$type": setType(formElement.component)
                        };

                        if (formElement.component === "section") {
                            items = formElement.components;

                            tempObj["Items"] = (function () {
                                var _k, _len2, _results;
                                _results = [];
                                for (_k = 0, _len2 = items.length; _k < _len2; _k++) {
                                    item = items[_k];
                                    tempItem = {
                                        "InputType": this.vocabularyBackwards[item.component] || null,
                                        "Id": item.id || null,
                                        "Title": item.label || null,
                                        "IsRequired": item.required,
                                        "Description": item.description || '',
                                        "ExtraProperties": {
                                            "$type": "System.Collections.Generic.Dictionary`2[[System.String, mscorlib],[FormBuilder.Models.ExtraProperty, FormBuilder]], mscorlib"
                                        },
                                        "$type": setType(item.component)
                                    };

                                    options = item.options || [];
                                    if (options.length)  tempItem["variants"] = setOptions(options);

                                    _results.push(tempItem);
                                }
                                return _results;
                            }).call(_this);
                        } else {
                            options = formElement.options || [];
                            if (options.length)  tempObj["variants"] = setOptions(options);

                            tempObj["InputType"] = _this.vocabulary[formElement.component] || null;
                            tempObj["Name"] = formElement.id;
                            tempObj["Title"] = formElement.label || null;
                            tempObj["ShowTitle"] = formElement.show_label || null;
                            tempObj["IsRequired"] = formElement.required;
                            tempObj["Description"] = formElement.description || null;
                        }

                        jsonPage["Elements"].push(tempObj);
                    }

                    jsonData["Pages"].push(jsonPage)
                }

                return jsonData;
            };
        })(this);

        this.$get = [
            '$injector', (function (_this) {
                return function ($injector) {
                    _this.setupProviders($injector);
                    return {
                        getFormData: _this.getFormData,
                        translate: _this.translate,
                        translateBackwards: _this.translateBackwards
                    };
                };
            })(this)
        ];
    });