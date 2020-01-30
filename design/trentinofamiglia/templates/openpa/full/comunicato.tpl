{if $openpa.control_cache.no_cache}
  {set-block scope=root variable=cache_ttl}0{/set-block}
{/if}

{if $openpa.content_tools.editor_tools}
  {include uri=$openpa.content_tools.template}
{/if}

{def $images = array()}
{def $video = array()}
{def $argomenti = array()}


{if $node|has_attribute( 'immagini' )}
  {foreach $node.data_map.immagini.content.relation_list as $relation_item}
    {set $images = $images|append(fetch('content','node',hash('node_id',$relation_item.node_id)))}
  {/foreach}
{/if}

{if $node|has_attribute( 'video' )}
  {foreach $node.data_map.video.content.relation_list as $relation_item}
    {set $video = $video|append(fetch('content','node',hash('node_id',$relation_item.node_id)))}
  {/foreach}
{/if}

{def $matrix_link_has_content = false()}
{if $node|has_attribute( 'link' )}
  {foreach $node|attribute( 'link' ).content.rows.sequential as $row}
    {foreach $row.columns as $index => $column}
      {if $column|ne('')}
        {set $matrix_link_has_content = true()}
      {/if}
    {/foreach}
  {/foreach}
{/if}

{def $has_sidebar = false()
$has_social  = true()}
{if or(
  $node|has_attribute( 'allegati' ),
  $node|has_attribute( 'audio' ),
  $node|has_attribute( 'fonte' ),
  gt($video|count,1),
  $node|has_attribute( 'geo' ),
  $matrix_link_has_content,
  $has_social
)}
  {set $has_sidebar = true()}
{/if}

<div class="openpa-full class-{$node.class_identifier}">
  <div class="title u-margin-bottom-s">
    {include uri='design:openpa/full/parts/node_languages.tpl'}
    <h1>
      {if $node|has_attribute( 'occhiello' )}
        <small style="font-weight: normal;color: #000">
          {attribute_view_gui attribute=$node|attribute( 'occhiello' )}
        </small>
        <br/>
      {/if}
      <span class="u-text-h1">{$node.name|wash()}</span>
    </h1>

    {if $node|has_attribute( 'sottotitolo' )}
      <h3 class="u-text-h3">
        {attribute_view_gui attribute=$node|attribute( 'sottotitolo' )}
      </h3>
    {/if}
  </div>
  <div class="content-container">
    <div class="content{if $has_sidebar} withExtra{/if}">

      <article class="content-main-abstract">
        <p class="u-layout-prose u-color-grey-90 u-text-p">
          {if $node|has_attribute( 'published' )}
            {attribute_view_gui attribute=$node|attribute( 'published' )} -
          {/if}
          {attribute_view_gui attribute=$node|attribute( 'abstract' )}
        </p>
      </article>

      {if gt($images|count,0)}
        {include uri='design:atoms/image.tpl' item=$images[0] image_class=imagefull css_classes="main_image"}
      {/if}

      <article class="content-main-body">
        {attribute_view_gui attribute=$node|attribute( 'testo_completo' )}
      </article>

      {attribute_view_gui attribute=$node|attribute( 'tematica' )}

      {if count($images)|gt(1)}
        <h2 class="u-margin-top-s"><i class="fa fa-camera"></i> Immagini</h2>
        {include uri='design:atoms/gallery.tpl' items=$images title=false()}
      {/if}



      {include uri=$openpa.content_contacts.template}

      {include uri=$openpa.content_infocollection.template}

      {node_view_gui content_node=$node view=children view_parameters=$view_parameters}

    </div>

    {if $has_sidebar}
      <div class="extra">

        {if $node|has_attribute( 'fonte' )}
          <h2 class="openpa-widget-title"><i class="fa fa-code-fork"></i> Fonte</h2>
          <div class="openpa-widget nav-section">
            <ul class="Linklist Linklist--padded">
              <li>{attribute_view_gui attribute=$node|attribute( 'fonte' )}</li>
            </ul>
          </div>
        {/if}

        {if $matrix_link_has_content}
          <h2 class="openpa-widget-title"><i class="fa fa-link"></i> {$node|attribute( 'link' ).contentclass_attribute_name}</h2>
          <div class="openpa-widget nav-section">
            {attribute_view_gui attribute=$node|attribute( 'link' )}
          </div>
        {/if}

        {if $node|has_attribute( 'geo' )}
          <h2 class="openpa-widget-title"><i class="fa fa-map-marker"></i> Luogo</h2>
          <div class="openpa-widget nav-section">
            {attribute_view_gui attribute=$node.data_map.geo zoom=3}
          </div>
        {/if}
      </div>
    {/if}

  </div>
</div>
