{ezscript_require( array(
'leaflet/leaflet.0.7.2.js',
'ezjsc::jquery',
'plugins/chosen.jquery.js',
'leaflet/leaflet.markercluster.js',
'leaflet/Leaflet.MakiMarkers.js',
'jquery.opendataTools.js',
'jquery.opendataMap.js'
) )}
{ezcss_require( array(
'plugins/chosen.css',
'plugins/leaflet/leaflet.css',
'plugins/leaflet/map.css',
'MarkerCluster.css',
'MarkerCluster.Default.css' ) )}

{set_defaults(hash(
'height', 600,
'map_type', 'osm',
'show_title', true()
))}

{set $height = $height|fix_dimension()}

<div class="openpa-widget {$block.view}">
  {if and( $show_title, $block.name|ne('') )}
    <h3 class="openpa-widget-title">{if and($openpa.root_node, $link_top_title)}<a href={$openpa.root_node.url_alias|ezurl()}>{/if}{$block.name|wash()}{if $openpa.root_node}</a>{/if}</h3>
  {/if}
  <div class="openpa-widget-content">
    <div class="content-filters"></div>
    <div id="map-{$block.id}" style="height: {$height}px; width: 100%"></div>

    <script type="text/javascript" language="javascript" class="init">

      var mainQuery = "(raw[attr_lat_s] = '*' and raw[attr_lon_s] = '*') and classes [public_organization]";
      var siteAccess = "{"/"|ezurl(no)}";
      var mapId = 'map-{$block.id}';
      var markersId = 'markers-{$block.id}';

      $.opendataTools.settings('language', 'ita-IT');
      $.opendataTools.settings('endpoint', {ldelim}
        "geo": "{'/opendata/api/geo/search/'|ezurl(no)}",
        "search": "{'/opendata/api/content/search/'|ezurl(no)}",
        "class": "{'/opendata/api/classes/'|ezurl(no)}"
      {rdelim});

      {literal}

      var facets = [
        {field: 'comunita', 'limit': 100, 'sort': 'alpha', name: 'Comunità di valle'},
        {field: 'categoria', 'limit': 100, 'sort': 'alpha', name: 'Tipo di ente'}
      ];

      $(document).ready(function () {
        var opendataMap = $.opendataMap;
        opendataMap.tools = $.opendataTools;

        mainQuery += ' facets [' + opendataMap.tools.buildFacetsString(facets) + ']';

        opendataMap.tools.settings = $.extend(true, {}, {
          "builder": {
            "query": mainQuery,
            "filters": {}
          },
          "endpoint": {/literal}'{"/openpa/data/tn_fam_reverse_map_markers"|ezurl(no)}'{literal}
        });

        opendataMap.mapId = mapId;
        opendataMap.markersId = markersId;
        opendataMap.loadMap();
      });
    </script>

  </div>
</div>
