<div class="Grid Grid--withGutter azioni-container u-padding-all-s">
  {*if $macroambito.required_azioni|count()|gt(0)}
    <div class="Grid-cell u-sizeFull u-margin-bottom-l">
      <div class="Alert Alert--info">
        <p class="u-margin-bottom-l">Per il macroambito <strong>{$macroambito.name}</strong> sono obbligattorie le seguenti tipologie di azione:</p>
        <ul class="two-columns">
          {foreach $macroambito.required_azioni as $r}
            <li>{$r.name}</li>
          {/foreach}
        </ul>
      </div>
    </div>
  {/if*}
  {if $macroambito.missing_azioni|count()|gt(0)}
    <div class="Grid-cell u-sizeFull u-margin-bottom-l">
      <div class="Alert Alert--warning">
        <p class="u-margin-bottom-l">Per il macroambito <strong>{$macroambito.name}</strong> devi ancora aggiungere le seguenti tipologie di azione:</p>
        <ul class="two-columns">
          {foreach $macroambito.missing_azioni as $r}
            <li id="missing_{$r.id}">{$r.name}</li>
          {/foreach}
        </ul>
      </div>
    </div>
  {/if}
  <div class="Grid-cell u-sizeFull u-pullRight">
    <a href="#"
       data-class="azione"
       data-parent="{$post.object.main_node_id}"
       data-piano="{$post.object.id}"
       data-ambito="{$macroambito.id}"
       class="Button Button--default u-text-r-xs btn-sm u-floatRight CreateAzioniButton"><i class="fa fa-plus" aria-hidden="true"></i> Aggiungi azione</a>
  </div>

  <div class="Grid-cell u-sizeFull">
    <div class="form-azioni u-margin-top-s"></div>
  </div>

  <div class="Grid-cell u-sizeFull editorialstuff">
    <div class="content-data" id="ambito_{$macroambito.id}" data-piano="{$post.object.id}" data-ambito="{$macroambito.id}" ></div>
  </div>
</div>
