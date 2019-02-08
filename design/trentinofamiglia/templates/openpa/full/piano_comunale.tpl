{if $openpa.control_cache.no_cache}
  {set-block scope=root variable=cache_ttl}0{/set-block}
{/if}

{if $openpa.content_tools.editor_tools}
  {include uri=$openpa.content_tools.template}
{/if}

{if $openpa.control_menu.side_menu.root_node}
  {def $tree_menu = tree_menu( hash( 'root_node_id', $openpa.control_menu.side_menu.root_node.node_id, 'user_hash', $openpa.control_menu.side_menu.user_hash, 'scope', 'side_menu' ))
  $show_left = and( $openpa.control_menu.show_side_menu, count( $tree_menu.children )|gt(0) )}
{else}
  {def $show_left = false()}
{/if}

{def $extra_template = 'design:openpa/full/parts/section_left/piano_comunale.tpl'}

<div class="openpa-full class-{$node.class_identifier}">
  <div class="title">
    {include uri='design:openpa/full/parts/node_languages.tpl'}
    <h2>{$node.name|wash()}</h2>
  </div>
  <div class="content-container">

    {include uri='design:openpa/full/parts/piano_comunale/map.tpl'}

    <div class="content">

      <div class="Grid Grid--withGutter">
        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
          {if or($node|has_attribute( 'nome_rappresentante_legale' ), $node|has_attribute( 'email_rappresentante_legale' ))}
            <h4 class="u-text-h4 u-margin-top-xs u-margin-bottom-xs">Referente Marchio Family</h4>
            {def $attributes = array('nome_rappresentante_legale', 'email_rappresentante_legale')}
            {foreach $attributes as $a}
              <p class="Prose">{attribute_view_gui attribute=$node|attribute($a)  show_newline=true()}</p>
            {/foreach}
          {/if}
        </div>
        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
          {if or($node|has_attribute( 'nome_rappresentante_legale' ), $node|has_attribute( 'email_rappresentante_legale' ))}
            <h4 class="u-text-h4">Rappresentante legale</h4>
            {def $attributes = array('nome_rappresentante_legale', 'email_rappresentante_legale')}
            {foreach $attributes as $a}
              <p class="Prose">{attribute_view_gui attribute=$node|attribute($a)  show_newline=true()}</p>
            {/foreach}
          {/if}
        </div>
      </div>


      {if $node.data_map.organizzazione.has_content}

        {def $organization=fetch( 'content', 'node', hash( 'node_id', $node.data_map.organizzazione.content.relation_list[0].node_id ) )}
        {include uri='design:openpa/full/parts/piano_comunale/certifications.tpl'}

      {/if}


      {if $node|has_attribute( 'piani_pregressi' )}
        <div class="Grid Grid--withGutter u-margin-top-l">
          <div class="Grid-cell u-sizeFull">
            <h4 class="u-text-h4 u-margin-top-xs"> Piani pregressi</h4>
            <div class="content-detail">
              {foreach $node.data_map.piani_pregressi.content.relation_list as $i}

                {def $item=fetch( 'content', 'node', hash( 'node_id', $i.node_id ) )}
                <div class="u-padding-top-xs u-padding-bottom-xs" style="border-bottom: 1px solid #ccc;">

                  <a class="u-text-h6" href="{$item.url_alias|ezurl(no)}">{$item.name}</a>
                </div>
                {undef $item}
              {/foreach}
            </div>
          </div>
        </div>
      {/if}

      {if $node|has_attribute( 'infrastrutture_family' )}
        <div class="Grid Grid--withGutter u-margin-top-l">
          <div class="Grid-cell u-sizeFull">
            <h4 class="u-text-h4 u-margin-top-xs"> Infrastrutture family esistenti</h4>
            <div class="content-detail">
              {foreach $node.data_map.infrastrutture_family.content.relation_list as $i}

                {def $item=fetch( 'content', 'node', hash( 'node_id', $i.node_id ) )}
                <div class="u-padding-top-xs u-padding-bottom-xs" style="border-bottom: 1px solid #ccc;">
                  <a class="u-text-h6" href="{$item.url_alias|ezurl(no)}">{$item.name}</a>
                </div>
                {undef $item}
              {/foreach}
            </div>
          </div>
        </div>
      {/if}

      {*include uri=$openpa.content_contacts.template label=''*}

      <div class="content-detail">
        {foreach $openpa.content_detail.attributes as $openpa_attribute}
          <div
            class="content-detail-item{if and( $openpa_attribute.full.show_label, $openpa_attribute.full.collapse_label|not() )} withLabel{/if}">
            {if and( $openpa_attribute.full.show_label, $openpa_attribute.full.collapse_label|not() )}
              <div class="label u-text-h5">
                <strong>{$openpa_attribute.label}</strong>
              </div>
            {/if}
            <div class="value">
              {if and( $openpa_attribute.full.show_label, $openpa_attribute.full.collapse_label )}
                <h4 class="u-text-h4 u-margin-top-xs u-margin-bottom-xs">{$openpa_attribute.label}</h4>
              {/if}
              <div class="Prose attribute-{$openpa_attribute.contentobject_attribute.contentclass_attribute.identifier}">
                {attribute_view_gui attribute=$openpa_attribute.contentobject_attribute href=cond($openpa_attribute.full.show_link|not, 'no-link', '') show_newline=true()}
              </div>
              {if $openpa_attribute.contentobject_attribute.contentclass_attribute.identifier|eq('premessa')}
                <p class="u-padding-all-s u-textCenter">
                  <a class="Button read-more-button" href="#">Leggi tutto</a>
                </p>
              {/if}
            </div>
          </div>
        {/foreach}
      </div>


      {literal}
        <style>
          .attribute-premessa {
            padding: 10px;
            overflow: hidden;
            background-color: #f3f3f3;
          }
        </style>

        <script type="text/javascript">
          var el, elp, up, totalHeight;

          totalHeight = $('.attribute-premessa').outerHeight();

          $('.attribute-premessa').css({"max-height": 250});

          $(document).ready(function(){

            $(".read-more-button").click(function() {

              el = $(this);
              elp = el.parent();
              up = $('.attribute-premessa');
              up
              .css({
                "height": up.height(),
                "max-height": 'unset'
              })
              .animate({
                "height": totalHeight
              });

              // Rimuove il bottone read more
              elp.fadeOut();

              return false;

            });

          });
        </script>
      {/literal}

      {*include uri=$openpa.content_infocollection.template*}

      {*{node_view_gui content_node=$node view=children view_parameters=$view_parameters}*}

      <div class="content-detail">
        <h4 class="u-text-h4 u-margin-top-xs u-margin-bottom-xs">Azioni per macroambito</h4>
        {def $macroambiti = get_macroambiti( $node.contentobject_id )}
        <div class="Accordion Accordion--default fr-accordion js-fr-accordion" id="accordion-piani-pregressi">
          {foreach $macroambiti as $k => $m}
            {if $m.azioni|count()gt(0)}
              {*<h4>{$m.name}</h4>*}
              <h5 class="Accordion-header js-fr-accordion__header fr-accordion__header" id="accordion-header-{$k}" style="font-size: 1.1em !important;">
                <span class="Accordion-link" style="font-size: 1.1em !important;">{$m.name}</span>
              </h5>
              <div id="accordion-panel-{$k}" class="Accordion-panel fr-accordion__panel js-fr-accordion__panel">
                <ul class="u-margin-left-xl u-padding-all-m" style="list-style: disc">
                  {foreach $m.azioni as $a}
                    {def $object=fetch( 'content', 'object', hash( 'object_id', $a.id ) )}
                    <li>
                      <h6 class="u-text-h6">{$object.name}</h6>
                    </li>
                  {/foreach}
                </ul>

              </div>
            {/if}
          {/foreach}
        </div>
      </div>
    </div>

    {*include uri='design:openpa/full/parts/section_left.tpl' extra_template=$extra_template*}
  </div>
  {if $openpa.content_date.show_date}
    {include uri=$openpa.content_date.template}
  {/if}
</div>
