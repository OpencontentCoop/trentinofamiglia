<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\TagRepository;

class EditAzionePianoComunaleConnector extends AbstractBaseConnector
{

  protected $contentSearch;
  protected $tagRepository;

  private $object;
  private $class;
  private $ambito;

  private $tipologie;
  private $attivita;
  private $tipologiaPartnersip;

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

    // Ambito
    $dataMap = $this->object->dataMap();
    $this->ambito = $dataMap['macroambito']->toString();

    $this->contentSearch = new ContentSearch();
    $this->contentSearch->setEnvironment(EnvironmentLoader::loadPreset("content"));

    // Tipologie
    $language = eZLocale::currentLocaleCode();
    //$this->tipologie = $this->contentSearch->search("select-fields [metadata.id => metadata.name] classes [tipo_azione] and raw[submeta_macroambito_family___id____si] = {$this->ambito->ID}");
    $types = $this->contentSearch->search("classes [tipo_azione] and raw[submeta_macroambito_family___id____si] = {$this->ambito}");
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
    $dataMap = $this->object->dataMap();

    $organizzazioni = array();
    if ($dataMap['organizzazioni_coinvolte']->hasContent()) {

      $content = $dataMap['organizzazioni_coinvolte']->content();
      foreach ( $content['relation_list'] as $c ) {
        $obj = eZContentObject::fetch( $c['contentobject_id'] );
        if ( $obj instanceof eZContentObject ) {
          $organizzazioni[] = array(
            'id' => $c['contentobject_id'],
            'name' => $obj->Name,
            'class' => $c['contentclass_identifier'],
          );
        }
        unset($obj);
      }
    }

    $data = array(
      'titolo' => $dataMap['titolo']->toString(),
      'tipo_azione' => $dataMap['tipo_azione']->toString(),
      'attivita' => implode(',',$dataMap['attivita']->content()->attribute('keywords')),
      'descrizione' => $dataMap['descrizione']->toString(),
      'obiettivo' => $dataMap['obiettivo']->toString(),
      'assessorato' => $dataMap['assessorato']->toString(),
      'tipologia_partnership' => implode(',',$dataMap['tipologia_partnership']->content()->attribute('keywords')),
      'organizzazioni_coinvolte' => $organizzazioni,
      'altre_organizzazioni_coinvolte' => $dataMap['altre_organizzazioni_coinvolte']->toString(),
      'indicatore' => $dataMap['indicatore']->toString()
    );

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
          "submit" => array(
            "styles" => "btn btn-lg btn-success u-margin-right-xs pull-right u-margin-bottom-xs"
          ),
          "reset" => array(
            "value"=> "Annulla",
            "styles"=> "btn btn-lg btn-danger u-margin-right-xs u-margin-bottom-xs reset-button"
          )
        )
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

    $organizzazioniCoinvolte = array();
    if (isset($_POST['organizzazioni_coinvolte'])) {
      foreach ($_POST['organizzazioni_coinvolte'] as $o) {
        $organizzazioniCoinvolte []= $o['id'];
      }
    }

    $params = array();
    $params['attributes'] = array(
      'titolo'                         => $_POST['titolo'],
      'tipo_azione'                    => $_POST['tipo_azione'],
      'attivita'                       => $this->generateTagInput('attivita', $_POST['attivita']),
      'descrizione'                    => $_POST['descrizione'],
      'obiettivo'                      => $_POST['obiettivo'],
      'assessorato'                    => $_POST['assessorato'],
      'tipologia_partnership'          => $this->generateTagInput('tipologia_partnership', $_POST['tipologia_partnership']),
      'organizzazioni_coinvolte'       => implode(',', $organizzazioniCoinvolte),
      'altre_organizzazioni_coinvolte' => $_POST['altre_organizzazioni_coinvolte'],
      'indicatore'                     => $_POST['indicatore'],
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;
  }

  private function generateTagInput( $attributeIdentifier, $value ) {

    $class = eZContentClass::fetchByIdentifier('azione');
    $attribute = $class->fetchAttributeByIdentifier($attributeIdentifier);
    $subtreeLimitation =  $attribute->attribute(eZTagsType::SUBTREE_LIMIT_FIELD);
    $locale =  eZLocale::currentLocaleCode();

    if ( is_array($value) ) {
      $data = $value;
    } else {
      $data = explode(',', $value );
    }

    $ids      = array();
    $keywords = array();
    $subtree  = array();
    $locales  = array();
    $returnArray = array();
    foreach ($data as $d) {
      $ids[] = '0';
      $keywords[] = $d;
      $subtree[] = $subtreeLimitation;
      $locales[] = $locale;
    }
    $returnArray []= implode( '|#', $ids );
    $returnArray []= implode( '|#', $keywords );
    $returnArray []= implode( '|#', $subtree );
    $returnArray []= implode( '|#', $locales );
    return implode( '|#', $returnArray );
  }

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}

