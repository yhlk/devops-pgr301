## Eksamen devops 2024

# Oppgave 1: Generere og deploye en serverless-applikasjon med SAM

## 🛠️ Mål
Vi opprettet en serverless-applikasjon som genererer bilder basert på tekstprompts ved hjelp av **AWS Lambda** og **AWS SAM**.

---

## 🚀 Trinn-for-trinn-guide

### 1. Opprettelse av prosjekt
For å starte et nytt prosjekt, brukte vi `sam init`:

sam init

Valg under init-prosessen:

   - Template: AWS Quick Start Templates
   - Runtime: Python 3.8
   - Application name: sam-app-tael002

2. Implementasjon av Lambda-funksjonen

Lambda-funksjonen ble implementert i application.py. Den tar imot tekstprompts og genererer bilder ved hjelp av Bedrock-modellen. Genererte bilder lastes opp til en S3-bucketen vi har tilgjengelig fra lærer.

3. Bygging av applikasjonen

For å bygge applikasjonen kjørte vi:

sam build

4. Deploy av applikasjonen

Deploy ble gjennomført ved hjelp av sam deploy --guided:

sam deploy --guided

Under deploy spesifiserte vi nødvendige parametere som:

    BucketName: pgr301-couch-explorers
    KandidatNr: 18
    region: eu-west-1

5. Testing av applikasjonen

Etter deploy sendte vi POST-forespørsler til API Gateway for å teste funksjonaliteten:

curl -X POST https://opypl77il0.execute-api.eu-west-1.amazonaws.com/Prod/generate \
-H "Content-Type: application/json" \
-d '{"prompt": "A croissant"}'




# Oppgave 2: Infrastruktur med Terraform og SQS
Kommandoer vi brukte

    terraform init
    Initialiserte Terraform-prosjektet og konfigurerte backend for lagring av state-fil i S3-bucketen pgr301-2024-terraform-state.

    terraform validate
    Validerte at Terraform-koden var syntaktisk korrekt og klar for bruk.

    terraform plan
    Genererte en plan for infrastrukturen som viste hvilke ressurser som ville bli opprettet, endret eller slettet.

    terraform apply
    Implementerte endringene ved å opprette, endre eller fjerne ressurser i AWS basert på Terraform-koden.

A. Infrastruktur som kode

For å løse ytelsesproblemene brukte vi Amazon SQS som mellomledd mellom klientene og bildeprosesseringskoden. Dette sikret en mer skalerbar løsning. Vi utførte følgende steg:

    Terraform-konfigurasjon for Lambda og SQS:
        Opprettet en Lambda-funksjon som behandler meldinger fra SQS-køen.
        Konfigurerte en SQS-kø som mellomledd mellom klient og bildebehandlingsfunksjonen.
        Integrerte Lambda-funksjonen med SQS for asynkron behandling.
        Opprettet nødvendige IAM-roller og policyer for Lambda-funksjonen:
            Lesetilgang til SQS.
            Skrivetilgang til S3-bucketen pgr301-couch-explorers.
        Lagret Terraform state-filen i S3-bucketen pgr301-2024-terraform-state.

    Lagring i S3:
        Lambda-funksjonen ble konfigurert til å laste opp genererte bilder til S3-bucketen pgr301-couch-explorers/images.

    Timeout-konfigurasjon:
        Justerte Lambda-funksjonens timeout til 10 sekunder for å håndtere lengre prosesseringstider.

B. GitHub Actions Workflow for Terraform

For å automatisere deploy av infrastrukturen brukte vi GitHub Actions. Workflowen ble satt opp med følgende regler:

    Hovedbranch (main):
        Workflow kjører terraform apply for å oppdatere infrastrukturen automatisk med endringene.

    Feature branches (testing-terraform):
        Workflow kjører terraform plan for å vise en plan for infrastrukturendringer uten å implementere dem.

Leveranser

    Lenker til workflow-kjøringer:
        Workflow-kjøring med terraform apply på main: https://github.com/yhlk/devops-pgr301/actions/runs/12016974033
        Workflow-kjøring med terraform plan på andre brancher: https://github.com/yhlk/devops-pgr301/actions/runs/11988700165
    SQS URL: URL-en til den opprettede SQS-køen for testing av meldinger: https://sqs.eu-west-1.amazonaws.com/244530008913/taelqueue

# Oppgave 3: Javaklient og Docker
A. Docker-image for SQS-klienten

