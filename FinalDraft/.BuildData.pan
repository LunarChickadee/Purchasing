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

///**********************************************Part 2 Appending to The Purchasing Database

///Note: This uses global variables from .BuildData

global ParentDict, SoldArray, ParentCode, counter, Name,Lbs

ParentDict=""
SoldArray=""



///loop1
window wComments
firstrecord
loop
field (CurrentYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsThisYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop2
window wComments
firstrecord
loop
field (PrevYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field LbsLastYear
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsLastYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (TwoYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs2YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs2YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (ThreeYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs3YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs3YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

lastrecord
if str(ItemNum)=""
deleterecord
nop
endif


////******Part 3 Get the Mix Info

window wPurch







/*
Legend
arrayName=an array of names
dictNameX=(key/Value pair of Name and Something esle

788.5
*/
