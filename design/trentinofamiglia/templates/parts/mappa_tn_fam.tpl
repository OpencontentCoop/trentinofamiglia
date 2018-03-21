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
  'title', false(),
  'id', '',
  'query', '',
  'facets', '',
  'attribute', ''
))}

{set $height = $height|fix_dimension()}

<div class="openpa-widget">
  {if $title}
    <h3 class="openpa-widget-title">{$title}</h3>
  {/if}
  <div class="openpa-widget-content">
    <div class="content-filters"></div>
    <div id="map-{$id}" style="height: {$height}px; width: 100%"></div>

    <script type="text/javascript" language="javascript" class="init">

      var mainQuery = "{$query|trim()}";
      var siteAccess = "{"/"|ezurl(no)}";
      var mapId = 'map-{$id}';
      var markersId = 'markers-{$id}';
      {*{field: 'stato_certificazione', 'limit': 100, 'sort': 'alpha', name: 'Stato certificazione'},
      {field: 'sperimentazione', 'limit': 100, 'sort': 'alpha', name: 'Tipo di sperimentazione'}*}
      var facets = [{$facets|trim()}];
      var attribute = '{$attribute|trim()}';

      $.opendataTools.settings('language', 'ita-IT');
      $.opendataTools.settings('endpoint', {ldelim}
        "geo": "{'/opendata/api/geo/search/'|ezurl(no)}",
        "search": "{'/opendata/api/content/search/'|ezurl(no)}",
        "class": "{'/opendata/api/classes/'|ezurl(no)}"
      {rdelim});

      {literal}
      $(document).ready(function () {
        var opendataMap = $.opendataMap;
        opendataMap.tools = $.opendataTools;

        mainQuery += ' facets [' + opendataMap.tools.buildFacetsString(facets) + ']';

        opendataMap.tools.settings = $.extend(true, {}, {
          "builder": {
            "query": mainQuery,
            "filters": {}
          },
          "endpoint": {/literal}'{"/openpa/data/tn_fam_map_markers"|ezurl(no)}'
          {literal}
        });

        opendataMap.mapId = mapId;
        opendataMap.markersId = markersId;
        opendataMap.parameters = [
          {"key": "attribute", "value": attribute},
          {"key": "contentType", "value": "geojson"}
        ];
        opendataMap.loadMap();
        {/literal}
      });
    </script>

  </div>
</div>
