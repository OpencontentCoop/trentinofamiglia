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
'jquery.price_format.min.js',
'jquery.opendatabrowse.js',
'fields/OpenStreetMap.js',
'fields/RelationBrowse.js',
'fields/LocationBrowse.js',
'fields/Tags.js',
'jquery.opendataform.js'

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
'jquery.tag-editor.css'
))}
{literal}
  <style>
    .actions {
      white-space: nowrap;
    }
  </style>
{/literal}
<div class="openpa-full">
  <div class="title">
    <h2>
      {$node.name}
    </h2>

    <div class="content-container">
      <div class="content">

      </div>
    </div>
  </div>
</div>

<script type="text/javascript" language="javascript" class="init">
  $.opendataTools.settings('accessPath', "{'/'|ezurl(no,full)}");
  $.opendataTools.settings('subTree', "[{$node.node_id}]");
  $.opendataTools.settings('language', "{ezini('RegionalSettings','Locale')}");
  $.opendataTools.settings('dasboardClassIdentifier', "piano_comunale");
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

<script type="text/javascript" language="javascript" class="init">
  {literal}
  $(document).ready(function () {
    var tools = $.opendataTools;

    var datatableLanguage = "//cdn.datatables.net/plug-ins/1.10.12/i18n/Italian.json";
    var calendarLocale = 'it';
    if (tools.settings('language') == 'ger-DE') {
      datatableLanguage = "//cdn.datatables.net/plug-ins/1.10.12/i18n/German.json";
      calendarLocale = 'de';
    } else if (tools.settings('language') == 'eng-GB') {
      datatableLanguage = "//cdn.datatables.net/plug-ins/1.10.12/i18n/English.json";
      calendarLocale = 'en';
    }

    var mainQuery = 'classes ['+tools.settings('dasboardClassIdentifier')+']';
    if (tools.settings('subTree').length > 0){
      mainQuery += ' subtree ' + tools.settings('subTree');
    }
    var stateSelect = $('select#state');
    var datatable = $('.content-data').opendataDataTable({
      "builder": {
        "query": mainQuery
      },
      "datatable": {
        "language": {"url": datatableLanguage},
        "ajax": {url: tools.settings('accessPath') + "/opendata/api/datatable/search/"},
        "order": [[3, "desc"]],
        "columns": [
          {"data": "metadata.remoteId", "name": 'remote_id', "title": '', "sortable": false},
          {"data": "metadata.name." + tools.settings('language'), "name": 'name', "title": "Titolo"},
          {
            "data": "metadata",
            "name": 'raw[meta_owner_name_t]',
            "title": Translations['Autore']
          },
          {"data": "metadata.published", "name": 'published', "title": Translations['Pubblicato']},
          {"data": "metadata.stateIdentifiers", "name": 'state', "title": Translations['Stato'], "sortable": false},
          {"data": "metadata.id", "name": 'id', "title": '', "sortable": false}
        ],
        "columnDefs": [
          {
            "render": function (data, type, row) {
              return '<a class="btn btn-info" href="' + tools.settings('accessPath') + '/editorialstuff/edit/' + row.metadata.classIdentifier + '/' + row.metadata.id + '">'+Translations['Dettaglio']+'</a>';
            },
            "targets": [0]
          },
          {
            "render": function (data, type, row) {
              //var contentData = row.data;
              //var titolo = typeof contentData[tools.settings('language')] != 'undefined' ? contentData[tools.settings('language')].titolo : contentData[Object.keys(contentData)[0]].titolo;
              //return '<a href="#" data-toggle="modal" data-remote-target="#preview .modal-content" data-target="#preview" data-load-remote="' + tools.settings('accessPath') + '/layout/set/modal/content/view/full/' + row.metadata.mainNodeId + '">'+titolo+'</a>';
              return data;
            },
            "targets": [1]
          },
          {
            "render": function (data, type, row) {
              var contentData = row.metadata.ownerName;
              return typeof contentData[tools.settings('language')] != 'undefined' ? contentData[tools.settings('language')] : contentData[Object.keys(contentData)[0]];
            },
            "targets": [2]
          },
          {
            "render": function (data, type, row) {
              return moment(new Date(data)).format('DD/MM/YYYY');
            },
            "targets": [3]
          },
          {
            "render": function (data, type, row) {
              return $.map(data, function (value, key) {
                var parts = value.split('.');
                if (parts[0] == 'comunicati_stampa') {
                  return $.map(stateSelect.find('option'), function (option) {
                    var $option = $(option);
                    if ($option.data('state_identifier') == parts[1]) {
                      return '<span class="label label-info label-'+$option.data('state_identifier')+'">'+$option.text()+'</span>';
                    }
                  });
                }
              });
            },
            "targets": [4]
          },
          {
            "render": function (data, type, row) {
              return ' <form method="post" action="' + tools.settings('accessPath') + '/content/action" style="display: inline;"><button class="btn-sm btn-danger" type="submit" name="ActionRemove"><i class="fa fa-trash" style="font-size: 12px;"></i></button><input name="ContentObjectID" value="' + row.metadata.id + '" type="hidden"><input name="NodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="ContentNodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="RedirectIfCancel" value="editorialstuff/dashboard/piano_comunale" type="hidden"><input name="RedirectURIAfterRemove" value="editorialstuff/dashboard/piano_comunale" type="hidden"></form> ';
            },
            "targets": [5]
          }
        ]
      },
    }).data('opendataDataTable')
    //.attachFilterInput(stateSelect)
    .loadDataTable();

    $(document).on('click','[data-load-remote]',function(e) {
      e.preventDefault();
      var $this = $(this);
      $($this.data('remote-target')).html('<em>Loading...</em>');
      var remote = $this.data('load-remote');
      if(remote) {
        $($this.data('remote-target')).load(remote);
      }
    });

    $.opendataFormSetup({
      onBeforeCreate: function(){
        $('#modal').modal('show');
      },
      onSuccess: function(data){
        $('#modal').modal('hide');
      }
    });
  });

  {/literal}
</script>


