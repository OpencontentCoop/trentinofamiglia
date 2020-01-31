{if is_set( $attribute_base )|not}{def $attribute_base = 'ContentObjectAttribute'}{/if}

<fieldset class="Form-field{if $attribute.has_validation_error} has-error{/if}">
    <legend class="Form-label {if $attribute.is_required}is-required{/if}">
        {first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}
        {if $attribute.is_information_collector} <em
                class="collector">{'information collector'|i18n( 'design/admin/content/edit_attribute' )}</em>{/if}
        {if $attribute.is_required} ({'required'|i18n('design/ocbootstrap/designitalia')}){/if}
    </legend>

{def $latitude  = $attribute.content.latitude|explode(',')|implode('.')
     $longitude = $attribute.content.longitude|explode(',')|implode('.')
     $contacts = openpapagedata().contacts}

    <div data-osmap-attribute="{$attribute.id}">

        <div id="map-{$attribute.id}" style="width: 100%; height: 300px; margin-top: 2px;"></div>

        <div class="block buttons float-break">
            <button class="pull-right button btn btn-sm btn-danger" name="Reset" style="display: none">Annulla modifiche</button>
            <button class="pull-right button btn btn-sm btn-info" name="MyLocation">Rileva posizione</button>
        </div>
        <div class="Grid Grid--withGutter">
            <div class="Grid-cell u-size12of12 address">
                <label>Indirizzo</label>
                <input class="ezgml_new_address box form-control"
                       type="text"
                       name="{$attribute_base}_data_gmaplocation_address_{$attribute.id}"
                       value="{$attribute.content.address|wash()}"/>
                <input class="ezgml_hidden_address"
                       type="hidden"
                       name="ezgml_hidden_address"
                       value="{$attribute.content.address|wash()}"
                       disabled="disabled"/>
            </div>
        </div>
        <div class="Grid Grid--withGutter">
            <div class="Grid-cell u-size6of12 latitude">
                <label>Latitudine</label>
                <input class="ezgml_new_latitude box form-control"
                       type="text"
                       name="{$attribute_base}_data_gmaplocation_latitude_{$attribute.id}"
                       value="{$latitude|wash()}"/>
                <input class="ezgml_hidden_latitude"
                       type="hidden"
                       name="ezgml_hidden_latitude"
                       value="{$latitude|wash()}"
                       disabled="disabled"/>
            </div>

            <div class="Grid-cell u-size6of12 longitude">
                <label>Longitudine</label>
                <input class="ezgml_new_longitude box form-control"
                       type="text"
                       name="{$attribute_base}_data_gmaplocation_longitude_{$attribute.id}"
                       value="{$longitude|wash()}"/>
                <input class="ezgml_hidden_longitude"
                       type="hidden"
                       name="ezgml_hidden_longitude"
                       value="{$longitude|wash()}"
                       disabled="disabled"/>
            </div>
        </div>
    </div>

{ezcss_require(array(
    'leaflet/leaflet.0.7.2.css',
    'leaflet/geocoder/Control.Geocoder.css',
    'leaflet/Control.Loading.css'
))}
{ezscript_require(array(
    'leaflet/leaflet.0.7.2.js',
    'ezjsc::jquery',
    'leaflet/Control.Loading.js',
    'leaflet/Leaflet.MakiMarkers.js',
    'leaflet/geocoder/Control.Geocoder.js',
    'leaflet/geocoder/osmaplocation.js'
))}

</fieldset>
