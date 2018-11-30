<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\EnvironmentLoader;

class InfrastrutturePianoComunaleConnector extends AbstractBaseConnector
{

  protected $contentSearch;

  private $object;
  private $class;
  private $infrastrutture;

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

    $this->contentSearch = new ContentSearch();
    $this->contentSearch->setEnvironment(EnvironmentLoader::loadPreset("content"));

    // Infrastrutture presenti
    $dataMap = $this->object->dataMap();

    $this->infrastrutture = $this->contentSearch->search("select-fields [metadata.id => metadata.name] classes [infrastruttura_family] and raw[submeta_organizzazione_proprietaria___id____si] = {$dataMap['organizzazione']->toString()}");
  }

  protected function getData()
  {

    $data = array();
    $dataMap = $this->object->dataMap();
    if ($dataMap['infrastrutture_family']->hasContent()) {

      $content = $dataMap['infrastrutture_family']->content();
      foreach ( $content['relation_list'] as $c ) {
        $obj = eZContentObject::fetch( $c['contentobject_id'] );
        if ( $obj instanceof eZContentObject ) {
          /*$data[] = array(
            'id' => $c['contentobject_id'],
            'name' => $obj->Name,
            'class' => $c['contentclass_identifier'],
          );*/
          $data []= $c['contentobject_id'];
        }
        unset($obj);
      }
    }
    return array(
      'infrastrutture_family' => $data
    );
  }

  protected function getSchema()
  {

    $dataMap = $this->class->dataMap();
    $properties = array(
      "infrastrutture_family" => array(
        "title" => '',
        "type" => "array",
        "enum" => array_map('strval', array_keys($this->infrastrutture))
      )
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
    $attribute = $this->class->fetchAttributeByIdentifier('infrastrutture_family');
    $classContent = $attribute->dataType()->classAttributeContent($attribute);
    $classConstraintList = (array)$classContent['class_constraint_list'];
    $defaultPlacement = isset( $classContent['default_placement']['node_id'] ) ? $classContent['default_placement']['node_id'] : null;


    $dataMap = $this->class->dataMap();
    $options = array(
      "infrastrutture_family" => array(
        'helper' => $dataMap['infrastrutture_family']->description(),
        "type" => "checkbox",
        "optionLabels" => array_values($this->infrastrutture),
        "fieldClass" => "label_as_legend",
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

    /*$infrastrutture = array();
    if (isset($_POST['infrastrutture_family'])) {
      foreach ($_POST['infrastrutture_family'] as $o) {
        $infrastrutture []= $o['id'];
      }
    }*/

    $params['attributes'] = array(
      'infrastrutture_family'        => implode(',', $_POST['infrastrutture_family'])
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;

  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}

