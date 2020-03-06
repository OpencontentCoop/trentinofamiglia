<div class="Grid Grid--withGutter u-margin-bottom-m">
  <div class="Grid-cell u-size4of6">
    <h1 class="u-text-h2">{$post.object.name|wash()}</h1>
  </div>

  <div class="Grid-cell u-size2of6">
      <p class="u-textCenter u-text-md-right u-text-lg-right u-margin-top-m">
          <a class="u-color-50 u-textClean u-text-h5" href="{concat('editorialstuff/dashboard/', $factory_identifier)|ezurl(no)}"><i class="fa fa-angle-left" aria-hidden="true"></i> Torna alla Dashboard</a>
      </p>
  </div>

  {include uri=concat('design:', $template_directory, '/parts/workflow.tpl') post=$post}
</div>
<div class="Grid Grid--withGutter u-margin-bottom-m" id="dashboard-tabs">
  <ul class="Linklist Linklist--padded Grid-cell u-size3of12">
    {foreach $post.tabs as $index=> $tab}
      <li role="presentation" class="{if $index|eq(0)} active{/if}">
        <a href="#{$tab.identifier}" class="Linklist-link" aria-controls="{$tab.identifier}"
           data-toggle="tab">{$tab.name}</a>
      </li>
    {/foreach}
  </ul>
  <div class="Grid-cell u-size9of12 u-padding-left-xl tab-content">
    {foreach $post.tabs as $index=> $tab}
      <div class="tab-pane{if $index|eq(0)} active{/if}" id="{$tab.identifier}">
        {include uri=$tab.template_uri post=$post}
      </div>
    {/foreach}
  </div>

</div>
</div>

<div class="Dialog js-fr-dialogmodal" id="preview">
  <div class="
      Dialog-content
      Dialog-content--centered
      u-background-white
      u-layout-medium
      u-margin-all-xl
      u-padding-all-xl
      js-fr-dialogmodal-modal" aria-labelledby="modal-title">
    <div class="modal-content" role="document"></div>
  </div>

  {ezscript_require( array( 'modernizr.min.js', 'ezjsc::jquery') )}
  {literal}
    <script type="text/javascript">
      $(document).ready(function () {
        var hash = document.location.hash;
        var prefix = "tab_";
        if (hash) {
          var index = $('.Linklist a[href=' + hash.replace(prefix, "") + ']').parent().index();
          $("#dashboard-tabs").tabs({
            active: index,
            activate: function (event, ui) {
              event.preventDefault();
              window.location.hash = event.currentTarget.hash.replace("#", "#" + prefix);
            }
          });
        } else {
          $("#dashboard-tabs").tabs({
            activate: function (event, ui) {
              event.preventDefault();
              window.location.hash = event.currentTarget.hash.replace("#", "#" + prefix);
            }
          });
        }
      });
    </script>
    <style>

      .radio.alpaca-control {
        padding-left: 20px;
      }

      li.ui-state-active a {
        background-color: rgb(59, 59, 59) !important;
        color: #fff !important;
      }

      .ui-widget-content {
        border: none;
        background: #fff !important
      }

      .glyphicon-star::before {
        content: "\002a";
      }
      table {
        width: 100% !important;
      }
      .note-editing-area,
      .note-editable {
        min-height: 200px !important;
      }

      .note-editable {
        margin-top: 40px;
      }
      .progress-bar {
        color: #000;
        font-weight: 800;
      }
      .btn-info {
        color: #fff;
      }

      .form-azioni form,
      .form-valutazioni form {
        background-color: #efefef;
      }

      li.ui-state-active a {
        background-color: #efefef !important;
        color: #003e54 !important;
        font-weight: bold;
      }

      li.ui-state-active a:before {
        font-family: FontAwesome;
        content: "\f0da";
        padding-right: 3px;
      }

      ul.two-columns {
        /*columns: 2;
        -webkit-columns: 2;
        -moz-columns: 2;*/
        list-style-type: disc;
        padding-left: 20px;
      }

      #azioni-tabs ul.nav li a {
        min-height: 65px;
      }

      #overlay.fullscreen {
        z-index: 9999;
        height: 100%;
        width: 100%;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0,0,0,0.8); /* Black background with opacity */
        position: fixed;
        visibility: visible;
      }

      h5.Accordion-header span.Accordion-link {
        font-size: 1.7rem !important;
      }

    </style>
  {/literal}

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
  'openpa_pianocomunale_infrastrutture.js',
  'openpa_pianocomunale_azioni.js',
  'openpa_pianocomunale_valutazioni.js'
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


    {literal}$('.state_assign').on('click', function (e) {
      if (confirm("Attenzione, l'azione non può essere annullata. Vuoi procedere?")) {
        $.ajax({
          url: $(this).data('url'),
          data: {
            'Ajax': true
          }
        }).done(function(data) {
          console.log(data);
          if (data.result === 'success') {
            window.location.reload();
          } else {
            $('.workflow-feedback')
            .prepend('<div class="Alert Alert--error u-text-h4">' + data.error_message + '</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);
          }
        });
      }
      e.preventDefault();
    });
    {/literal}

  </script>
