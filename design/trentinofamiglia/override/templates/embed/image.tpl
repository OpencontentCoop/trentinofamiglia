
{include uri='design:atoms/image.tpl'
         item=$object
         image_class='large'
         href=cond( is_set( $link_parameters.href ), $link_parameters.href|ezurl, false() )
         css_classes="embed_image"
         image_css_class="media-object tr_all_long_hover"}
