{if $post.object.data_map.organizzazione.has_content}
  {def $node=fetch( 'content', 'node', hash( 'node_id', $post.object.data_map.organizzazione.content.relation_list[0].node_id ) )}
  {include uri='design:openpa/full/parts/organizations/certifications.tpl' show_title=false()}
{else}
  <div style="margin: 0 10px" class="Alert Alert--warning u-text-h6" id="no-organizations">Non ci sono orgnanizzazioni collegate</div>
  <div id="form-certificazioni" class="u-background-white"></div>

  <script>
    {literal}
    $(document).ready(function () {
      $('#form-certificazioni').opendataFormEdit({
        object: "{/literal}{$post.object.id}{literal}"
      }, {
        connector: 'certificazioni-piano-comunale',
        onSuccess: function(data){
          console.log(data);
          if (data) {
            $('#form-certificazioni')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--success u-text-h6" id="feedback-certificazioni">Organizzazione salvata con successo</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);

            $('#no-organizations').remove();

          } else {
            $('#form-certificazioni')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--error u-text-h6" id="feedback-certificazioni">Si è verificato un errore durante il salvataggio</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);
          }
          $('html, body').animate({
            scrollTop: $('#feedback-certificazioni').offset().top
          }, 1000);
        }
      });
    });
    {/literal}
  </script>
{/if}
