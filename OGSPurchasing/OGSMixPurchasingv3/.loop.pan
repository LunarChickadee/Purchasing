global FdName, Counter,strItemIng,strvItem

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
 copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
  //   message vInMixes
     vMix = «Mix Parent Code»
//     message vMix



ounter=1
strItem=str(vItem)

Loop
   FieldChoice="ItemIngredient"+str(Counter)
 Field (FieldChoice) 
//the parenthesis lets pan turn the              //variable into a valid "Field Name"
  Copycell
  vClip=str(clipboard())

     //Since we continue if we don't get 
     // match, we just need a false if
       If vClip≠strItem
          Increment Counter
        Endif

    //Since your last field is 17
    //We can use that to stop infinite loops 

        If counter=18 
             Message "no match found!"
        Endif

Stoploopif counter=18 
    
Until vClip=strItem

//If the loop didn't get to 18, then you got a //match

     right
     right
/*
Note: if this is to get to a field that has the same number as item ingredient you could reuse the Counter variable with the new field name just like we did above. 

This prevents issues if you ever decide to add another line item or something else that changes what "two rights from Ingridents" points to
*/
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     //message vInMixes
     vMix = «Mix Parent Code»
    // message vMix




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