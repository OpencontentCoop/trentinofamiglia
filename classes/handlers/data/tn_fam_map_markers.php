<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;


class DataHandlerTnFamMapMarkers implements OpenPADataHandlerInterface
{

  public $contentType = 'geojson';

  private $query = '';
  private $attributes = '';
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

    if (!isset($this->maps[$hashIdentifier])) {
      $this->maps[$hashIdentifier] = MapsCacheManager::getCacheManager($hashIdentifier)->processCache(
        array('MapsCacheManager', 'retrieveCache'),
        array(__CLASS__, 'generateCache'),
        null,
        null,
        $args
      );
    }
    return $this->maps[$hashIdentifier];
  }

  public static function generateCache( $file, $args )
  {

    extract( $args );
    $content = self::find( $query, $attributes);

    return array(
      'content' => $content,
      'scope' => 'maps-cache',
      'datatype' => 'php',
      'store' => true
    );
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
    $featureData = new DataHandlerTnFamMapMarkersGeoJsonFeatureCollection();
    $language    = eZLocale::currentLocaleCode();
    try {
      $data = self::findAll($query, $language);
      $result['facets'] = $data->facets;

      foreach ($data->searchHits as $hit) {
        try {
          foreach ($attributes as $attribute)
          {
            if (isset($hit['data'][$language][$attribute]))
            {
              foreach ($hit['data'][$language][$attribute]['content'] as $gObject)
              {
                $geoObjectId = $gObject['id'];
                $geoObject = eZContentObject::fetch($geoObjectId);

                if ($geoObject instanceof eZContentObject) {
                  $properties = array(
                    /*'id' => $hit['metadata']['id'],*/
                    'id' => $geoObjectId,
                    'type' => $hit['metadata']['classIdentifier'],
                    'class' => $hit['metadata']['classIdentifier'],
                    'name' => $hit['metadata']['name'][$language],
                    'url' => '/content/view/full/' . $hit['metadata']['mainNodeId'],
                    'popupContent' => '<em>Loading...</em>'
                  );

                  $geoDataMap = $geoObject->dataMap();
                  if ($geoDataMap['geo']->hasContent()) {
                    $geoData = $geoDataMap['geo']->content();
                    /*$feature = new DataHandlerTnFamMapMarkersGeoJsonFeature($hit['metadata']['id'],
                      array($geoData->longitude, $geoData->latitude), $properties);*/
                    $feature = new DataHandlerTnFamMapMarkersGeoJsonFeature($geoObjectId,
                      array($geoData->longitude, $geoData->latitude), $properties);
                    $featureData->add($feature);
                  }
                }
              }
            }
          }

        } catch (Exception $e) {
          eZDebug::writeError($e->getMessage(), __METHOD__);
        }
      }
      return serialize( $featureData );

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

        $result['content'] = json_decode( $this->load( md5(trim($this->query . '-' . implode('-', $this->attributes))) ), true ) ;
        return $result;

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
  public $featuresIndex = array();

  public function add(DataHandlerTnFamMapMarkersGeoJsonFeature $feature)
  {
    if (!isset($this->featuresIndex[$feature->id]))
    {
      $this->featuresIndex[$feature->id] = $feature;
      $this->features[] = $feature;
    }
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
