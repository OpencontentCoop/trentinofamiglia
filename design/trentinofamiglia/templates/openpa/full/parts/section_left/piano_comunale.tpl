<div class="u-margin-top-m">

  {if $node|attribute( 'geo' ).has_content}
    <div class="openpa-widget">
      <div class="openpa-widget nav-section">
        <h5 class="u-text-h5"><i class="fa fa-map-marker"></i> Dove si trova</h5>
        <div class="openpa-widget-content">
          {if $node|has_attribute( 'geo' )}
            <p class="Prose u-margin-bottom-s">{$node.data_map.geo.content.address}</p>
            {attribute_view_gui attribute=$node.data_map.geo zoom=3}
          {/if}
          {if $node|has_attribute( 'come_arrivare' )}
            <div class="Prose">{attribute_view_gui attribute=$node.data_map.come_arrivare  show_newline=true()}</div>
          {/if}
        </div>
      </div>
    </div>
  {/if}


  {if $node|has_attribute( 'dati_demografici' )}
    <div class="openpa-widget">
      <div class="openpa-widget nav-section">
        <h5 class="u-text-h5"><i class="fa fa-users"></i> Sintesi dati demografici</h5>
        <div class="openpa-widget-content">
          {attribute_view_gui attribute=$node.data_map.dati_demografici }
        </div>
      </div>
    </div>
  {/if}

  {if $node|has_attribute( 'piani_pregressi' )}
    <div class="openpa-widget">
      <div class="openpa-widget nav-section">
        <h5 class="u-text-h5"><i class="fa fa-files-o" aria-hidden="true"></i> Piani pregressi</h5>
        <div class="openpa-widget-content">
          {attribute_view_gui attribute=$node.data_map.piani_pregressi }
        </div>
      </div>
    </div>
  {/if}

  {if $node|has_attribute( 'infrastrutture_family' )}
    <div class="openpa-widget">
      <div class="openpa-widget nav-section">
        <h5 class="u-text-h5"><i class="fa fa-map-pin" aria-hidden="true"></i> Infrastrutture family esistenti</h5>
        <div class="openpa-widget-content content-detail-item" style="padding-left: 20px">
          {attribute_view_gui attribute=$node.data_map.infrastrutture_family }
        </div>
      </div>
    </div>
  {/if}


</div>
