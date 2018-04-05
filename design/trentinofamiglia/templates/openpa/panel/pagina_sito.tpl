<div class="openpa-panel {$node|access_style}">

  {include uri='design:openpa/panel/parts/image.tpl'}

  <div class="openpa-panel-content">
    <h3 class="Card-title">
      <a class="Card-titleLink" href="{$openpa.content_link.full_link}"
         title="{$node.name|wash()}">{$node.name|wash()}</a>
    </h3>

    {if $node|attribute('abstract').has_content}
      <div class="Card-text">
        {$node|abstract()}
      </div>
    {/if}
  </div>

</div>
