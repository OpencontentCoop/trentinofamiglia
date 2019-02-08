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
'height', 450,
'map_type', 'osm',
'title', false(),
'id', '',
'query', '',
'facets', '',
'class', '',
'attribute', ''
))}

{set $height = $height|fix_dimension()}


<div id="map" style="height: {$height}px; width: 100%"></div>

<script type="text/javascript" language="javascript" class="init">

  var mainQuery = "{$node.contentobject_id}";
  var siteAccess = "{"/"|ezurl(no)}";
  var mapId = 'map';
  var markersId = 'markers';
  {*{field: 'stato_certificazione', 'limit': 100, 'sort': 'alpha', name: 'Stato certificazione'},
  {field: 'sperimentazione', 'limit': 100, 'sort': 'alpha', name: 'Tipo di sperimentazione'}*}
  var facets = [];
  var classIdentifier = 'piano_comunale';
  var attribute = 'geo';

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

    opendataMap.tools.settings = $.extend(true, {}, {
      "builder": {
        "query": mainQuery,
        "filters": {}
      },
      "endpoint": {/literal}'{"/openpa/data/tn_fam_map_piano_comunale_markers"|ezurl(no)}'
      {literal}
    });

    opendataMap.mapId = mapId;
    opendataMap.markersId = markersId;
    opendataMap.parameters = [
      {"key": "classIdentifier", "value": classIdentifier},
      {"key": "attribute", "value": attribute},
      {"key": "contentType", "value": "geojson"}
    ];
    opendataMap.loadMap();
    {/literal}
  });
</script>
