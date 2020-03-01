{if $post.is_pending}
  <div class="Grid Grid--withGutter">
    <div class="Grid-cell u-sizeFull u-pullRight">
      <a href="{concat('layout/set/pdf/pianicomunali/view/', $post.object.id)|ezurl(no)}"
         class="Button Button--default u-text-r-xs btn-sm u-floatRight" target="_blank">
        <i class="fa fa-download" aria-hidden="true"></i> Scarica il piano in pdf
      </a>
    </div>
  </div>
  <form id="form-delibera" class="u-background-white"></form>
  <script>
    {literal}
    $(document).ready(function () {

      $('#form-delibera').opendataFormEdit({
        object: "{/literal}{$post.object.id}{literal}"
      }, {
        connector: 'delibera-piano-comunale',
        onSuccess: function (data) {
          console.log(data);
          if (data) {
            $('#form-delibera')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--success u-text-h6" id="feedback-delibera">Delibera salvata con successo</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);

          } else {
            $('#form-delibera')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--error u-text-h6" id="feedback-delibera">Si è verificato un errore durante il salvataggio</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);
          }
          $('html, body').animate({
            scrollTop: $('#feedback-delibera').offset().top
          }, 1000);
        }
      });
    });
    {/literal}
  </script>
{elseif $post.is_published}
  <div class="Grid Grid--withGutter">
    <div class="Grid-cell u-sizeFull u-pullRight">
      <a href="{concat('layout/set/pdf/pianicomunali/view/', $post.object.id)|ezurl(no)}"
         class="Button Button--default u-text-r-xs btn-sm u-floatRight" target="_blank">
        <i class="fa fa-download" aria-hidden="true"></i> Scarica il piano in pdf
      </a>
    </div>
  </div>

  {def $attributes = array('numero_delibera', 'data_delibera', 'piano_pdf', 'delibera_pdf')}

  {foreach $attributes as $attribute}
    <div class="content-detail-item withLabel">
      <div class="u-padding-bottom-l">
        <div class="u-text-h6"><strong>{$post.object.data_map[$attribute].contentclass_attribute.name}</strong></div>
        <div class="Prose">
          {attribute_view_gui attribute=$post.object.data_map[$attribute]  show_newline=true()}
        </div>
      </div>
    </div>
  {/foreach}
{else}
  <div class="Alert Alert--warning u-text-h6">
    I dati sulla delibera posso essere riempiti solo in fase di approvazione.
  </div>
{/if}



