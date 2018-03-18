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


<div class="Grid">
  <div
    class="Grid-cell {if $show_list}{if $items_per_row|eq(1)}u-sizeFull{else} u-md-size3of4 u-lg-size3of4{/if}{else}u-sizeFull{/if}">
    <div class="content-filters"></div>
    <div id="map-{$node.node_id}" style="height: {$height}px; width: 100%"></div>

    <script type="text/javascript" language="javascript" class="init">

      var mainQuery = "classes [adesione_distretto_famiglia] subtree [24427]";
      var siteAccess = "{"/"|ezurl(no)}";
      var mapId = 'map-{$node.node_id}';
      var markersId = 'markers-{$node.node_id}';

      $.opendataTools.settings('language', 'ita-IT');
      $.opendataTools.settings('endpoint', {ldelim}
        geo: "{'/opendata/api/geo/search/'|ezurl(no)}",
        search: "{'/opendata/api/content/search/'|ezurl(no)}",
        class: "{'/opendata/api/classes/'|ezurl(no)}",
        {rdelim});


      {literal}

      var facets = [
        {field: 'distretto.name', 'limit': 100, 'sort': 'alpha', name: 'Distretto'}
      ];

      $(document).ready(function () {
        var opendataMap = $.opendataMap;
        opendataMap.tools = $.opendataTools;

        opendataMap.tools.settings = $.extend(true, {}, {
          "builder": {
            "query": mainQuery,
            "filters": {}
          },
          "endpoint": {/literal}'{"/openpa/data/tn_fam_map_markers"|ezurl(no)}'{literal}
        });

        opendataMap.mapId = mapId;
        opendataMap.markersId = markersId;

        mainQuery += ' facets [' + opendataMap.tools.buildFacetsString(facets) + ']';

        opendataMap.tools.find(mainQuery + ' limit 1', function (response) {
          var form = $('<form class="form">');
          $.each(response.facets, function () {
            form.append( opendataMap.buildFilterInput(facets, this) );
          });
          $('.content-filters').append(form).show();
        });
        opendataMap.loadMap();
      });
    </script>

  </div>
</div>
