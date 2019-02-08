<div class="Grid Grid--withGutter azioni-container u-padding-all-s">
  <div class="Grid-cell u-size3of4">
    <h3>{$azione.name}</h3>
  </div>
  <div class="Grid-cell u-size1of4">
    <a href="#"
       data-class="valutazione_attivita"
       data-piano="{$post.object.id}"
       data-parent="{$post.object.main_node_id}"
       data-azione="{$azione.id}"
       class="Button Button--default u-text-r-xs btn-sm u-floatRight CreateValutazioneButton"><i class="fa fa-plus" aria-hidden="true"></i> Aggiungi valutazione</a>
  </div>

  <div class="Grid-cell u-sizeFull">
    <div class="form-valutazioni u-margin-top-s"></div>
  </div>

  <div class="Grid-cell u-sizeFull editorialstuff">
    <div class="content-data" id="azione_{$azione.id}" data-class="valutazione_attivita" data-piano="{$post.object.id}" data-parent="{$post.object.main_node_id}" data-azione="{$azione.id}" ></div>
  </div>
</div>
