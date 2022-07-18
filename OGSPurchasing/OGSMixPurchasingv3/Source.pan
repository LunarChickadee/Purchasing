
___ PROCEDURE FillFromClipboard ________________________________________________
local vHolder, Counter, ToPaste, vField

vHolder=Clipboard()
alertokcancel "Make sure you have a clipboard of data the same length as your records"
Counter=1
message "choose Field to Fill from Clipboard"
fieldsdialog
firstrecord
loop
ToPaste=array(vHolder,Counter,¶)
cell ToPaste
downrecord
increment Counter
until info("stopped")
___ ENDPROCEDURE FillFromClipboard _____________________________________________

___ PROCEDURE testselects ______________________________________________________
selectall
find ItemNum contains "dsafdsf"
;message "found"+str(info("found"))
;message "empty"+str(info("empty"))
if info("found")
message "Yes"
else
message "No"
endif
next

;if found true and empty is false, you found the right info
;if found and empy are true you didn't find it
;select ItemNum contains "5"
___ ENDPROCEDURE testselects ___________________________________________________

___ PROCEDURE FillMixes ________________________________________________________
Global MixCode, IngCheck, Item


window "MixesV2"

MixCode=«Mix Parent Code»
IngCheck=IngredientList

window "45MixPurchasingDB"

if IngCheck contains ItemNum
message "True"
else
message "False"
endif


___ ENDPROCEDURE FillMixes _____________________________________________________

___ PROCEDURE GetIngredientNums(L) _____________________________________________
local vCounter,vcheck, ASize
vCounter=1
ASize=arraysize(vAllStuff,",")+1

loop
field ItemNum
vcheck=array(vAllStuff,vCounter,",")
find ItemNum=vcheck

if info("found")
;message info("found")
goto skip

else
addrecord
cell vcheck
goto skip

skip:
increment vCounter
until vCounter=ASize
endif

___ ENDPROCEDURE GetIngredientNums(L) __________________________________________

___ PROCEDURE TestCompare ______________________________________________________
if CodeDict contains ItemNum
message "yes"
else
Message "No"
endif
___ ENDPROCEDURE TestCompare ___________________________________________________

___ PROCEDURE CreateGlobalArray ________________________________________________
global vItemArray
___ ENDPROCEDURE CreateGlobalArray _____________________________________________

___ PROCEDURE MixList __________________________________________________________
global vList, Mix, DB, itemStr, listOfItems,mixCode,mixArray

Mix="MixesV2"
DB="45MixPurchasingDB"


loop

window DB
itemStr=«ItemNum»

Window Mix
find IngredientList contains itemStr
if info("found")
    mixCode=«Mix Parent Code»
else
    window DB
    downrecord
        repeatloopif (not info("found"))
endif

window DB
Mix1=mixCode+","+Mix1

window Mix
repeatNext:
next
if info("found")
    mixCode=«Mix Parent Code»

    window DB
    Mix1=mixCode+","+Mix1
        goto repeatNext
endif

if (not info("found"))

window DB
downrecord
endif
until info("stopped")
___ ENDPROCEDURE MixList _______________________________________________________

___ PROCEDURE FillMixes2 _______________________________________________________
local listMix, aSize, counter1

loop
listMix=Mix1
listMix=arraystrip(listMix,",")
aSize=arraysize(listMix,",")

if aSize>1
Mix1=array(listMix,1,",")
Mix2=array(listMix,2,",")
Mix3=array(listMix,3,",")
Mix4=array(listMix,4,",")
Mix5=array(listMix,5,",")
endif
downrecord
until info("stopped")

/*
8369,8309
comma delimited array
element=things between delimiters
does not include delimiter in getting element
*/





___ ENDPROCEDURE FillMixes2 ____________________________________________________

___ PROCEDURE Available In Mix _________________________________________________
/* This macro calculates how many pounds of an ingredient is available in the total available number of #s of that mix */
global vPercent, vInMixes, vMix, vItem

local wMixesDB

vPercent = ""
vInMixes = ""
vItem = ""
wMixesDB = ""

vItem=ItemNum

wMixesDB = info("windowname")
firstrecord

loop

vItem=""
vItem=ItemNum

