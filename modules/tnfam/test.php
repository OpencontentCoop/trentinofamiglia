<?php

/** @var eZModule $Module */
$Module = $Params['Module'];
$tpl = eZTemplate::factory();


$object = eZContentObject::fetch(40725);
echo '<pre>';
print_r($object);
exit;

$dataMap = $object->dataMap();
$content = $dataMap['tipo_azione']->content();


echo '<pre>';
echo $content['relation_list'][0]['contentobject_id'];
exit;


/*$fetch_parameters = array(
  'class_id'  => array('public_organization,private_organization'),
  'filter'    => array( 'attr_visibilita_b:false'),
  'limit'     => array(1000)
);
$result = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);

if ( $result['SearchCount'] > 0 )
{
  foreach ($result['SearchResult'] as $item) {
    $node = eZContentObjectTreeNode::fetch($item->MainNodeID);
    eZContentObjectTreeNode::hideSubTree($node);
  }
}*/


$time = new DateTime( 'now', new DateTimeZone('UTC') );
$value = '"' . ezfSolrDocumentFieldBase::convertTimestampToDate( $time->format('U') ) . '"';


$fetch_parameters = array(
  'class_id'  => array('adesione_distretto_famiglia, adesione_network_nazionale, adesione_family_card, certificazione_familyaudit, certificazione_familyineuropa, certificazione_familyinitalia, certificazione_familyintrentino'),
  'filter'    => array( 'attr_data_scadenza_dt:[* TO '. $value .']'),
  'limit'     => array(1000)
);


$result = eZFunctionHandler::execute('ezfind', 'search', $fetch_parameters);

echo '<pre>';
print_r($result);

exit;


//data_det_revoca
