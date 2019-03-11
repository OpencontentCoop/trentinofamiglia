<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\TagRepository;

class CreateAzionePianoComunaleConnector extends AbstractBaseConnector
{

  protected $contentSearch;
  protected $tagRepository;

  private $class;
  private $parent;

  private $piano;
  private $ambito;

  private $tipologie;
  private $attivita;
  private $tipologiaPartnersip;

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
      throw new Exception("Object non selezionato", 1);
    }

    // Nodo padre (Main node del piano)
    $this->parent = $this->piano->mainNodeID();

    // Ambito
    if (isset($_GET['ambito'])) {
      $this->ambito = eZContentObject::fetch((int)$_GET['ambito']);
    }
    if (!$this->ambito instanceof eZContentObject) {
      throw new Exception("Ambito non selezionato", 1);
    }

    $this->contentSearch = new ContentSearch();
    $this->contentSearch->setEnvironment(EnvironmentLoader::loadPreset("content"));

    // Tipologie
    $language = eZLocale::currentLocaleCode();
    //$this->tipologie = $this->contentSearch->search("select-fields [metadata.id => metadata.name] classes [tipo_azione] and raw[submeta_macroambito_family___id____si] = {$this->ambito->ID}");
    $types = $this->contentSearch->search("classes [tipo_azione] and raw[submeta_macroambito_family___id____si] = {$this->ambito->ID}");
    foreach ($types->searchHits as $t) {
      $this->tipologie[$t['metadata']['id']] = $t['metadata']['name'][$language];
    }



    $this->tagRepository = new TagRepository();
    // Attività
    $attribute = $this->class->fetchAttributeByIdentifier('attivita');
    $subtreeLimitation =  $attribute->attribute(eZTagsType::SUBTREE_LIMIT_FIELD);
    if ($subtreeLimitation > 0) {
      $tags = $this->tagRepository->read($subtreeLimitation);
      if ($tags->hasChildren) {
        foreach ($tags->children as $c ) {
          $this->attivita[$c->id]= $c->keyword;
        }
      }
    }

    // Tipologia Partnerships
    $attribute = $this->class->fetchAttributeByIdentifier('tipologia_partnership');
    $subtreeLimitation =  $attribute->attribute(eZTagsType::SUBTREE_LIMIT_FIELD);
    if ($subtreeLimitation > 0) {
      $tags = $this->tagRepository->read($subtreeLimitation);
      if ($tags->hasChildren) {
        foreach ($tags->children as $c ) {
          $this->tipologiaPartnersip[$c->id]= $c->keyword;
        }
      }
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
      'titolo' => array(
        'title' => $dataMap['titolo']->name(),
        'required' => filter_var($dataMap['titolo']->IsRequired, FILTER_VALIDATE_BOOLEAN)
      ),
      "tipo_azione" => array(
        "title" => $dataMap['tipo_azione']->name(),
        "type" => "string",
        'required' => filter_var($dataMap['tipo_azione']->IsRequired, FILTER_VALIDATE_BOOLEAN),

        "enum" => array_map('strval', array_keys($this->tipologie))
        //'enum' => array_values($this->tipologie)
      ),
      "attivita" => array(
        "title" => $dataMap['attivita']->name(),
        "type" => "string",
        'required' => filter_var($dataMap['attivita']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        "enum" => array_map('strval', array_keys($this->attivita))

      ),
      'descrizione' => array(
        'title' => $dataMap['descrizione']->name(),
        'required' => filter_var($dataMap['descrizione']->IsRequired, FILTER_VALIDATE_BOOLEAN)
      ),
      'obiettivo' => array(
        'title' => $dataMap['obiettivo']->name(),
        'required' => filter_var($dataMap['obiettivo']->IsRequired, FILTER_VALIDATE_BOOLEAN)
      ),
      'assessorato' => array(
        'title' => $dataMap['assessorato']->name(),
        'required' => filter_var($dataMap['assessorato']->IsRequired, FILTER_VALIDATE_BOOLEAN)
      ),
      "tipologia_partnership" => array(
        "title" => $dataMap['tipologia_partnership']->name(),
        "type" => "string",
        'required' => filter_var($dataMap['tipologia_partnership']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        "enum" => array_map('strval', array_keys($this->tipologiaPartnersip))
      ),
      "organizzazioni_coinvolte" => array(
        "title" => $dataMap['organizzazioni_coinvolte']->name(),
        "type" => "array",
        'required' => filter_var($dataMap['organizzazioni_coinvolte']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      ),
      'altre_organizzazioni_coinvolte' => array(
        'title' => $dataMap['altre_organizzazioni_coinvolte']->name(),
        'required' => filter_var($dataMap['altre_organizzazioni_coinvolte']->IsRequired, FILTER_VALIDATE_BOOLEAN)
      ),
      'indicatore' => array(
        'title' => $dataMap['indicatore']->name(),
        'required' => filter_var($dataMap['indicatore']->IsRequired, FILTER_VALIDATE_BOOLEAN)
      ),

    );

    $schema = array(
      "title" => "Crea nuova azione per il piano comunale",
      "type" => "object",
      "properties" => $properties
    );

    return $schema;
  }

  protected function getOptions()
  {

    $attribute = $this->class->fetchAttributeByIdentifier('organizzazioni_coinvolte');
    $classContent = $attribute->dataType()->classAttributeContent($attribute);
    $classConstraintList = (array)$classContent['class_constraint_list'];
    $defaultPlacement = isset( $classContent['default_placement']['node_id'] ) ? $classContent['default_placement']['node_id'] : null;

    $dataMap = $this->class->dataMap();
    $options = array(
      'titolo' => array(
        'helper' => $dataMap['titolo']->description(),
        'label' => $dataMap['titolo']->name(),
        'type' => 'text'
      ),
      "tipo_azione" => array(
        'helper' => $dataMap['tipo_azione']->description(),
        "type" => "select",
        "optionLabels" => array_values($this->tipologie),
        "fieldClass" => "label_as_legend",
      ),
      "attivita" => array(
        'helper' => $dataMap['attivita']->description(),
        "type" => "select",
        "optionLabels" => array_values($this->attivita),
        "fieldClass" => "label_as_legend",
      ),
      'descrizione' => array(
        'helper' => $dataMap['descrizione']->description(),
        'label' => $dataMap['descrizione']->name(),
        "summernote" => PianiComunaliHelper::getSummernoteToolbar(),
        'type' => 'summernote'
      ),
      'obiettivo' => array(
        'helper' => $dataMap['obiettivo']->description(),
        'label' => $dataMap['obiettivo']->name(),
        "summernote" => PianiComunaliHelper::getSummernoteToolbar(),
        'type' => 'summernote'
      ),
      'assessorato' => array(
        'helper' => $dataMap['assessorato']->description(),
        'label' => $dataMap['assessorato']->name(),
        'type' => 'text'
      ),
      "tipologia_partnership" => array(
        'helper' => $dataMap['tipologia_partnership']->description(),
        "type" => "select",
        "optionLabels" => array_values($this->tipologiaPartnersip),
        "fieldClass" => "label_as_legend",
      ),
      "organizzazioni_coinvolte" => array(
        'helper' => $dataMap['organizzazioni_coinvolte']->description(),
        "type" => "relationbrowse",
        'label' => $dataMap['organizzazioni_coinvolte']->name(),
        'browse' => array(
          'addCloseButton' => true,
          'addCreateButton' => false,
          'classes' => $classConstraintList,
          'selectionType' => 'multiple',
          'subtree' => $defaultPlacement
        )
      ),
      'altre_organizzazioni_coinvolte' => array(
        'helper' => $dataMap['altre_organizzazioni_coinvolte']->description(),
        'label' => $dataMap['altre_organizzazioni_coinvolte']->name(),
        "summernote" => PianiComunaliHelper::getSummernoteToolbar(),
        'type' => 'summernote'
      ),
      'indicatore' => array(
        'helper' => $dataMap['indicatore']->description(),
        'label' => $dataMap['indicatore']->name(),
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

    $organizzazioniCoinvolte = array();
    if (isset($_POST['organizzazioni_coinvolte'])) {
      foreach ($_POST['organizzazioni_coinvolte'] as $o) {
        $organizzazioniCoinvolte []= $o['id'];
      }
    }

    $params['attributes'] = array(
      'titolo'                         => $_POST['titolo'],
      'tipo_azione'                    => $_POST['tipo_azione'],
      'attivita'                       => $_POST['attivita'],
      'descrizione'                    => $_POST['descrizione'],
      'obiettivo'                      => $_POST['obiettivo'],
      'assessorato'                    => $_POST['assessorato'],
      'tipologia_partnership'          => $_POST['tipologia_partnership'],
      'organizzazioni_coinvolte'       => implode(',', $organizzazioniCoinvolte),
      'altre_organizzazioni_coinvolte' => $_POST['altre_organizzazioni_coinvolte'],
      'indicatore'                     => $_POST['indicatore'],
      'piano_comunale'                 => $this->piano->ID,
      'macroambito'                    => $this->ambito->ID
    );
    $result = eZContentFunctions::createAndPublishObject($params);

    if ($result instanceof eZContentObject) {
      $dataMap = $result->dataMap();
      $content = $dataMap['tipo_azione']->content();

      return array(
        'status'  => 'success',
        'id'      => $result->ID,
        'tipo_id' => $content['relation_list'][0]['contentobject_id']
      );
    }
    return false;

  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}

