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

  {if $contact_points|count()|gt(0)}
    {def $services = array()}
    {foreach $contact_points as $contact_point}
      {def $search_reverse_related = fetch('ezfind','search', hash('limit',20,'filter',array(concat("servizio_culturale/contact_point/id:",$contact_point.object.id))))
           $objects = $search_reverse_related.SearchResult
           $objects_count = $search_reverse_related.SearchCount}

      {if $objects_count|gt(0)}
        {foreach $objects as $object}
          {if $object.can_read}
            {set $services = $services|append($object)}
          {/if}
        {/foreach}
      {/if}
    {/foreach}


    {if $services|count()|gt(0)}
      <div class="openpa-widget nav-section">
        <h2 class="openpa-widget-title"><i class="fa fa-magic" aria-hidden="true"></i> Servizi offerti</h2>
        <div class="openpa-widget-content">
          <ul>
            {foreach $services as $s}
              <li><a href="{$s.url_alias|ezurl(no)}">{$s.name}</a></li>
            {/foreach}
          </ul>
        </div>
      </div>
    {/if}
  {/if}

</div>
