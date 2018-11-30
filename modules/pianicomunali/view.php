<?php

/** @var eZModule $module */
$module = $Params['Module'];
$http   = eZHTTPTool::instance();
$tpl    = eZTemplate::factory();


$id    = $Params['ID'];
$piano = eZContentObject::fetch($id);

if (!$piano instanceof eZContentObject) {
  return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );
}

$tpl->setVariable('piano', $piano);

$Result = array();
$Result['content'] = $tpl->fetch( "design:pianicomunali/view.tpl" );
$Result['path'] = array( array( 'url' => false, 'text' => 'Piano comunale' ) );


/*echo $tpl->fetch( 'design:pianicomunali/view.tpl' );
eZDisplayDebug();
eZExecution::cleanExit();*/

?>
