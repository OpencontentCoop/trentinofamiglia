{def $object_azione=fetch( 'content', 'object', hash( 'object_id', $azione.id ) )}
<div class="Grid Grid--withGutter azioni-container u-padding-all-s" style="background-color: #f2f2f2; margin: 20px 0px;">
  <div class="Grid-cell u-sizeFull">
    <div class="Accordion Accordion--default fr-accordion js-fr-accordion" id="accordion-{$azione.id}">
      <h5 class="Accordion-header js-fr-accordion__header fr-accordion__header u-text-h5" id="accordion-header-{$azione.id}">
        <span class="Accordion-link">{$azione.name}</span>
      </h5>
      <div id="accordion-panel-{$azione.id}" class="Accordion-panel fr-accordion__panel js-fr-accordion__panel u-background-white u-padding-all-xs">
        {def $attributes = array(
        'tipo_azione', 'attivita', 'descrizione', 'obiettivo',
        'assessorato', 'tipologia_partnership', 'organizzazioni_coinvolte',
        'altre_organizzazioni_coinvolte', 'indicatore'
        )}
        {foreach $attributes as $attribute}
          {if $object_azione|has_attribute($attribute)}
            <div class="content-detail-item withLabel">
              <div class="u-padding-bottom-l">
                <div class="u-text-h6"><strong>{$object_azione|attribute($attribute).contentclass_attribute.name}</strong></div>
                <div>
                  {attribute_view_gui attribute=$object_azione|attribute($attribute)  show_newline=true()}
                </div>
              </div>
            </div>
          {/if}
        {/foreach}
        {undef $object_azione $attributes}
      </div>
    </div>
  </div>

  <div class="Grid-cell u-sizeFull">
    <div class="form-valutazioni u-margin-top-s"></div>
  </div>

  <div class="Grid-cell u-sizeFull editorialstuff">
    <div class="content-data" id="azione_{$azione.id}" data-class="valutazione_attivita" data-piano="{$post.object.id}" data-parent="{$post.object.main_node_id}" data-azione="{$azione.id}" ></div>
  </div>

  <div class="Grid-cell u-sizeFull u-padding-top-l">
    <a href="#"
       data-class="valutazione_attivita"
       data-piano="{$post.object.id}"
       data-parent="{$post.object.main_node_id}"
       data-azione="{$azione.id}"
       class="Button Button--default u-text-r-xs btn-sm u-floatRight CreateValutazioneButton"><i class="fa fa-plus" aria-hidden="true"></i> Aggiungi valutazione</a>
  </div>
</div>
