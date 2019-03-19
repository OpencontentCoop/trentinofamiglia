;(function ($, window, document, undefined) {

    var FilterFactory = function(label, queryField, containerSelector, facetSort, facetLimit, cssClasses){
        return {

            cssClasses: cssClasses,

            label: label,

            showSpinner: false,

            showCount: false,

            multiple: true,

            current: ['all'],

            name: queryField,

            container: containerSelector,

            buildQueryFacet: function () {
                return queryField+'|'+facetSort+'|'+facetLimit;
            },

            buildQuery: function () {
                var currentValues = this.getCurrent();
                if (currentValues.length && jQuery.inArray('all', currentValues) == -1) {
                    if (queryField.endsWith("_ms]")){
                        return queryField+' in [\'' + $.map(currentValues, function (item) {
                            return item.toString()
                                .replace(/"/g, '\\\"')
                                .replace(/'/g, "\\'")
                                .replace(/\(/g, "\\(")
                                .replace(/\)/g, "\\)");
                        }).join("','") + '\']';
                    }else{
                        return queryField+' in [\'"' + $.map(currentValues, function (item) {
                            return item.toString()
                                .replace(/"/g, '\\\"')
                                .replace(/'/g, "\\'")
                                .replace(/\(/g, "\\(")
                                .replace(/\)/g, "\\)");
                        }).join("','") + '"\']';
                    }
                }

                return null;
            },

            filterClickEvent: function (e, view) {
                var self = this;
                var selectedValue = [];
                var selected = $(e.currentTarget);
                if (selected.data('value') != 'all'){
                    var selectedWrapper = selected.parent();
                    if (this.multiple){
                        if (selectedWrapper.hasClass(self.cssClasses.itemWrapperActive)){
                            selectedWrapper.removeClass(self.cssClasses.itemWrapperActive);
                            selected.removeClass(self.cssClasses.itemActive);
                        }else{
                            selectedWrapper.addClass(self.cssClasses.itemWrapperActive);
                            selected.addClass(self.cssClasses.itemActive);
                        }
                        $('li.active', $(this.container)).each(function(){
                            var value = $(this).find('a').data('value');
                            if (value != 'all'){
                                selectedValue.push(value);
                            }
                        });
                    }else{
                        $('li', $(this.container)).removeClass(self.cssClasses.itemWrapperActive);
                        $('li a', $(this.container)).removeClass(self.cssClasses.itemActive);
                        selectedWrapper.addClass(self.cssClasses.itemWrapperActive);
                        selected.addClass(self.cssClasses.itemActive);
                        selectedValue = [selected.data('value')];
                    }
                    if (this.showSpinner){
                        selected.parents('div.filter-wrapper').find('.widget_title a').append('<span class="loading pull-right"> <i class="fa fa-circle-notch fa-spin"></i></span>');
                    }
                }
                this.setCurrent(selectedValue);
                view.doSearch();
                e.preventDefault();
            },

            init: function (view, filter) {
                $(filter.container).find('a').on('click', function (e) {
                    filter.filterClickEvent(e, view)
                });
            },

            setCurrent: function (value) {
                this.current = value;
            },

            getCurrent: function () {
                return this.current;
            },

            refresh: function (response, view) {
                var self = this;
                if (self.showSpinner){
                    $('span.loading').remove();
                }

                var current = self.getCurrent();
                $('li a', $(self.container)).each(function () {
                    if ($(this).data('value') !== 'all'){
                        var name = $(this).data('name');
                        $(this).html(name).data('count', 0).addClass(self.cssClasses.itemEmpty);
                    }
                });

                $.each(response.facets, function () {
                    var name = this.name;
                    if (this.name == self.name) {
                        $.each(this.data, function (value, count) {
                            if (value != '') {
                                var quotedValue = self.quoteValue(value);

                                var item = $('li a[data-value="' + value + '"]', $(self.container));
                                if (item.length) {
                                    var nameText = item.data('name');
                                    if (self.showCount){
                                        nameText += ' (' + count + ')';
                                    }
                                    item.html(nameText)
                                        .removeClass(self.cssClasses.itemEmpty)
                                        .data('count', count);
                                } else {
                                    var li = $('<li></li>');
                                    var a = $('<a href="#" class="'+self.cssClasses.item+'" data-name="' + value + '" data-value="' + quotedValue + '"></a>')
                                        .data('count', count)
                                        .on('click', function(e){self.filterClickEvent(e,view)});
                                    var nameText = value;
                                    if (self.showCount){
                                        nameText += ' (' + count + ')';
                                    }
                                    a.html(nameText)
                                        .removeClass(self.cssClasses.itemEmpty)
                                        .appendTo(li);
                                    $(self.container).append(li);
                                }
                            }
                        });
                    }
                });
            },

            quoteValue: function(value){
                return value;
            },

            reset: function (view) {
                var self = this;
                $('li', $(self.container)).removeClass(self.cssClasses.itemWrapperActive);
                var currentValues = this.getCurrent();
                $.each(currentValues, function () {
                    $('li a[data-value="' + this + '"]', $(self.container)).parent().addClass(self.cssClasses.itemWrapperActive);
                });
            }
        }
    };

    $.initTnFamMapViewEvent = function(){
        $('.widget').on('hidden.bs.collapse', function () {
          $(this).parents('.filters-wrapper').removeClass('has-active');
          $(this).parent().removeClass('active').addClass('unactive');
          $(this).prev().find('i').removeClass('fa-times').addClass('fa-plus');
        }).on('show.bs.collapse', function () {
          $(this).parents('.filters-wrapper').find('div.filter-wrapper').removeClass('active').addClass('unactive');
          $(this).parent().removeClass('unactive').addClass('active').show();
          $(this).parents('.filters-wrapper').addClass('has-active');
          $(this).prev().find('i').removeClass('fa-plus').addClass('fa-times');
        });

        $('body').click(function (e) {
            if($(e.target).closest('.widget').length == 0 && $(e.target).closest('.widget_title').length == 0) {
                $('.widget').each(function(){
                    if($(this).hasClass('in')){
                        $(this).removeClass('in').trigger('hidden.bs.collapse');
                    }
                })
            }
        });

        $('.open-xs-filter').on('click', function(){
            $(this).addClass('hidden-xs');
            $('.filters-wrapper').removeClass('hidden-xs').addClass('filters-wrapper-xs');
            $('.close-xs-filter').show();
            $('body').addClass('modal-open');
        });
        $('.close-xs-filter').on('click', function(){
            $(this).hide();
            $('.open-xs-filter').removeClass('hidden-xs');
            $('.filters-wrapper').removeClass('filters-wrapper-xs').addClass('hidden-xs');
            $('body').removeClass('modal-open');
        });
    };

    var tiles = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    });


    $.fn.tnFamMap = function (settings) {

        var that = $(this);

        var tiles = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {maxZoom: 18,attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'});
        var map = L.map(that.find('.current-result .map')[0])
            .addLayer(tiles);
        map.scrollWheelZoom.disable();
        var markers = L.markerClusterGroup();

        markers.on('click', function (a) {
            $.getJSON( options.endpoint + "?contentType=marker&view=panel&id=" + a.layer.feature.id, function (data) {
                var popup = new L.Popup({maxHeight: 360});
                popup.setLatLng(a.layer.getLatLng());
                popup.setContent(data.content);
                map.openPopup(popup);
            });
        });

        var options = $.extend(true, {
            'filterTpl': '#tpl-filter',
            'spinnerTpl': '#tpl-spinner',
            'emptyTpl': '#tpl-empty',
            'itemTpl': '#tpl-item',
            'loadOtherTpl': '#tpl-load-other',
            'closeXsFilterTpl': '#tpl-close-xs-filter',
            'cssClasses': {
                'item': '',
                'itemActive': '',
                'itemEmpty': 'text-muted',
                'itemWrapper': '',
                'itemWrapperActive': 'active',
                'listWrapper': 'nav nav-pills nav-stacked'
            },
            'viewHelpers': $.opendataTools.helpers,
            'endpoint': null,
            'block': null,
            'facetDefinitions': null
        }, settings)

        $.opendataTools.settings('endpoint', {search: options.endpoint+'/'+options.block});

        var filterTpl = $.templates(options.filterTpl);
        var spinner = $($.templates(options.spinnerTpl).render({}));
        var empty = $.templates(options.emptyTpl).render({});
        var cssClasses = options.cssClasses;

        var searchView = that.opendataSearchView({
            query: '',
            onBeforeSearch: function (query, view) {
                view.container.find('.current-result').prepend(spinner);
            },
            onLoadResults: function (response, query, appendResults, view) {
                var currentFilterContainer = view.container.find('.current-filter');


                currentFilterContainer.empty();
                $.each(view.filters, function(){
                    var filter = this;
                    var currentValues = filter.getCurrent();
                    var filterContainer = $(filter.container);
                    var currentXsFilterContainer = filterContainer.parents('div.filter-wrapper').find('.current-xs-filters');
                    currentXsFilterContainer.empty();
                    if (currentValues.length && jQuery.inArray('all', currentValues) == -1) {
                        var item = $('<li><strong>'+ filter.label +'</strong>:</li>');
                        $.each(currentValues, function(){
                            var value = this;
                            var valueElement = $('a[data-value="'+filter.quoteValue(value)+'"]', filter.container);
                            var name = valueElement.data('name');
                            currentXsFilterContainer.append('<li>'+name+'</li>');
                            $('<a href="#" style="margin:0 5px"><i class="fa fa-times"></i> '+name+'</a>')
                                .on('click', function(e){
                                    valueElement.trigger('click');
                                    e.preventDefault();
                                })
                                .appendTo(item);
                        });
                        item.appendTo(currentFilterContainer);
                    }else{
                        filterContainer.find('li a[data-value="all"]').parent().addClass('active');
                    }
                });

                spinner.remove();

                markers.clearLayers();
                var geoJsonLayer = L.geoJson(response, {
                    pointToLayer: function (feature, latlng) {
                      var customIcon = L.MakiMarkers.icon({icon: "star", color: "#f00", size: "l"});
                      var marker = L.marker(latlng, {icon: customIcon});
                      return marker;
                    }
                });
                markers.addLayer(geoJsonLayer);
                map.addLayer(markers);
                map.fitBounds(markers.getBounds());
            },
            onLoadErrors: function (errorCode, errorMessage, jqXHR, view) {
                view.container.html('<div class="alert alert-danger">' + errorMessage + '</div>')
            }
        }).data('opendataSearchView');

        var template = $.templates(options.filterTpl);
        if (options.facetDefinitions.length > 0){
            $.each(options.facetDefinitions, function(){
                var cleanSelector = this.field.replace('raw[', '').replace(']', '').replace('.', '');
                var field = this.field;
                if (field == 'raw[meta_class_identifier_ms]'){
                    field = 'raw[meta_class_name_ms]';
                }
                var filter = {
                    id: cleanSelector,
                    label: this.name || cleanSelector,
                    queryField: field,
                    facetSort: this.sort || 'alpha',
                    facetLimit: this.limit || 100,
                    containerSelector: '#'+that.attr('id')+' ul[data-filter="'+cleanSelector+'"]',
                    cssClasses: options.cssClasses
                };
                var filterWrapper = that.find('.filters-wrapper').append($(template.render(filter)));
                searchView.addFilter(FilterFactory(
                    filter.label,
                    filter.queryField,
                    filter.containerSelector,
                    filter.facetSort,
                    filter.facetLimit,
                    filter.cssClasses
                ));
            });
            that.find('.filters-wrapper').append($($.templates(options.closeXsFilterTpl).render({id: that.attr('id')})));
        }
        searchView.init().doSearch();

        $.initTnFamMapViewEvent();

        return this;
    };
})(jQuery, window, document);
