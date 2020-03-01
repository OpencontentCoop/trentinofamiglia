<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\ConnectorHelper;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\FieldConnectorFactory;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\FieldConnector\FileField;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\FieldConnectorInterface;
use Opencontent\Ocopendata\Forms\Connectors\OpendataConnector\UploadFieldConnector;
use Opencontent\Opendata\Api\Values\Content;

class DeliberaPianoComunaleConnector extends AbstractBaseConnector
{
    protected static $isLoaded;

    private $object;

    private $class;

    /**
     * @var FieldConnectorInterface[]
     */
    protected $fieldConnectors;

    protected $fields = array(
        'numero_delibera',
        'data_delibera',
        'piano_pdf',
        'delibera_pdf'
    );

    protected $content;


    public function runService($serviceIdentifier)
    {
        $this->load();
        if ($serviceIdentifier == 'debug') {
            return $this->getDebug();
        }
        return parent::runService($serviceIdentifier);
    }

    protected function getDebug()
    {
        $data = array(
            'connector' => get_called_class(),
            'attributes' => array()
        );
        foreach ($this->getFieldConnectors() as $identifier => $connector) {
            $data['attributes'][$identifier] = get_class($connector);
        }

        return $data;
    }

    protected function load()
    {
        if (!self::$isLoaded) {
            if ($this->hasParameter('object')) {
                $this->object = eZContentObject::fetch((int)$this->getParameter('object'));
            }
            if (!$this->object instanceof eZContentObject) {
                throw new Exception("Oggetto non selezionato", 1);
            }

            $this->class = $this->object->contentClass();

            $data = (array)Content::createFromEzContentObject($this->object);
            $locale = \eZLocale::currentLocaleCode();
            if (isset($data['data'][$locale])) {
                $this->setContent($data['data'][$locale]);
            }

            self::$isLoaded = true;
        }
    }

    protected function getFieldConnectors()
    {
        if ($this->fieldConnectors === null) {
            /** @var \eZContentClassAttribute[] $classDataMap */
            $classDataMap = $this->class->dataMap();
            $defaultCategory = \eZINI::instance('content.ini')->variable('ClassAttributeSettings', 'DefaultCategory');
            foreach ($classDataMap as $identifier => $attribute) {
                if (in_array($identifier, $this->fields)) {
                    $this->fieldConnectors[$identifier] = FieldConnectorFactory::load(
                        $attribute,
                        $this->class,
                        $this->getHelper()
                    );
                }
            }
        }

        return $this->fieldConnectors;
    }

    /**
     * @param mixed $content
     */
    public function setContent($content)
    {
        $this->content = $content;
        if (is_array($this->content)) {
            foreach ($this->getFieldConnectors() as $identifier => $connector) {
                if (isset($this->content[$identifier])) {
                    $connector->setContent($this->content[$identifier]);
                }
            }
        }
    }

    protected function getData()
    {
        $content = array();
        foreach ($this->getFieldConnectors() as $identifier => $connector) {
            $content[$identifier] = $connector->getData();
        }

        return $content;
    }

    protected function getSchema()
    {
        $schema = array(
            "type" => "object",
            "properties" => array()
        );

        foreach ($this->getFieldConnectors() as $identifier => $fieldConnector) {
            $schema["properties"][$identifier] = $fieldConnector->getSchema();
        }


        return $schema;
    }

    protected function getOptions()
    {
        $fields = array();

        foreach ($this->getFieldConnectors() as $identifier => $fieldConnector) {
            $fields[$identifier] = $fieldConnector->getOptions();
            if (empty($fields[$identifier])) {
                unset($fields[$identifier]);
            }
        }

        return array(
            "form" => array(
                "attributes" => array(
                    "action" => $this->getHelper()->getServiceUrl('action', $this->getHelper()->getParameters()),
                    "method" => "post",
                    "enctype" => "multipart/form-data"
                ),
                "buttons" => array(
                    "submit" => array()
                ),
            ),
            "helper" => $this->class->attribute('description'),
            'hideInitValidationError' => true,
            "fields" => $fields
        );
    }

    protected function getView()
    {
        return array(
            "parent" => "bootstrap-edit",
            "locale" => "it_IT"
        );
    }

    protected function submit()
    {
        $data = $_POST;
        $fieldsData = array();
        foreach ($this->getFieldConnectors() as $identifier => $connector) {
            $postData = isset($data[$identifier]) ? $data[$identifier] : null;
            if ($postData) {
                $payloadData = $connector->setPayload($postData);
                if ($payloadData !== null) {
                    $fieldsData[$identifier] = $payloadData;
                }
            }
        }

        $params = array();
        $params['attributes'] = array(
            'numero_delibera' => $fieldsData['numero_delibera'],
            'data_delibera' => date("U", strtotime($fieldsData['data_delibera'])),
            'piano_pdf' => $this->getTemporaryFilePath($fieldsData['piano_pdf']['filename'], $fieldsData['file']),
            'delibera_pdf' => $this->getTemporaryFilePath($fieldsData['delibera_pdf']['filename'], $fieldsData['file'])
        );
        $result = eZContentFunctions::updateAndPublishObject($this->object, $params);
        if (!$result) {
            throw new Exception("Error Processing Request", 1);
        }
        return $result;
    }

    protected function upload()
    {
        if ($this->getHelper()->hasParameter('attribute')) {
            $id = $this->getHelper()->getParameter('attribute');
            $connectors = $this->getFieldConnectors();
            foreach ($connectors as $connector) {
                if ($connector->getAttribute()->attribute('id') == $id) {
                    if ($connector instanceof UploadFieldConnector) {
                        return $connector->handleUpload(
                            $this->getHelper()->getSetting('upload_param_name_prefix')
                        );
                    }
                }
            }
        }

        return false;
    }

    private function getTemporaryFilePath($filename, $fileEncoded = null)
    {
        $tempDir = eZDir::path(array(eZSys::cacheDirectory(), 'tmp'), true);
        eZDir::mkdir($tempDir);

        $data = null;
        $binary = base64_decode($fileEncoded);
        eZFile::create($filename, $tempDir, $binary);
        $data = $tempDir . $filename;

        return $data;
    }
}
