<div class="Footer-subBlock">
  <ul class="Footer-socialIcons">
    {if is_set($pagedata.contacts.facebook)}
      <li>
        <a href="{$pagedata.contacts.facebook}">
          <span class="openpa-icon fa-stack">
              <i class="fa fa-circle fa-stack-2x"></i>
              <i class="fa fa-facebook fa-stack-1x u-color-grey-80"
                 aria-hidden="true"></i>
          </span>
          <span class="u-hiddenVisually">Facebook</span>
        </a>
      </li>
    {/if}
    {if is_set($pagedata.contacts.twitter)}
      <li>
        <a href="{$pagedata.contacts.twitter}">
          <span class="openpa-icon fa-stack">
              <i class="fa fa-circle fa-stack-2x"></i>
              <i class="fa fa-twitter fa-stack-1x u-color-grey-80" aria-hidden="true"></i>
          </span>
          <span class="u-hiddenVisually">Twitter</span>
        </a>
      </li>
    {/if}
    {if is_set($pagedata.contacts.linkedin)}
      <li>
        <a href="{$pagedata.contacts.linkedin}">
          <span class="openpa-icon fa-stack">
              <i class="fa fa-circle fa-stack-2x"></i>
              <i class="fa fa-linkedin fa-stack-1x u-color-grey-80"
                 aria-hidden="true"></i>
          </span>
          <span class="u-hiddenVisually">Linkedin</span>
        </a>
      </li>
    {/if}
    {if is_set($pagedata.contacts.instagram)}
      <li>
        <a href="{$pagedata.contacts.instagram}">
          <span class="openpa-icon fa-stack">
              <i class="fa fa-circle fa-stack-2x"></i>
              <i class="fa fa-instagram fa-stack-1x u-color-grey-80"
                 aria-hidden="true"></i>
          </span>
          <span class="u-hiddenVisually">Instagram</span>
        </a>
      </li>
    {/if}
    <li>
      <a href="http://trentinofamiglia.voxmail.it/user/register" target="_blank">
          <span class="openpa-icon fa-stack">
              <i class="fa fa-circle fa-stack-2x"></i>
              <i class="fa fa-envelope fa-stack-1x u-color-grey-80" aria-hidden="true"></i>
          </span>
        <span class="u-hiddenVisually">Newletter</span>
      </a>
    </li>
  </ul>
</div>
