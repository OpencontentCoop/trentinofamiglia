<?php

class PianoComunale extends OCEditorialStuffPostDefault
{

  const STATE_DRAFT   = 'draft';
  const STATE_PENDING   = 'pending';
  const STATE_PUBLISHED = 'published';

  public function attributes()
  {
    $attributes = parent::attributes();
    $attributes[] = 'macroambiti';
    $attributes[] = 'is_draft';
    $attributes[] = 'is_pending';
    $attributes[] = 'is_published';
    return $attributes;
  }

  public function attribute($property)
  {
    if ($property == 'macroambiti') {
      return $this->getMacroambiti();
    }

    if ($property == 'is_draft') {
      return $this->isDraft();
    }

    if ($property == 'is_pending') {
      return $this->isPending();
    }

    if ($property == 'is_published') {
      return $this->isPublished();
    }

    return parent::attribute($property);
  }

  protected function getMacroambiti()
  {
    $result = array();
    $fetch_parameters = array(
      'query' => '',
      'class_id' => array('macroambito_family')
    );
    $searchResult = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);

    if ($searchResult['SearchCount'] > 0) {
      foreach ($searchResult['SearchResult'] as $s) {
        $dataMap = $s->ContentObject->dataMap();
        $temp = array(
          'id'         => $s->ContentObject->ID,
          'name'       => $s->ContentObject->Name,
          'short_name' => $dataMap['nome_breve']->toString()
        );
        $required = $this->getRequiredAzioniByMacroambito($s->ContentObject->ID);
        $temp['required_azioni'] = $required;
        $actions = $this->getAzioniByMacroambito($s->ContentObject->ID);
        $temp['azioni'] = $actions['actions'];



        $missing = empty($actions['types']) ? $required : array_diff_key($required, $actions['types']);
        $temp['missing_azioni'] = $missing;

        $result []= $temp;
        unset($temp);
      }
    }
    return $result;
  }

  protected function getAzioniByMacroambito($macroambitoID)
  {
    $result = array();
    $fetch_parameters = array(
      'query' => '',
      'class_id' => array('azione'),
      'filter' => array('submeta_macroambito___id____si:' . $macroambitoID .  ' AND submeta_piano_comunale___id____si:' . $this->id())
    );
    $searchResult = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);
    if ($searchResult['SearchCount'] > 0) {
      foreach ($searchResult['SearchResult'] as $s) {
        $dataMap = $s->ContentObject->dataMap();
        $type = $dataMap['tipo_azione']->content();

        $result['types'][$type['relation_list'][0]['contentobject_id']]= $type['relation_list'][0]['contentobject_id'];

        $result['actions'][$s->ContentObject->ID] = array(
          'id'         => $s->ContentObject->ID,
          'name'       => $s->ContentObject->Name
        );
      }
    }
    return $result;
  }

  protected function getRequiredAzioniByMacroambito($macroambitoID)
  {
    $result = array();
    $fetch_parameters = array(
      'query' => '',
      'class_id' => array('tipo_azione'),
      'filter' => array('submeta_macroambito_family___id____si:' . $macroambitoID . ' AND attr_obbligatoria_b:true')
    );
    $searchResult = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);
    if ($searchResult['SearchCount'] > 0) {
      foreach ($searchResult['SearchResult'] as $s) {
        $dataMap = $s->ContentObject->dataMap();
        $result[$s->ContentObject->ID] = array(
          'id'         => $s->ContentObject->ID,
          'name'       => $s->ContentObject->Name
        );
      }
    }
    return $result;
  }

  protected function hasMissingActions() {
    $result = false;
    $ambiti = $this->getMacroambiti();
    foreach ($ambiti as $a) {
      if ( !empty($a['missing_azioni']) ) {
        $result = true;
        break;
      }
    }

    return $result;
  }

  protected function hasDeliberaData() {
    $dataMap = $this->dataMap;
    return $dataMap['numero_delibera']->hasContent() && $dataMap['data_delibera']->hasContent();
  }

  protected function isDraft()
  {
    return $this->currentState()->Identifier == self::STATE_DRAFT;
  }

  protected function isPending()
  {
    return $this->currentState()->Identifier == self::STATE_PENDING;
  }

  protected function isPublished()
  {
    return $this->currentState()->Identifier == self::STATE_PUBLISHED;
  }

  public function setState( $stateIdentifier )
  {
    $states = $this->states();
    if ( isset( $states[$stateIdentifier] ) && $states[$stateIdentifier]->attribute( 'identifier' ) == self::STATE_PENDING) {

      if ($this->hasMissingActions()) {
        throw new Exception("Non è stato possibile completare l'operazione. <br /> Alcune azioni obbligatorie non sono ancora presenti!");
      }
    }

    if ( isset( $states[$stateIdentifier] ) && $states[$stateIdentifier]->attribute( 'identifier' ) == self::STATE_PUBLISHED) {

      if ($this->hasMissingActions()) {
        throw new Exception("Non è stato possibile completare l'operazione. <br /> Alcune azioni obbligatorie non sono ancora presenti!");
      }

      if (!$this->hasDeliberaData()) {
        throw new Exception("Non è stato possibile completare l'operazione. <br /> I dati sulla delibera non sono ancora presenti!");
      }
    }

    parent::setState( $stateIdentifier );

  }



  public function tabs()
  {
    $currentUser = eZUser::currentUser();
    $templatePath = $this->getFactory()->getTemplateDirectory();
    $tabs = array(
      array(
        'identifier' => 'contesto',
        'name' => "Contesto",
        'template_uri' => "design:{$templatePath}/parts/contesto.tpl"
      ),
      array(
        'identifier' => 'certificazioni',
        'name' => "Certificazioni",
        'template_uri' => "design:{$templatePath}/parts/certificazioni.tpl"
      ),
      array(
        'identifier' => 'piani_pregressi',
        'name' => "Piani pregressi",
        'template_uri' => "design:{$templatePath}/parts/piani_pregressi.tpl"
      ),
      /*array(
        'identifier' => 'dati_demografici',
        'name' => "Dati demografici",
        'template_uri' => "design:{$templatePath}/parts/dati_demografici.tpl"
      ),*/

      array(
        'identifier' => 'infrastrutture',
        'name' => "Infrastrutture family esistenti nel comune",
        'template_uri' => "design:{$templatePath}/parts/infrastrutture.tpl"
      ),
      array(
        'identifier' => 'premessa',
        'name' => "Premessa",
        'template_uri' => "design:{$templatePath}/parts/premessa.tpl"
      ),
      array(
        'identifier' => 'azioni',
        'name' => "Azioni",
        'template_uri' => "design:{$templatePath}/parts/azioni.tpl"
      ),

      array(
        'identifier' => 'delibera',
        'name' => "Delibera di approvazione",
        'template_uri' => "design:{$templatePath}/parts/delibera.tpl"
      ),

      array(
        'identifier' => 'valutazione',
        'name' => "Valutazione",
        'template_uri' => "design:{$templatePath}/parts/valutazione.tpl"
      ),
    );

    // $tabs[] = array(
    //   'identifier' => 'history',
    //   'name' => ezpI18n::tr('editorialstuff/dashboard', 'History'),
    //   'template_uri' => "design:{$templatePath}/parts/history.tpl"
    // );
    return $tabs;
  }
}
