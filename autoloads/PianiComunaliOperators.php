<?php

class PianiComunaliOperators
{
  /**
   * Returns the list of template operators this class supports
   *
   * @return array
   */
  function operatorList()
  {
    return array(
      'get_macroambiti'
    );
  }

  /**
   * Indicates if the template operators have named parameters
   *
   * @return bool
   */
  function namedParameterPerOperator()
  {
    return true;
  }

  /**
   * Returns the list of template operator parameters
   *
   * @return array
   */
  function namedParameterList()
  {
    return array(
      'get_macroambiti' => array(
        'piano' => array('type' => 'string', 'required' => true)
      ),
    );
  }


  /**
   * @param $tpl
   * @param $operatorName
   * @param $operatorParameters
   * @param $rootNamespace
   * @param $currentNamespace
   * @param $operatorValue
   * @param $namedParameters
   * @param $placement
   * @return array
   */
  function modify($tpl, $operatorName, $operatorParameters, $rootNamespace, $currentNamespace, &$operatorValue, $namedParameters, $placement)
  {
    switch ($operatorName) {

      case 'get_macroambiti':
        $operatorValue = PianiComunaliHelper::getMacroambiti($namedParameters['piano']);
        return $operatorValue;
        break;

    }
  }
}
