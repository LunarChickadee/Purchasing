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
find ItemNum = vItem
field (vMix)
cell vInMixes
window "Mixes"
downrecord
until info("stopped")
