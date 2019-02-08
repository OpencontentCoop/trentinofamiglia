{* Certificazione family Audit*}
{def $search = fetch('ezfind','search', hash(
'limit',100,
'class_id', array('piano_comunale'),
'filter', array(concat(solr_meta_subfield('organizzazione','id'),":",$node.object.id))
))
$objects = $search.SearchResult
$objects_count = $search.SearchCount}
{if $objects_count|gt(0)}
<h3 class="u-text-h3 u-margin-top-m"><i class="fa fa-copy fa-lg" style="color: #00923f"></i> Piani comunali</h3>
  <div class="u-margin-bottom-l">
  {foreach $objects as $o}
      <h5 class="u-text-h5"><a href="{$o.url_alias|ezurl(no)}">{$o.name}</a></h5>
    {delimiter}<hr />{/delimiter}
  {/foreach}
  </div>
{/if}
{undef $search_reverse_related $objects $objects_count}

