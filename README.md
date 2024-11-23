##Eksamen devops 2024

#Oppgave 1


#Oppgave 2


#Oppgave 3


#Oppgave 4




Oppgave 5: Serverless, Function as a Service vs Container-teknologi
Drøftelsen tar utgangspunkt i implikasjonene av å velge mellom serverless arkitektur med Function-as-a-Service (FaaS), som AWS Lambda, og en mikrotjenestebasert arkitektur, sett opp mot sentrale DevOps-prinsipper.
________________________________________
1. Automatisering og kontinuerlig levering (CI/CD)
Serverless Arkitektur
•	Styrker:
o	FaaS-tjenester som AWS Lambda er tettere integrert med CI/CD-verktøy som AWS CodePipeline, noe som muliggjør enklere automatisering av utrullinger.
o	Hver funksjon kan ha sin egen utrullingsprosess, noe som gir mulighet for raskere endringer i spesifikke deler av systemet uten å påvirke andre komponenter.
o	"Zero-downtime deploys" blir enklere ved hjelp av versjonskontroll og trafikksplitting (f.eks. AWS Lambda Alias og Canary Deployments).
•	Svakheter:
o	Flere funksjoner fører til flere pipelines, noe som kan øke kompleksiteten i administrasjonen av CI/CD-prosesser.
o	Testing av serverless-funksjoner krever ofte mock-tjenester eller miljøer som simulerer AWS-integrasjoner, noe som kan være utfordrende.
Mikrotjenestearkitektur
•	Styrker:
o	CI/CD-pipelines for mikrotjenester er mer etablerte og støttet av mange verktøy som Jenkins, GitHub Actions, og ArgoCD.
o	En samlet containerbasert pipeline kan redusere kompleksiteten sammenlignet med serverless-funksjoner som krever flere separate pipelines.
•	Svakheter:
o	Rulling ut endringer kan kreve koordinasjon mellom tjenester, spesielt hvis de deler ressurser som databaser.
o	Oppdatere containere krever mer arbeid, som å bygge, teste og publisere Docker-images.
________________________________________
2. Observability (Overvåkning)
Serverless Arkitektur
•	Styrker:
o	AWS tilbyr integrasjoner som CloudWatch og X-Ray for logging, sporing og feilsøking.
o	Funksjonsbasert isolasjon gjør det lettere å spore spesifikke feil tilbake til individuelle komponenter.
•	Svakheter:
o	Logging og overvåkning blir ofte fragmentert. Hver funksjon må ha tilstrekkelig logging for å kunne spore gjennom hele flyten.
o	"Cold start"-problemer kan være vanskelige å oppdage og overvåke.
o	Distribuert natur skaper utfordringer med sammenhengende tracing på tvers av funksjoner og tjenester.
Mikrotjenestearkitektur
•	Styrker:
o	Observability-verktøy som Prometheus, Grafana og Jaeger gir omfattende overvåkning og tracing på tvers av tjenester.
o	Feilsøking kan være enklere i systemer med sammenhengende tjenester som kjører i container-clustere (f.eks. Kubernetes).
•	Svakheter:
o	Mer kompleks logging når tjenester kommuniserer via mange ulike nettverksprotokoller.
o	Overvåkning av containere krever oppsett og vedlikehold av egne observability-løsninger, noe som kan kreve mer arbeid enn serverless.
________________________________________
3. Skalerbarhet og Kostnadskontroll
Serverless Arkitektur
•	Styrker:
o	Automatisk skalerbarhet er innebygd. Lambda skalerer basert på antall forespørsler uten behov for manuell intervensjon.
o	"Pay-as-you-go"-modell gir direkte kostnadsoptimalisering. Du betaler kun for tiden funksjonen kjører.
•	Svakheter:
o	Høye trafikkvolumer kan føre til uventet høye kostnader, spesielt for tjenester som kalles ofte.
o	Begrensninger i samtidige forespørsler (f.eks. "concurrent execution limits") kan føre til flaskehalsproblemer.
Mikrotjenestearkitektur
•	Styrker:
o	Kostnadene kan forutses mer nøyaktig siden containerbaserte løsninger vanligvis krever faste ressurser som EC2-instanser.
o	Skalerbarhet kan kontrolleres mer presist ved å tilpasse ressurser i Kubernetes eller ECS.
•	Svakheter:
o	Over- eller underprovisjonering kan føre til ineffektiv ressursbruk.
o	Manuell skalering og vedlikehold av infrastrukturen krever mer DevOps-innsats.
________________________________________
4. Eierskap og Ansvar
Serverless Arkitektur
•	Styrker:
o	Infrastrukturansvar flyttes til AWS. DevOps-teamet kan fokusere på applikasjonslogikk fremfor infrastruktur.
o	Serverless-tjenester er enklere å administrere med mindre vedlikehold sammenlignet med containere.
•	Svakheter:
o	Manglende kontroll over infrastrukturen kan føre til vanskeligheter med feilsøking, spesielt i komplekse systemer.
o	DevOps-team må holde oversikt over flere små funksjoner, noe som kan føre til "function sprawl".
Mikrotjenestearkitektur
•	Styrker:
o	Mer kontroll over infrastrukturen gir mulighet for tilpasning, noe som er viktig i komplekse systemer.
o	Hver mikrotjeneste har et dedikert team, noe som styrker eierskapet.
•	Svakheter:
o	Mer ansvar for administrasjon av infrastruktur som containere, orkestrering og oppsett av miljøer.
o	Overvåking av mange separate tjenester kan være utfordrende.
________________________________________
Konklusjon
Når velge Serverless:
•	Når applikasjonen har uforutsigbar eller varierende trafikk.
•	Når rask utvikling og minimal infrastrukturadministrasjon er viktig.
•	Når kostnadseffektivitet for mindre arbeidsmengder er nødvendig.
Når velge Mikrotjenester:
•	Når applikasjonen har komplekse avhengigheter eller trenger konsistent ytelse.
•	Når full kontroll over infrastruktur og ressursutnyttelse er viktig.
•	Når det er behov for å integrere med eldre systemer eller spesifikke containermiljøer.
Valget mellom de to arkitekturene bør baseres på organisasjonens behov, ferdighetsnivå og forretningskrav. Begge tilnærmingene har styrker og svakheter, og ofte kan en hybridløsning være optimal.
