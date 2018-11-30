<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;
use Opencontent\Opendata\GeoJson\FeatureCollection;
use Opencontent\Opendata\GeoJson\Feature;


class DataHandlerTnFamReverseMapMarkers extends DataHandlerTnFamMapMarkers
{

    public $contentType = 'geojson';

    private $classIdentifier;

    private $query;

    private $attribute;

    private $block;

    private $queryList = array();

    public function __construct(array $Params)
    {
        if (eZHTTPTool::instance()->hasGetVariable('contentType')){
            $this->contentType = eZHTTPTool::instance()->getVariable('contentType');
        }
        
        if ($this->contentType == 'geojson'){
            if (isset($Params['Parameters'][1])) {
                $blockId = $Params['Parameters'][1];
                $this->block = eZPageBlock::fetch($blockId);
            }

            if ($this->block instanceof eZPageBlock && $this->block->attribute('type') == "MappaTnFamReverse") {
                $attributes = $this->block->attribute('custom_attributes');

                $this->query = $attributes['query'];
                if (eZHTTPTool::instance()->hasGetVariable('q')){
                    $this->query .= ' and ' . urldecode(eZHTTPTool::instance()->getVariable('q'));
                }
                $this->classIdentifier = $attributes['class'];
                $this->attribute = $attributes['attribute'];
            } else {
                if (eZHTTPTool::instance()->hasGetVariable('query')){
                    $this->query = eZHTTPTool::instance()->getVariable('query');
                }

                if (eZHTTPTool::instance()->hasGetVariable('attribute')){
                    $this->attribute = eZHTTPTool::instance()->getVariable('attribute');                    
                }

                if (eZHTTPTool::instance()->hasGetVariable('classIdentifier')){
                    $this->classIdentifier = eZHTTPTool::instance()->getVariable('classIdentifier');                    
                }
            }
        }
    }

    public function find()
    {
        $contentRepository = new ContentRepository();
        $contentSearch = new ContentSearch();
        $currentEnvironment = new TNFamGeoEnvironmentSettings(); //@todo override per bug di GeoEnvironmentSettings
        $parser = new ezpRestHttpRequestParser();
        $request = $parser->createRequest();
        $currentEnvironment->__set('request', $request);
        $contentRepository->setEnvironment($currentEnvironment);
        $contentSearch->setEnvironment($currentEnvironment);

        try {
            $collection = new FeatureCollection();  
            $language = eZLocale::currentLocaleCode();

            $classQuery = "classes [{$this->classIdentifier}]";

            $data = $this->findAll($classQuery);
            $searchIdList = array();

            if ($data->totalCount > 0) {
                foreach ($data->searchHits as $hit) {
                    if (isset($hit['data'][$language][$this->attribute]['content'][0]['id'])){
                        $searchIdList [] = $hit['data'][$language][$this->attribute]['content'][0]['id'];
                    }
                }
            }
            array_unique($searchIdList);

            $count = 0;
            $features = array();
            $facets = array();
            $query = $this->query . ' and id = [' . implode(',', array_unique($searchIdList)) . ']';
            while ($query) {
                $this->queryList[] = $query;
                $results = $contentSearch->search($query);
                $facets = $results->facets;
                $count = $results->totalCount;
                $features = array_merge($features, $results->features);                
                $query = $results->nextPageQuery;
            }
            
            $collection->facets = $facets;
            $collection->query = $this->queryList;
            $collection->features = $features;
            $collection->totalCount = $count;

            return $collection;

        } catch (Exception $e) {            
            return array('error' => $e->getMessage());
        }
    }

    public function getData()
    {
        if ($this->contentType == 'marker'){

            $view = eZHTTPTool::instance()->variable('view', 'panel');
            $id = eZHTTPTool::instance()->variable('id', 0);
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

        }elseif ($this->query && $this->attribute && $this->classIdentifier) {
            
            $blockId = $this->block ? $this->block->attribute('id') : '';       
            $hashIdentifier = md5(trim($blockId . '-' . $this->query . '-' . $this->attribute . '-' . $this->classIdentifier));

            return MapsCacheManager::getCacheManager($hashIdentifier)->processCache(
                array('MapsCacheManager', 'retrieveCache'),
                function() use($blockId){
                    $handler = new DataHandlerTnFamReverseMapMarkers(array('Parameters' => array(1 => $blockId)));
                    $content = $handler->find();

                    return array(
                      'content' => json_decode(json_encode($content), true),
                      'scope' => 'maps-cache',
                      'datatype' => 'php',
                      'store' => true
                    );
                }                
            );            
        } 

        return array('error' => 'Bad request');    
    }
}

