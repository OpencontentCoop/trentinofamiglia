{if $openpa.control_cache.no_cache}
  {set-block scope=root variable=cache_ttl}0{/set-block}
{/if}

{if $openpa.content_tools.editor_tools}
  {include uri=$openpa.content_tools.template}
{/if}

{def $contact_points = array()}

{if $openpa.control_menu.side_menu.root_node}
  {def $tree_menu = tree_menu( hash( 'root_node_id', $openpa.control_menu.side_menu.root_node.node_id, 'user_hash', $openpa.control_menu.side_menu.user_hash, 'scope', 'side_menu' ))
  $show_left = and( $openpa.control_menu.show_side_menu, count( $tree_menu.children )|gt(0) )}
{else}
  {def $show_left = false()}
{/if}

{def $extra_template = 'design:openpa/full/parts/section_left/public_organization.tpl'}

<div class="openpa-full class-{$node.class_identifier}">
  <div class="title">
    {include uri='design:openpa/full/parts/node_languages.tpl'}
    <h2>{$node.name|wash()}</h2>
  </div>
  <div class="content-container">
    <div class="content{if or( $show_left, $openpa.control_menu.show_extra_menu )} withExtra{/if}">

      {include uri=$openpa.content_main.template}

      {include uri=$openpa.content_contacts.template}

      {* Contatti *}
      {if $node.data_map.punti_di_contatto_on_line.has_content}
        {foreach $node.data_map.punti_di_contatto_on_line.content.relation_list as $l}

          {def $contact_point = fetch( 'content', 'node', hash( 'node_id', $l.node_id ) )}
          {set $contact_points = $contact_points|append($contact_point)}
          {undef $contact_point}
        {/foreach}
      {/if}

      {if $contact_points|count()|gt(0)}
        <section class="Prose Alert Alert--info u-margin-bottom-l">
          <div class="Grid Grid--withGutter">
            {foreach $contact_points as $c}
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

              {if $c.data_map.telefono.has_content}
                <div class="Grid-cell u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
                  <strong>{$c.data_map.telefono.contentclass_attribute.name}: </strong>
                </div>
                <div class="Grid-cell u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
                  {attribute_view_gui attribute=$c.data_map.telefono}
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

      {include uri=$openpa.content_detail.template}

      {include uri=$openpa.content_infocollection.template}

      {* Certificazione family Audit*}
      {def $search_reverse_related = fetch('ezfind','search', hash('limit',100,'filter',array(concat('certificazione_familyaudit',"/",'id_unico',"/id:",$node.object.id))))
      $objects = $search_reverse_related.SearchResult
      $objects_count = $search_reverse_related.SearchCount}

      <h3 class="u-text-h3 u-margin-top-m">Certificazioni</h3>
      {if $objects_count|gt(0)}
        <table class="Table Table--compact reverse-related" cellspacing="0">
          <tr>
            {foreach $objects as $o}
              <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
                <img class="img-responsive" src="{'familyaudit.png'|ezimage(no)}" />
              </td>
              <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4">
                {if $o.data_map.n_iscriz_registro.has_content}
                  <p>{$o.data_map.n_iscriz_registro.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_iscriz_registro}</strong></p>
                {/if}
                {if $o.data_map.stato_certificazione.has_content}
                  <p>{$o.data_map.stato_certificazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.stato_certificazione}</strong></p>
                {/if}
                {if $o.data_map.sperimentazione.has_content}
                  <p>{$o.data_map.sperimentazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.sperimentazione}</strong></p>
                {/if}
                {if $o.data_map.data_fa.has_content}
                  <p>{$o.data_map.data_fa.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_fa}</strong></p>
                {/if}
                {if $o.data_map.determina_fa.has_content}
                  <p>{$o.data_map.determina_fa.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.determina_fa}</strong></p>
                {/if}
                {if $o.data_map.data_executive.has_content}
                  <p>{$o.data_map.data_executive.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_executive}</strong></p>
                {/if}
                {if $o.data_map.determina_executive.has_content}
                  <p>{$o.data_map.determina_executive.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.determina_executive}</strong></p>
                {/if}
                {if $o.data_map.data_revoca.has_content}
                  <p>{$o.data_map.data_revoca.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_revoca}</strong></p>
                {/if}
                {if $o.data_map.determina_revoca.has_content}
                  <p>{$o.data_map.determina_revoca.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.determina_revoca}</strong></p>
                {/if}
                {if $o.data_map.data_scadenza.has_content}
                  <p>{$o.data_map.data_scadenza.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_scadenza}</strong></p>
                {/if}
                {if $o.data_map.note.has_content}
                  <p>{$o.data_map.note.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.note}</strong></p>
                {/if}
              </td>
            {/foreach}

          </tr>
        </table>
      {/if}
      {undef $search_reverse_related $objects $objects_count}

      {* Certificazione family in Trentino*}
      {def $search_reverse_related = fetch('ezfind','search', hash('limit',100,'filter',array(concat('certificazione_familyintrentino',"/",'id_unico',"/id:",$node.object.id))))
      $objects = $search_reverse_related.SearchResult
      $objects_count = $search_reverse_related.SearchCount}

      {if $objects_count|gt(0)}
        <table class="Table Table--compact reverse-related" cellspacing="0">
          <tr>
            {foreach $objects as $o}
              <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
                <img class="img-responsive" src="{'familyintrentino.jpg'|ezimage(no)}" />
              </td>
              <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4">
                {if $o.data_map.id_unico.has_content}
                  <p>{$o.data_map.id_unico.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.id_unico}</strong></p>
                {/if}
                {if $o.data_map.tipologia.has_content}
                  <p>{$o.data_map.tipologia.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.tipologia}</strong></p>
                {/if}
                {if $o.data_map.n_det_assegnazione.has_content}
                  <p>{$o.data_map.n_det_assegnazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_det_assegnazione}</strong></p>
                {/if}
                {if $o.data_map.data_det_assegnazione.has_content}
                  <p>{$o.data_map.data_det_assegnazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_det_assegnazione}</strong></p>
                {/if}
                {if $o.data_map.n_registrazione_familyintrentino.has_content}
                  <p>{$o.data_map.n_registrazione_familyintrentino.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_registrazione_familyintrentino}</strong></p>
                {/if}
              </td>
            {/foreach}

          </tr>
        </table>
      {/if}
      {undef $search_reverse_related $objects $objects_count}

      {* Certificazione family in Trentino*}
      {def $search_reverse_related = fetch('ezfind','search', hash('limit',100,'filter',array(concat('adesione_distretto_famiglia',"/",'organizzazione_aderente',"/id:",$node.object.id))))
      $objects = $search_reverse_related.SearchResult
      $objects_count = $search_reverse_related.SearchCount}

      {if $objects_count|gt(0)}
        <h3 class="u-text-h3 u-margin-top-m">Adesioni</h3>
        <table class="Table Table--compact reverse-related" cellspacing="0">
          <tr>
            {foreach $objects as $o}

              {def $distretto = fetch( 'content', 'object', hash( 'object_id', $o.data_map.distretto.content.relation_list[0].contentobject_id ) )}

              <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
                {attribute_view_gui attribute=$distretto.data_map.image}
              </td>
              <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4">
                {if $o.data_map.distretto.has_content}
                  <p>{$o.data_map.distretto.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.distretto}</strong></p>
                {/if}
                {if $o.data_map.data_inizio_adesione.has_content}
                  <p>{$o.data_map.data_inizio_adesione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_inizio_adesione}</strong></p>
                {/if}
                {if $o.data_map.coordinatore.has_content}
                  <p>{$o.data_map.coordinatore.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.coordinatore}</strong></p>
                {/if}
                {if $o.data_map.proponente.has_content}
                  <p>{$o.data_map.proponente.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.proponente}</strong></p>
                {/if}

              </td>

            {/foreach}

          </tr>
        </table>
      {/if}
      {undef $search_reverse_related $objects $objects_count}


      {node_view_gui content_node=$node view=children view_parameters=$view_parameters}

    </div>

    {include uri='design:openpa/full/parts/section_left.tpl' extra_template=$extra_template}
  </div>
  {if $openpa.content_date.show_date}
    {include uri=$openpa.content_date.template}
  {/if}
</div>



