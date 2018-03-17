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

            {include uri=$openpa.content_contacts.template}

            {include uri=$openpa.content_detail.template}

            {include uri=$openpa.content_infocollection.template}

            {node_view_gui content_node=$node view=children view_parameters=$view_parameters}

        </div>



      {def $parent = fetch( 'content', 'node', hash( 'node_id', 1254 ) ) }



      {ezscript_require( array(
      'leaflet/leaflet.0.7.2.js',
      'ezjsc::jquery',
      'leaflet/leaflet.markercluster.js',
      'leaflet/Leaflet.MakiMarkers.js',
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
          <div id="map-{$node.node_id}" style="height: {$height}px; width: 100%"></div>

          <script>
            {run-once}
            {literal}

            var facets = [
              {field: 'incaricato.name', 'limit': 100, 'sort': 'alpha', name: 'Incaricato'},
              {field: 'raw[extra_provvedimento_tipo_s]', 'limit': 100, 'sort': 'alpha', name: 'Tipo'},
              {field: 'descrizione_struttura', 'limit': 100, 'sort': 'alpha', name: 'Struttura'}
            ];


            var loadMap = function(mapId,markersId,geoJson){




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
            {/run-once}
            loadMap('map-{$node.node_id}', 'markers-{$node.node_id}', "{concat('/openpa/data/tn_fam_map_markers'|ezurl(no), '?parentNode=1254', '&classIdentifiers=', $class_identifiers|implode(',') )}&contentType=geojson");
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



