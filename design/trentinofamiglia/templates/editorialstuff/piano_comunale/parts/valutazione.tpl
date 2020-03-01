{if $post.is_published}
  <div class="Grid-cell u-sizeFull">
    <form id="form-valutazione-globale" class="u-background-white"></form>
    <script>
      {literal}
      $(document).ready(function () {

        $('#form-valutazione-globale').opendataFormEdit({
          object: "{/literal}{$post.object.id}{literal}"
        }, {
          connector: 'edit-valutazione-globale-piano-comunale',
          onSuccess: function (data) {
            console.log(data);
            if (data) {
              $('#form-valutazione-globale')
                      .prepend('<div style="margin: 0 10px" class="Alert Alert--success u-text-h6" id="feedback-valutazione-globale">Delibera salvata con successo</div>')
                      .children(':first')
                      .delay(5000)
                      .fadeOut(200);

            } else {
              $('#form-valutazione-globale')
                      .prepend('<div style="margin: 0 10px" class="Alert Alert--error u-text-h6" id="feedback-valutazione-globale">Si è verificato un errore durante il salvataggio</div>')
                      .children(':first')
                      .delay(5000)
                      .fadeOut(200);
            }
            $('html, body').animate({
              scrollTop: $('#feedback-valutazione-globale').offset().top
            }, 1000);
          }
        });
      });
      {/literal}
    </script>
  </div>
  <div class="Grid-cell u-sizeFull">
    <div id="dashboard-tabs">
      <ul class="nav nav-tabs">
        {def $count = 0}
        {foreach $post.macroambiti as $index => $m}
          {if $m.azioni|count()gt(0)}
            <li role="presentation" class="nav-tab{if $count|eq(0)} active{/if}">
              <a href="#valutazione_{$m.id}" aria-controls="valutazione_{$m.id}" data-toggle="tab" class="u-text-xs">{$m.name}</a>
            </li>
            {set $count = $count|sum(1)}
          {/if}
        {/foreach}
      </ul>

      <div class="tab-content">
        {set $count = 0}
        {foreach $post.macroambiti as $index => $m}
          {if $m.azioni|count()gt(0)}
            <div class="tab-pane{if $count|eq(0)} active{/if}" id="valutazione_{$m.id}">
              {foreach $m.azioni as $a}
                {include uri='design:editorialstuff/piano_comunale/parts/valutazioni/azione.tpl' azione=$a}
              {/foreach}
            </div>
            {set $count = $count|sum(1)}
          {/if}
        {/foreach}
        {undef $count}
      </div>
    </div>
  </div>
{else}
  <div class="Alert Alert--warning u-text-h6">
    Per inserire le valutazioni il piano comunale deve essere approvato.
  </div>
{/if}
