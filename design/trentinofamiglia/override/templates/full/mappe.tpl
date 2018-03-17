{def $openpa = object_handler($node)}


{if $openpa.control_cache.no_cache}
    {set-block scope=root variable=cache_ttl}0{/set-block}
{/if}

{if $openpa.content_tools.editor_tools}
    {include uri=$openpa.content_tools.template}
{/if}

{if $openpa.control_menu.side_menu.root_node}
{def $tree_menu = tree_menu( hash( 'root_node_id', $openpa.control_menu.side_menu.root_node.node_id, 'user_hash', $openpa.control_menu.side_menu.user_hash, 'scope', 'side_menu' ))
     $show_left = and( $openpa.control_menu.show_side_menu, count( $tree_menu.children )|gt(0) )}
{else}
  {def $show_left = false()}
{/if}

<div class="openpa-full class-{$node.class_identifier}">
    <div class="title">
        {include uri='design:openpa/full/parts/node_languages.tpl'}
        <h2>{$node.name|wash()}</h2>
    </div>
    <div class="content-container">
        <div class="content{if or( $show_left, $openpa.control_menu.show_extra_menu )} withExtra{/if}">

            {include uri=$openpa.content_main.template}

        </div>



      {def $parent = fetch( 'content', 'node', hash( 'node_id', 1254 ) ) }



      {ezscript_require( array(
      'leaflet/leaflet.0.7.2.js',
      'ezjsc::jquery',
      'leaflet/leaflet.markercluster.js',
      'leaflet/Leaflet.MakiMarkers.js',
      'jquery.opendataTools.js',
      'jquery.opendataMap.js'
      ) )}
      {ezcss_require( array( 'plugins/leaflet/leaflet.css', 'plugins/leaflet/map.css', 'MarkerCluster.css', 'MarkerCluster.Default.css' ) )}

      {set_defaults(hash(
      'height', 600,
      'map_type', 'osm',
      'class_identifiers', array(),
      'items_per_row', 1,
      'show_list', true()
      ))}

      {set $height = $height|fix_dimension()}
      {*def $markers = fetch( 'ocbtools', 'map_markers', hash( 'parent_node_id', $node.node_id, class_identifiers, $class_identifiers ) )}
      {if $markers|count()*}

      <div class="Grid">
        <div class="Grid-cell {if $show_list}{if $items_per_row|eq(1)}u-sizeFull{else} u-md-size3of4 u-lg-size3of4{/if}{else}u-sizeFull{/if}">
          <div class="content-filters"></div>
          <div id="map-{$node.node_id}" style="height: {$height}px; width: 100%"></div>

          <script type="text/javascript" language="javascript" class="init">

            var mainQuery = "classes [certificazione_familyaudit] subtree [1254]";
            var siteAccess = "{"/"|ezurl(no)}";

            $.opendataTools.settings('language', 'ita-IT');
            $.opendataTools.settings('endpoint', {ldelim}
              geo: "{'/opendata/api/geo/search/'|ezurl(no)}",
              search: "{'/opendata/api/content/search/'|ezurl(no)}",
              class: "{'/opendata/api/classes/'|ezurl(no)}",
              {rdelim});

            {literal}

            var facets = [
              {field: 'stato_certificazione', 'limit': 100, 'sort': 'alpha', name: 'Stato certificazione'},
              {field: 'sperimentazione', 'limit': 100, 'sort': 'alpha', name: 'Tipo di sperimentazione'}
            ];
            $(document).ready(function () {
              var tools = $.opendataTools;
              tools.settings = $.extend(true, {}, {
                "builder": {
                  "query": mainQuery,
                  "filters": {}
                },
                "endpoint": {/literal}'{"/openpa/data/tn_fam_map_markers"|ezurl(no)}'{literal}
              });
              mainQuery += ' facets [' + tools.buildFacetsString(facets) + ']';


              tools.find(mainQuery + ' limit 1', function (response) {
                var form = $('<form class="form">');
                $.each(response.facets, function () {
                  form.append(buildFilterInput(facets, tools , this));
                });

                $('.content-filters').append(form).show();
              });

              var query = buildQuery(false, tools);
              //loadMap('map-{$node.node_id}', 'markers-{$node.node_id}', "{concat('/openpa/data/tn_fam_map_markers'|ezurl(no), '?parentNode=1254', '&classIdentifiers=', $class_identifiers|implode(',') )}&contentType=geojson");
              loadMap(tools, query);


            });

            var loadMapData = function (tools) {
              //tools.settings.datatable.prevQuery = tools.settings.datatable.ajax.query;
              var buildedQuery = tools.buildQuery();
              tools.settings.datatable.ajax.url = tools._ajaxUrl + '?q=' + buildedQuery;
              tools.settings.datatable.ajax.query = buildedQuery;

            };

            var buildQuery = function (notEncoded, tools ) {
              var query = '';
              $.each(tools.settings.builder.filters, function () {
                if (this != null) {
                  console.log(this);
                  if ($.isArray(this.value)) {

                    query += this.field + " " + this.operator + " ['" + this.value.join("','") + "']";
                    query += ' and ';
                  }
                }
              });
              if (tools.settings.builder.query != null) {
                query += tools.settings.builder.query;
              }
              console.log( ' -- Query: ' + query);
              return !notEncoded ? encodeURIComponent(query) : query;
            };

            var buildFilterInput = function (facets, tools, facet) {
              for (var i = 0, len = facets.length; i < len; i++) {
                var currentFilters = tools.settings.builder.filters;
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
                  attachFilterInput(select, tools);
                  return selectContainer;

                }
              }

            };


            var attachFilterInput = function($select, tools){
              $select.chosen({width: '100%', allow_single_deselect: true}).on('change', function (e) {
                var that = $(e.currentTarget);
                var values = $(e.currentTarget).val();
                if (typeof $(e.currentTarget).attr('multiple') == 'undefined' && values) {
                  values = [values]
                }
                if (values != null && values.length > 0) {
                  console.log('filtro');
                  tools.settings.builder.filters[that.data('field')] = {
                    'field': that.data('field'),
                    'operator': 'contains',
                    'value': values
                  };
                } else {
                  tools.settings.builder.filters[that.data('field')] = null;
                  console.log('elimina filtro');
                }
                console.log(tools.settings.builder.filters);
                var query = buildQuery(false, tools);
                loadMap(tools, query);

              });
            }

            var loadMap = function(tools, query){
              var endpoint = tools.settings.endpoint;
              var mapId = 'map-{/literal}{$node.node_id}{literal}';
              var markersId = 'markers-{/literal}{$node.node_id}{literal}';
              var geoJson = endpoint + '?query=' + query + '&contentType=geojson';


              //var tiles = L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {maxZoom: 18,attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'});
              var tiles = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {maxZoom: 18,attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'});
              var map = L.map(mapId).addLayer(tiles);
              map.scrollWheelZoom.disable();
              var markers = L.markerClusterGroup();
              var markerMap = {};
              $.getJSON(geoJson, function(data) {
                $.each(data.content.features, function(i,v){
                  var markerListItem = $("<li data-id='"+v.id+"'><a href='"+v.properties.url+"'><small>"+v.properties.className+"</small> "+v.properties.name+"</a></li>");
                  markerListItem.bind('click',markerListClick);
                  $('#'+markersId).append(markerListItem);
                });
                var geoJsonLayer = L.geoJson(data.content, { pointToLayer: function (feature, latlng) {
                  var customIcon = L.MakiMarkers.icon({icon: "star", color: "#f00", size: "l"});
                  var marker = L.marker(latlng, {icon: customIcon});
                  markerMap[feature.id] = marker;
                  return marker;
                } });
                markers.addLayer(geoJsonLayer);
                map.addLayer(markers);
                map.fitBounds(markers.getBounds());
              });
              markers.on('click', function (a) {
                $.getJSON("{/literal}{'/openpa/data/map_markers'|ezurl(no)}{literal}?contentType=marker&view=panel&id="+a.layer.feature.id, function(data) {
                  var popup = new L.Popup({maxHeight:360});
                  popup.setLatLng(a.layer.getLatLng());
                  popup.setContent(data.content);
                  map.openPopup(popup);
                });
              });
              markerListClick = function(e){
                var id = $(e.currentTarget).data('id');
                var m = markerMap[id];
                markers.zoomToShowLayer(m, function() { m.fire('click');});
                e.preventDefault();
              }
            };
            {/literal}
          </script>
        </div>

        {if $show_list}
          <div class="Grid-cell {if $items_per_row|eq(1)}u-sizeFull{else}u-md-size1of4 u-lg-size1of4{/if}">
            <ul id="markers-{$node.node_id}" class="Linklist Linklist--padded"{if $items_per_row|gt(1)} style="height: {$height}px;overflow-y: auto"{/if}></ul>
          </div>
        {/if}

      </div>




    </div>
</div>



