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

      {*include uri='design:parts/mappa_tn_fam.tpl'
               title="Organizzazioni aderenti"
               query= concat("raw[subattr_geo___coordinates____gpt] range ['-90,-90','90,90'] and classes [public_organization,private_organization] and comune.id in [", $node.contentobject_id, "]")
               facets=""
               class="comune"
               attribute="comune"
      *}

      <div id="map" style="height: 600px; width: 100%"></div>

      {node_view_gui content_node=$node view=children view_parameters=$view_parameters}

    </div>
    {def $extra_template = 'design:openpa/full/parts/section_left/empty.tpl'}
    {include uri='design:openpa/full/parts/section_left.tpl' extra_template=$extra_template}
  </div>
  {if $openpa.content_date.show_date}
    {include uri=$openpa.content_date.template}
  {/if}
</div>

{ezscript_require( array(
    'ezjsc::jquery',
    'jquery.opendataTools.js',
    'moment-with-locales.min.js',    
    'leaflet.js',
    'leaflet.markercluster.js',
    'leaflet.makimarkers.js'    
))}

{ezcss_require( array(
    'plugins/leaflet/leaflet.css',
    'plugins/leaflet/map.css',
    'MarkerCluster.css',
    'MarkerCluster.Default.css' 
))}

<script type="text/javascript" language="javascript">
var query = "{concat("classes [public_organization,private_organization] and comune.id in [", $node.contentobject_id, "]")}";
{literal}
$(document).ready(function () {
  var tools = $.opendataTools;
  var initMap = function () {
    var map = tools.initMap(
        'map',
        function (response) {
            return L.geoJson(response, {
                pointToLayer: function (feature, latlng) {
                    var customIcon = L.MakiMarkers.icon({icon: "circle", size: "l"});
                    return L.marker(latlng, {icon: customIcon});
                },
                onEachFeature: function (feature, layer) {
                    var popupDefault = '<h3><a href="' + tools.settings('accessPath') + '/agenda/event/' + feature.properties.mainNodeId + '" target="_blank">';
                    popupDefault += feature.properties.name;
                    popupDefault += '</a></h3>';
                    var popup = new L.Popup({maxHeight: 360});
                    popup.setContent(popupDefault);                          
                    layer.bindPopup(popup);
                }
            });
        }
    );
    map.scrollWheelZoom.disable();
    tools.loadMarkersInMap(query);
  };
  initMap();
});
{/literal}
</script>

