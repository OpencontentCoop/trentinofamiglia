{def $object=fetch( 'content', 'object', hash( 'object_id', $item ) )}
<h4>{$object.name}</h4>
<table>
  {def $attributes = array(
  'image', 'data_attivazione', 'numero_posti',
  'tipo_infrastruttura', 'note_tipo_infrastruttura', 'organizzazione_proprietaria'
  )}
  {foreach $attributes as $attribute sequence array('#fff', '#f2f2f2') as $bgcolor}

    {if $object|has_attribute($attribute)}
      <tr style="background-color: {$bgcolor}">
        <td class="name">
          {$object.data_map[$attribute].contentclass_attribute.name}
        </td>
        <td class="value">
          {attribute_view_gui attribute=$object.data_map[$attribute]  show_newline=true()}
        </td>
      </tr>
    {/if}
  {/foreach}
  {undef $object $attributes}
</table>
