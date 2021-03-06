{def $openpa = object_handler($node)}

{if $openpa.content_tools.editor_tools}
  {include uri=$openpa.content_tools.template}
{/if}

{def $tree_menu = tree_menu( hash( 'root_node_id', $openpa.control_menu.side_menu.root_node.node_id, 'user_hash', $openpa.control_menu.side_menu.user_hash, 'scope', 'side_menu' ))
$show_left = and( $openpa.control_menu.show_side_menu, count( $tree_menu.children )|gt(0) )}


<div class="openpa-full class-{$node.class_identifier}">
  <div class="title">
    {include uri='design:openpa/full/parts/node_languages.tpl'}
    <h2>{$node.name|wash()}</h2>
  </div>
  <div class="content-container">

    <div class="content{if or( $show_left, $openpa.control_menu.show_extra_menu )} withExtra{/if}">

      {if $node.data_map.page.has_content}
        {attribute_view_gui attribute=$node.data_map.page}
      {else}
        {node_view_gui content_node=$node view=children view_parameters=$view_parameters}
      {/if}

      {include uri='design:parts/family_in_trentino.tpl'}
    </div>

    {include uri='design:openpa/full/parts/section_left.tpl'}

  </div>

  {if $openpa.content_date.show_date}
    {include uri=$openpa.content_date.template}
  {/if}

</div>


{include uri='design:parts/load_website_toolbar.tpl' current_user=fetch(user, current_user)}

{if openpaini('GeneralSettings','valutation', 1)}
    {ezpagedata_set( 'valuation', $node.node_id )}
{/if}

{def $homepage = fetch('openpa', 'homepage')}
{if $homepage.node_id|eq($node.node_id)}
    {ezpagedata_set('is_homepage', true())}
{/if}

{if $openpa.control_area_tematica.is_area_tematica}
    {ezpagedata_set('is_area_tematica', $openpa.control_area_tematica.area_tematica.contentobject_id)}
{/if}

{if and( $homepage|has_attribute('partners'), $homepage|attribute('partners').has_content) }
    {include uri='design:footer/partners.tpl' homepage=$homepage}
{/if}