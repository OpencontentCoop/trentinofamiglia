<?php
$Module = array('name' => 'Trentinofamiglia');

$ViewList = array();
$ViewList['test'] = array(
    'script' => 'test.php',
    'functions' => array('test')
);
$ViewList['tsm'] = array(
    'script' => 'tsm.php',
    'params' => array('Identifier'),
    'functions' => array('tsm')
);

$FunctionList = array();
$FunctionList['test'] = array();
$FunctionList['tsm'] = array();
