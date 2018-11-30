{def $object=fetch( 'content', 'object', hash( 'object_id', $item ) )}
<div class="Grid Grid--withGutter azioni-container u-padding-all-s u-margin-all-s u-background-5">
  <div class="Grid-cell">
    <h5 class="u-text-h5">{$object.name}</h5>
  </div>
  <div class="Grid-cell">
    {def $attributes = array(
    'image', 'data_attivazione', 'numero_posti',
    'tipo_infrastruttura', 'note_tipo_infrastruttura', 'organizzazione_proprietaria'
    )}
    {foreach $attributes as $attribute}

      {if $object|has_attribute($attribute)}
        <div class="content-detail-item withLabel">
          <div class="u-padding-bottom-l">
            <div class="u-text-h6"><strong>{$object|attribute($attribute).contentclass_attribute.name}</strong></div>
            <div>
              {attribute_view_gui attribute=$object|attribute($attribute)  show_newline=true()}
            </div>
          </div>
        </div>
      {/if}

    {/foreach}
    {undef $object $attributes}
  </div>
</div>
