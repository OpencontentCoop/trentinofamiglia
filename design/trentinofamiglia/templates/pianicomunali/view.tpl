<div class="content">
  <div style="padding: 50px 0; margin-top: 100px; text-align: center">
    <img src="{'logo.png'|ezimage(no)}" />
    <h1 style="margin-top: 100px;">{$piano.name}</h1>
  </div>


  <h3>Contesto</h3>

  {def $attributes = array(
  'anno', 'ruolo_rappresentante_legale', 'nome_rappresentante_legale', 'email_rappresentante_legale',
  'telefono_rappresentante_legale', 'nome_referente_tecnico', 'email_referente_tecnico', 'telefono_referente_tecnico')}

  <table style="width: 100%">
    {foreach $attributes as $attribute sequence array('#fff', '#f2f2f2') as $bgcolor}
      <tr style="background-color: {$bgcolor}">
        <td class="name">
          {$piano.data_map[$attribute].contentclass_attribute.name}
        </td>
        <td class="value">
          {attribute_view_gui attribute=$piano.data_map[$attribute]  show_newline=true()}
        </td>
      </tr>
    {/foreach}
  </table>


  {* certificazioni *}
  <h3>Certificazioni</h3>
  {include uri='design:pianicomunali/parts/certificazioni.tpl'}

  {* Piani pregressi *}
  <h3>Piani pregressi</h3>
  {if $piano|attribute('piani_pregressi').has_content}
    <ul>
      {foreach $piano|attribute('piani_pregressi').content.relation_list as $k => $item sequence array('#fff', '#f2f2f2') as $bgcolor}
        {def $pp = fetch( 'content', 'object', hash( 'object_id', $item.contentobject_id ) )}
        {def $macroambiti = get_macroambiti( $item.contentobject_id )}
        <li>
          <h4>{$pp.name}</h4>
          {foreach $macroambiti as $m}
            {if $m.azioni|count()gt(0)}
              <p><strong>{$m.name}</strong></p>
              <ul>
                {foreach $m.azioni as $a}
                  <li>{$a.name}</li>
                {/foreach}
              </ul>
            {/if}
          {/foreach}
        </li>
        {undef $macroambiti $pp}
      {/foreach}
    </ul>
  {/if}

  {* Premessa *}
  <h3>Premessa</h3>
  {attribute_view_gui attribute=$piano.data_map['premessa']  show_newline=true()}

  {* Infrastrutture *}
  <h3>Infrastrutture Family</h3>
  {if $piano|has_attribute('infrastrutture_family')}
    {foreach $piano|attribute('infrastrutture_family').content.relation_list as $i}
      {include uri='design:pianicomunali/parts/infrastruttura.tpl' item=$i.contentobject_id}
    {/foreach}
  {/if}

  {* Azioni *}
  <h3>Azioni</h3>
  {def $macroambiti = get_macroambiti( $piano.id )}
  {foreach $macroambiti as $m}
    {if $m.azioni|count()gt(0)}
      <h4>{$m.name}</h4>
      {foreach $m.azioni as $a}
        {include uri='design:pianicomunali/parts/azione.tpl' item=$a}
      {/foreach}
    {/if}
  {/foreach}

  {*<h3>Delibera</h3>

  {def $attributes = array(
  'numero_delibera', 'data_delibera')}

  <table style="width: 100%">
    {foreach $attributes as $attribute sequence array('#fff', '#f2f2f2') as $bgcolor}
      <tr style="background-color: {$bgcolor}">
        <td class="name">
          {$piano.data_map[$attribute].contentclass_attribute.name}
        </td>
        <td class="value">
          {attribute_view_gui attribute=$piano.data_map[$attribute]  show_newline=true()}
        </td>
      </tr>
    {/foreach}
  </table>*}

</div>
