<?php

$Module = $Params['Module'];
$requestIdentifier = $Params['Identifier'];
$tpl = eZTemplate::factory();

$modules = array();
$fileList = eZDir::recursiveFind(eZSys::rootDir() . '/extension/trentinofamiglia/design/trentinofamiglia/templates/tsm', '.tpl');
foreach ($fileList as $file) {
	$fileName = basename($file);
	$identifier = str_replace('.tpl', '', $fileName);
	if ($identifier == 'summary'){
		continue;
	}
	$name = implode(' ', explode('-', $identifier));
	$modules[strtolower($identifier)] = $name;

	if (strtolower($identifier) == strtolower($requestIdentifier)){
		$requestIdentifier = $identifier;
	}
}

if ($requestIdentifier){
	$templateUri = 'design:tsm/' . $requestIdentifier . '.tpl';
	$result = $tpl->loadURIRoot( $templateUri, false, $extraParameters );

	if ($result){
		echo $tpl->fetch($templateUri);
		eZDisplayDebug();
		eZExecution::cleanExit();
	}
}

$tpl->setVariable( 'modules', $modules );
$Result = array(
    'path' => array(array( 'url' => false, 'text' => 'Trentino School of Management' )        ),
    'content' => $tpl->fetch( 'design:tsm/summary.tpl' )
);
