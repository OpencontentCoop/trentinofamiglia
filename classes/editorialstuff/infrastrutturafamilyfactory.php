<?php


class InfrastrutturaFamilyFactory extends OCEditorialStuffPostDefaultFactory
{

    public function instancePost( $data )
    {
        return new InfrastrutturaFamily( $data, $this );
    }

    public function getTemplateDirectory()
    {
        return 'editorialstuff/infrastruttura_family';
    }

}
