{* File - List embed view *}
<div class="content-view-embed">
    <div class="class-file">
        {if $object.data_map.file.has_content}
            {def $file = $object.data_map.file}
            {if $object.can_read|not()}
                {$object.name|wash}<br />
                {if is_set($from_attribute)}
                    {if or( $from_attribute.object.data_map.oggetto.content|contains('revocata'), $from_attribute.object.data_map.oggetto.content|contains('annullata') )}
                        <em>Il  testo del provvedimento è stato rimosso in quanto l'atto è stato revocato o annullato.</em>
                    {elseif ezini_hasvariable( 'OscuraAttiSettings', 'TestoStandard', 'oscuraatti.ini' )}
                        <em>{ezini( 'OscuraAttiSettings', 'TestoStandard', 'oscuraatti.ini' )}</em>
                    {/if}
                {elseif ezini_hasvariable( 'OscuraAttiSettings', 'TestoStandard', 'oscuraatti.ini' )}
                    <em>{ezini( 'OscuraAttiSettings', 'TestoStandard', 'oscuraatti.ini' )}</em>
                {/if}
            {else}
                <div class="content-body attribute-{$file.content.mime_type_part|explode('.')|implode('-')}">
                    <a href={concat("content/download/", $file.contentobject_id, "/", $file.id, "/file/", $file.content.original_filename)|ezurl}>
                      <i class="fa fa-file-{$file.content.mime_type_part|explode('.')|implode('-')}-o mime-file mime-{$file.content.mime_type_part|explode('.')|implode('-')}"></i> {$object.name|wash}{*$file.content.original_filename|wash("xhtml")*}
                    </a> <span class="u-text-xxs">{$file.content.filesize|si(byte)}</span>
                </div>
            {/if}
            {undef $file}
        {else}
            <div class="content-body">
                <a href={$object.main_node.url_alias|ezurl}>{$object.name|wash}</a>
            </div>
        {/if}
    </div>
</div>
