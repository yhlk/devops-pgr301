##Eksamen devops 2024

#Oppgave 1


#Oppgave 2


#Oppgave 3


#Oppgave 4




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
