'use strict';
jQuery(function ($) {
  const opendataMap = {
    init: function () {
      //this.loadDataTable();
    },
    loadDataTable: function () {
      this.settings.datatable.prevQuery = this.settings.datatable.ajax.query;
      var buildedQuery = this.buildQuery();
      this.settings.datatable.ajax.url = this._ajaxUrl + '?q=' + buildedQuery;
      this.settings.datatable.ajax.query = buildedQuery;
      var id = this.settings.table.id;
      var table = $(this.settings.table.template).attr('id', id);
      $(this.element).append(table);
      if (this.datatable != null) {
        this.datatable.destroy(true);
      }
      this.datatable = table.DataTable(this.settings.datatable);
      if ($.isFunction(this.settings.loadDatatableCallback)) {
        this.settings.loadDatatableCallback(this);
      }
    },
    buildQuery: function (notEncoded) {
      var query = '';
      $.each(this.settings.builder.filters, function () {
        if (this != null) {
          if ($.isArray(this.value)) {
            query += this.field + " " + this.operator + " ['" + this.value.join("','") + "']";
            query += ' and ';
          }
        }
      });
      query += this.settings.builder.query;
      //console.log( ' -- Query: ' + query);
      return !notEncoded ? encodeURIComponent(query) : query;
    },
    buildFilterInput: function (facets, facet, cb, context) {
      var self = this;
      for (var i = 0, len = facets.length; i < len; i++) {
        var currentFilters = this.settings.builder.filters;
        var facetDefinition = facets[i];

        if (facetDefinition.field === facet.name && !facetDefinition.hidden) {

          var select = $('<select id="' + facetDefinition.field + '" data-field="' + facetDefinition.field + '" data-placeholder="Seleziona" name="' + facetDefinition.field + '">');

          if (facetDefinition.multiple) {
            select.attr('multiple', 'multiple');
          } else {
            select.append($('<option value=""></option>'));
          }

          facetDefinition.data = facet.data;

          $.each(facetDefinition.data, function (value, count) {
            if (value.length > 0) {
              var quotedValue = facetDefinition.field.search("extra_") > -1 ? encodeURIComponent('"' + value + '"') : value;
              var option = $('<option value="' + quotedValue + '">' + value + ' (' + count + ')</option>');
              if (currentFilters[facetDefinition.field]
                && currentFilters[facetDefinition.field].value
                && $.inArray(quotedValue, currentFilters[facetDefinition.field].value) > -1) {
                option.attr('selected', 'selected');
              }
              select.append(option);
            }
          });

          var selectContainer = $('<div class="form-group" style="margin-bottom: 10px"></div>');
          var label = $('<label for="' + facetDefinition.field + '">' + facetDefinition.name + '</label>');

          selectContainer.append(label);
          selectContainer.append(select);

          self.attachFilterInput(select);

          if ($.isFunction(cb)) {
            cb.call(context, selectContainer);
          }
        }
      }

      return self;
    },

    attachFilterInput: function ($select, cb, context) {
      var self = this;
      $select.chosen({width: '100%', allow_single_deselect: true}).on('change', function (e) {
        var that = $(e.currentTarget);
        var values = $(e.currentTarget).val();
        if (typeof $(e.currentTarget).attr('multiple') == 'undefined' && values) {
          values = [values]
        }
        if (values != null && values.length > 0) {
          self.settings.builder.filters[that.data('field')] = {
            'field': that.data('field'),
            'operator': 'contains',
            'value': values
          };
        } else {
          self.settings.builder.filters[that.data('field')] = null;
        }
        self.loadDataTable();
      });

      if ($.isFunction(cb)) {
        cb.call(context, self);
      }

      return self;
    }
  }
  opendataMap.init();
});
