{def $object=fetch( 'content', 'object', hash( 'object_id', $item.id ) )}
<table>
  {def $attributes = array(
  'titolo', 'macroambito', 'tipo_azione', 'attivita',
  'descrizione', 'obiettivo', 'assessorato', 'tipologia_partnership', 'organizzazioni_coinvolte',
    'altre_organizzazioni_coinvolte', 'indicatore'
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
