{if $node|attribute( 'geo' ).has_content}
  <div class="content-related">
      <div class="openpa-widget nav-section">
      <h2 class="openpa-widget-title"><i class="fa fa-map-marker"></i> Dove si trova</h2>
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
