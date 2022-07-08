global vItem, vList, all_items, num_items, last_item, vRepacknum, vWarehouseID, vWarehouseitem1, vWarehouseitem2, vWarehouseitem3, 
vWarehouseitem4, vWarehouseArray, vWeight, vAmounttomake, vRepackType
    vList = ""
    vItem = Item
    vWarehouseID = ""
    vWeight = ""
    vRepackType = ""
     
local wasWindow
   wasWindow=info("windowname") 
 
vWarehouseitem1 = ""
vWarehouseitem2 = ""
vWarehouseitem3 = ""
vWarehouseitem4 = ""
vWarehouseArray = ""


//****Populates vWeight for mixes

vWeight  = ActWt

//****Opens Staff file to populate repack and recorder names.

//openfile "Staff"

//****Builds an array to populate field in repack DB that shows what repack items to use.
   
openfile "44ogscomments.warehouse"
window wasWindow  
gosheet
field «Repack Supplies»

arraylinebuild vWarehouseID,¶,"", «Repack Supplies»
vWarehouseitem1 = extract(vWarehouseID, ¶, 1)   
vWarehouseitem2 = extract(vWarehouseID, ¶, 2)
vWarehouseitem3 = extract(vWarehouseID, ¶, 3)
vWarehouseitem4 = extract(vWarehouseID, ¶, 4)
window "44ogscomments.warehouse"
    select str(IDNumber) contains vWarehouseitem1
    vWarehouseArray=«Item»+¬+«Description»+¶
    select str(IDNumber) contains vWarehouseitem2
    vWarehouseArray=vWarehouseArray+«Item»+¬+«Description»+¶
    select str(IDNumber) contains vWarehouseitem3
    vWarehouseArray=vWarehouseArray+«Item»+¬+«Description»+¶
    select str(IDNumber) contains vWarehouseitem4
    vWarehouseArray=vWarehouseArray+«Item»+¬+«Description»
    arraydeduplicate vWarehouseArray,vWarehouseArray,¶

window wasWindow

//****Regardless of which repack is needed OGSRepack will need to be
//****opened, a new record added for item being made, and the perm
//****ID filled into repack DB by calling the permID macro
//****Go back to CL to decide which form needs to be opened based on
//****what is displayed in the Form field

case «Type of Repack» ="Seed"
    vRepackType = «Type of Repack»
    openfile "44ogsrepack"
    gosheet    
    field RepackNumber
    sortup
    lastrecord
    addrecord
    field ItemNumMade1
    ItemNumMade1 = vItem
    «Repack Type» = vRepackType
    call .permID 
    openform "Seed Repack Form"  
case «Type of Repack» = "Seed/Mix"
       YesNo "Are you making a Repack? Click No if you are making a mix."
            if clipboard() contains "Yes"
                vRepackType = "Seed"
                openfile "44ogsrepack"
                gosheet
                field RepackNumber
                sortup
                lastrecord
                addrecord
                field ItemNumMade1
                ItemNumMade1 = vItem
                call .permID
                openform "Seed Repack Form"
                «Repack Type» = vRepackType
            else
                GetscrapOK "How many do you need to make?"
                vAmounttomake=val(clipboard())
                call .mixrepack
                openfile "44ogsrepack"
                gosheet    
                field RepackNumber
                    sortup
                    lastrecord
                    addrecord
                vRepackType = "Mix"    
                field ItemNumMade1
                    ItemNumMade1 = vItem
                call .permID
                TotalWt = vAmounttomake * vWeight
                AmountToMake = vAmounttomake
                openform "Mix Repack Form"
                «Repack Type» = vRepackType
            endif
case «Type of Repack» ="Kit"
    vRepackType = «Type of Repack»
   GetscrapOK "How many do you need to make?"
                vAmounttomake=val(clipboard())
                call .kitrepack
                openfile "44ogsrepack"
                gosheet    
                field RepackNumber
                    sortup
                    lastrecord
                    addrecord
                «Repack Type» = vRepackType
                field ItemNumMade1
                    ItemNumMade1 = vItem
                call .permID
                AmountToMake = vAmounttomake
                openform "Kit Repack Form"
case «Type of Repack» ="Item"
    vRepackType = «Type of Repack»
    openfile "44ogsrepack"
    gosheet    
    field RepackNumber
    sortup
    lastrecord
    addrecord
    «Repack Type» = vRepackType
    field ItemNumMade1
    ItemNumMade1 = vItem
    call .permID 
    openform "Item Repack Form"
case «Type of Repack» = "Item/Mix"
       YesNo "Are you making a Repack? Click No if you are making a mix."
            if clipboard() contains "Yes"
                vRepackType = "Item"
                openfile "44ogsrepack"
                gosheet
                field RepackNumber
                sortup
                lastrecord
                addrecord
                 «Repack Type» = vRepackType
                field ItemNumMade1
                ItemNumMade1 = vItem
                call .permID
               openform "Item Repack Form"  
            else
                vRepackType = "Mix"
                GetscrapOK "How many do you need to make?"
                vAmounttomake=val(clipboard())
                call .mixrepack
                openfile "44ogsrepack"
                gosheet    
                field RepackNumber
                    sortup
                    lastrecord
                    addrecord
                «Repack Type» = vRepackType
                field ItemNumMade1
                    ItemNumMade1 = vItem
                call .permID
                TotalWt = vAmounttomake * vWeight
                AmountToMake = vAmounttomake
                openform "Mix Repack Form"
            endif
case «Type of Repack» ="Mix"
    vRepackType = «Type of Repack»
 GetscrapOK "How many do you need to make?"
                vAmounttomake=val(clipboard())
                call .mixrepack
                openfile "44ogsrepack"
                gosheet    
                field RepackNumber
                    sortup
                    lastrecord
                    addrecord
                 «Repack Type» = vRepackType
                field ItemNumMade1
                    ItemNumMade1 = vItem
                call .permID
                TotalWt = vAmounttomake * vWeight
                AmountToMake = vAmounttomake
                openform "Mix Repack Form"
endcase
//Creating new Repack Number

Field RepackNumber

arraybuild all_items,¶,"",RepackNumber
arraynumericsort all_items,all_items,¶

num_items = arraysize(all_items,¶)
last_item = val(array(all_items,num_items,¶))

clipboard() = last_item + 1

RepackNumber=(clipboard())

vRepacknum=RepackNumber


