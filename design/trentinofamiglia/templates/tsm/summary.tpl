<div class="openpa-full">
    <div class="title">        
        <h2>Trentino School of Management</h2>
    </div>
    <div class="content-container">
        <div class="content">
            <article class="content-main-abstract">
                <ul>
                {foreach $modules as $identifier => $name}
                <li><a href="{concat('tnfam/tsm/', $identifier)|ezurl(no)}">{$name|wash}</a></li>
                {/foreach}
                </ul>
            </article>
            
        </div>
    </div>
</div>