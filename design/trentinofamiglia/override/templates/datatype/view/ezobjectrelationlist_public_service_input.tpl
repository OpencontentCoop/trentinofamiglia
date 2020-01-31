{def $related_nodes = array()}

{if $attribute.has_content}
  {foreach $attribute.content.relation_list as $l}
    {def $related_node = fetch( 'content', 'node', hash( 'node_id', $l.node_id ) )}
    {if $related_node.can_read}
    	{set $related_nodes = $related_nodes|append($related_node)}
    {/if}
    {undef $related_node}
  {/foreach}
{/if}

{if $related_nodes|count()|gt(0)}  
  {foreach $related_nodes as $related_node}
      {node_view_gui content_node=$related_node view=line}
  {/foreach}
{/if}

{undef $related_nodes}
