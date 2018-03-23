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
{literal}
$(document).ready(function () {
  var tools = $.opendataTools;
  tools.settings('accessPath', "{/literal}{'/'|ezurl(no)}{literal}");
  var initMap = function () {
    var map = tools.initMap(
        "map", //"{/literal}{$map_id}{literal}", todo fix jquery.opendataTools.js#552
        function (response) {
            return L.geoJson(response, {
                pointToLayer: function (feature, latlng) {
                    var customIcon = L.MakiMarkers.icon({icon: "circle", size: "l"});
                    return L.marker(latlng, {icon: customIcon});
                },
                onEachFeature: function (feature, layer) {
                    var popupDefault = '<h3><a href="' + tools.settings('accessPath') + '/openpa/object/' + feature.properties.id + '" target="_blank">';
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
    tools.loadMarkersInMap("{/literal}{$query}{literal}");
  };
  initMap();
});
{/literal}
</script>

<div id="map" style="height: 600px; width: 100%"></div>