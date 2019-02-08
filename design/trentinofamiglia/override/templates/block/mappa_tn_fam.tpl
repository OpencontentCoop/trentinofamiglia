{ezscript_require(array(    
  'leaflet/leaflet.0.7.2.js',
  'leaflet/leaflet.markercluster.js',
  'leaflet/Leaflet.MakiMarkers.js',
  'bootstrap/transition.js',
  'bootstrap/collapse.js',
  'jquery.opendataTools.js',
  'jquery.opendataSearchView.js',  
  'tnfam_map.js',
  'jsrender.js'
))}
{ezcss_require(array(
  'tnfam_map.css',
  'plugins/leaflet/leaflet.css',
  'plugins/leaflet/map.css',
  'MarkerCluster.css',
  'MarkerCluster.Default.css'
))}    

{set_defaults(hash(
  'show_title', true(),
  'height', '600',
))}

{set $height = $height|fix_dimension()}

<div class="openpa-widget {$block.view}">
    {if and( $show_title, $block.name|ne('') )}
        <h3 class="openpa-widget-title"><span>{$block.name|wash()}</span></h3>
    {/if}
    <div class="openpa-widget-content facet-search" id="tnfam_map-{$block.id}">
        
        <a href="#" class="Button Button--default btn-block open-xs-filter u-sm-hidden u-md-hidden u-lg-hidden"><i class="fa fa-filter"></i> Filtri</a>
        
        <div class="Grid Grid--withGutter filters-wrapper hidden-xs"></div>

        <div class="Grid Grid--withGutter current-filters-wrapper">
            <div class="Grid-cell">
                <ul class="list-inline current-filter"></ul>
            </div>
        </div>
        <div class="current-result"><div class="map" style="height: {$height}px"></div></div>
            
    </div>
</div>
{unset_defaults(array('show_title'))}

{run-once}
{literal}
<script id="tpl-filter" type="text/x-jsrender">
<div class="Grid-cell u-sizeFull {/literal}{if $items_per_row|gt(1)}u-sm-size1of3 u-md-size1of3 u-lg-size1of3{/if}{literal} filter-wrapper">                    
    <h4 class="u-text-h4 widget_title">
        <a data-toggle="collapse" href="#{{:id}}" aria-expanded="false" aria-controls="{{:id}}">
            <i class="fa fa-plus"></i>
            <span>{{:label}}</span>                          
        </a>
        <ul class="list-inline current-xs-filters"></ul>                
    </h4>
    <div class="widget collapse" id="{{:id}}">                    
        <ul class="Linklist Linklist--padded" data-filter="{{:id}}">
          <li class="remove-filter"><a href="#" data-value="all">Rimuovi filtri</a></li>
        </ul>
    </div>
</div>
</script>

<script id="tpl-close-xs-filter" type="text/x-jsrender">
    <a href="#{{:id}}" class="Button Button--default btn-block close-xs-filter" style="display: none;"><i class="fa fa-times"></i> Chiudi</a>
</script>

<script id="tpl-spinner" type="text/x-jsrender">
<div class="Grid-cell spinner u-textCenter" style="position: absolute;z-index: 1001;{/literal}padding-top: {$height|div(2)}px; height: {$height}px; {literal} width: 100%;background: #333;opacity: 0.5;">
    <i class="fa fa-circle-o-notch fa-spin fa-3x fa-fw" style="color:#fff"></i>
    <span class="sr-only">Loading...</span>
</div>
</script>

<script id="tpl-empty" type="text/x-jsrender">
<div class="Grid-cell u-textCenter">
    <i class="fa fa-times"></i> Nessun risultato trovato
</div>
</script>

<script id="tpl-item" type="text/x-jsrender">
<div class="Grid-cell u-sizeFull u-sm-size1of2 u-md-size1of2 u-lg-size1of3 u-margin-bottom-l">    
    <div class="openpa-panel">      
        <div class="openpa-panel-image">
            <a href="{{:~settings('accessPath')}}/content/view/full/{{:metadata.mainNodeId}}" aria-hidden="true" tabindex="-1">
              <img src="{{:~firstImageUrl(~i18n(data,'image'))}}" class="u-sizeFull" role="presentation" />
            </a>
      </div>      
      <div class="openpa-panel-content">        
        <h3 class="Card-title">
          <a class="Card-titleLink" href="{{:~settings('accessPath')}}/content/view/full/{{:metadata.mainNodeId}}" title="{{:~i18n(data,'name')}}">{{:~i18n(data,'name')}}</a>
        </h3>
        {{if ~i18n(data,'abstract')}}
        <div class="Card-text">{{:~i18n(data,'abstract')}}</div>
        {{/if}}
      </div>
      <a class="readmore" href="{{:~settings('accessPath')}}/content/view/full/{{:metadata.mainNodeId}}" title="{{:~i18n(data,'name')}}">Dettaglio</a>        
    </div>
</div>
</script>

<script id="tpl-load-other" type="text/x-jsrender">
<div class="Grid-cell u-textCenter">
    <a href="#" class="Button Button--default u-margin-all-xxl">Carica altri risultati</a>
</div>
</script>
{/literal}
{/run-once}

<script>{literal}
$(document).ready(function(){
    $.opendataTools.settings('accessPath', "{/literal}{''|ezurl(no,full)}{literal}");

    $('{/literal}#tnfam_map-{$block.id}{literal}').tnFamMap({
        'endpoint': {/literal}'{"/openpa/data/tn_fam_map_markers"|ezurl(no)}{literal}',
        'facetDefinitions': [{/literal}{$block.custom_attributes.facets|trim()}{literal}],
        'block': "{/literal}{$block.id}{literal}",
        'cssClasses': {
            'item': 'Linklist-link',
            'itemActive': 'Linklist-link--lev1',
            'listWrapper': 'Linklist Linklist--padded'
        },
        'viewHelpers': $.extend({}, $.opendataTools.helpers, {
            'firstImageUrl': function (image) {                        
                if (image.length > 0 && typeof image[0].id == 'number') {
                    return $.opendataTools.settings('accessPath') + '/image/view/' + image[0].id + '/agid_panel';
                }
                return image.url;
            }
        })
    });   
});
{/literal}
</script>

