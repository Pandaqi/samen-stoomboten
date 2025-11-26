# Samen Stoomboten (Dagboek)

Welkom bij dit "speldagboek" voor **Samen Stoomboten**. Het is een simpel computerspel dat ik maakte voor Sinterklaas, bedoeld om te spelen met meerdere kinderen (of "de hele familie") achter hetzelfde scherm. Het was ook mijn eerste "test" voor mijn idee en systeem voor "One Button Games". Daarom leek het mij interessant om even op te schrijven wat ik heb gedaan en wat ik heb geleerd :)

## Wat is het idee?

De naam zegt het al. **Je bestuurt samen de stoomboot.**

* Elke speler krijgt één knopje.
* Dat knopje is verbonden met één of twee richtingen, zoals NAAR LINKS en NAAR BOVEN
* Zodoende moet je samenwerken om die boot in de juiste richting te krijgen.

Het is zo'n beetje de meest pure invulling van mijn "One Button Game" idee. Iedereen krijgt één knop, maar je moet echt _samenwerken_ als je iets wilt bereiken in het spel. Tegelijkertijd is dit natuurlijk erg simpel om te begrijpen en spelen. Kinderen kennen de stoomboot, ze begrijpen hoe beweging werkt, en ze begrijpen dat hij naar Nederland moet.

Maar dan...

Ik had al twee jaar lang geen computerspel meer geprogrammeerd. Ik had twee jaar geleden mijn "systeem" voor One Button Games opgezet, wat betekent dat ik algemene code schrijf die ik zo hopsakee in elk volgende spel kan gooien om meteen te luisteren naar de juiste knopjes. Maar toen dat systeem zo goed als af was, nam mijn leven weer een paar andere wendingen.

Zodoende kwam ik dus pas na twee jaar (eindelijk) weer terug bij dit idee en dit systeem. En ik was compléét vergeten hoe ik alles had opgezet en was teleurgesteld in de matige notities die ik voor mezelf had achtergelaten. Dus de eerste paar uur betekenden vooral mijn eigen code teruglezen en zwaar verbeteren. Maar toen ik het eenmaal weer begreep, kon het spellenmaken beginnen.

## Probleem 1: Weinig Spelers

Dit zijn van die dingen die je hoofd niet bedenkt, maar die _meteen_ duidelijk worden wanneer je iets gaat maken.

Als je met 2 of 3 spelers bent ... dan heb je niet genoeg knoppen om de boot in alle richtingen te sturen :p 

Eén iemand gaat rechts, de ander gaat links, en dan... en dan? Je kan wel twee richtingen geven (één speler gaat LINKS+BOVEN, de ander RECHTS+ONDER), maar dan kan je alleen in een schuine rechte lijn bewegen. Want ja, je hebt maar één knopje, dus je drukt altijd _al je richtingen tegelijkertijd in_.

De oplossing? Ik koos voor **de pijlen draaien**. Oftewel, de pijlen rondom de stoomboot draaien langzaam met de klok mee. Zo verandert jouw richting langzaam over tijd. Door een paar seconden _niks_ in te drukken, sta je stil en kan daarna weer een andere richting in. 

Deze oplossing maakte het spel ook gewoon beter, omdat je nu dus variatie hebt in wat je knopje doet. Zodat je niet het hele potje maar loopt te wachten op die _ene keer_ dat de stoomboot achteruit wil.

Dat brengt mij bij het volgende punt...

## Probleem 2: Dit is best een lastig programmeerding eigenlijk

Misschien kwam het doordat ik al jaren niet meer spellen had geprogrammeerd. Maar ik stond echt even een halfuur versteld van hoe ik dit (netjes) moest doen.

* Je hebt spelers die één knopje hebben.
* Maar dat ene knopje kan (soms) _meerdere richtingen_ besturen.
* En je moet dat zo verdelen dat je alle richtingen gelijkmatig verdeeld en dat je altijd alle kanten op kan.
* En dat moet gebeuren terwijl spelers kunnen inloggen of weggaan _terwijl je speelt_ (een belangrijke feature van One Button Games)
* (En dan dus ook nog dat je richtingen _draaien_!)

Nou goed, uiteindelijk heb ik het als volgt gedaan.

