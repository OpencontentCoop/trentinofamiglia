<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;


class DataHandlerTnFamMapMarkers implements OpenPADataHandlerInterface
{
  public $contentType = 'geojson';

  private $contentRepository;

  private $contentSearch;

  private $currentEnvironment;

  public function __construct(array $Params)
  {
    $this->contentType = eZHTTPTool::instance()->getVariable('contentType', $this->contentType);
    $this->contentRepository = new ContentRepository();
    $this->contentSearch = new ContentSearch();

    $this->currentEnvironment = new FullEnvironmentSettings();
    $parser = new ezpRestHttpRequestParser();
    $request = $parser->createRequest();
    $this->currentEnvironment->__set('request', $request);

    $this->contentRepository->setEnvironment($this->currentEnvironment);
    $this->contentSearch->setEnvironment($this->currentEnvironment);

  }

  private function findAll($query, $languageCode = null, array $limitation = null)
  {
    $hits = array();
    $count = 0;
    $facets = array();
    $query .= ' and limit ' . $this->currentEnvironment->getMaxSearchLimit();
    eZDebug::writeNotice($query, __METHOD__);
    while ($query) {
      $results = $this->contentSearch->search($query, $limitation);
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

  public function getData()
  {
    if ($this->contentType == 'geojson') {
      $featureData = new DataHandlerTnFamMapMarkersGeoJsonFeatureCollection();

      $query = false;

      if (eZHTTPTool::instance()->hasGetVariable('query') && eZHTTPTool::instance()->hasGetVariable('attribute')) {

        $result = false;
        $query = eZHTTPTool::instance()->getVariable('query');
        $attribute = eZHTTPTool::instance()->getVariable('attribute');
        $language = eZLocale::currentLocaleCode();
        try {
          $data = $this->findAll($query, $language);

          $result['facets'] = $data->facets;

          foreach ($data->searchHits as $hit) {
            try {
              $geoObject = eZContentObject::fetch($hit['data'][$language][$attribute]['content'][0]['id']);

              if ($geoObject instanceof eZContentObject) {
                $properties = array(
                  'id' => $hit['metadata']['id'],
                  'type' => $hit['metadata']['classIdentifier'],
                  'class' => $hit['metadata']['classIdentifier'],
                  'name' => $hit['metadata']['name'][$language],
                  'url' => '/content/view/full/' . $hit['metadata']['mainNodeId'],
                  'popupContent' => '<em>Loading...</em>'
                );

                $geoDataMap = $geoObject->dataMap();
                if ($geoDataMap['geo']->hasContent()) {
                  $geoData = $geoDataMap['geo']->content();
                  $feature = new DataHandlerTnFamMapMarkersGeoJsonFeature($hit['metadata']['id'],
                    array($geoData->longitude, $geoData->latitude), $properties);
                  $featureData->add($feature);
                }
              }
            } catch (Exception $e) {
              eZDebug::writeError($e->getMessage(), __METHOD__);
            }
          }

          $result['content'] = $featureData;

          return $result;

        } catch (Exception $e) {
          eZDebug::writeError($e->getMessage() . " in query $query", __METHOD__);
        }
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


class DataHandlerTnFamMapMarkersGeoJsonFeatureCollection
{
  public $type = 'FeatureCollection';
  public $features = array();

  public function add(DataHandlerTnFamMapMarkersGeoJsonFeature $feature)
  {
    $this->features[] = $feature;
  }
}

class DataHandlerTnFamMapMarkersGeoJsonFeature
{
  public $type = "Feature";
  public $id;
  public $properties;
  public $geometry;

  public function __construct($id, array $geometryArray, array $properties)
  {
    $this->id = $id;

    $this->geometry = new DataHandlerTnFamMapMarkersGeoJsonGeometry();
    $this->geometry->coordinates = $geometryArray;

    $this->properties = new DataHandlerTnFamMapMarkersGeoJsonProperties($properties);
  }
}

class DataHandlerTnFamMapMarkersGeoJsonGeometry
{
  public $type = "Point";
  public $coordinates;
}

class DataHandlerTnFamMapMarkersGeoJsonProperties
{
  public function __construct(array $properties = array())
  {
    foreach ($properties as $key => $value) {
      $this->{$key} = $value;
    }
  }
}
