<?php

use Opencontent\Opendata\Api\Values\ExtraData;
use Opencontent\Opendata\Api\Values\ExtraDataProviderInterface;

class ezfIndexTnFam implements ezfIndexPlugin, ExtraDataProviderInterface
{
    /**
     * @param eZContentObject $contentObject
     * @param eZSolrDoc[] $docList
     */
    public function modify( eZContentObject $contentObject, &$docList )
    {
        try
        {
            $dataMap = $contentObject->dataMap();
            $availableLanguages = $contentObject->currentVersion()->translationList( false, false );
            if ( $contentObject->attribute('class_identifier') == 'adesione_distretto_famiglia') {

              if ($dataMap['organizzazione_aderente']->hasContent())
              {
                $attributeContent = $dataMap['organizzazione_aderente']->content();
                foreach ( $attributeContent['relation_list'] as $objId )
                {
                  $relatedObj = eZContentObject::fetch($objId['contentobject_id']);
                  if ($relatedObj instanceof eZContentObject) {
                    $relatedObjDataMap = $relatedObj->dataMap();

                    if ($relatedObjDataMap['comunita']->hasContent())
                    {
                      /** @var eZTags $content */
                      $content = $relatedObjDataMap['comunita']->content();
                      foreach ($content->tags() as $tag)
                      {
                        foreach ( $availableLanguages as $languageCode )
                        {
                          $docList[$languageCode]->addField('organizzazione_aderente_comunita____s', $tag->Keyword );
                        }
                      }

                      /*foreach ( $availableLanguages as $languageCode )
                      {
                        $docList[$languageCode]->addField('organizzazione_aderente_comunita____s', $countries[0]['Name'] );
                      }*/
                    }

                    //comunita
                    /*echo '<pre>';
                    print_r($relatedObjDataMap);
                    exit;*/
                  }
                }

                /*foreach ( $availableLanguages as $languageCode )
                {
                  $docList[$languageCode]->addField('extra_country____s', $countries[0]['Name'] );
                }*/
              }
            }

            /*if (in_array( $contentObject->attribute('class_identifier'), array('trainers', 'user')))
            {
                if ($dataMap['country']->hasContent())
                {
                    $countries = array_values($dataMap['country']->content()['value']);
                    foreach ( $availableLanguages as $languageCode )
                    {
                        $docList[$languageCode]->addField('extra_country____s', $countries[0]['Name'] );
                    }
                }
            }*/
        }
        catch( Exception $e )
        {
            eZDebug::writeError( $e->getMessage(), __METHOD__ );
        }
    }


    public function getExtraData()
    {
        return array();
    }

    /**
     * @param eZContentObject $object
     * @param ExtraData $extraData
     */
    public function setExtraDataFromContentObject(eZContentObject $object, ExtraData $extraData)
    {
        /*try {
            $user = eZUser::fetch($object->ID);
            $availableLanguages = $object->currentVersion()->translationList(false, false);

            if ($user instanceof eZUser) {
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
            }

        } catch (Exception $e) {
            eZDebug::writeError($e->getMessage(), __METHOD__);
        }*/
    }
}