For å forenkle bruken av SQS-klienten uten behov for å installere Java lokalt, opprettet vi et Docker-image. Her er prosessen vi fulgte:

    Pull av Docker-imaget
    Teamet kan enkelt hente imaget fra Docker Hub ved å bruke følgende kommando:

docker pull tael002/java-sqs-client-tael002:latest

Opprettelse av Dockerfile
Vi brukte en multi-stage build for å optimalisere Docker-imaget:

    Første stage:
        Kompilerte Java-koden ved hjelp av Maven.
        Bygde en JAR-fil fra koden.
    Andre stage:
        Kopierte nødvendig output fra første stage.
        Kjørte applikasjonen i et lettvekts runtime-miljø som openjdk:17-jre-slim.

Testing av Docker-imaget
Vi testet Docker-imaget ved å sende meldinger til SQS-køen.
Kommando for testing:

    docker run \
        -e AWS_ACCESS_KEY_ID=AKIATR3Y72NI5E2TSO7R \
        -e AWS_SECRET_ACCESS_KEY=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 \
        -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/taelqueue \
        tael002/java-sqs-client-tael002 "Me on top of a pyramid"

B. GitHub Actions Workflow for Docker

For å automatisere bygging og publisering av Docker-imaget opprettet vi en GitHub Actions workflow. Denne sikret at teamet alltid hadde tilgang til oppdatert funksjonalitet.

    Trigger for workflowen
        Workflow kjører automatisk ved hver push til main.
        Endringer i main resulterer i en oppdatert versjon av Docker-imaget.

    Publisering til Docker Hub
        Vi konfigurerte en Docker Hub-konto for å motta publiserte images.
        Workflow logger inn på Docker Hub, bygger imaget, og pusher det automatisk.

    Tagging-strategi
        Latest tag:
        Imaget tagges alltid med latest for enkel tilgang til den nyeste versjonen.
        Versjonskontroll:
        Imaget tagges også med spesifikke versjonsnummer (f.eks. 1.0.0) for historikk og kontroll.

Leveranser

    Docker Hub Image:

docker pull tael002/java-sqs-client-tael002:latest

Kommando for testing:
For å teste funksjonaliteten, kjør følgende kommando:

// vet at man ikke skal dele access key og secret key, men viser det som eksempel her kun for sensor
    docker run \
        -e AWS_ACCESS_KEY_ID=AKIATR3Y72NI5E2TSO7R \
        -e AWS_SECRET_ACCESS_KEY=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 \
        -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/taelqueue \
        tael002/java-sqs-client-tael002 "Me on top of a pyramid"

Denne prosessen sikret enkel bruk og rask distribusjon av klienten

# Oppgave 4: Metrics og overvåkning
A. CloudWatch-alarm for OldestMessageAlarm_TaelQueue

For å overvåke løsningen og sikre rask tilbakemelding, satte jeg opp en CloudWatch-alarm basert på SQS-metrikken ApproximateAgeOfOldestMessage.

    Terraform-kode:
        Alarmen trigges når verdien overstiger en angitt terskel i mitt tilfelle 120.
        E-postvarsling er satt opp via Amazon SNS. E-postadressen spesifiseres som en variabel i Terraform-koden. Brukte student-eposten.








# Oppgave 5: Serverless, Function as a Service vs Container-teknologi

Denne drøftelsen utforsker implikasjonene av å velge mellom en **serverless arkitektur** med Function-as-a-Service (FaaS), som AWS Lambda, og en **mikrotjenestearkitektur**, sett opp mot sentrale DevOps-prinsipper.

---

## 1. Automatisering og Kontinuerlig Levering (CI/CD)

### Serverless Arkitektur
**Styrker:**
- FaaS-tjenester som AWS Lambda er tettere integrert med CI/CD-verktøy som AWS CodePipeline, noe som muliggjør enklere automatisering av utrullinger.
- Hver funksjon kan ha sin egen utrullingsprosess, noe som gir mulighet for raskere endringer i spesifikke deler av systemet uten å påvirke andre komponenter.
- "Zero-downtime deploys" blir enklere ved hjelp av versjonskontroll og trafikksplitting (f.eks. AWS Lambda Alias og Canary Deployments).

**Svakheter:**
- Flere funksjoner fører til flere pipelines, noe som kan øke kompleksiteten i administrasjonen av CI/CD-prosesser.
- Testing av serverless-funksjoner krever ofte mock-tjenester eller miljøer som simulerer AWS-integrasjoner, noe som kan være utfordrende.

