<?php


class PianoComunaleFactory extends OCEditorialStuffPostDefaultFactory
{

    public function instancePost( $data )
    {
        return new PianoComunale( $data, $this );
    }

    public function getTemplateDirectory()
    {
        return 'editorialstuff/piano_comunale';
    }


}
