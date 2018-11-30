{if $post.is_draft}
  <form id="form-premessa" class="u-background-white"></form>
  <script>
    {literal}
    $(document).ready(function () {
      $('#form-premessa').opendataFormEdit({
        object: "{/literal}{$post.object.id}{literal}"
      }, {
        connector: 'premessa-piano-comunale',
        onSuccess: function(data){
          console.log(data);
          if (data) {
            $('#form-premessa')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--success u-text-h6" id="feedback-premessa">Premessa salvata con successo</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);

          } else {
            $('#form-premessa')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--error u-text-h6" id="feedback-premessa">Si è verificato un errore durante il salvataggio</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);
          }
          $('html, body').animate({
            scrollTop: $('#feedback-premessa').offset().top
          }, 1000);
        }
      });
    });
    {/literal}
  </script>
{else}

  {def $attributes = array('premessa')}
  {foreach $attributes as $attribute}

    <div class="content-detail-item withLabel">
      {*$post.object|attribute($attribute)|attribute(show)*}

      <div class="u-padding-bottom-l">
        <div class="Prose">
          {attribute_view_gui attribute=$post.object|attribute($attribute)  show_newline=true()}
        </div>
      </div>
    </div>
  {/foreach}

{/if}
