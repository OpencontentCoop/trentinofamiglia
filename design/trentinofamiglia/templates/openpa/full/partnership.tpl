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

<div class="openpa-full class-{$node.class_identifier}">
  <div class="title">
    {include uri='design:openpa/full/parts/node_languages.tpl'}
    <h2>{$node.name|wash()}</h2>
  </div>
  <div class="content-container">
    <div class="content{if or( $show_left, $openpa.control_menu.show_extra_menu )} withExtra{/if}">

      {include uri=$openpa.content_main.template}

      {include uri=$openpa.content_contacts.template}

      {include uri=$openpa.content_detail.template}

      {include uri=$openpa.content_infocollection.template}

      {*(raw[subattr_partner_privati_aderenti___lat____s] = '*' and raw[subattr_partner_privati_aderenti___lon____s] = '*') and classes [partnership] facets [stato_certificazione|alpha|100,sperimentazione|alpha|100]*}

      {*{include uri='design:parts/mappa_tn_fam.tpl'
      title="Organizzazioni private aderenti"
      id="partner-privati"
      query= concat("(raw[subattr_partner_privati_aderenti___lat____s] = '*' and raw[subattr_partner_privati_aderenti___lon____s] = '*') and classes [partnership] and id in [", $node.contentobject_id, "]")
      facets=""
      attribute="partner_privati_aderenti"
      }*}

      {*{include uri='design:parts/mappa_tn_fam.tpl'
      title="Organizzazioni pubbliche aderenti"
      id="partner-pubblici"
      query= concat("(raw[subattr_partner_pubblici___lat____s] = '*' and raw[subattr_partner_pubblici___lon____s] = '*') and classes [partnership]")
      facets=""
      attribute="partner_pubblici"
      }*}

      {include uri='design:parts/mappa_tn_fam.tpl'
      title="Organizzazioni aderenti"
      id="partner-pubblici"
      query= concat("((raw[subattr_partner_pubblici___lat____s] = '*' and raw[subattr_partner_pubblici___lon____s] = '*') or (raw[subattr_partner_privati_aderenti___lat____s] = '*' and raw[subattr_partner_privati_aderenti___lon____s] = '*')) and classes [partnership]")
      facets=""
      attribute="partner_privati_aderenti,partner_pubblici"
      }

      {node_view_gui content_node=$node view=children view_parameters=$view_parameters}

    </div>
    {def $extra_template = 'design:openpa/full/parts/section_left/empty.tpl'}
    {include uri='design:openpa/full/parts/section_left.tpl' extra_template=$extra_template}
  </div>
  {if $openpa.content_date.show_date}
    {include uri=$openpa.content_date.template}
  {/if}
</div>



