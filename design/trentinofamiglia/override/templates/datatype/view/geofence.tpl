{set_defaults( hash(
                'icon_size', 'small',
                'icon_title', $attribute.content.mime_type,
                'icon','no'
))}

{ezscript_require( array( 'leaflet.1.6.0.js', 'togeojson.js') )}
{ezcss_require( array( 'leaflet/leaflet.css', 'leaflet/map.css' ) )}

{if $attribute.has_content}
	{if $attribute.content}
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css"
          integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ=="
          crossorigin=""/>
    <div id="geofence-map" class="u-margin-bottom-s" style="width: 100%; height: 400px"></div>
    <script>
      var file = '{concat("content/download/",$attribute.contentobject_id,"/",$attribute.id,"/file/",$__file_name)|ezurl(no)}';
      {literal}
      var geoFenceMap = L.map('geofence-map').setView([46.066667, 11.116667], 14);
      mapLink =
              '<a href="http://openstreetmap.org">OpenStreetMap</a>';
      L.tileLayer(
              'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; ' + mapLink + ' Contributors',
                maxZoom: 18,
              }).addTo(geoFenceMap);

      $(document).ready(function () {
        $.ajax(file).done(function (xml) {
          var dom = (new DOMParser()).parseFromString(xml, 'text/xml');
          var geojsonFeature = toGeoJSON.gpx(dom);
          var jsonLayer = L.geoJSON(geojsonFeature).addTo(geoFenceMap);
          geoFenceMap.fitBounds(jsonLayer.getBounds());
        });
      });
      {/literal}
    </script>

	{def $__file_name = $attribute.content.original_filename}
	{set $__file_name = strReplace($__file_name,array(" ","_"))}

      <a href={concat("content/download/",$attribute.contentobject_id,"/",$attribute.id,"/file/",$__file_name)|ezurl} title="Scarica il file {$attribute.content.original_filename|wash( xhtml )}">
        <span title="{$attribute.content.original_filename|wash( xhtml )}"><i class="fa fa-download"></i> Scarica il file</span>
        <small>(File {$attribute.content.mime_type} {$attribute.content.filesize|si( byte )})</small>
      </a>
	{else}
		{editor_warning('The file could not be found.'|i18n( 'design/ezwebin/view/ezbinaryfile' ) )}
	{/if}
{/if}

