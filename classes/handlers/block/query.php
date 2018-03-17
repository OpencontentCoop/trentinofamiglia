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
        }

        $language = eZLocale::currentLocaleCode();

        $this->data['root_node'] = false;
        $this->data['has_content'] = false;
        $this->data['content'] = array();

        try{
        	$data = $contentSearch->search($query);

        	$nodeIdList = array();
        	foreach ($data->searchHits as $hit) {
        		try{
        			$content = new Content($hit); 		        			
    				$nodeIdList[] = $content->metadata->mainNodeId;
				}catch(Exception $e){
		        	eZDebug::writeError($e->getMessage(), __METHOD__);
		        }
        	}

        	if (!empty($nodeIdList)){
        		$nodes = eZContentObjectTreeNode::fetch($nodeIdList);	
        		if (!is_array($nodes)){
        			$nodes = array($nodes);
        		}
        		$this->data['has_content'] = count($nodeIdList) > 0;
        		$this->data['content'] = $nodes;
        		$this->data['root_node'] = $this->data['content'][0];
        	}        

        }catch(Exception $e){
        	eZDebug::writeError($e->getMessage() . " in query $query", __METHOD__);
        }
    
    }

}