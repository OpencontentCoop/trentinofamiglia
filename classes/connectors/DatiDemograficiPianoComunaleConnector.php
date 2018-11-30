<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;

class DatiDemograficiPianoComunaleConnector extends AbstractBaseConnector
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

    /** @var \eZMatrix $attributeContents */
    $attributeContents = $dataMap['dati_demografici']->content();
    $columns = (array) $attributeContents->attribute( 'columns' );
    $rows = (array) $attributeContents->attribute( 'rows' );

    $keys = array();
    foreach( $columns['sequential'] as $column )
    {
      $keys[] = $column['identifier'];
    }
    $data = array();
    foreach( $rows['sequential'] as $row )
    {
      $data[] = array_combine( $keys, $row['columns'] );
    }

    return array(
      'dati_demografici' => $data
    );
  }

  protected function getSchema()
  {
    $dataMap = $this->class->dataMap();
    $properties = array(
      'dati_demografici' => array(
        'title' => '',
        'required' => filter_var($dataMap['dati_demografici']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        "type" => "array",
        "items" => array(
          "type" => "object",
          "properties" => array()
        )
      )
    );

    $attribute = $this->class->fetchAttributeByIdentifier('dati_demografici');
    /** @var \eZMatrixDefinition $definition */
    $definition = $attribute->attribute('content');
    $columns = $definition->attribute('columns');
    foreach ($columns as $column) {
      $properties['dati_demografici']["items"]["properties"][$column['identifier']] = array(
        "title" => $column['name'],
        "type" => "string"
      );
    }

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
      'dati_demografici' => array(
        'helper' => $dataMap['dati_demografici']->description(),
        'label' => '',
        'type' => 'table'
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

    $fixedPostData = array();
    if(is_array($_POST['dati_demografici'])){
      foreach ($_POST['dati_demografici'] as $item) {
        $fixedPostData []= implode('|', $item);
      }
    }
    $params = array();
    $params['attributes'] = array(
      'dati_demografici'        => implode('&', $fixedPostData)
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;

  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}
