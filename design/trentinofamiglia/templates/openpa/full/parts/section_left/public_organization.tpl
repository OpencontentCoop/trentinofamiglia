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


{* Altre sedi --> organizzazioni pubblicahe con stesso cf*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('public_organization', 'private_organization'),
'filter', array(concat("attr_codice_fiscale_s:",$node.data_map.codice_fiscale.content))
))
$objects = $search_reverse_related.SearchResult
$objects_count = $search_reverse_related.SearchCount}

{if $objects_count|gt(1)}
  <div class="content-related">
    <div class="openpa-widget nav-section">
      <h3 class="openpa-widget-title"><i class="fa fa-university" aria-hidden="true"></i> Altre sedi</h3>
      <div class="openpa-widget-content Prose">
        <ul class="Linklist Prose u-text-r-xs" style="margin-left:0 !important;">
          {foreach $objects as $obj}
            {if $node.contentobject_id|ne($obj.id)}
              <li><a href="{$obj.global_url_alias|ezurl(no)}" class="u-text-xxs">{$obj.name}</a></li>
            {/if}
          {/foreach}
        </ul>
      </div>
    </div>
  </div>
{/if}
