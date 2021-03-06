<div class="Grid Grid--withGutter u-margin-bottom-m">
  <div class="Grid-cell u-sizeFull">
    <h1 class="u-text-h2">Dashboard Piani Comunali</h1>
  </div>
{ezscript_require(array(
    'ezjsc::jquery',
    'ezjsc::jqueryUI',
    'bootstrap.min.js',
    'bootstrap/tooltip.js',
    'bootstrap/popover.js',
    'bootstrap/modal.js',
    'plugins/chosen.jquery.js',
    'moment.min.js',
    'jquery.dataTables.js',
    'dataTables.bootstrap.js',
    'jquery.opendataDataTable.js',
    'jquery.opendataTools.js',
    'summernote/summernote-bs4.js',
    'handlebars.min.js',
    'moment-with-locales.min.js',
    'bootstrap-datetimepicker.min.js',
    'jquery.fileupload.js',
    'jquery.fileupload-process.js',
    'jquery.fileupload-ui.js',
    'jquery.tag-editor.js',
    'popper.min.js',
    'alpaca.js',
    'leaflet/leaflet.0.7.2.js',
    'leaflet/Control.Geocoder.js',
    'leaflet/Control.Loading.js',
    'leaflet/Leaflet.MakiMarkers.js',
    'leaflet/leaflet.activearea.js',
    'leaflet/leaflet.markercluster.js',
    'jquery.price_format.min.js',
    'jquery.opendatabrowse.js',
    'fields/OpenStreetMap.js',
    'fields/RelationBrowse.js',
    'fields/LocationBrowse.js',
    'fields/Tags.js',
    'jquery.opendataform.js',
    'openpa_pianocomunale_dashboard.js'
))}
{ezcss_require(array(
    'ocbootstrap.css',
    'alpaca.min.css',
    'leaflet/leaflet.0.7.2.css',
    'leaflet/Control.Loading.css',
    'leaflet/MarkerCluster.css',
    'leaflet/MarkerCluster.Default.css',
    'bootstrap-datetimepicker.min.css',
    'jquery.fileupload.css',
    'summernote/summernote-bs4.css',
    'jquery.tag-editor.css',
    'alpaca-custom.css'
))}

  <script type="text/javascript" language="javascript" class="init">
    $.opendataTools.settings('accessPath', "{'/'|ezurl(no,full)}");
    $.opendataTools.settings('subTree', "[{implode($factory_configuration.RepositoryNodes)}]");
    $.opendataTools.settings('language', "{ezini('RegionalSettings','Locale')}");
    $.opendataTools.settings('dasboardClassIdentifier', "{$factory_configuration.ClassIdentifier}");
    $.opendataTools.settings('languages', ['{ezini('RegionalSettings','SiteLanguageList')|implode("','")}']); //@todo
    $.opendataTools.settings('endpoint', {ldelim}
      'geo': '{'/opendata/api/geo/search/'|ezurl(no,full)}',
      'search': '{'/opendata/api/content/search/'|ezurl(no,full)}',
      'class': '{'/opendata/api/classes/'|ezurl(no,full)}',
      'fullcalendar': '{'/opendata/api/fullcalendar/search/'|ezurl(no,full)}',
      {rdelim});

    var Translations = {ldelim}
      'Titolo': '{'Titolo'|i18n('agenda/dashboard')}',
      'Pubblicato': '{'Pubblicato'|i18n('agenda/dashboard')}',
      'Autore': '{'Autore'|i18n('agenda/dashboard')}',
      'Inizio': '{'Inizio'|i18n('agenda/dashboard')}',
      'Fine': '{'Fine'|i18n('agenda/dashboard')}',
      'Stato': '{'Stato'|i18n('agenda/dashboard')}',
      'Traduzioni': '{'Traduzioni'|i18n('agenda/dashboard')}',
      'Dettaglio': '{'Dettaglio'|i18n('agenda/dashboard')}',
      'Loading...': '{'Loading...'|i18n('agenda/dashboard')}'
      {rdelim};

  </script>
  {literal}
    <style>
      .chosen-search input, .chosen-container-multi input {
        height: auto !important
      }

      .label-skipped {
        background-color: #999;
      }

      .label-waiting {
        background-color: #f0ad4e;
      }

      .label-accepted {
        background-color: #5cb85c;
      }

      .label-refused {
        background-color: #d9534f;
      }
    </style>
  {/literal}

  <div class="Grid-cell u-size2of3 u-margin-top-m">
    {if $factory_configuration.CreationRepositoryNode}
      <a href="#{*concat('editorialstuff/add/',$factory_identifier)|ezurl(no)*}"
         id="CreatePianoButton"
         data-class="{$factory_configuration.ClassIdentifier}"
         data-parent="{$factory_configuration.CreationRepositoryNode}"
         class="Button Button--default u-text-r-xs"><i class="fa fa-plus" aria-hidden="true"></i>  {$factory_configuration.CreationButtonText|wash()}</a>
    {/if}
  </div>

  {if $states|count()|gt(0)}
    <div class="Grid-cell u-size1of3 u-margin-top-m" id="dashboard-filters-container">
      <form class="form-inline">
        <div class="form-group" style="margin-bottom: 10px;width: 100%;">
          <label for="state">{'Filtra per stato'|i18n('agenda/dashboard')}</label>
          <select id="state" data-field="state" data-placeholder="{'Seleziona'|i18n('agenda/dashboard')}"
                  name="state">
            <option value=""></option>
            {foreach $states as $state}
              <option value="{$state.id|wash()}" data-state_identifier="{$state.identifier|wash()}"
                      class="label-{$state.identifier|wash()}">{$state.current_translation.name|wash()}</option>
            {/foreach}
          </select>
        </div>
      </form>
    </div>
  {/if}

  <hr/>

  <div class="Grid-cell u-sizeFull editorialstuff">
    <div class="content-data"></div>
  </div>

  <div id="modal" class="modal fade">
      <div class="modal-dialog modal-lg">
          <div class="modal-content">
              <div class="modal-body">
                  <div class="clearfix">
                      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  </div>
                  <div id="form" class="clearfix"></div>
              </div>
          </div>
      </div>
  </div>

</div>
