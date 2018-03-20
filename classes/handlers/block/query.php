<?php

use Opencontent\Opendata\Api\ContentRepository;
use Opencontent\Opendata\Api\ContentSearch;
use Opencontent\Opendata\Api\Values\Content;


class BlockHandlerQuery extends OpenPABlockHandler
{

	protected function run()
    {
        
        $contentRepository = new ContentRepository();	    
	    $contentSearch = new ContentSearch();

	    $currentEnvironment = new FullEnvironmentSettings();
        $contentRepository->setEnvironment( $currentEnvironment );        
        $contentSearch->setEnvironment( $currentEnvironment );

        $parser = new ezpRestHttpRequestParser();
        $request = $parser->createRequest();
        $currentEnvironment->__set('request', $request);

        $query = false;
        if (isset( $this->currentCustomAttributes['query'] )) {
        	$query = (string)$this->currentCustomAttributes['query'];
            eZDebug::writeDebug($query, __METHOD__);
        }

        $language = eZLocale::currentLocaleCode();

        $this->data['root_node'] = false;
        $this->data['has_content'] = false;
        $this->data['content'] = array();

        try{
        	$data = $contentSearch->search($query);

        	$nodes = array();
        	foreach ($data->searchHits as $hit) {
        		try{
        			$content = new Content($hit);
                    $object = $content->getContentObject($language);
                    if ($object instanceof eZContentObject){
    				    $nodes[] = $object->mainNode();
                    }
				}catch(Exception $e){
		        	eZDebug::writeError($e->getMessage(), __METHOD__);
		        }
        	}

        	if (!empty($nodes)){        		
        		$this->data['has_content'] = count($nodes) > 0;
        		$this->data['content'] = $nodes;
        		$this->data['root_node'] = $this->data['content'][0];
        	}        

        }catch(Exception $e){
        	eZDebug::writeError($e->getMessage() . " in query $query", __METHOD__);
        }
    
    }

}