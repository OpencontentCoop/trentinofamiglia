<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;
use Opencontent\Opendata\Api\Values\SearchResults;
use Opencontent\Opendata\GeoJson\FeatureCollection;
use Opencontent\Opendata\GeoJson\Feature;

class DataHandlerTnFamMapMarkers implements OpenPADataHandlerInterface
{
    public $contentType = 'geojson';

    private $query;

    private $attributes;

    private $attributesString;

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

            if ($this->block instanceof eZPageBlock && $this->block->attribute('type') == "MappaTnFam") {
                $attributes = $this->block->attribute('custom_attributes');

                $this->query = $attributes['query'];
                if (eZHTTPTool::instance()->hasGetVariable('q')){
                    $this->query .= ' and ' . urldecode(eZHTTPTool::instance()->getVariable('q'));
                }

                $this->attributes = explode(',', $attributes['attribute']);
            } else {
                if (eZHTTPTool::instance()->hasGetVariable('query')){
                    $this->query = eZHTTPTool::instance()->getVariable('query');
                }

                if (eZHTTPTool::instance()->hasGetVariable('attribute')){
                    $this->attributesString = eZHTTPTool::instance()->getVariable('attribute');
                    $this->attributes = explode(',', $this->attributesString);
                }
            }
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

        }elseif ($this->query && $this->attributes) {

            $blockId = $this->block ? $this->block->attribute('id') : '';
            $hashIdentifier = md5(trim($blockId . '-' . $this->query . '-' . $this->attributesString));

            return MapsCacheManager::getCacheManager($hashIdentifier)->processCache(
                array('MapsCacheManager', 'retrieveCache'),
                function() use($blockId){
                    $handler = new DataHandlerTnFamMapMarkers(array('Parameters' => array(1 => $blockId)));
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

    protected function findAll($query = null)
    {
        if ($query === null)
            $query = $this->query;

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

        while ($query) {
            $this->queryList[] = $query;
            $results = $contentSearch->search($query);
            $count = $results->totalCount;
            $hits = array_merge($hits, $results->searchHits);
            $facets = $results->facets;
            $query = $results->nextPageQuery;
        }

        $result = new SearchResults();
        $result->searchHits = $hits;
        $result->totalCount = $count;
        $result->facets = $facets;

        return $result;
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

        $collection = new FeatureCollection();
        $language = eZLocale::currentLocaleCode();
        try {

            $data = $this->findAll();
            $collection->facets = $data->facets;

            $searchIdList = array();
            foreach ($data->searchHits as $hit) {
                foreach ($this->attributes as $attribute) {
                    if (isset($hit['data'][$language][$attribute])) {
                        foreach ($hit['data'][$language][$attribute]['content'] as $gObject) {
                            $searchIdList[$gObject['id']] = $gObject['id'];
                        }
                    }
                }
            }

            $idList = array_unique($searchIdList);

            $count = 0;
            $features = array();

            foreach ($idList as $id) {
                $object = eZContentObject::fetch((int)$id);
                if ($object instanceof eZContentObject){
                    $count++;
                    $features[] = Content::createFromEzContentObject($object)->geoJsonSerialize(eZLocale::currentLocaleCode());
                }
            }

            // $searchIdListChunks = array_chunk($searchIdList, 20);
            // foreach ($searchIdListChunks as $searchIdListChunk) {
            //     $query = 'id = [' . implode(',', array_unique($searchIdListChunk)) . ']';
            //     while ($query) {
            //         $this->queryList[] = $query;
            //         $results = $contentSearch->search($query);

            //         $count += $results->totalCount;
            //         $features = array_merge($features, $results->features);
            //         $query = $results->nextPageQuery;
            //     }
            // }

            $collection->query = $this->queryList;
            $collection->features = $features;
            $collection->totalCount = $count;


            return $collection;

        } catch (Exception $e) {
            return array(
                'error' => $e->getMessage(),
                'query' => $this->queryList
            );
        }
    }
}
