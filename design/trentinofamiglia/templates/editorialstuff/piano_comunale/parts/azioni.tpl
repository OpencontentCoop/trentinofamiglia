{if $post.is_draft}
  <div class="Grid-cell u-sizeFull">
    <div id="azioni-tabs">
      <ul class="nav nav-tabs">
        {foreach $post.macroambiti as $index => $m}
          <li role="presentation" class="nav-tab{if $index|eq(0)} active{/if}">
            <a href="#{$m.id}" aria-controls="{$m.id}" data-toggle="tab" class="u-text-xxs">{$m.name}</a>
          </li>
        {/foreach}
      </ul>

      <div class="tab-content">
        {foreach $post.macroambiti as $index => $m}
          <div class="tab-pane{if $index|eq(0)} active{/if}" id="{$m.id}">
            {include uri='design:editorialstuff/piano_comunale/parts/azioni/azione-edit.tpl' macroambito=$m}
          </div>
        {/foreach}
      </div>
    </div>
  </div>
{else}
  <div class="Grid-cell u-sizeFull">
    <div id="azioni-tabs">
      <ul class="nav nav-tabs">
        {def $count = 0}
        {foreach $post.macroambiti as $index => $m}
          {if $m.azioni|count()gt(0)}
            <li role="presentation" class="nav-tab{if $count|eq(0)} active{/if}">
              <a href="#{$m.id}" aria-controls="{$m.id}" data-toggle="tab" class="u-text-xxs">{$m.name}</a>
            </li>
            {set $count = $count|sum(1)}
          {/if}
        {/foreach}
      </ul>

      <div class="tab-content">
        {set $count = 0}
        {foreach $post.macroambiti as $index => $m}

          {if $m.azioni|count()gt(0)}
            <div class="tab-pane{if $count|eq(0)} active{/if}" id="{$m.id}">
              {foreach $m.azioni as $a}
                {include uri='design:editorialstuff/piano_comunale/parts/azioni/azione-view.tpl' azione=$a}
                {delimiter}
                  <hr/>
                {/delimiter}
              {/foreach}
              {set $count = $count|sum(1)}
            </div>
          {/if}
        {/foreach}
        {undef $count}
      </div>
    </div>
  </div>
{/if}





