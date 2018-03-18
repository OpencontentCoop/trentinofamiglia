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


      <div class="Grid">
        <div
          class="Grid-cell {if $show_list}{if $items_per_row|eq(1)}u-sizeFull{else} u-md-size3of4 u-lg-size3of4{/if}{else}u-sizeFull{/if}">
          <div class="content-filters"></div>
          <div id="map-{$node.node_id}" style="height: {$height}px; width: 100%"></div>

          <script type="text/javascript" language="javascript" class="init">

            var mainQuery = "classes [certificazione_familyaudit] subtree [1254]";
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


    </div>

  </div>
</div>



