<?php

use Opencontent\Opendata\Api\Values\ExtraData;
use Opencontent\Opendata\Api\Values\ExtraDataProviderInterface;

class ezfIndexTnFam implements ezfIndexPlugin, ExtraDataProviderInterface
{
  /**
   * @param eZContentObject $contentObject
   * @param eZSolrDoc[] $docList
   */
  public function modify(eZContentObject $contentObject, &$docList)
  {

    $version = $contentObject->currentVersion();
    $dataMap = $contentObject->dataMap();

    try {

      /*$availableLanguages = $contentObject->currentVersion()->translationList(false, false);
      if ($contentObject->attribute('class_identifier') == 'adesione_distretto_famiglia') {

        if ($dataMap['organizzazione_aderente']->hasContent()) {
          $attributeContent = $dataMap['organizzazione_aderente']->content();
          foreach ($attributeContent['relation_list'] as $objId) {
            $relatedObj = eZContentObject::fetch($objId['contentobject_id']);
            if ($relatedObj instanceof eZContentObject) {
              $relatedObjDataMap = $relatedObj->dataMap();

              if ($relatedObjDataMap['comunita']->hasContent()) {
                $content = $relatedObjDataMap['comunita']->content();
                foreach ($content->tags() as $tag) {
                  foreach ($availableLanguages as $languageCode) {
                    $docList[$languageCode]->addField('organizzazione_aderente_comunita____s', $tag->Keyword);
                  }
                }
              }
            }
          }
        }
      }*/

      if (isset($dataMap['id_unico']) && $dataMap['id_unico']->hasContent()) {
        $content = $dataMap['id_unico']->content();
        foreach ($content['relation_list'] as $c ) {
          $location = eZContentObject::fetch($c['contentobject_id']);
          if ($location instanceof eZContentObject) {
            $locationDataMap = $location->dataMap();
            if (isset($locationDataMap['nome_comune']) && $locationDataMap['nome_comune']->hasContent()) {
              $this->addToDocList($version, $docList, 'comune____s', $locationDataMap['nome_comune']->toString());
            }
          }
        }
      }

      if (isset($dataMap['organizzazione_aderente']) && $dataMap['organizzazione_aderente']->hasContent()) {
        $content = $dataMap['organizzazione_aderente']->content();
        foreach ($content['relation_list'] as $c ) {
          $location = eZContentObject::fetch($c['contentobject_id']);
          if ($location instanceof eZContentObject) {
            $locationDataMap = $location->dataMap();
            if (isset($locationDataMap['nome_comune']) && $locationDataMap['nome_comune']->hasContent()) {
              $this->addToDocList($version, $docList, 'comune_____s', $locationDataMap['nome_comune']->toString());
            }
          }
        }
      }

    } catch (Exception $e) {
      eZDebug::writeError($e->getMessage(), __METHOD__);
    }
  }


  protected function addToDocList(eZContentObjectVersion $version, &$docList, $key, $value)
  {
    $key = 'extra_' . $key;
    if ($version instanceof eZContentObjectVersion) {
      $availableLanguages = $version->translationList(false, false);
      foreach ($availableLanguages as $languageCode) {
        if ($docList[$languageCode] instanceof eZSolrDoc) {
          $docList[$languageCode]->addField($key, $value);
        }
      }
    }
  }


  public function getExtraData()
  {
    return array('comune');
  }

  /**
   * @param eZContentObject $object
   * @param ExtraData $extraData
   */
  public function setExtraDataFromContentObject(eZContentObject $object, ExtraData $extraData)
  {
    try {

      $dataMap = $object->dataMap();
      $availableLanguages = $object->currentVersion()->translationList(false, false);

      /*if ($user instanceof eZUser) {
        if ( $object->attribute('class_identifier') == 'trainers') {
          // Subscribed to forums notifications
          $subscribed = 0;
          $nodeID = eZINI::instance('youth_app.ini')->variable('NodeSettings', 'TrainersPoolForumNode');
          $nodeIDList = eZSubtreeNotificationRule::fetchNodesForUserID($user->ID, false);
          if (in_array($nodeID, $nodeIDList)) {
            $subscribed = 1;
          }
          foreach ($availableLanguages as $languageCode) {
            $extraData->set('subscribed', $subscribed, $languageCode);
          }
        }

        foreach ($availableLanguages as $languageCode) {
          $extraData->set('login_count', $user->loginCount(), $languageCode);
          $extraData->set('last_visit', $user->lastVisit(), $languageCode);
        }
      }*/


      if (isset($dataMap['id_unico']) && $dataMap['id_unico']->hasContent()) {
        $content = $dataMap['id_unico']->content();
        foreach ($content['relation_list'] as $c ) {
          $location = eZContentObject::fetch($c['contentobject_id']);
          if ($location instanceof eZContentObject) {
            $locationDataMap = $location->dataMap();
            if (isset($locationDataMap['nome_comune']) && $locationDataMap['nome_comune']->hasContent()) {
              foreach ($availableLanguages as $languageCode) {
                $extraData->set('login_count', $locationDataMap['nome_comune']->toString(), $languageCode);
              }
            }
          }
        }
      }

      if (isset($dataMap['organizzazione_aderente']) && $dataMap['organizzazione_aderente']->hasContent()) {
        $content = $dataMap['organizzazione_aderente']->content();
        foreach ($content['relation_list'] as $c ) {
          $location = eZContentObject::fetch($c['contentobject_id']);
          if ($location instanceof eZContentObject) {
            $locationDataMap = $location->dataMap();
            if (isset($locationDataMap['nome_comune']) && $locationDataMap['nome_comune']->hasContent()) {
              foreach ($availableLanguages as $languageCode) {
                $extraData->set('login_count', $locationDataMap['nome_comune']->toString(), $languageCode);
              }
            }
          }
        }
      }

    } catch (Exception $e) {
      eZDebug::writeError($e->getMessage(), __METHOD__);
    }
  }
}
