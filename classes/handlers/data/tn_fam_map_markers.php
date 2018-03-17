<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;


class DataHandlerTnFamMapMarkers implements OpenPADataHandlerInterface
{
  public $contentType = 'geojson';

  public function __construct(array $Params)
  {
    $this->contentType = eZHTTPTool::instance()->getVariable('contentType', $this->contentType);

  }

  public function getData()
  {
    if ($this->contentType == 'geojson') {
      $parentNode = eZHTTPTool::instance()->getVariable('parentNode', 0);
      $featureData = new DataHandlerTnFamMapMarkersGeoJsonFeatureCollection();



      $contentRepository = new ContentRepository();
      $contentSearch = new ContentSearch();

      $currentEnvironment = new FullEnvironmentSettings();
      $contentRepository->setEnvironment( $currentEnvironment );
      $contentSearch->setEnvironment( $currentEnvironment );

      $parser = new ezpRestHttpRequestParser();
      $request = $parser->createRequest();
      $currentEnvironment->__set('request', $request);

      $query = false;
      /*if (isset( $this->currentCustomAttributes['query'] )) {
        $query = (string)$this->currentCustomAttributes['query'];
      }*/


      if ( isset($request->get) /*$parentNode > 0*/) {
        $result = false;
        //$classIdentifiers = eZHTTPTool::instance()->getVariable('classIdentifiers', false);

        //$query = "classes [certificazione_familyaudit] subtree [{$parentNode}] limit 500 facets [stato_certificazione|alpha|100]";
        $query = $request->get['query'] . ' limit 500';


        $language = eZLocale::currentLocaleCode();
        try {
          $data = $contentSearch->search($query);



          if ($data->totalCount > 0)
          {
            $result['facets'] = $data->facets;

            foreach ($data->searchHits as $hit) {
              try {

                $geoObject = eZContentObject::fetch($hit['data'][$language]['id_unico']['content'][0]['id']);

                if ($geoObject instanceof eZContentObject)
                {

                  $properties = array(
                    'id'           => $hit['metadata']['id'],
                    'type'        => $hit['metadata']['classIdentifier'],
                    'class'        => $hit['metadata']['classIdentifier'],
                    'name'         => $hit['metadata']['name'][$language],
                    'url'          => '/content/view/full/' . $hit['metadata']['mainNodeId'],
                    'popupContent' => '<em>Loading...</em>'
                  );

                  $geoDataMap = $geoObject->dataMap();
                  if ($geoDataMap['geo']->hasContent())
                  {
                    $geoData    = $geoDataMap['geo']->content();
                    $feature = new DataHandlerTnFamMapMarkersGeoJsonFeature($hit['metadata']['id'], array($geoData->longitude, $geoData->latitude), $properties);
                    $featureData->add($feature);
                  }
                }
              } catch (Exception $e) {
                eZDebug::writeError($e->getMessage(), __METHOD__);
              }
            }

            $result['content'] = $featureData;
            return $result;
          }

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
