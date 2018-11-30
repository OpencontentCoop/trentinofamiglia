<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;

class CertificazioniPianoComunaleConnector extends AbstractBaseConnector
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

    if ( !$this->class instanceof eZContentClass ) {
      throw new Exception("La classe specificata non esiste", 1);
    }

  }

  protected function getData()
  {
    $data = array();

    return $data;
  }

  protected function getSchema()
  {

    $dataMap = $this->class->dataMap();
    $properties = array(
      "organizzazione" => array(
        "title" => $dataMap['organizzazione']->name(),
        "type" => "array",
        'required' => filter_var($dataMap['organizzazione']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      ),
    );

    $schema = array(
      "title" => "",
      "type" => "object",
      "properties" => $properties
    );

    return $schema;
  }

  protected function getOptions()
  {
    $attribute = $this->class->fetchAttributeByIdentifier('organizzazione');
    $classContent = $attribute->dataType()->classAttributeContent($attribute);
    $classConstraintList = (array)$classContent['class_constraint_list'];
    $defaultPlacement = isset( $classContent['default_placement']['node_id'] ) ? $classContent['default_placement']['node_id'] : null;


    $dataMap = $this->class->dataMap();
    $options = array(
      "organizzazione" => array(
        'helper' => '',
        "type" => "relationbrowse",
        'label' => $dataMap['organizzazione']->name(),
        'browse' => array(
          'addCloseButton' => true,
          'addCreateButton' => false,
          "selectionType" => 'multiple',
          'classes' => $classConstraintList,
          'subtree' => $defaultPlacement
        )
      ),
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

    $organizzazioni = array();
    if (isset($_POST['organizzazione'])) {
      foreach ($_POST['organizzazione'] as $o) {
        $organizzazioni []= $o['id'];
      }
    }

    $params['attributes'] = array(
      'organizzazione'  => implode(',', $organizzazioni)
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;

  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}

