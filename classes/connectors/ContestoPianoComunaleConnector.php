<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Opendata\Api\TagRepository;

class ContestoPianoComunaleConnector extends AbstractBaseConnector
{
  const VALUES_TERRITORIO = array('Trentino', 'Italia');

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
    $dataMap = $this->object->dataMap();

    $data = array(
      'titolo' => $dataMap['titolo']->toString(),
      'anno' => $dataMap['anno']->content()->attribute('keywords'),
      'ruolo_rappresentante_legale' => $dataMap['ruolo_rappresentante_legale']->toString(),
      'nome_rappresentante_legale' => $dataMap['nome_rappresentante_legale']->toString(),
      'email_rappresentante_legale' => $dataMap['email_rappresentante_legale']->toString(),
      'telefono_rappresentante_legale' => $dataMap['telefono_rappresentante_legale']->toString(),
      'nome_referente_tecnico' => $dataMap['nome_referente_tecnico']->toString(),
      'email_referente_tecnico' => $dataMap['email_referente_tecnico']->toString(),
      'telefono_referente_tecnico' => $dataMap['telefono_referente_tecnico']->toString(),
      'territorio' => $dataMap['territorio']->toString() != null ? $dataMap['territorio']->toString() : CreatePianoComunaleConnector::TERRITORIO_DEFAULT,
    );
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
      ),
      'ruolo_rappresentante_legale' => array(
        'title'    => $dataMap['ruolo_rappresentante_legale']->name(),
        'required' => filter_var($dataMap['ruolo_rappresentante_legale']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      ),
      'nome_rappresentante_legale' => array(
        'title' => $dataMap['nome_rappresentante_legale']->name(),
        'required' => filter_var($dataMap['nome_rappresentante_legale']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      ),
      'email_rappresentante_legale' => array(
        'title' => $dataMap['email_rappresentante_legale']->name(),
        'required' => filter_var($dataMap['email_rappresentante_legale']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        'format' => 'email'
      ),
      'telefono_rappresentante_legale' => array(
        'title' => $dataMap['telefono_rappresentante_legale']->name(),
        'required' => filter_var($dataMap['telefono_rappresentante_legale']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      ),
      'nome_referente_tecnico' => array(
        'title' => $dataMap['nome_referente_tecnico']->name(),
        'required' => filter_var($dataMap['nome_referente_tecnico']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      ),
      'email_referente_tecnico' => array(
        'title' => $dataMap['email_referente_tecnico']->name(),
        'required' => filter_var($dataMap['email_referente_tecnico']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        'format' => 'email'
      ),
      'telefono_referente_tecnico' => array(
        'title' => $dataMap['telefono_referente_tecnico']->name(),
        'required' => filter_var($dataMap['telefono_referente_tecnico']->IsRequired, FILTER_VALIDATE_BOOLEAN),
      ),
      'territorio' => array(
        'title' => $dataMap['territorio']->name(),
        'required' => filter_var($dataMap['territorio']->IsRequired, FILTER_VALIDATE_BOOLEAN),
        "enum" => ContestoPianoComunaleConnector::VALUES_TERRITORIO
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
      'anno' => array(
        'helper'       => $dataMap['anno']->description(),
        'label'        => $dataMap['anno']->name(),
        "type"         => "radio",
        "optionLabels" => array_values($this->anni),
        "fieldClass"   => "label_as_legend",
      ),
      'ruolo_rappresentante_legale' => array(
        'helper' => $dataMap['ruolo_rappresentante_legale']->description(),
        'label' => $dataMap['ruolo_rappresentante_legale']->name(),
        'type' => 'text'
      ),
      'nome_rappresentante_legale' => array(
        'helper' => $dataMap['nome_rappresentante_legale']->description(),
        'label' => $dataMap['nome_rappresentante_legale']->name(),
        'type' => 'text'
      ),
      'email_rappresentante_legale' => array(
        'helper' => $dataMap['email_rappresentante_legale']->description(),
        'label' => $dataMap['email_rappresentante_legale']->name(),
        /*'type' => 'text'*/
      ),
      'telefono_rappresentante_legale' => array(
        'helper' => $dataMap['telefono_rappresentante_legale']->description(),
        'label' => $dataMap['telefono_rappresentante_legale']->name(),
        'type' => 'text'
      ),
      'nome_referente_tecnico' => array(
        'helper' => $dataMap['nome_referente_tecnico']->description(),
        'label' => $dataMap['nome_referente_tecnico']->name(),
        'type' => 'text'
      ),
      'email_referente_tecnico' => array(
        'helper' => $dataMap['email_referente_tecnico']->description(),
        'label' => $dataMap['email_referente_tecnico']->name(),
        /*'type' => 'text'*/
      ),
      'telefono_referente_tecnico' => array(
        'helper' => $dataMap['telefono_referente_tecnico']->description(),
        'label' => $dataMap['telefono_referente_tecnico']->name(),
        'type' => 'text'
      ),
      'territorio' => array(
        'helper' => $dataMap['territorio']->description(),
        "type" => "select",
        "optionLabels" => ContestoPianoComunaleConnector::VALUES_TERRITORIO,
        "fieldClass" => "label_as_legend",
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
      'titolo'        => $_POST['titolo'],
      'anno'          => $this->generateTagInput('anno', $_POST['anno']),
      'ruolo_rappresentante_legale' => $_POST['ruolo_rappresentante_legale'],
      'nome_rappresentante_legale' => $_POST['nome_rappresentante_legale'],
      'email_rappresentante_legale' => $_POST['email_rappresentante_legale'],
      'telefono_rappresentante_legale' => $_POST['telefono_rappresentante_legale'],
      'nome_referente_tecnico' => $_POST['nome_referente_tecnico'],
      'email_referente_tecnico' => $_POST['email_referente_tecnico'],
      'telefono_referente_tecnico' => $_POST['telefono_referente_tecnico'],
      'territorio' => $_POST['territorio'],
    );

    $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
    return $result;

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

  protected function upload()
  {
    throw new Exception("Method not allowed", 1);
  }
}
