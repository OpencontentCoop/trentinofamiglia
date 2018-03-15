{def $header_service = openpaini('GeneralSettings','header_service', 1)}

{if $header_service|eq(1)}
  <div class="Header-banner">
    <div class="Header-owner Headroom-hideme">
      <a href="{openpaini('InstanceSettings','UrlAmministrazioneAfferente', '#')}">
        <img style="margin-bottom: -5px" src="{'logo-pat.png'|ezimage(no)}" title="{openpaini('InstanceSettings','NomeAmministrazioneAfferente', 'Provincia autonoma di Trento')}" />
        <span>{openpaini('InstanceSettings','NomeAmministrazioneAfferente', 'Provincia autonoma di Trento')}</span>
      </a>

      {include uri='design:header/languages.tpl'}
      <img class="u-floatRight" style="margin-bottom: -5px" src="{'logo-trentino.png'|ezimage(no)}" title="Trentino" />
    </div>
  </div>
{/if}
