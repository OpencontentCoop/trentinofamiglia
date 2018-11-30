{if $post.is_draft}
  <form id="form-contesto" class="u-background-white"></form>
  <script>
    {literal}
    $(document).ready(function () {

      $('#form-contesto').opendataFormEdit({
        object: "{/literal}{$post.object.id}{literal}"
      }, {
        connector: 'contesto-piano-comunale',
        onSuccess: function (data) {
          console.log(data);
          if (data) {
            $('#form-contesto')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--success u-text-h6" id="feedback-contesto">Contesto salvato con successo</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);

          } else {
            $('#form-contesto')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--error u-text-h6" id="feedback-contesto">Si è verificato un errore durante il salvataggio</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);
          }
          $('html, body').animate({
            scrollTop: $('#feedback-contesto').offset().top
          }, 1000);
        }
      });
    });
    {/literal}
  </script>
{else}
  {def $attributes = array(
    'titolo', 'anno', 'ruolo_rappresentante_legale', 'nome_rappresentante_legale', 'email_rappresentante_legale',
    'telefono_rappresentante_legale', 'nome_referente_tecnico', 'indirizzo_referente_tecnico',
    'email_referente_tecnico', 'telefono_referente_tecnico'
  )}
  {foreach $attributes as $attribute}

    <div class="content-detail-item withLabel">
      <div class="u-padding-bottom-l">
        <div class="u-text-h6"><strong>{$post.object|attribute($attribute).contentclass_attribute.name}</strong></div>
        <div class="Prose">
          {attribute_view_gui attribute=$post.object|attribute($attribute)  show_newline=true()}
        </div>
      </div>
    </div>
  {/foreach}

{/if}
