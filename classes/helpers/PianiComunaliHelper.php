<?php

class PianiComunaliHelper
{
  /**
   * @param $inputDate
   * @param string $format
   * @return null|string
   */
  public static function stringToTime($inputDate, $format = DateTime::ISO8601)
  {

    if ($inputDate == null) {
      return null;
    }

    $dateTime = DateTime::createFromFormat($format, $inputDate);
    if ($dateTime instanceOf DateTime) {
      return $dateTime->format('U');
    }
    return null;
  }


  public static function getSummernoteToolbar()
  {

     return array(
      "toolbar" => array (
        array('style', array('bold', 'italic', 'underline', 'clear')),
        array('font', array('strikethrough', 'superscript', 'subscript')),
        array('para', array('ul', 'ol', 'paragraph')),
        array('insert', array('link', 'table', 'hr')),
        array('insert', array('undo', 'redo'))
      )
    );
  }

  public static function getPianiPregressi( $comuneID )
  {
    $result = array();
    $fetch_parameters = array(
      'query' => '',
      'class_id' => array('piano_comunale'),
      'filter' => array('submeta_organizzazione___id____si:' . $comuneID )
    );
    $searchResult = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);
    if ($searchResult['SearchCount'] > 0) {
      foreach ($searchResult['SearchResult'] as $s) {
        $result []= $s->ContentObject->attribute('id');
      }
    }
    return $result;
  }

  public static function getMacroambiti( $pianoID ) {
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
        $actions = self::getAzioniByMacroambito($s->ContentObject->ID, $pianoID);
        $temp['azioni'] = $actions['actions'];
        $result []= $temp;
        unset($temp);
      }
    }
    return $result;
  }

  public static function getAzioniByMacroambito($macroambitoID, $pianoID)
  {
    $result = array();
    $fetch_parameters = array(
      'query' => '',
      'class_id' => array('azione'),
      'filter' => array('submeta_macroambito___id____si:' . $macroambitoID .  ' AND submeta_piano_comunale___id____si:' . $pianoID)
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

}
