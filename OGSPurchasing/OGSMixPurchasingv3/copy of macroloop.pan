/* This macro calculates how many pounds of an ingredient is available in the total available number of #s of that mix */
global vPercent, vInMixes, vMix, vItem,FdName, Counter,strItemIng,strvItem,Percentagefield

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
global 

Counter=1
FdName="ItemIngredient"+str(Counter)
strvItem=str(vItem)

loop
Field (FdName)
Copycell
  vClip=str(clipboard())
     If vClip≠strItem
          Increment Counter
        Endif
Stoploopif counter=18 
Until vClip=strItem

Percentagefield="Ingredient "+str(Counter)+" Description"
field (Percentagefield)
 copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
//     message vMix

;call .loop
debug

window wMixesDB
downrecord
field ItemNum
until info("stopped")
