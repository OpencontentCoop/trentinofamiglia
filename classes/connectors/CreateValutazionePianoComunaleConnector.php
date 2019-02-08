<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\TagRepository;

class CreateValutazionePianoComunaleConnector extends AbstractBaseConnector
{

  protected $contentSearch;
  protected $tagRepository;

  private $class;
  private $parent;

  private $piano;
  private $azione;

  private $completamento = array();

  public function __construct($identifier)
  {
    parent::__construct($identifier);


    // Classe
    if (isset($_GET['class'])) {
      $this->class = eZContentClass::fetchByIdentifier($_GET['class']);
    } else {
      throw new Exception("Deve essere specificata una classe", 1);
    }
    if ( !$this->class instanceof eZContentClass ) {
      throw new Exception("La classe specificata non esiste", 1);
    }

    // Piano comunale
    if (isset($_GET['piano'])) {
      $this->piano = eZContentObject::fetch((int)$_GET['piano']);
    }
    if (!$this->piano instanceof eZContentObject) {
      throw new Exception("Piano comunale non selezionato", 1);
    }

    // Azione
    if (isset($_GET['azione'])) {
      $this->azione = eZContentObject::fetch((int)$_GET['azione']);
    }
    if (!$this->azione instanceof eZContentObject) {
      throw new Exception("Azione non selezionata", 1);
    }

    // Nodo padre (Main node del piano)
    $this->parent = $this->piano->mainNodeID();

    $this->completamento = array('0','25','50','75','100');

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
      'data' => array(
        'title' => $dataMap['data']->name(),
        'required' => filter_var($dataMap['data']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        'format'   => 'date',
        'default' => date('d/m/Y')
      ),
      "completamento" => array(
        "title" => $dataMap['completamento']->name(),
        "type" => "string",
        'required' => filter_var($dataMap['completamento']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        "enum" => array_map('strval', $this->completamento)
        //'enum' => array_values($this->tipologie)
      ),
      'note' => array(
        'title' => $dataMap['note']->name(),
        'required' => filter_var($dataMap['note']->IsRequired, FILTER_VALIDATE_BOOLEAN)
      )
    );

    $schema = array(
      "title" => "Crea nuova valuazione per il piano comunale",
      "type" => "object",
      "properties" => $properties
    );

    return $schema;
  }

  protected function getOptions()
  {

    $dataMap = $this->class->dataMap();
    $options = array(
      'data' => array(
        'helper' => $dataMap['data']->description(),
        'label'  => $dataMap['data']->name(),
        'type'   => 'date',
        'locale' => 'it'
      ),
      "completamento" => array(
        "type" => "select",
        "optionLabels" => $this->completamento,
        "fieldClass" => "label_as_legend",
      ),
      'note' => array(
        'helper' => $dataMap['note']->description(),
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
          "submit" => array(),
          "reset" => array(
            "value"=> "Annulla",
            "styles"=> "btn btn-lg btn-danger pull-right u-margin-right-xs reset-button",

          )
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
    $params['class_identifier'] = $this->class->attribute('identifier');
    $params['parent_node_id'] = $this->parent;


    $params['attributes'] = array(
      'azione'        => $this->azione->ID,
      'data'          => PianiComunaliHelper::stringToTime($_POST['data'], 'd/m/Y'),
      'completamento' => $_POST['completamento'],
      'note'          => $_POST['note']
    );

    $result = eZContentFunctions::createAndPublishObject($params);

    if ($result instanceof eZContentObject) {
      return $result->ID;
    }
    return false;

  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}

