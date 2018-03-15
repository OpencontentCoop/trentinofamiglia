# Openpa design Italia

Design per Openpa conforme alle linee guida per i siti web della PA (http://design.italia.it/)

# Configurare l'estensione per lo sviluppo

**NB: modifiche all'estensione comportano l'installazione di Node e di altri componenti. Tale installazione non vai mai eseguita su un server di produzione, le modifiche all'estensione vanno eseguite in locale o in un ambiente di sviluppo dedicato.**

## Installare il software richiesto

Per poter compilare i sorgenti (CSS / JS) è richiesta l’installazione di Node.js / npm.

Terminata l’installazione, la seguente sequenza di comandi eseguiti all’interno della directory dell'estensione completerà il download e l’installazione delle librerie richieste per lo sviluppo:

```
npm install 
```

## Compilare i sorgenti

Dopo aver eseguito il comando
```
npm run build --openpa_designitalia:theme="nome_nuovo_tema"
```
le directory design/designitalia/stylesheets design/designitalia/javascript conterranno i file CSS e Javascript compilati.

## Modificare i sorgenti

Per poter visualizzare la styleguide in locale (i template HTML con i diversi componenti grafici) puoi sostituire come ultimo passaggio (al posto di npm run build) il comando

```
npm run watch --openpa_designitalia:theme="nome_nuovo_tema"
```

A questo punto puoi modificare i sorgenti: qualsiasi modifica effettuata ai fogli di stile CSS, Javascript e/o template HTML mentre npm run watch rimane in esecuzione sarà immediatamente visibile nel browser dopo aver ricaricato manualmente la pagina e senza lanciare il comando di build.

**NB se non viene specificato un tema il buld prendera come default il tema Pac

## run build, build:css build:js 
Come è possibile verificare dal file package.json il comando di build esegue 2 diversi sottocomandi
```javascript
"build": "npm-run-all build:css build:js..."
```
Esegue prima il build dei css, successivamente quello dei js, quindi:

- Se vengono eseguite modifiche ai soli template è assolutamente inutile eseguire il build.
- Se vengono eseguite modifiche ai soli css è assolutamente inutile eseguire un build generale, meglio procedere con:
```
npm run build:css --openpa_designitalia:theme="nome_nuovo_tema"
```

# Come creare un nuovo tema

1. Duplicare la cartella di un tema esistente (no base) e rinominarla (evitare caratteri strani)
2. Modifciare l'index.css del tema appena creato, sostituire .nome_tema_copiato con .nome_nuovo_tema
3. Eseguire:
```
npm run build --openpa_designitalia:theme="nome_nuovo_tema"
```
oppure in caso di sviluppo
```
npm run watch --openpa_designitalia:theme="nome_nuovo_tema"
``` 
4. Modificare GeneralSettings:theme in openpa.ini con nome_nuovo_tema
5. Svuotare le cache
6. Ricaricare la pagina
