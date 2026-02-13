# Database---Project-AutoFix
Databázový model informačního systému malé autodílny AutoFix. Projekt zahrnuje návrh konceptuálního schématu, SQL implementaci a dotazy pokrývající různé kategorie (JOIN, agregace, množinové operace, vnořené dotazy). Součástí jsou také ekvivalenty vybraných dotazů v relační algebře.

 Popis

Malá autodílna AutoFix poskytuje opravy a servis osobních vozidel. Každý zákazník může mít více vozidel a pro každé z nich mohou vznikat servisní zakázky. Cílem práce je navrhnout schéma databáze malé až střední autodílny. Ta má za úkol pokrýt evidenci zákazníků, zakázek, vozidel, použitých dílů, dostupných dílů, servisních úkonů a stavů plateb. Systém zaznamenává počet strávených hodin jednotlivých mechaniků na daných zakázkách. Každá zakázka může mít více na ní pracujících mechaniků a každý mechanik může pracovat na více zakázkách. Tím se zefektivní plánování kapacit a kalkulace nákladů. Dílna má omezený počet odstavných míst pro vozidla a tři pracovní plochy pro servisní práce. Databáze proto eviduje rezervace servisních stání a obsazenost odstavných míst, aby nedocházelo ke kolizím a přetížení kapacit. Každá zakázka má naplánovaný interval na konkrétním servisním stání, zatímco vozidla mimo aktivní opravu mohou být zařazena na dostupná odstavná místa. Práce se v rámci dostupných dílů nebude zabývat způsobem jejich skladování, pouze jejich dostupností na skladě, pro případné doobjednání. Pro každý díl evidujeme název, kód, prodejní cenu,počet kusů skladem a minimální zásobu, aby bylo možné včas doobjednat chybějící díly, tak aby byl zachován plynulý chod dílny a nestalo se, že u často používaných dílů se musí čekat po každé zakázce, než přijde nový kus. Částky za zakázky se počítají z počtu odpracovaných hodin a cen dílů. Díky dohledatelnosti nákladnosti a časové náročnosti jednotlivých zakázek bude možné efektivně odhadovat náklady a přibližnou finální částku, kterou bude muset zákazník zaplatit. V systému jsou sledovány různé stavové informace. Zakázky mohou být ve stavech přijatá, v realizaci, čeká na díl, dokončená nebo uzavřená. Servisní úkony mohou být naplánované, probíhající nebo dokončené. Faktury mohou být vystavené, po splatnosti, zaplacené nebo stornované. Platby mají stav nezaplaceno, částečně zaplaceno nebo zaplaceno a způsob platby. U všech stavových přechodů se zaznamenává datum, kdy k dané změně došlo, aby bylo možné sledovat časový průběh zakázek i plateb. Celý proces sleduje tok od zákazníka přes jeho vozidlo, přijetí zakázky, servisní úkony a použité díly až po vystavení faktury a její úhradu (platbu). Databázový model tak autodílně poskytne přehled o historii oprav, vytížení mechaniků, stavu skladových zásob a kapacitním využití pracovních ploch. Díky tomu bude možné lépe plánovat práci a urychlit proces vyúčtování zákazníků.

 Diskuze smyček

V navrženém modelu se žádné redundantní ani problémové smyčky nenacházejí. Níže jsou proto popsány pouze smyčky, které by v systému mohly vzniknout, pokud by byly jednotlivé entity propojeny nevhodným způsobem.

1) Zákazník – Vozidlo – Zakázka – Faktura – Platba – Zákazník

Pokud by existovala přímá vazba mezi Zákazníkem a Fakturou nebo Zákazníkem a Platbou, vznikla by smyčka umožňující evidovat platby či faktury mimo zakázku. To by vedlo k nekonzistentním datům. V modelu jsou však vazby vedeny výhradně přes Vozidlo a Zakázku, takže tato smyčka ve skutečnosti nevzniká.

2) Zakázka – Servisní úkon – Mechanik – Zakázka

Tato smyčka by vznikla, pokud by byl přidán přímý vztah mezi Mechanikem a Zakázkou. To by vytvořilo dvě různé cesty ke stejným informacím — přes Servisní úkon a přímo. Model však obsahuje pouze vazbu Mechanik–Servisní úkon, takže smyčka není skutečná a nemůže způsobit problémy.

3) Zakázka – Servisní úkon – Díl – Zakázka

Duplicitní smyčka by nastala, pokud by existoval přímý vztah Zakázka–Díl. V takové situaci by bylo možné zapisovat spotřebu dílů dvěma různými způsoby: přímo k zakázce nebo přes servisní úkony. Proto v modelu záměrně existuje pouze vazba Díl–Servisní úkon a přímá vazba k zakázce chybí.

4) Vozidlo – Zakázka – Servisní stání – Odstavné místo – Vozidlo

Pokud by časové atributy rezervace stání nebo odstavení vozidel byly uložené přímo v entitách Servisní stání či Odstavné místo, vznikla by smyčka, která by mohla vést k nejasnostem (např. že je vozidlo současně odstaveno i na stání). V modelu jsou však časové údaje správně vedeny pouze ve vztazích, takže žádná smyčka reálně nevzniká.

5) Další drobné smyčky

Další smyčky by mohly vzniknout zejména při přidání přímých vazeb typu Zakázka–Mechanik nebo Zakázka–Díl. Tyto vazby jsou v modelu záměrně vynechány, aby nedocházelo k duplicitním cestám. Proto se v aktuálním návrhu nevyskytují žádné skutečné smyčky.
