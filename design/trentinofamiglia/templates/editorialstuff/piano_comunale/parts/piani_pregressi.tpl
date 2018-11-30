{*if $post.is_draft}
  <form id="form-piani-pregressi" class="u-background-white"></form>
  <script>
    {literal}
    $(document).ready(function () {
      $('#form-piani-pregressi').opendataFormEdit({
        object: "{/literal}{$post.object.id}{literal}"
      }, {
        connector: 'piani-pregressi-piano-comunale',
        onSuccess: function(data){
          console.log(data);
          if (data) {
            $('#form-piani-pregressi')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--success u-text-h6" id="feedback-piani-pregressi">Piani pregressi salvati con successo</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);

          } else {
            $('#form-piani-pregressi')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--error u-text-h6" id="feedback-piani-pregressi">Si è verificato un errore durante il salvataggio</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);
          }
          $('html, body').animate({
            scrollTop: $('#feedback-piani-pregressi').offset().top
          }, 1000);
        }
      });
    });
    {/literal}
  </script>
{else}

  {def $attributes = array('piani_pregressi')}
  {foreach $attributes as $attribute}

    <div class="content-detail-item withLabel">
      <div class="u-padding-bottom-l">
        <div class="Prose">
          {attribute_view_gui attribute=$post.object|attribute($attribute)  show_newline=true()}
        </div>
      </div>
    </div>
  {/foreach}

{/if*}

{if $post.object|attribute('piani_pregressi').has_content}
  <div class="Accordion Accordion--default fr-accordion js-fr-accordion" id="accordion-piani-pregressi">
  {foreach $post.object|attribute('piani_pregressi').content.relation_list as $k => $item}
    {def $pp = fetch( 'content', 'object', hash( 'object_id', $item.contentobject_id ) )}
    {def $macroambiti = get_macroambiti( $item.contentobject_id )}

    <h5 class="Accordion-header js-fr-accordion__header fr-accordion__header" id="accordion-header-{$k}">
      <span class="Accordion-link">{$pp.name}</span>
    </h5>
    <div id="accordion-panel-{$k}" class="Accordion-panel fr-accordion__panel js-fr-accordion__panel">
      {foreach $macroambiti as $m}
        {if $m.azioni|count()|gt(0)}
          <p><strong>{$m.name}</strong></p>
          <ul>
            {foreach $m.azioni as $a}
              <li>{$a.name}</li>
            {/foreach}
          </ul>
        {/if}
      {/foreach}
    </div>
    {undef $macroambiti $pp}
  {/foreach}
  </div>
{else}
  <div class="Alert Alert--info u-text-h6">
    Non sono presenti piani pregressi.
  </div>
{/if}
