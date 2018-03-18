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

      {include uri='design:parts/family_audit.tpl'}
    </div>

    {include uri='design:openpa/full/parts/section_left.tpl'}

  </div>

  {if $openpa.content_date.show_date}
    {include uri=$openpa.content_date.template}
  {/if}

</div>


