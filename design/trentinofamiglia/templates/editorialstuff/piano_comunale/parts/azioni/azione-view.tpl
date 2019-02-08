{def $object=fetch( 'content', 'object', hash( 'object_id', $azione.id ) )}
<div class="Grid Grid--withGutter azioni-container u-padding-all-s u-margin-all-s u-background-5">
  <div class="Grid-cell">
    <h5 class="u-text-h5">{$azione.name}</h5>
  </div>
  <div class="Grid-cell">
    {def $attributes = array(
    'tipo_azione', 'attivita', 'descrizione', 'obiettivo',
    'assessorato', 'tipologia_partnership', 'organizzazioni_coinvolte',
    'altre_organizzazioni_coinvolte', 'indicatore'
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
