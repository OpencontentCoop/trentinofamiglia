{* Certificazione family Audit*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('certificazione_familyaudit'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$organization.object.id))
))
$fam_audit = $search_reverse_related.SearchCount}


{* Certificazione family in Trentino*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('certificazione_familyintrentino'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$organization.object.id))
))
$fam_trentino = $search_reverse_related.SearchCount}


{* Certificazione family in Italia*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('certificazione_familyinitalia'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$organization.object.id))
))
$fam_italia = $search_reverse_related.SearchCount}


{* Distretto famiglia*}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('adesione_distretto_famiglia'),
'filter', array(concat(solr_meta_subfield('organizzazione_aderente','id'),":",$organization.object.id))
))
$dis_fam = $search_reverse_related.SearchCount}


{* Network Nazionale *}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('adesione_network_nazionale'),
'filter', array(concat(solr_meta_subfield('organizzazione_aderente','id'),":",$organization.object.id))
))
$net_naz = $search_reverse_related.SearchCount}


{* Family  Card *}
{def $search_reverse_related = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('adesione_family_card'),
'filter', array(concat(solr_meta_subfield('id_unico','id'),":",$organization.object.id))
))
$fam_card = $search_reverse_related.SearchCount}



{if or( $fam_audit|gt(0), $fam_trentino|gt(0), $fam_italia|gt(0), $dis_fam|gt(0), $net_naz|gt(0), $fam_card|gt(0) )}
<div class="Grid Grid--withGutter u-margin-top-l">
  <div class="Grid-cell u-sizeFull">
    <h4 class="u-text-h4 u-margin-top-xs u-margin-bottom-xs"> Certificazioni</h4>
  </div>


    {if $fam_audit|gt(0)}
      <div class="Grid-cell u-md-size1of4 u-lg-size1of4 u-padding-all-l">
        <img class="img-responsive" src="{'familyaudit.png'|ezimage(no)}" />
      </div>
    {/if}



    {if $fam_trentino|gt(0)}
      <div class="Grid-cell u-md-size1of4 u-lg-size1of4 u-padding-all-l">
        <img class="img-responsive" src="{'familyintrentino.jpg'|ezimage(no)}" />
      </div>
    {/if}



    {if $fam_italia|gt(0)}
      <div class="Grid-cell u-md-size1of4 u-lg-size1of4 u-padding-all-l">
        <img class="img-responsive" src="{'familyinitalia.png'|ezimage(no)}" />
      </div>
    {/if}



    {if $dis_fam|gt(0)}
      <div class="Grid-cell u-md-size1of4 u-lg-size1of4 u-padding-all-l">
        <img class="img-responsive" src="{'distrettofamiglia.png'|ezimage(no)}" />
      </div>
    {/if}



    {if $net_naz|gt(0)}
      <div class="Grid-cell u-md-size1of4 u-lg-size1of4 u-padding-all-l">
        <img class="img-responsive" src="{'networknazionale.png'|ezimage(no)}" />
      </div>
    {/if}



    {if $fam_card|gt(0)}
      <div class="Grid-cell u-md-size1of4 u-lg-size1of4 u-padding-all-l">
        <img class="img-responsive" src="{'familycard.png'|ezimage(no)}" />
      </div>
    {/if}

</div>
{/if}


{undef $fam_audit $fam_trentino $fam_italia $dis_fam $net_naz $fam_card}

