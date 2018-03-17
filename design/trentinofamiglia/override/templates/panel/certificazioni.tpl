{literal}
  <style>
    .certificazioni {
      background-color: #fff !important;
      width: 100%;
    }
    .certificazioni .openpa-panel-image .bg-img {
      background-image:url({/literal}{'certificazioni-bg.jpg'|ezimage(no)}{literal});
      background-repeat: no-repeat;
      background-size: 100% auto;
      background-position: center;
      width: 98%;
      padding-bottom: 50%;
      margin: 0.3% 1%;
    }

    .certificazioni:hover .openpa-panel-image .bg-img {
      background-image:url({/literal}{'certificazioni-bg-hover.jpg'|ezimage(no)}{literal});
    }
  </style>
{/literal}



<div class="openpa-panel certificazioni {$node|access_style}">

  <div class="openpa-panel-image">
    <a href="{$openpa.content_link.full_link}" aria-hidden="true" role="presentation" tabindex="-1">
      <div class="bg-img">

      </div>
    </a>
  </div>

  <div class="openpa-panel-content">
    <h3 class="Card-title">
      <a class="Card-titleLink" href="{$openpa.content_link.full_link}"
         title="{$node.name|wash()}">{$node.name|wash()}</a>
    </h3>

    <div class="Card-text">
      <p>{$node|abstract()|oc_shorten(150)}</p>
    </div>
  </div>

</div>
