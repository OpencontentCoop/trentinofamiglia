<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;


class DataHandlerTnFamMapPianoComunaleMarkers implements OpenPADataHandlerInterface
{

  public $contentType = 'geojson';

  private $query = '';
  private $attributes = '';
  private $object;
  private $maps = array();


  public function __construct(array $Params)
  {
    $this->contentType = eZHTTPTool::instance()->getVariable('contentType', $this->contentType);
  }


  private function load( $hashIdentifier )
  {
    $query      = $this->query;

    $attributes = $this->attributes;
    $args = compact(array("hashIdentifier", "query", "attributes"));


    return self::find($query, $attributes);

  }

  protected static function findAll($query, $languageCode = null, array $limitation = null)
  {

    $contentRepository = new ContentRepository();
    $contentSearch = new ContentSearch();
    $currentEnvironment = new FullEnvironmentSettings();
    $parser = new ezpRestHttpRequestParser();
    $request = $parser->createRequest();
    $currentEnvironment->__set('request', $request);

    $contentRepository->setEnvironment($currentEnvironment);
    $contentSearch->setEnvironment($currentEnvironment);


    $hits = array();
    $count = 0;
    $facets = array();
    $query .= ' and limit ' . $currentEnvironment->getMaxSearchLimit();
    eZDebug::writeNotice($query, __METHOD__);
    while ($query) {
      $results = $contentSearch->search($query, $limitation);
      $count = $results->totalCount;
      $hits = array_merge($hits, $results->searchHits);
      $facets = $results->facets;
      $query = $results->nextPageQuery;
    }

    $result = new \Opencontent\Opendata\Api\Values\SearchResults();
    $result->searchHits = $hits;
    $result->totalCount = $count;
    $result->facets = $facets;

    return $result;
  }

  protected static function find( $query, $attributes)
  {
    $featureData = new DataHandlerTnFamMapPianoComunaleMarkersGeoJsonFeatureCollection();
    $language    = eZLocale::currentLocaleCode();
    try {

      $geo = array();;
      $object = eZContentObject::fetch($query);
      if ($object instanceof eZContentObject) {
        $dataMap = $object->dataMap();

        if ($dataMap['organizzazione']->hasContent()) {
          $content = $dataMap['organizzazione']->content();
          foreach ( $content['relation_list'] as $c) {
            $geo[]= $c['contentobject_id'];
          }
        }

        if ($dataMap['infrastrutture_family']->hasContent()) {
          $content = $dataMap['infrastrutture_family']->content();
          foreach ( $content['relation_list'] as $c) {
            $geo[]= $c['contentobject_id'];
          }
        }
      }

      foreach ($geo as $gObject)
      {
        $geoObjectId = $gObject;
        $geoObject = eZContentObject::fetch($geoObjectId);

        if ($geoObject instanceof eZContentObject) {
          $properties = array(
            /*'id' => $hit['metadata']['id'],*/
            'id' => $geoObjectId,
            'type' => $geoObject->attribute('class_identifier'),
            'class' => $geoObject->attribute('class_identifier'),
            'name' => $geoObject->Name,
            'url' => '/content/view/full/' . $geoObject->mainNodeID(),
            'popupContent' => '<em>Loading...</em>'
          );

          $geoDataMap = $geoObject->dataMap();
          if ($geoDataMap['geo']->hasContent()) {
            $geoData = $geoDataMap['geo']->content();
            /*$feature = new DataHandlerTnFamMapPianoComunaleMarkersGeoJsonFeature($hit['metadata']['id'],
              array($geoData->longitude, $geoData->latitude), $properties);*/
            $feature = new DataHandlerTnFamMapPianoComunaleMarkersGeoJsonFeature($geoObjectId,
              array($geoData->longitude, $geoData->latitude), $properties);
            $featureData->add($feature);
          }
        }
      }
      $result['facets'] = [];
      $result['content'] =  $featureData;


      return json_encode($result);

    } catch (Exception $e) {
      eZDebug::writeError($e->getMessage() . " in query $query", __METHOD__);
    }
  }


  public function getData()
  {
    if ($this->contentType == 'geojson') {

      if (eZHTTPTool::instance()->hasGetVariable('query') && eZHTTPTool::instance()->hasGetVariable('attribute')) {
        $this->query = eZHTTPTool::instance()->getVariable('query');
        $this->attributes = explode(',', eZHTTPTool::instance()->getVariable('attribute'));

        return  json_decode( $this->load( md5(trim($this->query . '-' . implode('-', $this->attributes))) ), true ) ;

      }
    } elseif ($this->contentType == 'marker') {
      $view = eZHTTPTool::instance()->getVariable('view', 'panel');
      $id = eZHTTPTool::instance()->getVariable('id', 0);
      $object = eZContentObject::fetch($id);
      if ($object instanceof eZContentObject && $object->attribute('can_read')) {
        $tpl = eZTemplate::factory();
        $tpl->setVariable('object', $object);
        $tpl->setVariable('node', $object->attribute('main_node'));
        $result = $tpl->fetch('design:node/view/' . $view . '.tpl');
        $data = array('content' => $result);
      } else {
        $data = array('content' => '<em>Private</em>');
      }

      return $data;
    }

    return null;
  }
}


class DataHandlerTnFamMapPianoComunaleMarkersGeoJsonFeatureCollection
{
  public $type = 'FeatureCollection';
  public $features = array();
  public $featuresIndex = array();

  public function add(DataHandlerTnFamMapPianoComunaleMarkersGeoJsonFeature $feature)
  {
    if (!isset($this->featuresIndex[$feature->id]))
    {
      $this->featuresIndex[$feature->id] = $feature;
      $this->features[] = $feature;
    }
  }
}

class DataHandlerTnFamMapPianoComunaleMarkersGeoJsonFeature
{
  public $type = "Feature";
  public $id;
  public $properties;
  public $geometry;

  public function __construct($id, array $geometryArray, array $properties)
  {
    $this->id = $id;

    $this->geometry = new DataHandlerTnFamMapPianoComunaleMarkersGeoJsonGeometry();
    $this->geometry->coordinates = $geometryArray;

    $this->properties = new DataHandlerTnFamMapPianoComunaleMarkersGeoJsonProperties($properties);
  }
}

class DataHandlerTnFamMapPianoComunaleMarkersGeoJsonGeometry
{
  public $type = "Point";
  public $coordinates;
}

class DataHandlerTnFamMapPianoComunaleMarkersGeoJsonProperties
{
  public function __construct(array $properties = array())
  {
    foreach ($properties as $key => $value) {
      $this->{$key} = $value;
    }
  }
}
