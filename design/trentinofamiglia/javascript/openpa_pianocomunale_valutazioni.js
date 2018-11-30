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

  var mainQuery = 'classes [valutazione_attivita]';

  $('#valutazione').find('.content-data').each(function (i, el) {

    var query = mainQuery;
    query += ' subtree [' + $(el).data('parent') + ']';
    query += " and raw[submeta_azione___id____si] = " + $(el).data('azione');

    console.log(query);

    $(el).opendataDataTable({
      "builder": {
        "query": query
      },
      "datatable": {
        "language": {"url": datatableLanguage},
        "ajax": {url: tools.settings('accessPath') + "/opendata/api/datatable/search/"},
        "order": [[0, "asc"]],
        "columns": [
          {"data": "metadata.id", "name": 'remote_id', "title": '', "width": "15%"},
          {"data": "metadata.name." + tools.settings('language'), "name": 'name', "title": "Titolo", "width": "40%"},
          {"data": "data." + tools.settings('language') + ".data", "name": 'published', "title": 'Data', "sortable": false, "width": "15%"},
          {"data": "data." + tools.settings('language') + ".completamento", "name": 'id', "title": 'Completamento (in %)', "sortable": false, "width": "30%"},
          {"data": "metadata.id", "name": 'id', "title": '', "sortable": false}
        ],
        "columnDefs": [
          {
            "render": function (data, type, row) {
              return '<a class="btn-sm btn-info editValutazione" href="#" data-object="'+row.metadata.id+'" data-azione="'+ $(el).data('azione') +'">Modifica</a>';
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
              return moment(new Date(data)).format('DD/MM/YYYY');
            },
            "targets": [2]
          },
          {
            "render": function (data, type, row) {
              var percent = data[0];
              /*if ( !Number.isInteger(percent) ) {
                percent = '0';
              }*/
              return '<div class="progress">' +
                     '<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="'+percent+'" aria-valuemin="0" aria-valuemax="100" style="width: '+percent+'%;">'+percent+'%</div>' +
                     '</div>';
            },
            "targets": [3]
          },
          {
            "render": function (data, type, row) {
              return ' <form method="post" action="' + tools.settings('accessPath') + '/content/action" style="display: inline;"><button class="btn-sm btn-danger" type="submit" name="ActionRemove"><i class="fa fa-trash""></i></button><input name="ContentObjectID" value="' + row.metadata.id + '" type="hidden"><input name="NodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="ContentNodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="RedirectIfCancel" value="editorialstuff/edit/piano_comunale/' + $(el).data('azione') + '#tab_valutazione" type="hidden"><input name="RedirectURIAfterRemove" value="editorialstuff/edit/piano_comunale/' + $(el).data('azione') + '#tab_valutazione" type="hidden"></form> ';
            },
            "targets": [4]
          }
        ],
        "drawCallback": function( settings ) {

          $(this).find('.editValutazione').on('click', function (e) {

            var table = $('#azione_' + $(this).data('azione')).data('opendataDataTable'),
                form  = $(this).parents('.azioni-container').find('.form-valutazioni');

            console.log(form);
            form.opendataFormEdit({
              object: $(this).data('object')
            }, {
              connector: 'edit-valutazione-piano-comunale',
              onSuccess: function (data) {
                // gestire eventuali errori
                if (data) {
                  form.html('')
                  .prepend('<div class="Alert Alert--success u-text-h6">Valutazione salvata con successo</div>')
                  .children(':first')
                  .delay(5000)
                  .fadeOut(200);


                  table.loadDataTable();
                  $('html, body').animate({
                    scrollTop: form.offset().top
                  }, 1000);
                }
              }
            });
            e.preventDefault();
          });
        }
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

  $('.CreateValutazioneButton').on('click', function (e) {

    var table = $('#azione_' + $(this).data('azione')).data('opendataDataTable'),
      form  = $(this).parents('.azioni-container').find('.form-valutazioni');

    form.opendataFormCreate({
      class: $(this).data('class'),
      piano: $(this).data('piano'),
      azione: $(this).data('azione'),
    }, {
      connector: 'create-valutazione-piano-comunale',
      onSuccess: function (data) {
        // gestire eventuali errori
        console.log(data);
        if (data > 0) {
          form.html('')
          .prepend('<div class="Alert Alert--success u-text-h6">Valutazione creata con successo</div>')
          .children(':first')
          .delay(5000)
          .fadeOut(200);
          table.loadDataTable();
          $('html, body').animate({
            scrollTop: form.offset().top
          }, 1000);
        }
      },
      alpaca: {
        postRender: function (control) {
          form.find('.reset-button').on('click', function (e) {
            e.preventDefault();
            form.html('');
          });
        }
      }
    });
    e.preventDefault();
  });

});
