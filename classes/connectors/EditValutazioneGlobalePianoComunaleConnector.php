<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\TagRepository;

class EditValutazioneGlobalePianoComunaleConnector extends AbstractBaseConnector
{
  protected $tagRepository;

  private $object;
  private $class;
  private $anni;

  public function __construct($identifier)
  {
    parent::__construct($identifier);
    if (isset($_GET['object'])) {
      $this->object = eZContentObject::fetch((int)$_GET['object']);
    }
    if (!$this->object instanceof eZContentObject) {
      throw new Exception("Object non selezionato", 1);
    }

    $this->class = eZContentClass::fetchByIdentifier($this->object->attribute('class_identifier'));

  }

  protected function getData()
  {
    $dataMap = $this->object->dataMap();

    $data = array(
      'valutazione_globale' => $dataMap['valutazione_globale']->toString()
    );
    return $data;
  }

  protected function getSchema()
  {
    $dataMap = $this->class->dataMap();
    $properties = array(
      'valutazione_globale' => array(
        'title'    => $dataMap['valutazione_globale']->name(),
        'required' => filter_var($dataMap['valutazione_globale']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      )
    );

    $schema = array(
      "type" => "object",
      "properties" => $properties
    );

    return $schema;
  }

  protected function getOptions()
  {
    $dataMap = $this->class->dataMap();
    $options = array(
      'valutazione_globale' => array(
        'helper' => $dataMap['valutazione_globale']->description(),
        'label' => $dataMap['valutazione_globale']->name(),
        'type' => 'summernote'
      )
    );

    return array(
      "form" => array(
        "attributes" => array(
          "action" => $this->getHelper()->getServiceUrl('action', $this->getHelper()->getParameters()),
          "method" => "post"
        ),
        "buttons" => array(
          "submit" => array()
        ),
      ),
      "fields" => $options,
    );
  }

  protected function getView()
  {
    return array(
      "parent" => "bootstrap-edit",
      "locale" => "it_IT"
    );
  }

  protected function submit()
  {
    $params = array();
    $params['attributes'] = array(
      'valutazione_globale' => $_POST['valutazione_globale']
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;

  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}
