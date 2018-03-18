{*
	OGGETTI INVERSAMENTE CORRELATI
	node	nodo a cui si riferisce
	title	titolo del blocco
	classe	classe su cui filtrare la ricerca
	attrib	attribute su cui filtrare la ricerca
	href	se =nolink non fa vedere il link all'oggetto inversamente correlato


*}

{if $classe|eq("struttura")}
    {def $sortby = array( 'class_identifier', true() )}
{else}
    {def $sortby = array( 'name', true() )}
{/if}


{debug-log var=concat($classe,"/",$attrib) msg='classe/attributo' }

{*def $stringa_ricerca = concat($classe,"/",$attrib)
     $objects = fetch( 'content', 'reverse_related_objects', hash( 'object_id',$node.object.id, 'attribute_identifier', $stringa_ricerca, 'sort_by',  $sortby ) )
     $objects_count = $objects|count()
     $my_node = ""*}
{def $search_reverse_related = fetch('ezfind','search', hash('limit',100,'filter',array(concat($classe,"/",$attrib,"/id:",$node.object.id))))
     $objects = $search_reverse_related.SearchResult
     $objects_count = $search_reverse_related.SearchCount
     $my_node = ""}

{def $style='col-odd'}
{if $objects_count|gt(0)}

    {if $objects_count|lt(100)}
        <div class="openpa-widget {if $objects|count()|not()} nocontent{/if}">

            <h3 class="openpa-widget-title">{$title}</h3>

            <div class="openpa-widget-content content-view-children">

                {foreach $objects as $object}
                    {if $object.can_read}
                        {if $classe|eq('ruolo')}
                            <div class="openpa-line media">
                                <h3 class="media-heading">{$object.name}</h3>
                                <ul class="media-details">
                                {if $object.data_map.descrizione_ruolo_speciale.has_content}
                                    <li>{attribute_view_gui attribute=$object.data_map.descrizione_ruolo_speciale}</li>
                                {else}
                                    <li>
                                        {if $object.name|contains('Direttore Generale')}
                                        {elseif $object.name|contains('Segretario')}
                                        {elseif $object.name|contains('Dirigente con Incarico Speciale')}
                                            {attribute_view_gui  href=nolink attribute=$object.data_map.struttura_di_riferimento}
                                        {elseif $object.name|contains('Capoufficio')}
                                            {attribute_view_gui  href=nolink attribute=$object.data_map.struttura_di_riferimento}
                                        {elseif $object.name|contains('Responsabile del polo sociale')}
                                            {attribute_view_gui href=nolink attribute=$object.data_map.struttura_di_riferimento}
                                        {elseif $object.name|contains('Segretario di circoscrizione')}
                                            {attribute_view_gui  href=nolink attribute=$object.data_map.struttura_di_riferimento}
                                        {elseif $object.name|contains('Funzionario di sezione')}
                                            {attribute_view_gui href=nolink attribute=$object.data_map.struttura_di_riferimento}
                                        {elseif $object.name|contains("Dirigente dell'area")}
                                            "{attribute_view_gui  href=nolink attribute=$object.data_map.struttura_di_riferimento}"
                                        {elseif $object.name|contains('Dirigente del servizio')}
                                            "{attribute_view_gui href=nolink attribute=$object.data_map.struttura_di_riferimento}"
                                        {elseif $object.data_map.struttura_di_riferimento.has_content}
                                            {attribute_view_gui  href=nolink attribute=$object.data_map.struttura_di_riferimento}
                                        {/if}
                                    </li>
                                {/if}
                                </ul>
                            </div>
                        {elseif $classe|eq('struttura')}
                            {set $my_node=fetch( 'content', 'node', hash( 'node_id', $object.data_map.tipo_struttura.content.relation_list[0].node_id) )}
                                <div class="openpa-line media">
                                    <h3 class="media-heading">
                                        <a href={$object.url_alias|ezurl()}>{$my_node.name|wash()} "{$object.name}"</a>
                                    </h3>
                                </div>
                        {else}
                            {if is_set($href)}
                                {if $href|eq("nolink")}
                                    <div class="openpa-line media">
                                        <h3 class="media-heading">{$object.name}</h3>
                                    </div>
                                {/if}
                            {else}
                                {node_view_gui content_node=$object view='line'}
                            {/if}
                        {/if}
                    {/if}
                {/foreach}
            </div>
        </div>
    {/if}

{/if}


