{def $image = false()}

{def $home = fetch('openpa','homepage')}
{set $image = $home.data_map.image}
<div class="Headroom-hideme Header-homebanner u-hidden u-sm-block u-md-block u-lg-block u-textCenter" style="max-height: none !important;">

    <div id="Imageheader" role="presentation">
        <div class="inner"></div>
    </div>

    {if $home|has_attribute('menu_button')}
        {def $banner = $home|attribute('menu_button').content}
        <div class="u-hidden u-sm-block u-md-block u-lg-block u-layout-wide u-layoutCenter u-layout-withGutter u-padding-r-top">
            <div class="Entrypoint-item u-md-size1of2 u-lg-size1of3 u-background-teal-70 u-textCenter">
                <p class="u-padding-bottom-m u-textLeft">
                    <a class="u-textClean u-text-h4 u-color-white"
                       href="{object_handler($banner).content_link.full_link}">{$banner.name|wash()}</a>
                </p>
                {if $banner|has_attribute('image')}
                    {attribute_view_gui attribute=$banner|attribute('image') image_class=large image_css_classes='u-sizeFull' href=object_handler($banner).content_link.full_link}
                {/if}
                {if $banner|has_attribute('abstract')}
                    <div class="u-color-white u-lineHeight-xl u-textLeft u-padding-top-m">
                        {attribute_view_gui attribute=$banner|attribute('abstract')}
                    </div>
                {/if}
            </div>
        </div>
        {undef $banner}
    {/if}
</div>
{undef $home}
{if $image}
    {literal}
        <style>
            .Headroom-hideme.Header-homebanner #Imageheader {
                background-image: url({/literal}{$image.content['agid_topbanner'].url|ezroot(no)}{literal});
            }

            @media only screen and (min-width: 768px) and (max-width: 992px){
                .Headroom-hideme.Header-homebanner #Imageheader {
                    background-image: url({/literal}{$image.content['agid_topbanner_sm'].url|ezroot(no)}{literal});
                }
            }

            @media only screen and (min-width: 992px) and (max-width: 1440px){
                .Headroom-hideme.Header-homebanner #Imageheader {
                    background-image: url({/literal}{$image.content['agid_topbanner_md'].url|ezroot(no)}{literal});
                }
            }

            @media only screen and (min-width: 1440px){
                .Headroom-hideme.Header-homebanner #Imageheader {
                    background-image: url({/literal}{$image.content['agid_topbanner_lg'].url|ezroot(no)}{literal});
                }
            }
        </style>
    {/literal}
{/if}
{undef $image}
