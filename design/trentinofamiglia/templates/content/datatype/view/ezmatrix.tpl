{default swipe=false()}

{if $swipe|not()}
  {let matrix=$attribute.content}
    <table class="Table Table--withBorder Table--compact u-text-r-xxs" cellspacing="0">
      <thead>
      <tr class="u-border-bottom-xs">
        {section var=ColumnNames loop=$matrix.columns.sequential}
          <th>{$ColumnNames.item.name}</th>
        {/section}
      </tr>
      </thead>
      <tbody>
      {section var=Rows loop=$matrix.rows.sequential sequence=array( bglight, bgdark )}
        <tr class="{$Rows.sequence}">
          {section var=Columns loop=$Rows.item.columns}
            <td>{$Columns.item|wash( xhtml )}</td>
          {/section}
        </tr>
      {/section}
      </tbody>
    </table>
  {/let}
{else}
  {ezcss_require('plugins/table-swipe.css')}
  {def $columns_name = array()}
  {let matrix=$attribute.content}
    <table class="Table Table--withBorder Table--compact u-text-r-xxs swipe" cellspacing="0">
      <thead>
      <tr class="u-border-bottom-xs">
        {section var=ColumnNames loop=$matrix.columns.sequential}
          {set $columns_name = $columns_name|append($ColumnNames.item.name)}
          <th>{$ColumnNames.item.name}</th>
        {/section}
      </tr>
      </thead>
      <tbody>
      {section var=Rows loop=$matrix.rows.sequential}
        <tr class="{$Rows.sequence}">
          {section var=Columns loop=$Rows.item.columns sequence=$columns_name}
            <td data-label="{$Columns.sequence}">{if $Columns.item|ne('')}{$Columns.item|wash( xhtml )}{else}-{/if}</td>
          {/section}
        </tr>
      {/section}
      </tbody>
    </table>
  {/let}

  {undef $columns_name}

{/if}