* De stoomboot luistert naar het signaal "spelers_veranderd" (dat betekent dus dat een speler is toegevoegd of weggehaald)
* Op dat moment geeft het om en om een richting aan de bestaande spelers, totdat alle richtingen zijn verdeeld.
* Deze "richting" is het "origineel". De spelers slaan dus op "Ik heb pijl 0 en 4", bijvoorbeeld.
* Als de pijlen gaan _draaien_, dan reken ik simpelweg _ter plekke_ de nieuwe richting uit op basis van het origineel. Dit maakt de code heel netjes en zorgt dat ik het draaien ook gewoon kan uitzetten zonder iets te hoeven veranderen.
  * Mijn pijl was "RECHTS"
  * Hé, de pijlen zijn nu 90 graden gedraaid.
  * Dus als ik mijn knop indruk, gaat de boot (op dit specifieke moment) "RECHTS" x 90 graden draaien = "OMLAAG"
* De spelers vuren een signaal af wanneer ze de knop indrukken of loslaten. De boot luistert naar dit signaal, rekent de dingen hierboven uit, en verplaatst dan in de uiteindelijke richting die spelers wilden.

## Probleem 3: De zee

Het doel van het spel is om aan te komen in Nederland. Er zijn dan twee dingen die je kan doen,

* Je maakt het _aankomen_ erg lastig. Dus je genereert een moeilijke map met veel obstakels, en als je te langzaam bent (of te vaak tegen een berg aanknalt ofzo) dan verlies je.
* Je gaat sowieso een keer aankomen, dus het gaat meer om je _score_ ("hoe goed je het hebt gedaan").

Ik koos voor de tweede optie.

Een tijdslimiet is lastig, want dat moet je flink testen en balanceren. En zelfs dan zal een groep van 8 mensen heel anders bewegen dan eentje van 4, dus je zal zelfs _verschillende_ tijdslimieten moeten hebben, en het wordt allemaal lastig zo. Ik heb maar een paar dagen om dit te maken!

De boot kapot laten gaan is nog oké. Ik heb dat eerder gedaan in een spel waarin je een kano bestuurde en tegen rotsen aan kon knallen. Maar ik weet niet of kinderen het leuk vinden om de helft van de potjes de stoomboot te zien zinken en gewoon niet aan te komen. Het grotere probleem is dat je dan "intelligent" de map moet genereren, want je moet niet te veel obstakels hebben maar ook niet te weinig. Ook dat is lastig als je maar weinig tijd hebt. En het voelt als "overkill" om een hele slimme realistische kaart te laten genereren voor zo'n enorm simpel klein spelletje.

De tweede optie dus.

* Er zijn wel obstakels (zoals eilanden), maar die zijn vrij ruim bemeten zodat je sowieso ergens erlangs kan. Zonder dat ik daar hele intelligente algoritmes voor moet schrijven. Want als je er tegenaan knalt... dan gaan ze gewoon weg (zie hieronder)
* Het gaat vooral om **met hoeveel pakjes je aankomt**. (Dat is je "score".)
* Dus ik plaats gewoon willekeurig dobberende pakjes in de zee.
* En als je tegen een gevaar botst, verlies je een pakje dat je al had. (Hij floept uit je boot en valt ergens in de buurt.)

Als je een grote kaart maakt, dan is het vaak verstandig om die maar "stukje voor stukje" te laden. (Dus alleen het stukje waar je _nu bent_ bestaat, en daaromheen is gewoon niks, want de camera ziet het toch niet.) Maar voor zo'n klein spel is het veel makkelijker om gewoon de hele kaart in één keer te laden, en de camera de boot te laten volgen waar die ook gaat.

Het enige dat ik nu moet doen is dingen "gelijkmatig verdelen" over de kaart. Dus niet dat ALLE pakjes in het begin zitten, bijvoorbeeld, en daarna niks meer. Daarvoor gebruik ik altijd zoiets simpels als dit,

* Hak het hele parcours in X stukjes.
* Plaats hetzelfde aantal pakjes/obstakels op willekeurige plakken in elk stukje.
* Als de stukken groot genoeg zijn, ziet dit er nog steeds natuurlijk en gevarieerd uit.

{{% remark %}}
Oh, en natuurlijk ervoor zorgen dat spelers niet van de kaart af kunnen. Maar daarvoor heeft Godot Engine gelukkig sinds een tijdje geleden de `WorldBoundaryShape2D`. Het is 10 regels code om die neer te zetten op de uiterste punten van mijn kaart die ik net heb gemaakt, en dan kan je er zelfs op hoge snelheid niet meer doorheen.
{{% /remark %}}

## Een werkend spel

Met deze problemen oplossen hebben we in principe een werkend spel. De boot verschijnt, je kan hem besturen, hij botst tegen obstakels en pakt pakjes op, en hij triggert een signaal als je over de finish komt.

Het ziet er op dit punt natuurlijk hartstikke lelijk uit. Als je een pakje verliest valt ie gewoon zomaar een afstand van je vandaan in het water, alsof hij teleporteert. Je mist plaatjes, je mist muziek, je mist zelfs een getalletje dat even zegt hoeveel pakjes je hebt. Dus dat gaan we nu maken.

