{* Certificazione family Audit*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('certificazione_familyaudit'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$node.object.id))
))
$objects = $search_reverse_related.SearchResult
$objects_count = $search_reverse_related.SearchCount}

<h3 class="u-text-h3 u-margin-top-m"><i class="fa fa-check-circle fa-lg" style="color: #00923f"></i> Certificazioni ed adesioni</h3>
{if $objects_count|gt(0)}

  <table class="Table Table--compact reverse-related" cellspacing="0">
    <tr>
      {foreach $objects as $o}
        <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
          <img class="img-responsive" src="{'familyaudit.png'|ezimage(no)}" />
        </td>
        <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4 Prose">
          {if $o.data_map.n_iscriz_registro.has_content}
            {$o.data_map.n_iscriz_registro.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_iscriz_registro}</strong><br />
          {/if}
          {if $o.data_map.stato_certificazione.has_content}
            {$o.data_map.stato_certificazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.stato_certificazione}</strong><br />
          {/if}
          {if $o.data_map.sperimentazione.has_content}
            {$o.data_map.sperimentazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.sperimentazione}</strong><br />
          {/if}
          {if $o.data_map.data_fa.has_content}
            {$o.data_map.data_fa.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_fa}</strong><br />
          {/if}
          {if $o.data_map.determina_fa.has_content}
            {$o.data_map.determina_fa.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.determina_fa}</strong><br />
          {/if}
          {if $o.data_map.data_executive.has_content}
            {$o.data_map.data_executive.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_executive}</strong><br />
          {/if}
          {if $o.data_map.determina_executive.has_content}
            {$o.data_map.determina_executive.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.determina_executive}</strong><br />
          {/if}
          {if $o.data_map.data_revoca.has_content}
            {$o.data_map.data_revoca.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_revoca}</strong><br />
          {/if}
          {if $o.data_map.determina_revoca.has_content}
            {$o.data_map.determina_revoca.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.determina_revoca}</strong><br />
          {/if}
          {if $o.data_map.data_scadenza.has_content}
            {$o.data_map.data_scadenza.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_scadenza}</strong><br />
          {/if}
          {if $o.data_map.note.has_content}
            {$o.data_map.note.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.note}</strong><br />
          {/if}
        </td>
      {/foreach}

    </tr>
  </table>
{/if}
{undef $search_reverse_related $objects $objects_count}

{* Certificazione family in Trentino*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('certificazione_familyintrentino'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$node.object.id))
))
$objects = $search_reverse_related.SearchResult
$objects_count = $search_reverse_related.SearchCount}

{if $objects_count|gt(0)}
  <table class="Table Table--compact reverse-related" cellspacing="0">
    <tr>
      {foreach $objects as $o}
        <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
          <img class="img-responsive" src="{'familyintrentino.jpg'|ezimage(no)}" />
        </td>
        <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4 Prose">
          {if $o.data_map.id_unico.has_content}
            {$o.data_map.id_unico.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.id_unico}</strong><br />
          {/if}
          {if $o.data_map.tipologia.has_content}
            {$o.data_map.tipologia.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.tipologia}</strong><br />
          {/if}
          {if $o.data_map.n_det_assegnazione.has_content}
            {$o.data_map.n_det_assegnazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_det_assegnazione}</strong><br />
          {/if}
          {if $o.data_map.data_det_assegnazione.has_content}
            {$o.data_map.data_det_assegnazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_det_assegnazione}</strong><br />
          {/if}
          {if $o.data_map.n_registrazione_familyintrentino.has_content}
            {$o.data_map.n_registrazione_familyintrentino.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_registrazione_familyintrentino}</strong><br />
          {/if}
        </td>
      {/foreach}

    </tr>
  </table>
{/if}
{undef $search_reverse_related $objects $objects_count}


{* Certificazione family in Italia*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('certificazione_familyinitalia'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$node.object.id))
))
$objects = $search_reverse_related.SearchResult
$objects_count = $search_reverse_related.SearchCount}

{if $objects_count|gt(0)}
  <table class="Table Table--compact reverse-related" cellspacing="0">
    <tr>
      {foreach $objects as $o}
        <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
          <img class="img-responsive" src="{'familyinitalia.png'|ezimage(no)}" />
        </td>
        <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4 Prose">
          {if $o.data_map.id_unico.has_content}
            {$o.data_map.id_unico.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.id_unico}</strong><br />
          {/if}
          {if $o.data_map.tipologia.has_content}
            {$o.data_map.tipologia.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.tipologia}</strong><br />
          {/if}
          {if $o.data_map.n_det_assegnazione.has_content}
            {$o.data_map.n_det_assegnazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_det_assegnazione}</strong><br />
          {/if}
          {if $o.data_map.data_det_assegnazione.has_content}
            {$o.data_map.data_det_assegnazione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_det_assegnazione}</strong><br />
          {/if}
          {if $o.data_map.n_registrazione_familyinitalia.has_content}
            {$o.data_map.n_registrazione_familyinitalia.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.n_registrazione_familyinitalia}</strong><br />
          {/if}
        </td>
      {/foreach}

    </tr>
  </table>
{/if}
{undef $search_reverse_related $objects $objects_count}

