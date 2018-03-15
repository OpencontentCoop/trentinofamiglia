<header class="Header u-hiddenPrint">
    {include uri='design:header/service.tpl'}
    {include uri='design:header/navigation.tpl'}
    <div id="HeaderLine"></div>
    {include uri='design:menu/header_menu.tpl'}
</header>

{if and( $pagedata.is_homepage|not, array( 'edit', 'browse' )|contains( $ui_context )|not() )}
    {include uri='design:header/banner.tpl'}
{/if}
