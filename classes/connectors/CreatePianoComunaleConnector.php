<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\TagRepository;

class CreatePianoComunaleConnector extends AbstractBaseConnector
{

  const TERRITORIO_DEFAULT = 'Trentino';

  protected $tagRepository;

  private $class;
  private $parent;
  private $organizzazione = false;
  private $anni;

  public function __construct($identifier)
  {
    parent::__construct($identifier);
    if (isset($_GET['class'])) {
      $this->class = eZContentClass::fetchByIdentifier($_GET['class']);
    } else {
      throw new Exception("Deve essere specificata una classe", 1);
    }

    if (isset($_GET['parent'])) {
      $this->parent = $_GET['parent'];
    } else {
      throw new Exception("Deve essere specificato un nodo padre", 1);
    }

    if ( !$this->class instanceof eZContentClass ) {
      throw new Exception("La classe specificata non esiste", 1);
    }

    // Recupero l'organizzazione dall'utente corrente
    $currentUser = eZUser::currentUser();
    if ($currentUser instanceof eZUser) {
      $userObject = $currentUser->contentObject();
      if ($userObject->attribute('class_identifier') == 'operatore_territoriale') {
        $userDataMap = $userObject->dataMap();
        $this->organizzazione = explode('-', $userDataMap['organizzazione']->toString());
      }
    }

    $this->tagRepository = new TagRepository();
    // Anni
    $attribute = $this->class->fetchAttributeByIdentifier('anno');
    $subtreeLimitation =  $attribute->attribute(eZTagsType::SUBTREE_LIMIT_FIELD);
    if ($subtreeLimitation > 0) {
      $tags = $this->tagRepository->read($subtreeLimitation);
      if ($tags->hasChildren) {
        foreach ($tags->children as $c ) {
          $this->anni[$c->id]= $c->keyword;
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
      'anno' => array(
        'title'    => $dataMap['anno']->name(),
        'required' => filter_var($dataMap['anno']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        'type'     => 'array',
        "enum"     => array_values($this->anni),
        'default'  => date('Y')
      )
    );

    if ( !$this->organizzazione ) {
      $properties['organizzazione'] = array(
        "title" => $dataMap['organizzazione']->name(),
        "type" => "array",
        'required' => filter_var($dataMap['organizzazione']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      );
    }


    $schema = array(
      "title" => "Crea nuovo piano comunale",
      "type" => "object",
      "properties" => $properties
    );

    return $schema;
  }

  protected function getOptions()
  {

    $dataMap = $this->class->dataMap();
    $options = array(
      'anno' => array(
        'helper'       => $dataMap['anno']->description(),
        'label'        => $dataMap['anno']->name(),
        "type"         => "radio",
        "optionLabels" => array_values($this->anni),
        "fieldClass"   => "label_as_legend",
      )
    );

    if (!$this->organizzazione) {
      $attribute = $this->class->fetchAttributeByIdentifier('organizzazione');
      $classContent = $attribute->dataType()->classAttributeContent($attribute);
      $classConstraintList = (array)$classContent['class_constraint_list'];
      $defaultPlacement = isset( $classContent['default_placement']['node_id'] ) ? $classContent['default_placement']['node_id'] : null;

      $options['organizzazione'] = array(
        'helper' => $dataMap['organizzazione']->description(),
        "type" => "relationbrowse",
        'label' => $dataMap['organizzazione']->name(),
        'browse' => array(
          'addCloseButton' => true,
          'addCreateButton' => false,
          "selectionType" => 'multiple',
          'classes' => $classConstraintList,
          'subtree' => $defaultPlacement
        )
      );
    }

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
    $params['class_identifier'] = $this->class->attribute('identifier');
    $params['parent_node_id'] = $this->parent;

    // Recupero l'organizzazione se non precedentemente impostata
    if ( !$this->organizzazione ) {
      if ( isset($_POST['organizzazione'])) {
        foreach ($_POST['organizzazione'] as $o) {
          $this->organizzazione []= $o['id'];
        }
      }
    }

    // Recupero i piani comunali associati all'organizzazione
    $pianiPregressi = PianiComunaliHelper::getPianiPregressi($this->organizzazione[0]);

    $params['attributes'] = array(
      'anno'            => $this->generateTagInput('anno', $_POST['anno']),
      'organizzazione'  => implode('-', $this->organizzazione),
      'piani_pregressi' => implode('-', $pianiPregressi),
      'territorio'      => CreatePianoComunaleConnector::TERRITORIO_DEFAULT
      //'data_delibera' => PianiComunaliHelper::stringToTime($_POST['data_delibera'], 'd/m/Y')
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

  private function generateTagInput( $attributeIdentifier, $value ) {

    $class = eZContentClass::fetchByIdentifier('piano_comunale');
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

}

