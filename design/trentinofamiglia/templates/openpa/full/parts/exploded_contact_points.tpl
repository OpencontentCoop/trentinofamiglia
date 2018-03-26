{set_defaults(hash(
'attribute_name', '',
'hide_title', true()
))}

{def $contact_points = array()
     $attribute = $node|attribute($attribute_name)}

{* Contatti *}
{if $attribute.has_content}
  {foreach $attribute.content.relation_list as $l}

    {def $contact_point = fetch( 'content', 'node', hash( 'node_id', $l.node_id ) )}
    {set $contact_points = $contact_points|append($contact_point)}
    {undef $contact_point}
  {/foreach}
{/if}

{if $contact_points|count()|gt(0)}
  {if $hide_title|not()}
    <h3 class="u-text-h3"><i class="fa fa-comments-o fa-lg"></i> Contatti</h3>
  {/if}
  <section class="Prose Alert Alert--info u-margin-bottom-l">
    <div class="Grid Grid--withGutter">
      {foreach $contact_points as $c}
        <h5 class="u-text-h5 u-sizeFull"> {$node.name}</h5>
        {if $c.data_map.pec.has_content}
          <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
            <strong>{$c.data_map.pec.contentclass_attribute.name}: </strong>
          </div>
          <div class="Grid-cell u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
            {attribute_view_gui attribute=$c.data_map.pec}
          </div>
        {/if}

        {if $c.data_map.fax.has_content}
          <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
            <strong>{$c.data_map.fax.contentclass_attribute.name}: </strong>
          </div>
          <div class="Grid-cell u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
            {attribute_view_gui attribute=$c.data_map.fax}
          </div>
        {/if}

        {if $c.data_map.telefono_principale.has_content}
          <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
            <strong>{$c.data_map.telefono_principale.contentclass_attribute.name}: </strong>
          </div>
          <div class="Grid-cell u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
            {attribute_view_gui attribute=$c.data_map.telefono_principale}
          </div>
        {/if}

        {if $c.data_map.telefono_secondario.has_content}
          <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
            <strong>{$c.data_map.telefono_secondario.contentclass_attribute.name}: </strong>
          </div>
          <div class="Grid-cell u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
            {attribute_view_gui attribute=$c.data_map.telefono_secondario}
          </div>
        {/if}

        {if $c.data_map.cellulare.has_content}
          <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
            <strong>{$c.data_map.cellulare.contentclass_attribute.name}: </strong>
          </div>
          <div class="Grid-cell u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
            {attribute_view_gui attribute=$c.data_map.cellulare}
          </div>
        {/if}
        {if $c.data_map.sito_web.has_content}
          <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
            <strong>{$c.data_map.sito_web.contentclass_attribute.name}: </strong>
          </div>
          <div class="Grid-cell u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
            {attribute_view_gui attribute=$c.data_map.sito_web}
          </div>
        {/if}
      {/foreach}
    </div>
  </section>
{/if}

{undef $contact_points $attribute}
