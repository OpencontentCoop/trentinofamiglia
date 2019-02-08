<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;

class PremessaPianoComunaleConnector extends AbstractBaseConnector
{
  private $object;
  private $class;

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
      'premessa' => str_replace( '&nbsp;', ' ', $dataMap['premessa']->attribute( 'content')->attribute( 'output' )->outputText() ),
    );
    return $data;
  }

  protected function getSchema()
  {
    $dataMap = $this->class->dataMap();
    $properties = array(
      'premessa' => array(
        'title' => '',
        'required' => filter_var($dataMap['premessa']->IsRequired, FILTER_VALIDATE_BOOLEAN)
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
      'premessa' => array(
        'helper' => $dataMap['premessa']->description(),
        'label' => '',
        "summernote" => PianiComunaliHelper::getSummernoteToolbar(),
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
      'premessa'        => SQLIContentUtils::getRichContent($_POST['premessa'])
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;

  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}
