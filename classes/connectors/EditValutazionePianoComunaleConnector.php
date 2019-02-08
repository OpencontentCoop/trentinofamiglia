<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\TagRepository;

class EditValutazionePianoComunaleConnector extends AbstractBaseConnector
{

  protected $contentSearch;
  protected $tagRepository;

  private $object;
  private $class;
  private $azione;

  private $completamento = array();

  public function __construct($identifier)
  {
    parent::__construct($identifier);


    parent::__construct($identifier);
    if (isset($_GET['object'])) {
      $this->object = eZContentObject::fetch((int)$_GET['object']);
    }
    if (!$this->object instanceof eZContentObject) {
      throw new Exception("Object non selezionato", 1);
    }

    // Class
    $this->class = eZContentClass::fetchByIdentifier($this->object->attribute('class_identifier'));

    $this->completamento = array('0','25','50','75','100');
  }

  protected function getData()
  {

    $dataMap = $this->object->dataMap();
    $data = array(
      'data' => $dataMap['data']->hasContent() ? date('d/m/Y', $dataMap['data']->toString()) : '',
      'completamento' => $dataMap['completamento']->toString(),
      'note' => str_replace( '&nbsp;', ' ', $dataMap['note']->attribute( 'content')->attribute( 'output' )->outputText() ),
    );
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
      "title" => "Modifica valutazione per il piano comunale",
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
        'helper' => $dataMap['completamento']->description(),
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
          "submit" => array(
            "styles" => "btn btn-lg btn-success u-margin-right-xs u-margin-bottom-xs"
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
    $params['attributes'] = array(
      'data' => PianiComunaliHelper::stringToTime($_POST['data'], 'd/m/Y'),
      'completamento' => $_POST['completamento'],
      'note'          => $_POST['note']
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;
  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}

