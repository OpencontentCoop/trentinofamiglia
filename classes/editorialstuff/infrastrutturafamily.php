<?php

class InfrastrutturaFamily extends OCEditorialStuffPostDefault
{

    public function tabs()
    {
        $currentUser = eZUser::currentUser();
        $templatePath = $this->getFactory()->getTemplateDirectory();
        $tabs = array(
            array(
                'identifier' => 'content',
                'name' => 'Contenuto',
                'template_uri' => "design:{$templatePath}/parts/content.tpl"
            )
        );

        /*$access = $currentUser->hasAccessTo( 'editorialstuff', 'media' );
        if ( $access['accessWord'] == 'yes' )
        {
            $tabs[] = array(
                'identifier' => 'media',
                'name' => 'Media (Immagini, Video, Audio)',
                'template_uri' => "design:{$templatePath}/parts/media.tpl"
            );
        }*/

        $tabs[] = array(
            'identifier' => 'history',
            'name' => 'Cronologia',
            'template_uri' => "design:{$templatePath}/parts/history.tpl"
        );
        return $tabs;
    }

}
