{if $openpa.content_contacts.has_content}
  <div class="openpa-widget">
    <h3 class="openpa-widget-title"><i class="fa fa-bookmark-o fa-lg"></i> Profilo dell'organizzazione</h3>
    <section class="Prose Alert Alert--info u-margin-bottom-l">
      <div class="Grid Grid--withGutter">
        {foreach $openpa.content_contacts.attributes as $openpa_attribute}
          {def $size = 12}
          {if $openpa_attribute.full.show_label}
            <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
              <strong>{$openpa_attribute.label}: </strong>
            </div>
          {/if}
          {if $openpa_attribute.full.show_label}
            {set $size = 8}
          {/if}
          <div class="Grid-cell u-sm-size{$size}of12 u-md-size{$size}of12 u-lg-size{$size}of12">
            {attribute_view_gui attribute=$openpa_attribute.contentobject_attribute href=cond($openpa_attribute.full.show_link|not, 'no-link', '')}
          </div>
          {undef $size}
        {/foreach}
      </div>
    </section>
  </div>
{/if}
