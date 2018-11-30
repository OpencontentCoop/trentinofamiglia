{if $post.is_draft}
  <div class="Grid Grid--withGutter">
    <div class="Grid-cell u-sizeFull u-pullRight">
      <a href="#" class="Button u-text-r-xs btn-sm u-floatLeft" id="refreshInfrastrutture">
        <i class="fa fa-refresh" aria-hidden="true"></i> Aggiorna lista infrastrutture
      </a>
      <a href="{'editorialstuff/dashboard/infrastruttura_family'|ezurl(no)}"
         class="Button Button--default u-text-r-xs btn-sm u-floatRight" target="_blank">
        <i class="fa fa-wrench" aria-hidden="true"></i> Gestisci infrastrutture
      </a>
    </div>
  </div>
  <div id="form-infrastrutture" class="u-background-white"></div>
  <script>
    {literal}

    function initFormInfrastrutture () {
      $('#form-infrastrutture').opendataFormEdit({
        object: "{/literal}{$post.object.id}{literal}"
      }, {
        connector: 'infrastrutture-piano-comunale',
        onSuccess: function (data) {
          console.log(data);
          if (data) {
            $('#form-infrastrutture')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--success u-text-h6" id="feedback-infrastrutture">Infrastrutture salvate con successo</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);

          } else {
            $('#form-infrastrutture')
            .prepend('<div style="margin: 0 10px" class="Alert Alert--error u-text-h6" id="feedback-infrastrutture">Si è verificato un errore durante il salvataggio</div>')
            .children(':first')
            .delay(5000)
            .fadeOut(200);
          }
          $('html, body').animate({
            scrollTop: $('#feedback-infrastrutture').offset().top
          }, 1000);
        }
      });
    }


    $(document).ready(function () {
      initFormInfrastrutture();
      $('#refreshInfrastrutture').on('click', function (e) {
        $('#form-infrastrutture').html('');
        initFormInfrastrutture();
      });
    });
    {/literal}
  </script>
{else}
  <div class="content-detail-item withLabel">
    <div class="u-padding-bottom-l">
      <div class="Prose">
        {if $post.object|has_attribute('infrastrutture_family')}
          {foreach $post.object|attribute('infrastrutture_family').content.relation_list as $i}
            {include uri='design:editorialstuff/piano_comunale/parts/infrastrutture/infrastruttura-view.tpl' item=$i.contentobject_id}
            {delimiter}
              <hr/>
            {/delimiter}
          {/foreach}
        {/if}
      </div>
    </div>
  </div>
{/if}



