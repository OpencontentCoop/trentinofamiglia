{if and( $attribute.content.latitude, $attribute.content.longitude )}
  {if is_set($map_id)|not()}
    {def $map_id = $attribute.id}
  {/if}

  {ezscript_require( array( 'leaflet.1.6.0.js', 'leaflet/Leaflet.MakiMarkers.js', 'leaflet/leaflet.markercluster.js') )}
  {ezcss_require( array( 'leaflet/leaflet.css', 'leaflet/map.css', 'leaflet/MarkerCluster.css', 'leaflet/MarkerCluster.Default.css' ) )}

  <div id="map-{$map_id}" style="width: 100%; height: 200px;"></div>
  <p class="goto">
    <a class="btn u-layout-matchHeight u-margin-bottom-xs u-margin-top-xs" target="_blank"
       href="https://www.google.com/maps/dir//'{$attribute.content.latitude},{$attribute.content.longitude}'/@{$attribute.content.latitude},{$attribute.content.longitude},15z?hl=it">
        <small>{'How to get'|i18n('openpa_designitalia')} <i class="fa fa-external-link"></i></small>
    </a>
  </p>

  {run-once}
  {literal}
    <script>
      var drawMap = function(latlng,id){
        var map = new L.Map('map-'+id);
        map.scrollWheelZoom.disable();
        var customIcon = L.MakiMarkers.icon({icon: "star", color: "#f00", size: "l"});
        var postMarker = new L.marker(latlng,{icon:customIcon});
        postMarker.addTo(map);
        map.setView(latlng, 16);
        L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
      }
    </script>
  {/literal}
  {/run-once}

  <script>
    drawMap([{$attribute.content.latitude},{$attribute.content.longitude}],"{$map_id}");
  </script>
  {undef $map_id}
{/if}
