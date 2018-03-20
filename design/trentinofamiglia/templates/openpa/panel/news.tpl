<div class="openpa-panel {$node|access_style}">
    {include uri='design:openpa/panel/parts/image.tpl'}

    <div class="openpa-panel-content">
        {if $node|has_attribute('data')}
            <p>{$node.data_map.data.content.timestamp|l10n(shortdate)}</p>
        {/if}                
        <h3 class="Card-title">
            <a class="Card-titleLink" href="{$openpa.content_link.full_link}"
               title="{$node.name|wash()}">{$node.name|wash()}</a>
        </h3>
        {if $node|has_attribute('politiche_familiari')}
            <p class="news-tags">{attribute_view_gui attribute=$node|attribute('politiche_familiari')}</p>
        {/if}
    </div>    

</div>
