<?php


class HideContentHandler extends SQLIImportAbstractHandler implements ISQLIImportHandler
{
  protected $rowIndex = 0;
  protected $rowCount;
  protected $currentGUID;

  protected $class  = 'iconografia';
  protected $logFile = 'HideContentHandler.log';

  /**
   * Constructor
   */
  public function __construct(SQLIImportHandlerOptions $options = null)
  {
    parent::__construct($options);
  }

  public function initialize()
  {
    try {

      $objects = array();


      // Recupero le organizzazioni
      $fetch_parameters = array(
        'class_id'  => array('public_organization,private_organization'),
        'filter'    => array( 'attr_visibilita_b:false'),
        'limit'     => array(1000)
      );
      $result = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);


      if ( $result['SearchCount'] > 0 )
      {
        foreach ($result['SearchResult'] as $item) {
          $objects []= $item->ContentObjectID;
          /*$node = eZContentObjectTreeNode::fetch($item->MainNodeID);
          eZContentObjectTreeNode::hideSubTree($node);*/
        }
      }

      // Recupero le certificazioni
      $time = new DateTime( 'now', new DateTimeZone('UTC') );
      $value = '"' . ezfSolrDocumentFieldBase::convertTimestampToDate( $time->format('U') ) . '"';


      $fetch_parameters = array(
        'class_id'  => array('adesione_distretto_famiglia, adesione_network_nazionale, adesione_family_card, certificazione_familyaudit, certificazione_familyineuropa, certificazione_familyinitalia, certificazione_familyintrentino', 'welfare_aziendale_territoriale'),
        'filter'    => array( 'attr_data_scadenza_dt:[* TO '. $value .']'),
        'limit'     => array(1000)
      );
      $result = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);


      if ( $result['SearchCount'] > 0 )
      {
        foreach ($result['SearchResult'] as $item) {
          $objects []= $item->ContentObjectID;
          /*$node = eZContentObjectTreeNode::fetch($item->MainNodeID);
          eZContentObjectTreeNode::hideSubTree($node);*/
        }
      }


      $this->dataSource = $objects;

    } catch (Exception $ex) {
      eZLog::write($ex->getMessage(), $this->logFile);
      $this->cli->error($ex->getMessage());
      exit;
    }
  }

  public function getProcessLength()
  {
    if (!isset($this->rowCount)) {
      $this->rowCount = count($this->dataSource);
    }
    return $this->rowCount;
  }


  public function getNextRow()
  {
    if ($this->rowIndex < $this->rowCount) {
      $row = $this->dataSource[$this->rowIndex];
      $this->rowIndex++;
    } else {
      $row = false; // We must return false if we already processed all rows
    }
    return $row;
  }

  public function cleanup()
  {
    return;
  }

  public function process($row)
  {

    $db = eZDB::instance();
    $db->setErrorHandling(eZDB::ERROR_HANDLING_EXCEPTIONS);

    try {

      $this->currentGUID = $row;
      eZLog::write('Nascondo oggetto con ID: ' . $row, $this->logFile);



      $object = eZContentObject::fetch($row);
      $node = $object->mainNode();
      eZContentObjectTreeNode::hideSubTree($node);


    } catch (eZDBException $e) {
      $this->cli->error($e->getMessage());
      $this->cli->error($e->getTraceAsString());
      $db->rollback();
      eZLog::write(var_export($e->getTrace(), 1), 'madput.log');
      eZLog::write(print_r($row, 1), 'rowmadput.log');
    } catch (Exception $e) {
      eZLog::write($e->getMessage(), $this->logFile);
      eZLog::write(var_export($row, 1), $this->logFile);
      $this->cli->error($e->getMessage());
    }

  }

  public function getHandlerIdentifier()
  {
    return 'hidecontenthandler';

  }

  public function getHandlerName()
  {
    return 'Hide Content Handler';
  }

  public function getProgressionNotes()
  {
    return 'Currently importing : ' . $this->currentGUID;
  }

}

?>
