 <ul class="Linklist Linklist--padded">
{def $href='' $text=''}
{foreach $attribute.content.rows.sequential as $row}
  {set $href='' $text=''}
  {foreach $row.columns as $index => $column}
    {if $index|eq(0)}{set $href=$column}{else}{set $text=$column}{/if}
  {/foreach}
  <li><a href="{$href}" target="_black">{$text}</a></li>  
{/foreach}
</ul>
{undef $href $text}           