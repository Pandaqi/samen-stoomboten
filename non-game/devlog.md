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

* Het handige van zo'n simpele kaart is dat ik exact weet hoe lang hij is en dat de finish op het einde is. Dus ik kan een mooie horizontale balk laten zien met je voortgang.
* Die balk maakte ik een _staf_ voor het thema. En de krul is dan de plek waarover ik het aantal pakjes kan laten zien dat je hebt.
* Waar laat ik zien welk knopje iedereen heeft? Ik koos ervoor om je knop, in het klein, maar gewoon naast _elke pijl van jou_ te laten zien.








@TODO:

* BUG: Can't reload current scene because player_data can't grab an available color???
* BUG: Mouse-add-player not working anymore
* BUG: Why the fuck are the keycodes now in numerical order? (A,B,C,D) What did I do to make that happen???
* UI: HOW TO MAKE IT LOOK BETTER/MORE CONSISTENT??
  * Should've picked fixed (font) sizes for everything and stuck to that from the start ... only scale it based on ONE value (and/or nice multiples of it)
* Polishing
  * Set proper max player count (8)
  * Track time + number of bounces/hits too
  * Do we NEED a tutorial?
* REFACTOR
  * Add settings for this particular game (change world size, obstacle density, etc) + their translations of course
  * Have fewer dependencies; if we do need them, INJECT them upon activation/ready
* Optional
  * Actual water texture?
  * More things to encounter
    * Grote Boek -> Will show you where all the gifts/closest gifts are (for a limited duration?) -> AT THE VERY LEAST, WE NEED SOME "MARKERS" TO RECOGNIZE WHERE YOU ARE/HAVE BEEN
    * Pepernoten/Snoepgoed -> You move faster? But rotation also happens faster?
  * Nice atmospheric things
  * Soundtrack + Sound Effects

MAIN IMPROVEMENTS NOW:
* Change button instructions to use a control node and no wonky scaling -> though then the "corner" mode for it will be broken too ...
  * I want it a bit _flatter_ anyway; use more width, less height
* Cleaner way to grab that bold/italic font on special settings stuff
  * SHOULD PROBABLY JUST FORCE DEFAULT TO `.otf` or `.ttf`, always, pick one.
* Settings -> Make the checkbox prettier / more in line with others
  * Do I want to go all GRAYSCALE with a single ACCENT COLOR?
  * Yes, this is more powerful if we can CHANGE THAT COLOR (SCHEME) ON THE FLY for each game.

* **Write much better TODO/DOCS for starting new OBG project!**
  * ButtonsInstructions are needed! And I don't even mention them in the docs!
  * Shouldn't global.tscn also just be a standard scene?
  * CLEANER FONT STRUCTURE/REPLACEMENT
  * Also, the "button instructions scale now RESETS when going through main menu" ... the default values are completely unusable anyway
  * Surely I had an easier way to "repeatedly fire held signal"?
  * WRITE DOWN LESSONS LEARNED ABOUT TRANSLATING
  * Research GDExtensions and whether that's a better way to do my OBG framework
  * Should probably just pick X FIXED COLORS that look good for sure in the interface and when tinting. The "max player count" of OBGs is really, feasibly, 10 or 12 people anyway
  * YEAH IT'S NOT GREAT that I now have to alter things directly inside the framework (such as adding my own tabs to the menu.tscn scene) ---> ideally, the framework should remain untouched so I can just copy-paste to each new game
    * Same thing with setting a custom default language for NL-focused games ... now it will just default to English all the time

@TODO:

* Also prototype other game idea?