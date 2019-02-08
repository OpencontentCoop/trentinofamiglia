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

  var mainQuery = 'classes [infrastruttura_family]';
  if (tools.settings('subTree').length > 0) {
    mainQuery += ' subtree ' + tools.settings('subTree');
  }

  $('#infrastrutture').find('.content-data').each(function (i, el) {

    $(el).opendataDataTable({
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
          {"data": "metadata.id", "name": 'id', "title": '', "sortable": false}
        ],
        "columnDefs": [
          {
            "render": function (data, type, row) {
              return '<a class="btn-sm btn-info" href="#">' + Translations['Dettaglio'] + '</a>';
            },
            "targets": [0]
          },
          {
            "render": function (data, type, row) {
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
              return ' <form method="post" action="' + tools.settings('accessPath') + '/content/action" style="display: inline;"><button class="btn-sm btn-danger" type="submit" name="ActionRemove"><i class="fa fa-trash""></i></button><input name="ContentObjectID" value="' + row.metadata.id + '" type="hidden"><input name="NodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="ContentNodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="RedirectIfCancel" value="editorialstuff/dashboard/comunicato" type="hidden"><input name="RedirectURIAfterRemove" value="editorialstuff/edit/piano_comunale" type="hidden"></form> ';
            },
            "targets": [4]
          }
        ]
      },
    }).data('opendataDataTable')
    .loadDataTable();

    $(document).on('click', '[data-load-remote]', function (e) {
      e.preventDefault();
      var $this = $(this);
      $($this.data('remote-target')).html('<em>Loading...</em>');
      var remote = $this.data('load-remote');
      if (remote) {
        $($this.data('remote-target')).load(remote);
      }
    });
  });

  $('.CreateInfrastruttureButton').on('click', function (e) {

    var table = $('#ambito_' + $(this).data('ambito')).data('opendataDataTable'),
        form  = $(this).parents('.azioni-container').find('.form-azioni');

    form.opendataFormCreate({
      class: $(this).data('class'),
      parent: $(this).data('parent'),
      piano: $(this).data('piano'),
      ambito: $(this).data('ambito'),
    }, {
      connector: 'create-azione-piano-comunale',
      onSuccess: function (data) {
        // gestire eventuali errori
        console.log(data);
        if (data > 0) {
          form.html('<div class="Alert Alert--success u-text-h6">Azione salvata con successo</div>').delay(5000).queue(function() {
            $(this).remove();
          });
          table.loadDataTable();
          $('html, body').animate({
            scrollTop: form.offset().top
          }, 1000);
        }
      }
    });
    e.preventDefault();
  });

});