Hieronder geef ik een overzicht van de meest belangrijke of interessante stappen.

* Het handige van zo'n simpele kaart is dat ik exact weet hoe lang hij is en dat de finish op het einde is. Dus ik kan een mooie horizontale balk laten zien met je voortgang.
* Die balk maakte ik een _staf_ voor het thema. En de krul is dan de plek waarover ik het aantal pakjes kan laten zien dat je hebt.
* Waar laat ik zien welk knopje iedereen heeft? Ik koos ervoor om je knop, in het klein, maar gewoon naast _elke pijl van jou_ te laten zien.
* De obstakels werden simpele eilanden. (Nogmaals, voor een groter spel wil je meer variatie in design en plaatsing, maar dit is een heel simpel spel met een heel simpele manier van elke wereld opbouwen.) 
  * De enige "slimme logica" hier is dat eilanden en pakjes altijd minstens X pixels uit elkaar moeten staan. Zodat ze niet lelijk over elkaar heen gaan zitten ("overlappen").
* Met weinig spelers (2 of 3) is het nu juist logischer als je _niet_ tegenovergestelde pijlen hebt (ene links en boven, andere rechts en onder). Het bewegen wordt makkelijker als de verdeling "asymmetrisch" is, dus met de meeste pijlen aan dezelfde kant.
  * Ook is het dan logischer als de pijlen _sneller_ draaien, want anders moet je soms 5 seconden wachten en niks doen totdat ie eindelijk verder is :p
  * Ik stond op het punt een mooie tekening van een pijl te maken... toen ik realiseerde dat het veel grappiger en passender was om gewoon een wortel te gebruiken als pijl.
* Met een "trucje" heb ik het laten lijken alsof de boot en de pakjes drijven in het water.
  * Dat trucje is gewoon 2 blauwe cirkels die willekeurige op en neer bewegen voor het pakje.
  * Maar wel met "clip children" aan, zodat de cirkel _alleen_ wordt getoond waar het pakje is, en niet daarbuiten. Zo lijkt het echt alsof het pakje in en uit het water gaat.
* Ik heb zo'n zelfde paar "slimme" animaties op de stoomboot gezet. Dat ging pas echt goed eruit zien toen ik de _afspeelsnelheid_ (`speed_scale`) aanpaste op basis van _je echte snelheid_. Oftewel, als je superhard gaat met de stoomboot, gaat de dobberanimatie óók sneller. (En als je stilstaat, staat de animatie natuurlijk ook zo goed als stil, `speed_scale = 0`)
* Ik besloot als achtergrondmuziek om gewoon mijn eigen versie van "Zie ginds komt de stoomboot" in te spelen op de piano hier en op te nemen met mijn mobiel. (Ik heb jammer genoeg al tijden geen toegang tot mijn fatsoenlijke opname apparatuur, noch mijn digitale keyboard.) De geluidskwaliteit is dan matig, en ik mag niet te veel fouten maken, maar met wat editing is het "goed genoeg". Halverwege dacht ik "dit is wel wat zielig zo, het moet meer funky voor een party game", dus toen ging ik dat erbij improviseren. Ik kan goed genoeg piano spelen om er dan ter plekke zonder plan iets moois uit te krijgen :)

Het grootste probleem was eigenlijk dat mijn "One Button Game"-systeem serieuze gebreken had. Ik had dat systeem dus zo'n 2 jaar geleden opgezet met het idee dat ik dan precies die code voor alle andere OBGs kon gebruiken. Maar ja, het was een eerste versie, en ik was nog niet eens begonnen met mijn webshop, dus heel veel dingen misten en klopten niet. Vaak kom je pas achter wat praktische wijsheden door het systeem daadwerkelijk te _gebruiken_ voor een paar projecten.

Bijvoorbeeld, toen ik het OBG systeem maakte dacht ik "weet je wat, we gebruiken gewoon dezelfde neutrale lettertypes voor ALLE OBGs, lekker makkelijk!" Maar dat was een dom idee. Lettertypes zijn _de_ makkelijkste en snelste manier om een spel een helemaal passend en uniek uiterlijk te geven. Voor zo'n spel als dit wil ik mijn Sinterklaaslettertypes gebruiken, anders ziet het er ook gewoon raar uit. Maar ja, het hele systeem had lettertypes "ingebakken", dus ik kon ze niet veranderen!