{* Distretto famiglia*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('adesione_distretto_famiglia'),
'filter', array(concat(solr_meta_subfield('organizzazione_aderente','id'),":",$node.object.id))
))
$objects = $search_reverse_related.SearchResult
$objects_count = $search_reverse_related.SearchCount}

{if $objects_count|gt(0)}
  <table class="Table Table--compact reverse-related" cellspacing="0">
    <tr>
      <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
        <img class="img-responsive" src="{'distrettofamiglia.png'|ezimage(no)}" />
      </td>
      <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4 Prose">
      {foreach $objects as $o}
        {def $distretto = fetch( 'content', 'object', hash( 'object_id', $o.data_map.distretto.content.relation_list[0].contentobject_id ) )}

        <div class="u-padding-bottom-s">
          {if $o.data_map.distretto.has_content}
            {$o.data_map.distretto.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.distretto}</strong><br />
          {/if}
          {if $o.data_map.data_inizio_adesione.has_content}
            {$o.data_map.data_inizio_adesione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_inizio_adesione}</strong><br />
          {/if}
          {if $o.data_map.coordinatore.has_content}
            {$o.data_map.coordinatore.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.coordinatore}</strong><br />
          {/if}
          {if $o.data_map.proponente.has_content}
            {$o.data_map.proponente.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.proponente}</strong><br />
          {/if}
        </div>
      {/foreach}
      </td>

    </tr>
  </table>
{/if}
{undef $search_reverse_related $objects $objects_count}


{* Network Nazionale *}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('adesione_network_nazionale'),
'filter', array(concat(solr_meta_subfield('organizzazione_aderente','id'),":",$node.object.id))
))
$objects = $search_reverse_related.SearchResult
$objects_count = $search_reverse_related.SearchCount}

{if $objects_count|gt(0)}
  <table class="Table Table--compact reverse-related" cellspacing="0">
    <tr>
      <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
        <img class="img-responsive" src="{'networknazionale.png'|ezimage(no)}" />
      </td>
      <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4 Prose">
        {foreach $objects as $o}
          {def $distretto = fetch( 'content', 'object', hash( 'object_id', $o.data_map.distretto.content.relation_list[0].contentobject_id ) )}

          <div class="u-padding-bottom-s">
            {if $o.data_map.distretto.has_content}
              {$o.data_map.distretto.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.distretto}</strong><br />
            {/if}
            {if $o.data_map.data_inizio_adesione.has_content}
              {$o.data_map.data_inizio_adesione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_inizio_adesione}</strong><br />
            {/if}
            {if $o.data_map.coordinatore.has_content}
              {$o.data_map.coordinatore.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.coordinatore}</strong><br />
            {/if}
            {if $o.data_map.proponente.has_content}
              {$o.data_map.proponente.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.proponente}</strong><br />
            {/if}
          </div>
        {/foreach}
      </td>

    </tr>
  </table>
{/if}
{undef $search_reverse_related $objects $objects_count}

{* Family  Card *}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('adesione_family_card'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$node.object.id))
))
$objects = $search_reverse_related.SearchResult
$objects_count = $search_reverse_related.SearchCount}

{if $objects_count|gt(0)}
  <table class="Table Table--compact reverse-related" cellspacing="0">
    <tr>
      <td class="u-sm-size1of4 u-md-size1of4 u-lg-size1of4">
        <img class="img-responsive" src="{'familycard.png'|ezimage(no)}" />
      </td>
      <td class="u-sm-size3of4 u-md-size3of4 u-lg-size3of4 Prose">
        {foreach $objects as $o}
          {def $distretto = fetch( 'content', 'object', hash( 'object_id', $o.data_map.distretto.content.relation_list[0].contentobject_id ) )}

          <div class="u-padding-bottom-s">
            {if $o.data_map.data_inizio_adesione.has_content}
              {$o.data_map.data_inizio_adesione.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.data_inizio_adesione}</strong><br />
            {/if}
            {if $o.data_map.tipo_family_card.has_content}
              {$o.data_map.tipo_family_card.contentclass_attribute.name}: <strong>{attribute_view_gui attribute=$o.data_map.tipo_family_card}</strong><br />
            {/if}
          </div>
        {/foreach}
      </td>

    </tr>
  </table>
{/if}
{undef $search_reverse_related $objects $objects_count}

