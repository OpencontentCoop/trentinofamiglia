{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{default attribute_base=ContentObjectAttribute html_class='full' placeholder=false()}

<fieldset class="Form-field{if $attribute.has_validation_error} has-error{/if}">
    <legend class="Form-label {if $attribute.is_required}is-required{/if}">
        {first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}
        {if $attribute.is_information_collector} <em class="collector">{'information collector'|i18n( 'design/admin/content/edit_attribute' )}</em>{/if}
        {if $attribute.is_required} ({'richiesto'|i18n('design/ocbootstrap/designitalia')}){/if}
    </legend>

    {if $contentclass_attribute.description}
        <em class="attribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</em>
    {/if}

<!-- {$attribute.content.contentobject_id} {$attribute.content.is_enabled} -->

{if ne( $attribute_base, 'ContentObjectAttribute' )}
    {def $id_base = concat( 'ezcoa-', $attribute_base, '-', $attribute.contentclassattribute_id, '_', $attribute.contentclass_attribute_identifier )}
{else}
    {def $id_base = concat( 'ezcoa-', $attribute.contentclassattribute_id, '_', $attribute.contentclass_attribute_identifier )}
{/if}


    <div class="Grid Grid--withGutter u-padding-bottom-xs">
        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
            <label class="Form-label" for="{$id_base}_login">{'Username'|i18n( 'design/standard/content/datatype' )}</label>
            {* Username. *}
            {if and($attribute.content.has_stored_login, $attribute.content.login|ne(''))}
                <p><input id="{$id_base}_login" autocomplete="off" type="text" name="{$attribute_base}_data_user_login_{$attribute.id}_stored_login" class="Form-input" value="{$attribute.content.login|wash()}" disabled="disabled" /></p>
                <input id="{$id_base}_login_hidden" type="hidden" name="{$attribute_base}_data_user_login_{$attribute.id}" value="{$attribute.content.login|wash()}" />
            {else}
                <input autocomplete="off" readonly="readonly" onfocus="this.removeAttribute('readonly');" id="{$id_base}_login" class="Form-input ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_data_user_login_{$attribute.id}" value="{$attribute.content.login|wash()}" />
            {/if}
        </div>
        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
            <label class="Form-label" for="{$id_base}_email">{'Email'|i18n( 'design/standard/content/datatype' )}</label>
            {* Email. *}
            <p><input autocomplete="off" readonly="readonly" onfocus="this.removeAttribute('readonly');" id="{$id_base}_email" class="Form-input ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_data_user_email_{$attribute.id}" value="{$attribute.content.email|wash( xhtml )}" /></p>
            {* Email #2. Require e-mail confirmation *}
            {if ezini( 'UserSettings', 'RequireConfirmEmail' )|eq( 'true' )}
                <p><input autocomplete="off" readonly="readonly" onfocus="this.removeAttribute('readonly');" placeholder="{'Confirm email'|i18n( 'design/standard/content/datatype' )}" id="{$id_base}_email_confirm" class="Form-input ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_data_user_email_confirm_{$attribute.id}" value="{cond( ezhttp_hasvariable( concat( $attribute_base, '_data_user_email_confirm_', $attribute.id ), 'post' ), ezhttp( concat( $attribute_base, '_data_user_email_confirm_', $attribute.id ), 'post')|wash( xhtml ), $attribute.content.email )}" /></p>
            {/if}

        </div>
    </div>
    <div class="Grid  Grid--withGutter">
        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
            <label class="Form-label" for="{$id_base}_password">{'Password'|i18n( 'design/standard/content/datatype' )}</label>
            {* Password #1. *}
            <p><input autocomplete="off" readonly="readonly" onfocus="this.removeAttribute('readonly');" id="{$id_base}_password" class="Form-input ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="password" name="{$attribute_base}_data_user_password_{$attribute.id}" value="{if $attribute.content.original_password}{$attribute.content.original_password}{else}{if $attribute.content.has_stored_login}_ezpassword{/if}{/if}" /></p>

        </div>
        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
            <label class="Form-label" for="{$id_base}_password_confirm">{'Confirm password'|i18n( 'design/standard/content/datatype' )}</label>
            {* Password #2. *}
            <p><input autocomplete="off" readonly="readonly" onfocus="this.removeAttribute('readonly');" id="{$id_base}_password_confirm" class="Form-input ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="password" name="{$attribute_base}_data_user_password_confirm_{$attribute.id}" value="{if $attribute.content.original_password_confirm}{$attribute.content.original_password_confirm}{else}{if $attribute.content.has_stored_login}_ezpassword{/if}{/if}" /></p>


        </div>
    </div>





</fieldset>

{/default}
