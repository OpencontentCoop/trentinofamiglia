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
                {"data": "metadata.id", "name": 'id', "title": '', "sortable": false}
            ],
            "columnDefs": [
                {
                    "render": function (data, type, row) {
                        return '<a class="Button Button--info" href="' + tools.settings('accessPath') + '/editorialstuff/edit/' + row.metadata.classIdentifier + '/' + row.metadata.id + '">'+Translations['Dettaglio']+'</a>';
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
                        return ' <form method="post" action="' + tools.settings('accessPath') + '/content/action" style="display: inline;"><button class="btn-sm btn-danger" type="submit" name="ActionRemove"><i class="fa fa-trash" style="font-size: 12px;"></i></button><input name="ContentObjectID" value="' + row.metadata.id + '" type="hidden"><input name="NodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="ContentNodeID" value="' + row.metadata.mainNodeId + '" type="hidden"><input name="RedirectIfCancel" value="editorialstuff/dashboard/piano_comunale" type="hidden"><input name="RedirectURIAfterRemove" value="editorialstuff/dashboard/piano_comunale" type="hidden"></form> ';
                    },
                    "targets": [4]
                }
            ]
        },
    }).data('opendataDataTable')
        .attachFilterInput(stateSelect)
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

});
