{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{default attribute_base=ContentObjectAttribute}
<fieldset class="Form-field Form-field--choose Grid-cell">
    <label class="Form-label Form-label--block"
           for="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}">
        <input class="Form-input"
               id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}"
               name="{$attribute_base}_ocgdpr_data_int_{$attribute.id}"
               {$attribute.data_int|choose( '', 'checked="checked"' )}
               value=""
               type="checkbox">
        <span class="Form-fieldIcon" role="presentation"></span>

        <span style="font-weight: normal">{$attribute.contentclass_attribute.data_text5}</span>
        <br /><a target="_blank" href="{$attribute.contentclass_attribute.data_text4|wash()}">{$attribute.contentclass_attribute.data_text3|wash()}</a>
    </label>

    </label>
</fieldset>
{/default}