window "Mixes"
Select exportline() contains str(vItem)
////////////////////////////////////////
/*
loop
case
     str(ItemIngredient1) = str(vItem)
     field ItemIngredient1
     //str(clipboard())=str(vItem)
     //message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
    // message vMix
case
     str(ItemIngredient2) = str(vItem)
     field ItemIngredient2
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
    // message vMix
case
     str(ItemIngredient3) = str(vItem)
     field ItemIngredient3
     //str(clipboard())=str(vItem)
    // message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
    // message vInMixes
     vMix = «Mix Parent Code»
    // message vMix
case
     str(ItemIngredient4) = str(vItem)
     field ItemIngredient4
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
    // message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
case
     str(ItemIngredient5) = str(vItem)
     field ItemIngredient5
     //str(clipboard())=str(vItem)
   // message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
 case
     str(ItemIngredient6) = str(vItem)
     field ItemIngredient6
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
 case
     str(ItemIngredient7) = str(vItem)
     field ItemIngredient7
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient8) = str(vItem)
     field ItemIngredient8
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient9) = str(vItem)
     field ItemIngredient8
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient10) = str(vItem)
     field ItemIngredient10
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
//     message vInMixes
     vMix = «Mix Parent Code»
//     message vMix
 case
     str(ItemIngredient11) = str(vItem)
     field ItemIngredient11
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient12) = str(vItem)
     field ItemIngredient12
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
//     message vMix
 case
     str(ItemIngredient13) = str(vItem)
     field ItemIngredient13
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
//     message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient14) = str(vItem)
     field ItemIngredient14
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient15) = str(vItem)
     field ItemIngredient15
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
 case
     str(ItemIngredient16) = str(vItem)
     field ItemIngredient16
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient17) = str(vItem)
     field ItemIngredient17
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
//     message vMix
 endcase
window wMixesDB
find ItemNum = vItem
field (vMix)
cell vInMixes
window "Mixes"
downrecord
until info("stopped")
*/
///////////////////////////////////////////////

call .loop
debug

window wMixesDB
downrecord
field ItemNum
until info("stopped")







___ ENDPROCEDURE Available In Mix ______________________________________________

___ PROCEDURE .loop ____________________________________________________________
loop
case
     str(ItemIngredient1) = str(vItem)
     field ItemIngredient1
     //str(clipboard())=str(vItem)
     //message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
    // message vMix
case
     str(ItemIngredient2) = str(vItem)
     field ItemIngredient2
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
    // message vMix
case
     str(ItemIngredient3) = str(vItem)
     field ItemIngredient3
     //str(clipboard())=str(vItem)
    // message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
    // message vInMixes
     vMix = «Mix Parent Code»
    // message vMix
case
     str(ItemIngredient4) = str(vItem)
     field ItemIngredient4
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
    // message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
case
     str(ItemIngredient5) = str(vItem)
     field ItemIngredient5
     //str(clipboard())=str(vItem)
   // message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
 case
     str(ItemIngredient6) = str(vItem)
     field ItemIngredient6
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
 case
     str(ItemIngredient7) = str(vItem)
     field ItemIngredient7
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient8) = str(vItem)
     field ItemIngredient8
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient9) = str(vItem)
     field ItemIngredient8
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient10) = str(vItem)
     field ItemIngredient10
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
//     message vInMixes
     vMix = «Mix Parent Code»
//     message vMix
 case
     str(ItemIngredient11) = str(vItem)
     field ItemIngredient11
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient12) = str(vItem)
     field ItemIngredient12
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
//     message vMix
 case
     str(ItemIngredient13) = str(vItem)
     field ItemIngredient13
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
//     message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient14) = str(vItem)
     field ItemIngredient14
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient15) = str(vItem)
     field ItemIngredient15
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
  //   message vMix
 case
     str(ItemIngredient16) = str(vItem)
     field ItemIngredient16
     //str(clipboard())=str(vItem)
  //   message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
 //    message vMix
 case
     str(ItemIngredient17) = str(vItem)
     field ItemIngredient17
     //str(clipboard())=str(vItem)
   //  message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
 //    message vInMixes
     vMix = «Mix Parent Code»
//     message vMix
endcase
window wMixesDB
find ItemNum = vItem
field (vMix)
cell vInMixes
window "Mixes"
downrecord
until info("stopped")

___ ENDPROCEDURE .loop _________________________________________________________

