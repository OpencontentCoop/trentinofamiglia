{def $image = false()
     $aspect_ratio = false()}
{if $node|has_attribute('image')}
	{if $node|attribute('image').content[$image_class]}
	  {set $image = $node|attribute('image').content[$image_class].url|ezroot(no)}
	  {set $aspect_ratio = $node|attribute('image').content[$image_class].height|div($node|attribute('image').content[$image_class].width)|mul(100)|sub(10)}
	{/if}
{/if}
{if $image}
  <div class="carousel-image"
       style="background-image:url({$image|ezroot(no, full)}); background-repeat: no-repeat; background-size: 100% auto; background-position: center; width: 100%; padding-bottom: {$aspect_ratio}%;">
  </div>
{/if}
{undef $image}
