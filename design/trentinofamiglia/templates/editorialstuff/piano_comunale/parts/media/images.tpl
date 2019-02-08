{def $images = array()
$main_image = false()
$priorities = array()
$firstPageIndex = 1}

{if $post.object.data_map.pagina_apertura.has_content}
  {set $firstPageIndex = $post.object.data_map.pagina_apertura.content}
{/if}

{if $post.images}
  {foreach $post.images.content.relation_list as $relation_item}
    {if $relation_item.priority|eq($firstPageIndex)}
      {set $main_image = fetch('content','node',hash('node_id',$relation_item.node_id))}
    {/if}
    {set $images = $images|append(fetch('content','node',hash('node_id',$relation_item.node_id)))}
  {/foreach}
{/if}

{if $post.images}
  {*<div class="Grid-cell u-sizeFull">
    <h4 class="u-text-h4">{'Immagini'|i18n('agenda/dashboard')}</h4>
  </div>*}
  {ezscript_require( array( "ezjsc::jquery", "plugins/blueimp/jquery.blueimp-gallery.min.js" ) )}
  {ezcss_require( array( "plugins/blueimp/blueimp-gallery.css" ) )}
  <div class="Grid-cell u-margin-top-m u-margin-bottom-m">
    <h6 class="u-text-h6">Immagine principale (immagine di apertura dello sfogliatore)</h6>
    <div class="Grid-cell u-sizeFull u-sm-size1of2 u-md-size1of2 u-lg-size1of2">
      <a class="gallery-strip-thumbnail" href={$main_image|attribute('image').content['imagefullwide'].url|ezroot} title="{$main_image.name|wash()}" data-gallery>
        {attribute_view_gui attribute=$main_image|attribute('image') image_class=medium fluid=false()}
        <br/>
        {$main_image.name|wash()}
      </a>
    </div>
    {*<div class="Grid-cell u-sizeFull u-sm-size1of2 u-md-size1of2 u-lg-size1of2">
      <p class="u-margin-top-xs">
        <a class="btn btn-success" title="Modifica"
           href="{concat('editorialstuff/media/', $factory_identifier, '/edit/', $post.object.id, '/image/', $main_image.contentobject_id )|ezurl(no)}"><i
            class="fa fa-pencil"></i></a>
        <a class="btn btn-danger" title="Elimina"
           href="{concat('editorialstuff/media/', $factory_identifier, '/remove/', $post.object.id, '/image/', $main_image.contentobject_id )|ezurl(no)}"><i
            class="fa fa-trash-o"></i></a>
      </p>
    </div>*}
  </div>
  {def $modulo=4 $col-width=3
       $index = 1}
  {if $images|count()|gt(0)}
    <div class="Grid-cell">
      <h6 class="u-text-h6 ">Tutte le immagini</h6>
    </div>
    {foreach $images as $item}
      <div class="Grid-cell Grid--withGutter u-size{$col-width}of12 u-size-sm{$col-width}of12 u-size-md{$col-width}of12 u-size-lg{$col-width}of12 u-margin-bottom-xl">
        <div class="Grid-cell u-sizeFull">
          <a class="gallery-strip-thumbnail"
             href={$item|attribute('image').content['imagefullwide'].url|ezroot} title="{$item.name|wash()}"
             data-gallery>
            {attribute_view_gui attribute=$item|attribute('image') image_class=medium fluid=false()}
            <br/>
            {$item.name|wash()}
          </a>
        </div>
        <div class="Grid-cell u-sizeFull">
          <p class="u-margin-top-xs">
            {if $index|ne($firstPageIndex)}
            <a class="btn btn-info" title="Usa come principale"
               href="{concat('editorialstuff/media/', $factory_identifier, '/updatepriority/', $post.object.id, '/image/', $index )|ezurl(no)}"><i
                class="fa fa-star" aria-hidden="true"></i></a>
            {/if}
            <a class="btn btn-success" title="Modifica"
               href="{concat('editorialstuff/media/', $factory_identifier, '/edit/', $post.object.id, '/image/', $item.contentobject_id )|ezurl(no)}"><i
                class="fa fa-pencil"></i></a>
            <a class="btn btn-danger" title="Elimina"
               href="{concat('editorialstuff/media/', $factory_identifier, '/remove/', $post.object.id, '/image/', $item.contentobject_id )|ezurl(no)}"><i
                class="fa fa-trash-o"></i></a>
          </p>
        </div>
      </div>
      {set $index = $index|sum(1)}
    {/foreach}
  {/if}
  {undef $modulo}
{/if}