### Mikrotjenestearkitektur
**Styrker:**
- CI/CD-pipelines for mikrotjenester er mer etablerte og støttet av mange verktøy som Jenkins, GitHub Actions og ArgoCD.
- En samlet containerbasert pipeline kan redusere kompleksiteten sammenlignet med serverless-funksjoner som krever flere separate pipelines.

**Svakheter:**
- Rulling ut endringer kan kreve koordinasjon mellom tjenester, spesielt hvis de deler ressurser som databaser.
- Oppdatering av containere krever mer arbeid, som å bygge, teste og publisere Docker-images.

---

## 2. Observability (Overvåkning)

### Serverless Arkitektur
**Styrker:**
- AWS tilbyr integrasjoner som CloudWatch og X-Ray for logging, sporing og feilsøking.
- Funksjonsbasert isolasjon gjør det lettere å spore spesifikke feil tilbake til individuelle komponenter.

**Svakheter:**
- Logging og overvåkning blir ofte fragmentert. Hver funksjon må ha tilstrekkelig logging for å kunne spore gjennom hele flyten.
- "Cold start"-problemer kan være vanskelige å oppdage og overvåke.
- Distribuert natur skaper utfordringer med sammenhengende tracing på tvers av funksjoner og tjenester.

### Mikrotjenestearkitektur
**Styrker:**
- Observability-verktøy som Prometheus, Grafana og Jaeger gir omfattende overvåkning og tracing på tvers av tjenester.
- Feilsøking kan være enklere i systemer med sammenhengende tjenester som kjører i container-clustere (f.eks. Kubernetes).

**Svakheter:**
- Mer kompleks logging når tjenester kommuniserer via mange ulike nettverksprotokoller.
- Overvåkning av containere krever oppsett og vedlikehold av egne observability-løsninger, noe som kan kreve mer arbeid enn serverless.

---

## 3. Skalerbarhet og Kostnadskontroll

### Serverless Arkitektur
**Styrker:**
- Automatisk skalerbarhet er innebygd. Lambda skalerer basert på antall forespørsler uten behov for manuell intervensjon.
- "Pay-as-you-go"-modell gir direkte kostnadsoptimalisering. Du betaler kun for tiden funksjonen kjører.

**Svakheter:**
- Høye trafikkvolumer kan føre til uventet høye kostnader, spesielt for tjenester som kalles ofte.
- Begrensninger i samtidige forespørsler (f.eks. "concurrent execution limits") kan føre til flaskehalsproblemer.

### Mikrotjenestearkitektur
**Styrker:**
- Kostnadene kan forutses mer nøyaktig siden containerbaserte løsninger vanligvis krever faste ressurser som EC2-instanser.
- Skalerbarhet kan kontrolleres mer presist ved å tilpasse ressurser i Kubernetes eller ECS.

**Svakheter:**
- Over- eller underprovisjonering kan føre til ineffektiv ressursbruk.
- Manuell skalering og vedlikehold av infrastrukturen krever mer DevOps-innsats.

---

## 4. Eierskap og Ansvar

### Serverless Arkitektur
**Styrker:**
- Infrastrukturansvar flyttes til AWS. DevOps-teamet kan fokusere på applikasjonslogikk fremfor infrastruktur.
- Serverless-tjenester er enklere å administrere med mindre vedlikehold sammenlignet med containere.

**Svakheter:**
- Manglende kontroll over infrastrukturen kan føre til vanskeligheter med feilsøking, spesielt i komplekse systemer.
- DevOps-team må holde oversikt over flere små funksjoner, noe som kan føre til "function sprawl".

### Mikrotjenestearkitektur
**Styrker:**
- Mer kontroll over infrastrukturen gir mulighet for tilpasning, noe som er viktig i komplekse systemer.
- Hver mikrotjeneste har et dedikert team, noe som styrker eierskapet.

**Svakheter:**
- Mer ansvar for administrasjon av infrastruktur som containere, orkestrering og oppsett av miljøer.
- Overvåking av mange separate tjenester kan være utfordrende.

---

## Konklusjon

### Når velge **Serverless**:
- Uforutsigbar eller varierende trafikk.
- Fokus på rask utvikling og minimal infrastrukturadministrasjon.
- Kostnadseffektivitet for mindre arbeidsmengder.

### Når velge **Mikrotjenester**:
- Komplekse avhengigheter eller konsistent ytelse er nødvendig.
- Full kontroll over infrastruktur og ressursutnyttelse.
- Behov for å integrere med eldre systemer eller spesifikke containermiljøer.

**Valget mellom de to arkitekturene bør tilpasses organisasjonens behov, ferdigheter og forretningsmål. Ofte kan en hybridløsning være optimal.**
