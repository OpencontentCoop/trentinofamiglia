{def $videos = array()}
{if $post.videos}
    {foreach $post.videos.content.relation_list as $relation_item}
        {set $videos = $videos|append(fetch('content','node',hash('node_id',$relation_item.node_id)))}
    {/foreach}
{/if}
{if count($videos)|gt(0)}
    <div class="Grid Grid-cell u-sizeFull  u-margin-bottom-m  u-margin-top-m">
        <h4 class="u-text-h4">Video</h4>
    </div>
    {def $modulo=3 $col-width=4}
        {foreach $videos as $item}
            <div class="Grid Grid-cell u-size{$col-width}of12 u-margin-bottom-s">
                <div class="Grid Grid-cell u-size1of2">
                    <p>
                        <i class="fa fa-file-video-o fa-2x" aria-hidden="true"></i>
                        <br />
                        <small>{$item.name|wash()}</small>
                        {*<small>{attribute_view_gui attribute=$item.data_map.file}</small>*}
                    </p>
                </div>
                <div class="Grid Grid-cell u-size1of2">
                    <a class="btn btn-success"
                       href="{concat('editorialstuff/media/', $factory_identifier, '/edit/', $post.object.id, '/video/', $item.contentobject_id )|ezurl(no)}"><i
                                class="fa fa-pencil"></i></a>
                    <a class="btn btn-danger"
                       href="{concat('editorialstuff/media/', $factory_identifier, '/remove/', $post.object.id, '/video/', $item.contentobject_id )|ezurl(no)}"><i
                                class="fa fa-trash-o"></i></a>
                </div>
            </div>
        {delimiter modulo=$modulo}</div>
        {/foreach}
    {undef $modulo $col-width}
{/if}