global arrayLbsPerYear, ItemNumArray,wIngList,wMixIngList,wMxList,arrayFiles,thisfolder,wComments,wPurch,TotalSoldArray,
CurrentYear,PrevYear,TwoYearsAgo,ThreeYearsAgo, Yr1Array,Yr2Array,Yr3Array,Yr4Array,SoldHold

yesno "Years to get data from are: "+CurrentYear+", "+PrevYear+", "+TwoYearsAgo+", and "+ThreeYearsAgo+" ?"
if clipboard()="No"
message "Panorama will open the Procedure you need to edit. Find the //********** below"
goprocedure ".BuildData"
stop
endif

wPurch="MixPurchasingDB"
wComments="45ogscomments"
wMxList="MixIngList"
wIngList="IngMixList"
ItemNumArray=""

///these represent current (yr1) to 4 years back (yr4)
Yr1Array=""
Yr2Array=""
Yr3Array=""
Yr4Array=""

///Gets the List of Ingredients to Search with from the IngMixList
window wIngList
arraybuild ItemNumArray, ¶, "", «ItemList»


//********
//********
//these make it so all you have to do is chage the following code to make the rest work
//just change ##sold to the proper years!
window wComments
CurrentYear="45sold"
PrevYear="44sold"
TwoYearsAgo="43sold"
ThreeYearsAgo="42sold"
selectall
removeallsummaries
//********
//********

select ItemNumArray contains str(«parent_code»)
field «parent_code»
groupup


//loop1
firstrecord
loop
        if info("summary")>0
        arraystrip Yr1Array,¶
        field (CurrentYear)
        «» = float(arraynumerictotal(Yr1Array,¶))
        Yr1Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (CurrentYear)
        copycell
        SoldHold=clipboard()
        Yr1Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr1Array)
    downrecord
until info("stopped")

///Loop2
firstrecord
loop

    if info("summary")>0
        arraystrip Yr2Array,¶
        field (PrevYear)
        «» = float(arraynumerictotal(Yr2Array,¶))
        Yr2Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (PrevYear)
        copycell
        SoldHold=clipboard()
        Yr2Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr2Array)
    downrecord
until info("stopped")

///Loop3
firstrecord
loop

    if info("summary")>0
        arraystrip Yr3Array,¶
        field (TwoYearsAgo)
        «» = float(arraynumerictotal(Yr3Array,¶))
        Yr3Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (TwoYearsAgo)
        copycell
        SoldHold=clipboard()
        Yr3Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr3Array)
    downrecord
until info("stopped")

///Loop4
firstrecord
loop

    if info("summary")>0
        arraystrip Yr4Array,¶
        field (ThreeYearsAgo)
        «» = float(arraynumerictotal(Yr4Array,¶))
        Yr4Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (ThreeYearsAgo)
        copycell
        SoldHold=clipboard()
        Yr4Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr4Array)
    downrecord
until info("stopped")

lastrecord
deleterecord
nop

outlinelevel "2"

call .AppendToMixPurch

/*
Legend
arrayName=an array of names
dictNameX=(key/Value pair of Name and Something esle

788.5
*/
