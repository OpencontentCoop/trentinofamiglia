{literal}
  <style>
    .politiche {
      background-color: #fff !important;
      width: 100%;
    }
    .politiche .openpa-panel-image .bg-img {
      background-image:url({/literal}{'politiche-bg.jpg'|ezimage(no)}{literal});
      background-repeat: no-repeat;
      background-size: 100% auto;
      background-position: center;
      width: 98%;
      padding-bottom: 50%;
      margin: 0.3% 1%;
    }

    .politiche:hover .openpa-panel-image .bg-img {
      background-image:url({/literal}{'politiche-bg-hover.jpg'|ezimage(no)}{literal});
    }
  </style>
{/literal}

{def $openpa = object_handler($node)}

<div class="openpa-panel politiche {$node|access_style}">

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
