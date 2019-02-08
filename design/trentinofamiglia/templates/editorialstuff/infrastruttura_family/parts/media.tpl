<div class="panel-body">
    {if and( $post.object.can_edit, $post.is_editable) }
        <div class="Grid Grid--withGutter u-padding-all-s u-padding-top-s">
            <div class="Grid-cell u-size1of2 u-sm-size3of12 u-md-size2of12">
                <form action="" enctype="multipart/form-data" method="post" id="upload-form">
                  <span class="btn btn-info btn-lg fileinput-button">
                    <span>{'Nuovo'|i18n('agenda/dashboard')}</span>
                    <input id="upload-media" type="file" name="MediaFile[]"
                           data-url="{concat('editorialstuff/media/', $factory_identifier, '/upload/', $post.object.id )|ezurl(no)}">
                  </span>
                </form>
                <div id="upload-loading" class="text-center" style="display: none">
                    <i class="fa fa-cog fa-spin fa-3x fa-fw"></i>
                </div>
            </div>
            <div class="Grid-cell u-size1of2 u-sm-size3of12 u-md-size2of12">
                <a class="btn btn-info btn-lg"
                   href="{concat('editorialstuff/media/', $factory_identifier, '/browse/', $post.object.id )|ezurl(no)}">
                    {'Libreria'|i18n('agenda/dashboard')}
                </a>
            </div>
        </div>
    {/if}

    <div class="Grid Grid--withGutter u-padding-all-s u-padding-top-s" id="data">
        {include uri=concat('design:', $template_directory, '/parts/media/data.tpl') post=$post}
    </div>

</div>

{ezscript_require( array( 'ezjsc::jquery', 'ezjsc::jqueryio', 'ezjsc::jqueryUI', 'plugins/jquery.fileupload/jquery.fileupload.js' ) )}
{ezcss_require( 'plugins/jquery.fileupload/jquery.fileupload.css' )}
{literal}
    <script>
        $(function () {
            $('#upload-media').fileupload({
                dataType: 'json',
                submit: function (e, data) {
                    $('#upload-form').hide();
                    $('#upload-loading').show();
                },
                done: function (e, data) {
                    if (data.result.errors.length > 0) {
                        var errorContainer = $('<div class="alert alert-danger"></div>');
                        $.each(data.result.errors, function (index, error) {
                            $('<p>' + error.description + '</p>').appendTo(errorContainer)
                        });
                        errorContainer.prependTo($('#data'));
                    } else if (typeof data.result.content != 'undefined') {
                        $('#data').html(data.result.content);
                    }
                    $('#upload-form').show();
                    $('#upload-loading').hide();
                }
            });
        });
    </script>
{/literal}