Nou goed, vervolgens ben je dus uren bezig met code herschrijven zodat je makkelijk _per spel_ kunt aangeven "nee nee, deze keer wil ik DIT lettertype gebruiken". Zonder dat daarvoor dat onderliggende systeem ooit hoeft aangepast of opengebroken. Ik schrijf vast ergens een keer in het Engels een devlog over dat OBG systeem, als het volledig genoeg is dat ik het openbaar maak en anderen het ook kunnen gebruiken!

## Een _beter_ werkend spel

Op dit moment kan je het spel spelen en je kan door alle menu's en instellingen heen. Dat noem ik altijd "publishable". Je zou, theoretisch, het spel nu aan mensen kunnen geven en ze kunnen het dus spelen van begin tot eind. Dat betekent natuurlijk niet dat het _goed_ is en dat er niet allemaal ruwe randjes aan zitten. Maar ik probeer altijd zo snel mogelijk naar publishable te komen. 

{{% remark %}}
Dat is beter voor motivatie, want je hebt tenminste _iets_ dat werkt en speelbaar is. Daarnaast kan je de toekomst niet voorspellen en weet niet of/wanneer je het project weer opgeeft, en je wilt het liefst niet allerlei onspeelbare dingen achterlaten.
{{% /remark %}}

Dus nu ga ik kijken naar de grootste dingen die ik zou willen verbeteren, soort van op volgorde van prioriteit.

* Het zou leuker zijn als hij ook andere dingen bijhoudt tijdens het spelen, zodat je die op het eindscherm kan laten zien. Bijvoorbeeld: "je bent X keer tegen een eiland gebotst".
* Het grootste probleem is dat je nu kan kwijtraken waar je bent/heen moet, omdat de hele zee vrij groot en hetzelfde is. 
  * Dus ik bouwde een systeem dat jou kan laten zien waar je nog pakjes kan vinden.
  * Maar dit krijg je alleen te zien als je een specifiek pakje weet op te pakken (het "Grote Boek").
  * Leek me thematisch. Zorgt ervoor dat het niet te makkelijk/overweldigend is aan het begin, en je hebt een reden om heel graag dat boek te pakken als je hem ziet.
* Op dezelfde manier deed ik er ook een chocoladeletter bij die je sneller maakt (maar óók de pijlen sneller laat ronddraaien) elke keer als je er eentje eet.
* Ik voegde wat meer geluidseffecten toe.
* Ik loste nog wat stomme fouten op met mijn OBG systeem die dingen ofwel lieten crashen ofwel lelijk maakten.
* Ik koos ervoor om eilanden _terug te laten komen_ (na X seconden, en alleen als boot niet in de buurt). Anders zou je, na 5 minuten spelen, een compleet lege wereld hebben.

Dit zijn allemaal van die dingen die samen een uurtje kosten (of twee), maar het spel flink soepeler laten werken, dus dat is eigenlijk altijd wel de moeite waard.

## Conclusie

Hopelijk was het interessant om te lezen over de globale stappen en de problemen/oplossingen onderweg. _Samen Stoomboten_ is echt een heel klein en simpel spel. Maar, zoals je ziet, gaat zelfs daar veel tijd inzetten en sta je zelfs daar verrast door dingen die misgaan. Dit is een grappig spelletje dat ik hoop dat sommige mensen een leuke pakjesavond bezorgd. En voor mij was het een fijn proefkonijn voor dit systeem.

Uiteindelijk heb ik het grootste deel van de tijd besteed aan het _OBG systeem_ verbeteren. Want dat was nogal nodig. Mijn eerste versie van twee jaar geleden was "oké", maar eigenlijk nog maar 50% af. Nu is het OBG systeem nog steeds niet "af", maar het is ver genoeg om dit spel af te sluiten en te beginnen aan het tweede Sintspel dat ik als proefkonijn wilde gebruiken.

Tot de volgende keer,

Tiamo




**THEME SETTINGS**:
* Add all these individual theme settings (with `needsThemeRefresh` ON), grouped and all
  * Some don't need a refresh though, such as instruction scale or touch area size
* QOL: Also add an option to _generate_ this color scheme on the fly from a single accent color -> so add option to set COLOR, and a TOGGLE to tell the system to use it

**TOUCHSCREEN SUPPORT**
* Update text/image for TOUCH instructions ---> move AFFINITY file to tablet first
* Update ButtonVisualizer to show "touch" (just a hand with little arrows at finger tip)
* Proper background/texture for semi-transparent touch area 

SAMEN STOOMBOTEN:

* FOR RELEASE:
  * Set main scene to menu, set chunks back to 8 or something
  * I really want settings to look a little better than this.
* Do we NEED a tutorial?
* REFACTOR: Have fewer dependencies; if we do need them, INJECT them upon activation/ready
 