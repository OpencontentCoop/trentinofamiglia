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

      var mainQuery = "classes [certificazione_familyaudit] subtree [1254]";
      var siteAccess = "{"/"|ezurl(no)}";
      var mapId = 'map-{$block.id}';
      var markersId = 'markers-{$block.id}';

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
