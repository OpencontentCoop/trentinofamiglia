<div class='Grid u-padding-bottom-xxl'>
  <div class='Grid-cell u-md-size1of3 u-lg-size1of3 u-md-before1of3 u-lg-before1of3'>
    <h1 class='u-textCenter u-text-h2 u-padding-bottom-m'>{"Login"|i18n("design/ocbootstrap/user/login")}</h1>
    
    {if $User:warning.bad_login}
    <div class="alert alert-danger">
    <p><strong>{"Could not login"|i18n("design/ocbootstrap/user/login")}</strong></p>
    <p>{"A valid username and password is required to login."|i18n("design/ocbootstrap/user/login")}</p>
    </div>
    {/if}
    
    {if $site_access.allowed|not}
    <div class="alert alert-danger">
    <p><strong>{"Access not allowed"|i18n("design/ocbootstrap/user/login")}</strong></p>
    <p>{"You are not allowed to access %1."|i18n("design/ocbootstrap/user/login",,array($site_access.name))}</p>
    </div>
    {/if}
    
    <form class="Form Form--spaced validate-form" method="post" action={"/user/login/"|ezurl} name="loginform">
      <div class='Form-field'>
        <div class='controls with-icon-over-input'>          
          <input type="text" autofocus="" name="Login" placeholder="{"Username"|i18n("design/ocbootstrap/user/login",'User name')}" class="form-control" data-rule-required="true" value="{$User:login|wash}">
          <i class='icon-user text-muted'></i>
        </div>
      </div>
      <div class='Form-field'>
        <div class='controls with-icon-over-input'>          
          <input type="password" name="Password" placeholder="{"Password"|i18n("design/ocbootstrap/user/login")}" class="form-control" data-rule-required="true" >
          <i class='icon-lock text-muted'></i>
        </div>
      </div>
      
      <fieldset class="Form-field Form-field--choose Grid-cell">
      <label class="Form-label" for="remember_me">
        <input class="Form-input" id="remember_me" name="Cookie" type="checkbox">
        <span class="Form-fieldIcon" role="presentation"></span> {"Remember me"|i18n("design/ocbootstrap/user/login")}          
      </label>
      </fieldset>
      
       <div class="Form-field Grid-cell u-textCenter">
        <button class='Button Button--info u-text-l' name="LoginButton">{'Login'|i18n('design/ocbootstrap/user/login','Button')}</button>
       </div>
      
      {if and( is_set( $User:post_data ), is_array( $User:post_data ) )}
        {foreach $User:post_data as $key => $postData}
           <input name="Last_{$key|wash}" value="{$postData|wash}" type="hidden" /><br/>
        {/foreach}
      {/if}      
      
    </form>
    <div class='u-textCenter u-padding-all-l u-color-70'>      
      <a href={'/user/forgotpassword'|ezurl}>{'Forgot your password?'|i18n( 'design/ocbootstrap/user/login' )}</a>
    </div>
  </div>
</div>
