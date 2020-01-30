<?php /* #?ini charset="utf-8"?

[ImportSettings]
AvailableSourceHandlers[]=hidecontent
AvailableSourceHandlers[]=comunicatistampa

[hidecontent-HandlerSettings]
Enabled=true
Name=Hide Content Handler
ClassName=HideContentHandler
HideUnlistedObjects=disabled

[comunicatistampa-HandlerSettings]
Enabled=true
Name=Comunicati Stampa PAT Handler
ClassName=TNFamComunicatiStampaHandler
DefaultParentNodeID=1424
Endpoint=https://www.ufficiostampa.provincia.tn.it/api/opendata/v2/content/search/
Query=classes [comunicato] and tematica contains ['"Politiche familiari e sociali"'] and published range [%start_date%,NOW] sort [published=>desc]


*/ ?>