___ PROCEDURE .test ____________________________________________________________
global StartingWinList, EndWindowList, vCount, WinChoice, EndSize
vCount=0
StartingWinList=ListWindows("")
makenewprocedure "(CommonFunctions)", ""
makenewprocedure "ExportMacros",""
makenewprocedure "ImportMacros",""
makenewprocedure "Symbol Reference",""
makenewprocedure "GetDBInfo",""
;---------
openprocedure "ExportMacros"
setproceduretext {local Dictionary1, ProcedureList
//this saves your procedures into a variable
exportallprocedures "", Dictionary1
clipboard()=Dictionary1
message "Macros are saved to your clipboard!"}
;---------
openprocedure "ImportMacros"
setproceduretext {local Dictionary1,Dictionary2, ProcedureList
Dictionary1=""
Dictionary1=clipboard()
yesno "Press yes to import all macros from clipboard"
if clipboard()="No"
stop
endif
//step one
importdictprocedures Dictionary1, Dictionary2
//changes the easy to read macros into a panorama readable file

//step 2
//this lets you load your changes back in from an editor and put them in
//copy your changed full procedure list back to your clipboard
//now comment out from step one to step 2
//run the procedure one step at a time to load the new list on your clipboard back in
//Dictionary2=clipboard()
loadallprocedures Dictionary2,ProcedureList
message ProcedureList //messages which procedures got changed
}
openprocedure "GetDBInfo"
setproceduretext {local DBChoice, vAnswer1, vClipHold
Message "This Procedure will give you the names of Fields, procedures, etc in the Database"
//The spaces are to make it look nicer on the text box
DBChoice="fields
forms
procedures
permanent
folder
level
autosave
fileglobals
filevariables
fieldtypes
records
selected
changes"
superchoicedialog DBChoice,vAnswer1,“caption="What Info Would You Like?"
captionheight=1”

vClipHold=dbinfo(vAnswer1,"")
bigmessage "Your clipboard now has the name(s) of "+str(vAnswer1)+"(s)"+¶+
"Preview: "+¶+str(vClipHold)
Clipboard()=vClipHold
}


openprocedure "Symbol Reference"
setproceduretext {bigmessage "Option+7= ¶  [in some functions use chr(13)
Option+= ≠ [not equal to]
Option+\= « || Option+Shift+\= » [chevron]
Option+L= ¬ [tab]
Option+Z= Ω [lineitem or Omega]
Option+V= √ [checkmark]
Option+M= µ [nano]
Option+<or>= ≤or≥ [than or equal to]"
}


///***********
///Clears all new windows made
//********
EndWindowList=listwindows("")
EndSize=arraysize(EndWindowList,¶)
vCount=1
loop
WinChoice=str(array(EndWindowList,val(vCount),¶))
if StartingWinList notcontains WinChoice
  window WinChoice
closewindow
increment vCount
    case StartingWinList contains WinChoice
    increment vCount
        repeatloopif vCount≠EndSize+1
    endcase
else
increment vCount
endif
until vCount=EndSize+1


___ ENDPROCEDURE .test _________________________________________________________

___ PROCEDURE (CommonFunctions) ________________________________________________

___ ENDPROCEDURE (CommonFunctions) _____________________________________________

___ PROCEDURE ExportMacros _____________________________________________________
local Dictionary1, ProcedureList
//this saves your procedures into a variable
exportallprocedures "", Dictionary1
clipboard()=Dictionary1
message "Macros are saved to your clipboard!"
___ ENDPROCEDURE ExportMacros __________________________________________________

___ PROCEDURE ImportMacros _____________________________________________________
local Dictionary1,Dictionary2, ProcedureList
Dictionary1=""
Dictionary1=clipboard()
yesno "Press yes to import all macros from clipboard"
if clipboard()="No"
stop
endif
//step one
importdictprocedures Dictionary1, Dictionary2
//changes the easy to read macros into a panorama readable file

//step 2
//this lets you load your changes back in from an editor and put them in
//copy your changed full procedure list back to your clipboard
//now comment out from step one to step 2
//run the procedure one step at a time to load the new list on your clipboard back in
//Dictionary2=clipboard()
loadallprocedures Dictionary2,ProcedureList
message ProcedureList //messages which procedures got changed

___ ENDPROCEDURE ImportMacros __________________________________________________

___ PROCEDURE Symbol Reference _________________________________________________
bigmessage "Option+7= ¶  [in some functions use chr(13)
Option+= ≠ [not equal to]
Option+\= « || Option+Shift+\= » [chevron]
Option+L= ¬ [tab]
Option+Z= Ω [lineitem or Omega]
Option+V= √ [checkmark]
Option+M= µ [nano]
Option+<or>= ≤or≥ [than or equal to]"

___ ENDPROCEDURE Symbol Reference ______________________________________________

___ PROCEDURE GetDBInfo ________________________________________________________
local DBChoice, vAnswer1, vClipHold
Message "This Procedure will give you the names of Fields, procedures, etc in the Database"
//The spaces are to make it look nicer on the text box
DBChoice="fields
forms
procedures
permanent
folder
level
autosave
fileglobals
filevariables
fieldtypes
records
selected
changes"
superchoicedialog DBChoice,vAnswer1,“caption="What Info Would You Like?"
captionheight=1”

vClipHold=dbinfo(vAnswer1,"")
bigmessage "Your clipboard now has the name(s) of "+str(vAnswer1)+"(s)"+¶+
"Preview: "+¶+str(vClipHold)
Clipboard()=vClipHold

___ ENDPROCEDURE GetDBInfo _____________________________________________________

-- 
Stasha Baldwin

