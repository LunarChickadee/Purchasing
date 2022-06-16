˛.Initializeˇforcesynchronize

selectall
field Item 
sortup

;openfile "NewSupplier"
;openfile "43OGSpurchasing"

if folderpath(dbinfo("folder","")) CONTAINS "sarah" and info("databasename") contains "linked"
    Field "IDNumber"
    SortUp
    SelectDuplicates ""
    if info("empty")
        field Item 
        sortup
    else
        message "Oh no, there are duplicate IDs!"
    endif
endif˛/.Initializeˇ˛.add-it-up-orderingˇglobal orderingaddup, soldwta, soldwtb, soldwtc, availwt, reord, soldwtatotal, soldwtbtotal, soldwtctotal, availwttotal, reordtotal

;;debug

arrayselectedbuild orderingaddup,¶, "44ogscomments.linked",
str(«42sold»)+¬+str(«43sold»)+¬+str(«44sold»)+¬+str(«44available»)+¬+str(«min»)+¬+str(«unit conversion»)+¬+str(«42sold»*«unit conversion»)
+¬+str(«43sold»*«unit conversion»)+¬+str(«44sold»*«unit conversion»)+¬+str(«44available»*«unit conversion»)+¬+str(«min»*«unit conversion»)

;;displaydata orderingaddup

arrayfilter orderingaddup, soldwta,¶,extract(import(),¬,7)
arrayfilter orderingaddup, soldwtb,¶,extract(import(),¬,8)
arrayfilter orderingaddup, soldwtc,¶,extract(import(),¬,9)
arrayfilter orderingaddup, availwt,¶,extract(import(),¬,10)
arrayfilter orderingaddup, reord,¶,extract(import(),¬,11)

;;displaydata reord

arraynumerictotal soldwta,¶, soldwtatotal
arraynumerictotal soldwtb,¶, soldwtbtotal
arraynumerictotal soldwtc,¶, soldwtctotal
arraynumerictotal availwt,¶, availwttotal
arraynumerictotal reord,¶, reordtotal
;;message reordtotal

if info("windowtype") = 15
    drawobjects
endif˛/.add-it-up-orderingˇ˛.clear_summariesˇRemoveSummaries 7˛/.clear_summariesˇ˛.depotordersˇglobal vItem

vItem = Item

message vItem

////Select items in tally that contain vItem

Openfile "44ogstally"

Select
    Order contains str(vItem) and ShipCode = "J" and Status <> "Com"
˛/.depotordersˇ˛.dropshipˇglobal ordersize, export, given, pon, suppinfo, intorder, progress, poitemarray
suppinfo=""
intorder=""
poitemarray=""
local waswindow, RecCount, ItemCount, POL#
waswindow=info("windowname")

yesno "you sure you're ready to place order?"

if val(forordering["0-9",1])=0
    message "Try adding a few items to the order first"
    stop 
endif
if clipboard() contains "n"
    window waswindow
    stop
endif

openfile "NewSupplier"
find SupplierIDNumber=val(extract(whichsupplier, "-", 1))
arraylinebuild suppinfo, ¶, "NewSupplier", str(SupplierIDNumber)+¬+Supplier+¬+¬+¬+Contact+¬+Fax+¬+Email+¬+Phone+¬+MAd+¬+City+¬+St+¬+pattern(Zip,"#####")

window waswindow
forordering=arraystrip(forordering,¶)
arrayfilter forordering, intorder, ¶, extract(extract(forordering, ¶, seq()),¬, 1)+¬+extract(extract(forordering, ¶, seq()),¬, 2)+¬+
    extract(extract(forordering, ¶, seq()),¬, 3)+¬+extract(extract(forordering, ¶, seq()),¬, 4)+¬+
    extract(extract(forordering, ¶, seq()),¬, 5)+¬+extract(extract(forordering, ¶, seq()),¬, 6)+¬+
    extract(extract(forordering, ¶, seq()),¬, 7)+¬+suppinfo+¬+¬+¬+extract(extract(forordering, ¶, seq()),¬, 8)


arraysort intorder,intorder,¶


export=intorder


ordersize=extract(extract(intorder,¶, 1),¬,5)


openfile "44ogsdropship"
Synchronize
goform "Entry"
selectall
field PO
SortUp
RecCount=info("Records")

openfile "+@export"

ItemCount=info("Records")-RecCount


if ItemCount>1
    field PO
    Maximum
    Copy
    RemoveSummaries 7
    clipboard()=val(clipboard()+1)
    LastRecord
    Paste
        loop
            uprecord
            Paste
        until ItemCount-1
    copycell
    ;message clipboard()
    select PO=val(clipboard())
    field «PO Line No»
    FormulaFill seq()
    field Date
    Date=today()
    field OrderNo
    formulafill vvoice
else
    field PO
    Maximum
    Copy
    RemoveSummaries 7
    clipboard()=val(clipboard()+1)
    LastRecord
    Paste
    field «PO Line No»
    «PO Line No»=1
    field Date
    Date=today()
    OrderNo=vvoice
endif
selectall
lastrecord
if ItemCount>1
    loop
        uprecord
    until ItemCount-1
endif

lastrecord
field PO
COPY
select PO=val(clipboard())
call Gather

;message "hello"

debug
;message "history"
window waswindow
select Item = lookupselected("44ogsdropship","Item",Item,"Item","",0)
;message "last"
if info("empty")
    goto warehouse
endif

field «Purchased»
formulafill «Purchased»+lookupselected("44ogsdropship",Item,Item,"Qty",0,0)

warehouse:
openfile "44ogscomments.warehouse"
select Item=lookupselected("44ogsdropship","Item",Item,"Item","",0)

if info("empty")
else
    field «Purchased»
    formulafill «Purchased»+lookupselected("44ogsdropship",Item,Item,"Qty",0,0)
endif

window "44ogsdropship:Entry"
lastrecord
˛/.dropshipˇ˛.exportˇglobal ordersize, export, given, pon, suppinfo, intorder, progress, poitemarray
suppinfo=""
intorder=""
poitemarray=""
local WindowCL, RecCount, ItemCount, POL#
WindowCL=info("windowname")


/*
******Adds PO information into the purchasing DB
*/


yesno "you sure you're ready to place order?"
//if forordering variable is empty this message will occur and stop the macro
if val(forordering["0-9",1])=0
    message "Try adding a few items to the order first"
    stop 
endif
//if user clicks "no" the macro will stop
if clipboard() contains "n"
    window WindowCL
    stop
//if yes is clicked the macro proceeeds
endif



//open newsupplier database
openfile "NewSupplier"
//find the supplierIDnumber that equals the whichsupplier variable
find SupplierIDNumber=val(extract(whichsupplier, "-", 1))
//building an array called SUPPINFO which contains supplier contact information
arraylinebuild suppinfo, ¶, "NewSupplier", str(SupplierIDNumber)+¬+Supplier+¬+¬+¬+Contact+¬+Fax+¬+Email+¬+Phone+¬+MAd+¬+City+¬+St+¬+pattern(Zip,"#####")

window WindowCL
forordering=arraystrip(forordering,¶)
arrayfilter forordering, intorder, ¶, extract(extract(forordering, ¶, seq()),¬, 1)+¬+extract(extract(forordering, ¶, seq()),¬, 2)+¬+
    extract(extract(forordering, ¶, seq()),¬, 3)+¬+extract(extract(forordering, ¶, seq()),¬, 4)+¬+
    extract(extract(forordering, ¶, seq()),¬, 5)+¬+extract(extract(forordering, ¶, seq()),¬, 6)+¬+
    extract(extract(forordering, ¶, seq()),¬, 7)+¬+suppinfo+¬+¬+¬+extract(extract(forordering, ¶, seq()),¬, 8)

bigmessage forordering

arraysort intorder,intorder,¶

clipboard()=intorder

;stop

export=intorder


ordersize=extract(extract(intorder,¶, 1),¬,5)


openfile "44OGSpurchasing"
Synchronize
;message "yup"
goform "Entry"
;message "still good"
selectall
field PO
SortUp
RecCount=info("Records")

openfile "+@export"

ItemCount=info("Records")-RecCount


if ItemCount>1
    field PO
    Maximum
    Copy
    RemoveSummaries 7
    clipboard()=val(clipboard()+1)
    LastRecord
    Paste
        loop
            uprecord
            Paste
        until ItemCount-1
    copycell
    ;message clipboard()
    select PO=val(clipboard())
    field «PO Line No»
    FormulaFill seq()
    field Date
    Date=today()
else
    field PO
    Maximum
    Copy
    RemoveSummaries 7
    clipboard()=val(clipboard()+1)
    LastRecord
    Paste
    field «PO Line No»
    «PO Line No»=1
    field Date
    Date=today()
endif
selectall
lastrecord
if ItemCount>1
    loop
        uprecord
    until ItemCount-1
endif

lastrecord
field PO
COPY
select PO=val(clipboard())
call Gather

;message "hello"

debug
;message "history"
window WindowCL
select Item = lookupselected("44OGSpurchasing","Item",Item,"Item","",0)
;message "last"
if info("empty")
    goto warehouse
endif

field «On Order»
formulafill «On Order»+lookupselected("44OGSpurchasing",Item,Item,"Qty",0,0)

warehouse:
openfile "44ogscomments.warehouse"
select Item=lookupselected("44OGSpurchasing","Item",Item,"Item","",0)

if info("empty")
else
    field «On Order»
    formulafill «On Order»+lookupselected("44OGSpurchasing",Item,Item,"Qty",0,0)
endif

window "44OGSpurchasing:Entry"
firstrecord
progress = str(PO)+¬+¬+¬+¬+¬+¬+¬+¬+str(SupplierID)+¬+Company+¬+¬+datestr(Date)+¬+str(Total)
openfile "44OGSinvoices"
openfile "+@progress"
˛/.exportˇ˛.finditemˇlocal finditem
GetscrapOK "What's the Item# ?"
finditem=val(clipboard())
Select «parent_code»=finditem
˛/.finditemˇ˛.get_summariesˇSelect «can be added up» contains "Y"

Field «parent_code»
GroupUp

Field «can be added up»
Maximum

Field TotalPoundsToSell
Maximum

SelectAll˛/.get_summariesˇ˛.limitˇif
val(length(Description))>20
message "Description is too long"
endif˛/.limitˇ˛.LiveQueryˇfileglobal liveQuery, queryResult
liveclairvoyance liveQuery, queryResult, ¶, "The List", "NewSupplier", Supplier, "contains", str(SupplierIDNumber)+¬+Supplier,30,0,ALL
;superobject "The List", "Open", "FillList", "close"

;drawobjects

˛/.LiveQueryˇ˛.makeadjustmentˇglobal vItem
vItem = Item
openfile "44Inventory Adjustment"
field Item
addrecord
Item = vItem
call .permid
˛/.makeadjustmentˇ˛.createrepackˇglobal vItem, vList, all_items, num_items, last_item, vRepacknum, vWarehouseID, vWarehouseitem1, vWarehouseitem2, vWarehouseitem3, 
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

openfile "Staff"

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


˛/.createrepackˇ˛.permIDˇ˛/.permIDˇ˛.placeorderˇglobal orderline, orderquantity, test2, intorder, ordersize
ordersize=""
orderline=""
orderquantity=0
intorder=""

find Item=extract(itemlist," ",1)
if info("found")
    getscrap "How many "+Description+" "+str(«Sz.»)+"# ?"
    orderquantity=clipboard()
        if val(orderquantity)=0
            stop
        endif
    orderline=str(IDNumber)+¬+str(Item)+¬+Description+¬+str(«Sz.»)+¬+str(«44cost»)+¬+orderquantity+¬+str(int(«44available»))+¬+SupplierID+¶
else
    window "44ogscomments.warehouse"
    find Item=extract(seconditemlist," ",1)
    getscrap "How many "+Description+" "+str(Unit)+" ?"
    orderquantity=clipboard()
        if val(orderquantity)=0
            stop
        endif
    orderline=str(IDNumber)+¬+str(Item)+¬+Description+¬+Unit+¬+str(«44Cost»)+¬+orderquantity+¬+str(int(«44Available»))+¬+str(SupplierID)+¶
endif

//orderquantity=clipboard()
//if val(orderquantity)=0
//    stop
//endif

//orderline=str(IDNumber)+¬+str(Item)+¬+Description+¬+str(«Sz.»)+¬+str(«44cost»)+¬+orderquantity+¬+str(int(«44available»))+¬+SupplierID+¶

clipboard()=orderline
stop

window "44ogscomments.linked:Generate-POnew"

forordering=forordering+orderline


arrayfilter forordering, intorder, ¶, extract(extract(forordering, ¶, seq()),¬, 1)+¬+extract(extract(forordering, ¶, seq()),¬, 2)+¬+
    extract(extract(forordering, ¶, seq()),¬, 3)+¬+extract(extract(forordering, ¶, seq()),¬, 4)+¬+
    extract(extract(forordering, ¶, seq()),¬, 5)+¬+extract(extract(forordering, ¶, seq()),¬, 6)+¬+
    extract(extract(forordering, ¶, seq()),¬, 7)+¬+¬+¬+¬+extract(extract(forordering, ¶, seq()),¬, 8)
clipboard()=intorder

ordersize=extract(extract(intorder,¶, 1),¬,5)

superobject "fromsupplier", "open"
activesuperobject "Close"

;clipboard()=forordering
˛/.placeorderˇ˛.selectaparentˇlocal parento
gettext "Which Item? (XXXX)",parento
select «parent_code»=val(parento)˛/.selectaparentˇ˛.selectIDˇItem = lookup("44ogscomments.linked","Item",«Item»,"IDNumber",0,0)
Description = lookup("44ogscomments.linked", "Item", «Item», "Description","",0)˛/.selectIDˇ˛.selectsupplierˇglobal forordering, itemlist, disorder, seconditemlist
superobject "fromsupplier", "Open"
activesuperobject "Clear"
activesuperobject "Close"
forordering=""
itemlist=""
seconditemlist=""

select SupplierNo_Primary=val(whichsupplier[1,"-"][1,-2])
if info("empty")
else
    arrayselectedbuild itemlist, ¶,"",str(Item)[1,-1]+rep(chr(32),31-length(Description[1,30]))+Description[1,30]+rep(chr(32), 5-length(str(«Sz.»)))+str(«Sz.»)
 +rep(chr(32),7-length(str(«44cost»)))+str(«44cost»)+rep(chr(32),7-length(str(«44available»)))+str(«44available»)
 endif
 
 ;; go to comments.warehouse
 openfile "44ogscomments.warehouse"
 select SupplierNo_Primary=val(whichsupplier[1,"-"][1,-2])
 if info("empty")
 else
     ;; build a similar array
     
    arrayselectedbuild seconditemlist, ¶,"",str(Item)[1,-1]+rep(chr(32),31-length(Description[1,30]))+Description[1,30]+rep(chr(32), 5-length(str(«Unit»)))+str(«Unit»)
 +rep(chr(32),7-length(str(«44Cost»)))+str(«44Cost»)+rep(chr(32),7-length(str(«44Available»)))+str(«44Available»)
  
//arrayselectedbuild seconditemlist, ¶,"",str(Item)[1,-1]+rep(chr(32),31-length(Description[1,30]))+Description[1,30]+rep(chr(32), 5-length(str(«Unit»)))+str(«Unit»)
//+rep(chr(32),7-length(str(«44Cost»)))+str(«44Cost»)+rep(chr(32),7-length(str(«44Available»)))+str(«44Available»)
   
 endif
 
 ;; append it to itemlist
 itemlist = itemlist + ¶ + seconditemlist
 
 window "44ogscomments.linked:Generate-POnew"

superobject "neworder", "FillList"˛/.selectsupplierˇ˛.springpuordersˇglobal vItem

vItem = Item

message vItem

////Select items in tally that contain vItem

Openfile "44ogstally"

Select
    Order contains str(vItem) and ShipCode = "P" and Status <> "Com"˛/.springpuordersˇ˛get next IDˇ;; This macro finds the highest permanent ID in the database, and generates the next ID
;; to come after that. The next ID is displayed in a popup message, and is put onto
;; the clipboard, so you can easily paste it.

local all_items, num_items, last_item

arraybuild all_items,¶,"",IDNumber
arraynumericsort all_items,all_items,¶

num_items = arraysize(all_items,¶)
last_item = val(array(all_items,num_items,¶))

clipboard() = last_item + 1
message "Whichever item is the newer one should get an ID of " + str(last_item+1)˛/get next IDˇ˛bookpricelinesˇ;; this macro generates catalog pricelines for books. It looks like the priceline field
;; is currently being used for something else, so check with Renee before running
;; this as it will wipe out the contents of that field. -SAO 9/7/21

field priceline
formulafill ¬+str(Item)+": "+Description+" ("+str(sz)+"#)/"+pattern(Price, "$#.##")˛/bookpricelinesˇ˛ChkInvˇ;; This macro is not currently functional, but could in theory be rehabilitated. What it's *trying*
;; to do is loop through all selected records, and if 44available is less than the reorder point,
;; it'll ask you if you want to change the reorder point. There is not currently a field in the
;; database called "reorder point," so it doesn't work.


local stuff
loop
    if «44available»≤«reorder point»
        stuff="Hey! "+str(«Item»)+" "+str(«Sz.»)+"#'s is gettin' low. Would you like to change the reorder threshold?"
        noyes stuff
        if clipboard() contains "y"
            getscrap "New reorder threshold for "+str(«Item»)+"?"
            «reorder point»=val(Clipboard())
        endif
    endif
downrecord
until info("eof")    ˛/ChkInvˇ˛pricelinesˇ;; Fills in catalog pricelines. Don't run this without checking with Renee, as it looks like she is
;; using the priceline field for something else currently. -SAO 9/7/21

field priceline
formulafill ¬+str(Item)+": "+?(«unit note»="",str(«Sz.»)+"# for "+pattern(Price, "$#.##"),«unit note»+" ("+str(«Sz.»)+"#) for "+pattern(Price, "$#.##"))
˛/pricelinesˇ˛tabdown/2ˇ;; a helper macro that triggers equations to recalculate

firstrecord
loop
Cell «»
downrecord
until info("stopped")
˛/tabdown/2ˇ˛add it up selectionˇ;; I think this macro isn't used by anyone. Check with Stasha. -SAO 9/7/21

;; runs the add it up macro just on the current selection.
;; only works on products with "can be added up" = "Y"
;; you must have all sizes selected. You can have one or more
;; products selected, as long as all sizes of each are selected.

Selectwithin «can be added up» contains "Y"
Field "parent_code"
GroupUp

Field TotalPoundsToSell
FormulaFill «unit conversion»*«44available»
Total

CollapseToLevel "1"
Field "TotalUnitsToSell"
FormulaFill TotalPoundsToSell

CollapseToLevel "Data"

Field "TotalPoundsToSell"
Fill ""
CollapseToLevel "1"

FormulaFill TotalUnitsToSell

CollapseToLevel "Data"
Field "TotalPoundsToSell"
PropagateUP

RemoveSummaries "7"

Field "TotalUnitsToSell"
FormulaFill TotalPoundsToSell/?(«unit conversion»>0,«unit conversion»,1)

//SelectAll

Field "Item"
Sortup˛/add it up selectionˇ˛findathing/1ˇ;; This is used in the add-it-up-purchasing form

getscrap "Which Item?"
if val(clipboard())=0
find Description contains clipboard()
else
find Item contains clipboard()
endif˛/findathing/1ˇ˛add-it-up-purchasingˇglobal orderingaddup, soldwta, soldwtb, soldwtc, availwt, reord, soldwtatotal, soldwtbtotal, soldwtctotal, availwttotal, reordtotal

arrayselectedbuild orderingaddup,¶, "44ogscomments.linked",
str(«42sold»)+¬+str(«43sold»)+¬+str(«44sold»)+¬+str(«44available»)+¬+str(«reorder point»)+¬+str(«unit conversion»)+¬+str(«42sold»*«unit conversion»)
+¬+str(«43sold»*«unit conversion»)+¬+str(«44sold»*«unit conversion»)+¬+str(«44available»*«unit conversion»)+¬+str(«reorder point»*«unit conversion»)

;;displaydata orderingaddup

arrayfilter orderingaddup, soldwta,¶,extract(import(),¬,7)
arrayfilter orderingaddup, soldwtb,¶,extract(import(),¬,8)
arrayfilter orderingaddup, soldwtc,¶,extract(import(),¬,9)
arrayfilter orderingaddup, availwt,¶,extract(import(),¬,10)
arrayfilter orderingaddup, reord,¶,extract(import(),¬,11)

;;displaydata reord

arraynumerictotal soldwta,¶, soldwtatotal
arraynumerictotal soldwtb,¶, soldwtbtotal
arraynumerictotal soldwtc,¶, soldwtctotal
arraynumerictotal availwt,¶, availwttotal
arraynumerictotal reord,¶, reordtotal
;;message reordtotal

if info("windowtype") = 15
    drawobjects
endif˛/add-it-up-purchasingˇ˛Check a Pickup/3ˇ;; Looks like this macro is supposed to help check the inventory
;; of items needed for a pickup order (or orders).
;; Not sure if this macro is currently being used. -SAO 9/7/21

local nolines
getscrap "How Many Items?"
nolines=val(clipboard())
getscrap "First Item:"
select Item contains clipboard()
if nolines>1
loop
getscrap "Next Item:"
selectadditional Item contains clipboard()
until nolines-1
endif
goform "Inventory for Pickup"˛/Check a Pickup/3ˇ˛How Much?/4ˇ;; tells you the value of 44available for whatever record you're currently on.
;; Not sure if this macro is being used -SAO 9/7/21

message «44available»˛/How Much?/4ˇ˛Generate a Pricelineˇ;; exports a text file with a priceline for one item (whatever record is active).
;; not sure if this macro is used -SAO 9/7/21

local thisone
thisone=Item
select Item=thisone
export Description+" priceline",Description+"®"+¬+str(Item)+": "+?(«unit note»≠""," "+«unit note»+" ","")+?(Comments="",str(«Sz.»)+"#/"," ("+str(«Sz.»)+"#)/")+pattern(Price, "$#.##")+?(Price≥100,"*","")
selectall
find Item=thisone˛/Generate a Pricelineˇ˛pricelines-screwyˇ;; not sure whether this macro is used -SAO 9/7/21

;select Listed contains "cat"
field priceline
formulafill ¬+str(«sparetext4»)+": "+?(«unit note»="",str(«Sz.»)+"#/"+pattern(CatalogPrice, "$#.##"),«unit note»+" ("+str(«Sz.»)+"#)/"+pattern(CatalogPrice, "$#.##"))˛/pricelines-screwyˇ˛deleteˇ;; Loops through the database and deletes all selected records
;; (except for the last one). Seems dangerous! Consider removing? -SAO 9/7/21

yesno "are you sure you want to run the delete macro?"
if clipboard() contains "y"
loop
deleterecord
until info("selected")=1
else
stop
endif˛/deleteˇ˛checknofaˇ;; I think this macro checks to make sure each successive
;; size code for a given item actually gives you a better deal
;; (by weight). Seems like it's intended to be run while you
;; have all size codes selected for a given seed variety.

local priceone, pricetwo
loop
priceone=CatalogNOFA/ActWt
loop
downrecord
pricetwo=divzero(CatalogNOFA,ActWt)
if pricetwo>.95*priceone
message "check"
stop
endif
priceone=pricetwo
until info("summary")>0
downrecord
until Category notcontains "Seed"˛/checknofaˇ˛selectmoreˇglobal vitemy
loop
vitemy=«parent_code»
selectadditional «parent_code»=vitemy and Listed≠"No"
loop
downrecord
until «parent_code»=vitemy
loop
downrecord 
until «parent_code»≠vitemy
until info("stopped")˛/selectmoreˇ˛Intrucking change by wtˇ;; this macro allows you to input the cost of intrucking a 50# bag and automatically
;; calculate the intrucking of the smaller sizes, though you DO need to tab
;; through to get the "base" to update

local tempvariable, costvariable, perpound
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Find «ActWt»=50
gettext "new cost?", costvariable
costvariable=val(costvariable)
«intrucking»=costvariable
perpound=costvariable/50
Field «intrucking»
FormulaFill perpound*«ActWt»˛/Intrucking change by wtˇ˛What's available by the #ˇlocal tempvariable, totalvariable

gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Field sparemoney3
FormulaFill «Sz.»*«44available»
Total
lastrecord
totalvariable=sparemoney3
removeallsummaries

message "we currently have "+str(totalvariable)+" pounds available"

;This is for automatically calculating how many total pounds we currently have available of a product 8/4/21 RM
˛/What's available by the #ˇ˛(Purchasing)ˇ˛/(Purchasing)ˇ˛PO - Open the databases!ˇopenfile "NewSupplier"
openfile "44ogscomments.warehouse"
openfile "44OGSpurchasing"˛/PO - Open the databases!ˇ˛bringonthebooks/5ˇ;; Looks like this macro is for receiving books. Maybe because book orders
;; don't go through the purchasing database?

local justso, desc, somany

again:
justso=""
desc=""
somany=0
select Category contains "Book"
getscrap "Which book came in?"
justso=clipboard()
selectwithin Description contains justso
desc=Description
getscrap "How many " +desc+ "s came in?"
somany=val(clipboard())

field Purchased
Purchased=Purchased+somany
field «On Order»
«On Order»=«On Order»-somany

Yesno 
"Did any other books come in?"
if clipboard() contains "Yes"
goto again
else 
endif


˛/bringonthebooks/5ˇ˛Annual - Pounds Neededˇlocal tempvariable, totalvariable
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Field sparemoney3
FormulaFill «Sz.»*«43sold»
Total
lastrecord
totalvariable=sparemoney3
removeallsummaries
message "last year we sold "+str(totalvariable)+" pounds"

;This is for automatically calculating how many total pounds we sold last year of a product 8/4/21 RM ˛/Annual - Pounds Neededˇ˛All Seed Sizes and Mixesˇlocal tempvariable
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable or «mixkit» contains tempvariable˛/All Seed Sizes and Mixesˇ˛What did we sell/9ˇif «add/drop» contains "new"
message str(«44sold»)+" sold so far this year"
else
message "43sold: "+str(«43sold»)+¶+"42sold: "+str(«42sold»)+¶+¶+str(«44sold»)+" sold so far this year"
endif˛/What did we sell/9ˇ˛Cost Change 50#&smallerˇ;; this macro allows you to input the cost of a 50# bag and automatically
;; calculate the cost of the smaller sizes, though you DO need to tab
;; through to get the "base" to update

local tempvariable, costvariable, perpound
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Find «ActWt»=50
gettext "new cost?", costvariable
costvariable=val(costvariable)
«44cost»=costvariable
perpound=costvariable/50
Field «44cost»
FormulaFill perpound*«ActWt»

˛/Cost Change 50#&smallerˇ˛Cost Change 25#&smallerˇ;; this macro allows you to input the cost of a 25# bag and automatically
;; calculate the cost of the smaller sizes, though you DO need to tab
;; through to get the "base" to update


local tempvariable, costvariable, perpound
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Find «ActWt»=25
gettext "new cost?", costvariable
costvariable=val(costvariable)
«44cost»=costvariable
perpound=costvariable/25
Field «44cost»
FormulaFill perpound*«ActWt»˛/Cost Change 25#&smallerˇ˛FY43 sold - total feetˇlocal tempvariable, totalvariable
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Field sparemoney3
FormulaFill «unit conversion»*«43sold»
Total
lastrecord
totalvariable=sparemoney3
removeallsummaries
message "last year we sold "+str(totalvariable)+" feet"

;This is for automatically calculating how many total feet we sold last year of a product 10/21 RM˛/FY43 sold - total feetˇ˛Available - by the footˇlocal tempvariable, totalvariable
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Field sparemoney3
FormulaFill «unit conversion»*«44available»
Total
lastrecord
totalvariable=sparemoney3
removeallsummaries
message "we have "+str(totalvariable)+" feet available"

;This is for automatically calculating how many total feet we have available of a product 10/21 RM˛/Available - by the footˇ˛Generate POˇopenfile "NewSupplier"
openfile "44ogscomments.warehouse"
window "44ogscomments.linked"
openform "Generate-POnew"˛/Generate POˇ˛Pricing Inquiryˇopenform "Pricing Inquiry"
˛/Pricing Inquiryˇ˛FY42 - Pounds Soldˇlocal tempvariable, totalvariable
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Field sparemoney3
FormulaFill «Sz.»*«42sold»
Total
lastrecord
totalvariable=sparemoney3
removeallsummaries
message "in FY42 we sold "+str(totalvariable)+" pounds"

;This is for automatically calculating how many total pounds we sold FY42 of a product 8/4/21 RM˛/FY42 - Pounds Soldˇ˛All Supplier Parent Codesˇlocal vSupplier, vParentcode

///vSupplier will be defined as the name of the supplier
///vParentcode will be defined as the parent code of items
///Search within the Supplier field that contains what is entered in the GetScrap prompt

GetscrapOK "What is the name of the supplier?"
vSupplier=str(clipboard())
Select «Supplier» contains vSupplier

///Expand the search to include all size codes within the selection
Field «parent_code»
Sortup
Firstrecord

vParentcode=«parent_code»
SelectAdditional str(«parent_code») contains str(vParentcode)

noshow

loop
    if 
        «parent_code»=vParentcode
        downrecord     
    else 
        vParentcode=""
        vParentcode=«parent_code»
        SelectAdditional str(«parent_code») contains str(vParentcode)
        
///Below piece of code put in because after running the "else" statement the first record
///Would be selected again.

        find val(vParentcode) = «parent_code»
        downrecord   
    endif
until info("stopped")

endnoshow

firstrecord
˛/All Supplier Parent Codesˇ˛(Inventory)ˇ˛/(Inventory)ˇ˛Update Tally Numbersˇrememberwindow
openfile "44orderedogs"

originalwindow

field ("44soldtally")
select «» <> lookupselected("44orderedogs","IDNumber", IDNumber, "qty", 0,1)

Selectwithin IDNumber=lookupselected("44orderedogs","IDNumber",IDNumber,"IDNumber",0,1)

field ("44soldtally")
formulafill lookupselected("44orderedogs","IDNumber", IDNumber, "qty", 0,1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Field ("44tallyfilled")
Select «» <> lookupselected("44orderedogs","IDNumber",IDNumber,"fill",0,1)

selectwithin IDNumber=lookupselected("44orderedogs","IDNumber",IDNumber,"IDNumber",0,1)

Field ("44tallyfilled")
formulafill lookupselected("44orderedogs","IDNumber",IDNumber,"fill",0,1)

;;SelectAll

window "44orderedogs"
closewindow

originalwindow

message "Finished Tally Sold/Filled Update"˛/Update Tally Numbersˇ˛rebuild_repack_numbersˇrememberwindow
openfile "repack_vertical_file"

originalwindow

Field ("44repack")
Select «» <> lookupselected("repack_vertical_file","IDNumber",IDNumber,"Net",0,0)

selectwithin IDNumber=lookupselected("repack_vertical_file","IDNumber",IDNumber,"IDNumber",0,0)

Field ("44repack")
formulafill lookupselected("repack_vertical_file","IDNumber",IDNumber,"Net",0,0)

call "tabdown/2"

;SelectAll
window "repack_vertical_file"
closewindow

originalwindow

message "Finished Repack Update"˛/rebuild_repack_numbersˇ˛walkin_sales_updateˇrememberwindow
openfile "44walkin_vertical_ogs"

originalwindow
Field ("44soldwalkin")
Select «» <> lookupselected("44walkin_vertical_ogs","IDNumber",IDNumber,"qty",0,1)

selectwithin IDNumber=lookupselected("44walkin_vertical_ogs","IDNumber",IDNumber,"IDNumber",0,1)

Field ("44soldwalkin")
formulafill lookupselected("44walkin_vertical_ogs","IDNumber",IDNumber,"qty",0,1)

SelectAll
window "44walkin_vertical_ogs"
closewindow

originalwindow

;;--------------------------- transfers -----------------------;;

openfile "44transfers_vertical_ogs"

originalwindow
Field ("44transfers")
Select «» <> lookupselected("44transfers_vertical_ogs","IDNumber",IDNumber,"qty",0,1)

selectwithin IDNumber=lookupselected("44transfers_vertical_ogs","IDNumber",IDNumber,"IDNumber",0,1)

Field ("44transfers")
formulafill lookupselected("44transfers_vertical_ogs","IDNumber",IDNumber,"qty",0,1)

;;SelectAll
window "44transfers_vertical_ogs"
closewindow

originalwindow

message "Finished Walk-in Sales Update"˛/walkin_sales_updateˇ˛add it upˇSelectall

NoShow

;;-------------------SOLD----------------------

Select «44sold» <> («44soldtally»+«44soldwalkin»+«44transfers»+«44soldseeds»)
if info("empty")
    SelectAll
else
    Field ("44soldtally")
    call "tabdown/2"
endif

Select «44sold» <> («44soldtally»+«44soldwalkin»+«44transfers»+«44soldseeds»)
if info("empty")
    SelectAll
else
    Field ("44soldwalkin")
    call "tabdown/2"
endif

Select «44sold» <> («44soldtally»+«44soldwalkin»+«44transfers»+«44soldseeds»)
if info("empty")
    SelectAll
else
    Field ("44transfers")
    call "tabdown/2"
endif

;; ---------------------------------AVAILABLE---------------------------------

Select «44available» <> (Initial+Purchased+«44repack»-«44soldtally»-«44soldwalkin»-«44soldseeds»-«44transfers»+Adjustments)
if info("empty")
    SelectAll
else
    Field ("44repack")
    call "tabdown/2"
endif

;; --------------------------------IN HOUSE-----------------------------

Select «44inhouse» <> («44available»+(«44soldtally»-«44tallyfilled»))
if info("empty")
    SelectAll
else
    Field ("44soldtally")
    call "tabdown/2"
endif

Select «44inhouse» <> («44available»+(«44soldtally»-«44tallyfilled»))
if info("empty")
    SelectAll
else
    Field ("44tallyfilled")
    call "tabdown/2"
endif

;; -------------------------------- add it up -------------------------

SelectAll
openfile "44ogscomments"
openfile "&&44ogscomments.linked"

Select «can be added up» contains "Y"
Field "parent_code"
GroupUp

Field TotalPoundsToSell
FormulaFill «unit conversion»*«44available»
Total

CollapseToLevel "1"
Field "TotalUnitsToSell"
FormulaFill TotalPoundsToSell

CollapseToLevel "Data"

Field "TotalPoundsToSell"
Fill ""
CollapseToLevel "1"

FormulaFill TotalUnitsToSell

CollapseToLevel "Data"
Field "TotalPoundsToSell"
PropagateUP

RemoveSummaries "7"

Field "TotalUnitsToSell"
FormulaFill TotalPoundsToSell/?(«unit conversion»>0,«unit conversion»,1)

Select «can be added up» contains "N"
Field "TotalUnitsToSell"
FormulaFill «44available»

EndNoShow

window "44ogscomments.linked"

Field "TotalUnitsToSell"
Select «» <> lookupselected("44ogscomments","IDNumber",IDNumber,"TotalUnitsToSell",0,0)
FormulaFill lookup("44ogscomments","IDNumber",IDNumber,"TotalUnitsToSell",0,0)

Field "TotalPoundsToSell"
Select «» <> lookupselected("44ogscomments","IDNumber",IDNumber,"TotalPoundsToSell",0,0)
FormulaFill lookup("44ogscomments","IDNumber",IDNumber,"TotalPoundsToSell",0,0)

SelectAll

Field "Item"
Sortup

message "Finished with Add-it-up!"˛/add it upˇ˛Negative Reportˇ;; searches for items that are less than 0 for Stasha to go and investigate.

Field Item
    sortup
    
Field "Item" Select «44available» < 0 or «44inhouse» < 0

openform "Inventory Report"

Print Dialog
˛/Negative Reportˇ˛Hide Most Fieldsˇlocal fieldstoshow
fieldstoshow = "Listed"+¶+"IDNumber"+¶+"Item"+¶+"Description"+¶+"Sz."+¶+"ActWt"+¶+"Comments"+¶+"notes"+¶+"44available"+¶+"TotalPoundsToSell"+¶+"TotalUnitsToSell"+¶+"Initial"+¶+"Adjustments"+¶+"44sold"+¶+"44inhouse"+¶+"44tallyfilled"+¶+"44soldtally"+¶+"44soldwalkin"+¶+"44repack"+¶+"unit note"

showthesefields fieldstoshow˛/Hide Most Fieldsˇ˛Inquiry/Iˇfield Item
sortup
openform "Inquiry"


˛/Inquiry/Iˇ˛Zero Reportˇ;;Searches for items that have a 0 "44Available" to make sure that comments are filled in and counts are accurate.

Field "Item"
sortup

Local fieldstoshow
fieldstoshow = "Item"+¶+"Description"+¶+"Sz."+¶+"Comments"+¶+"44available"

Field "Item"

Select («44available» = 0 or «44inhouse» = 0) and «Comments» notcontains "clearance" and «notes» notcontains "clearance" and «Comments» notcontains "service"

showthesefields fieldstoshow

openform "Inventory Report"
˛/Zero Reportˇ˛Update RepackˇField "44repack"
Select «44repack» <> 0

firstrecord
loop
Cell «»
downrecord
until info("stopped")
˛/Update Repackˇ˛PricelineˇField "add/drop"
Select «priceline» notcontains |||21||| or sizeof("priceline") = 0 and («add/drop» notcontains |||drop|||) ˛/Pricelineˇ˛dropˇField «IDNumber»
Sortup
Selectduplicates IDNumber˛/dropˇ˛Sale Historyˇ;;Searches sale history

Local fieldstoshow
fieldstoshow = "Item"+¶+"Description"+¶+"44available"+¶+"44sold"+¶+"43sold"+¶+"42sold"+¶+"41sold"+¶+"40sold"

showthesefields fieldstoshow
˛/Sale Historyˇ˛Archive Item Searchˇ;Search for items that may be able to be moved to comments.archive

Field "Item"
Select «Listed» = |||No||| and «add/drop» = |||historical||| and «44available» <= 0 and «44inhouse» <= 0 

if info("empty")
    message "No items that need to be archived"
endif
Selectwithin «44soldtally» > «44tallyfilled»

if info("empty")
    message "No outstanding orders"
 endif
 
 message "Next Step- Run Archive Selected Items macro"






˛/Archive Item Searchˇ˛Archive Selected Itemsˇokcancel "Careful! Make sure you have only the items you want appended selected. Continue?"
    if clipboard() = "Cancel"
        stop
    endif
 openfile "Comments.archive"
 openfile "++44ogscomments.linked" 
 window "44ogscomments.linked"

;Delete appended records from Comments.Linked

noyes "Do you wish to delete appended items?"  

if clipboard() = "Yes"
   Loop
   Lastrecord
   Deleterecord
   until info("selected") = 1
endif





˛/Archive Selected Itemsˇ˛SearchˇField "Item"
Select «44available» > «43sold» ˛/Searchˇ˛Item HistoryˇOpenform "Item History"˛/Item Historyˇ˛Zero Audit FormˇOpenform "Blank Zero Audit Form"
Message "When printing make sure to select 1 from 1 for print options, NOT all"
Print dialog
˛/Zero Audit Formˇ˛Export Inventory for Webˇlocal waswindow, myfilename
local temp_array, sorted_array, lastorderno, theText
waswindow = info("windowname")

;; This macro produces a CSV of OGS's current inventory numbers that can be uploaded to the website.
;; It is up to OGS how often to run this. I think once a week would be sufficient, but it could even be run 
;; daily if you want!

;; Tracking Preference in the tally - exact wording matters. All sizes for a given item MUST have the same
;; tracking preference (or there may be unpredictable results). Recognized values are:

;; "Allow repack, no packup" (soil amendments, seed)
;; "Do not track inventory" (things we never run out of, like soil tests, mixing, and drop ship items)
;; "Track by item size" (tools, books - items that are not repackable)
;; "Track by item size, allowing repack" ("no holds barred repack" like "repacking" jiffy pots into cases and vice versa)

;; This macro depends on the "unit conversion" field being filled out and accurate for any items with a
;; "Track by item size, allowing repack" or "Allow repack, no packup" tracking preference.
;; Also, "Web Inventory Units" must be filled out for all items with one of the "repack" tracking preferences
;; and "Web Inventory Units" MUST be the same for all sizes of a given item.

;; This macro uses two unlinked files: "OGS web inventory" and "ogs_undownloaded."

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; uses sparenumber3 to store a unit conversion on the bulk unlisted inventory
select Listed contains "bulk" and «Tracking Preference» contains "repack" and (sparenumber3 <> «44available»*«unit conversion»)
if info("empty")
else
    field sparenumber3
    formulafill «44available»*«unit conversion»
endif

;; excludes items with Listed="No" but includes items with Listed="bulk not listed"
select Listed <> "No"
field Item
Sortup
field parent_code
Groupup

;; this applies the last size code's tracking preference to the whole item, so if there are discrepancies, they get ignored
field «Tracking Preference»
Maximum

field «Web Inventory Units»
Maximum
field sparenumber3
Total
Outlinelevel 1

;; opens the unlinked file and replaces its contents with an export from ogscomments.linked
Openfile "OGS web inventory"
Openfile "&&44ogscomments.linked"
removedetail 0
removeallsummaries

field «inventory bulk»
formulafill lookup("44ogscomments.linked","parent_code",«parent_code»,"sparenumber3",zeroblank(0),1)

window waswindow
removeallsummaries

;; use formulafill to bring values from comments.linked into the unlinked file. 
;; Low stock threshold, out of stock threshold, 44available, and unit conversion are all brought over.

select Listed contains "web" and Item contains "A"
window "OGS web inventory"
field «low A»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos A»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory A»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «A unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "B"
window "OGS web inventory"
field «low B»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos B»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory B»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «B unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "C"
window "OGS web inventory"
field «low C»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos C»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory C»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «C unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "D"
window "OGS web inventory"
field «low D»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos D»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory D»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «D unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "E"
window "OGS web inventory"
field «low E»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos E»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory E»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «E unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "F"
window "OGS web inventory"
field «low F»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos F»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory F»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «F unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "G"
window "OGS web inventory"
field «low G»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos G»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory G»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «G unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "H"
window "OGS web inventory"
field «low H»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos H»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory H»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «H unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

window waswindow
select Listed contains "web" and Item contains "I"
window "OGS web inventory"
field «low I»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Low Stock Threshold",zeroblank(0),0)
field «oos I»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"Out of Stock Threshold",zeroblank(0),0)
field «inventory I»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"44available",zeroblank(0),0)
field «I unit conversion»
formulafill lookupselected("44ogscomments.linked","parent_code",«parent_code»,"unit conversion",zeroblank(0),0)

;; if there are any items with tracking preference 'N/A' assume they are not relevan to the web inventory upload
;; and remove them from the unlinked file
select «Tracking Preference» <> 'N/A'
removeunselected

;; replace tracking preference with values that the website will recognize
field «Tracking Preference»
formulafill replace(«Tracking Preference»,'Allow repack, no packup','repackNoPackup')
formulafill replace(«Tracking Preference»,'Do not track inventory','none')
formulafill replace(«Tracking Preference»,'Track by item size, allowing repack','repack')
formulafill replace(«Tracking Preference»,'Track by item size','size')

save

;;;;;;;;;;;;;;;;;;;;;;;;; get undownloaded orders from website ;;;;;;;;;;;;;;;;;;;;;;

;; This bit is important because it will account for any orders that have been placed online in the time since
;; the most recent orders in the tally were imported. Incorporating these undownloaded orders into the 
;; inventory calculation ensures that the inventory numbers we're uploading to the website are as accurate
;; as possible.

;; trying to open the tally without running the .Initialize macro
opensecret "44ogstally"
window "44ogstally:secret"

;;window "44ogstally"

;; The date restriction is just to return a smaller chunk of orders that need to be sorted, so that the macro runs more quickly.
;; Trying to find the most recent internet order that was placed. The group orders make it a little complicated, so that's
;; what this chunk of code is about.

select OrderNo > 320000 and OrderNo < 400000 and OrderPlaced >= (today()-7) and OrderNo = int(OrderNo)
if info("empty")
    ;; If there are no OGS internet orders in the tally, this will get all of the orders (will only be relevant 
    ;; for a short stretch of time after the fiscal year changeover but before the first batch of OGS orders is in the tally)
    LoadURL theText, "https://fedcoseeds.com/reports/ogs/collation?format=item"
else
    arrayselectedbuild temp_array, ¶, "",?(OriginalOrderNumber=0,str(OrderNo),str(OriginalOrderNumber))+¬+str(OrderNo)

    ;; sort by original order number
    sorted_array = arraymultisort(temp_array,¶,¬,"1n")

    ;; get OrderNo from last line in array
    lastorderno = arraylast(arraylast(sorted_array,¶),¬)
    
    ;;LoadURL theText, "https://landscape.fedcoseeds.com/api/v1/reports/ogs/collation?format=item&since-key=order&since-value=" + str(lastorderno)
    ;;LoadURL theText, "https://landscape.fedcoseeds.com/api/v1/reports/moose/collation"
    ;;LoadURL theText, "https://localhost/api/v1/reports/ogs/collation?since-key=order&format=item&since-value=" + "322478"
    Curl theText, "-k 'https://landscape.fedcoseeds.com/api/v1/reports/ogs/collation?since-key=order&format=item&since-value=" + str(lastorderno) + "'"

endif

debug

OpenFile "ogs_undownloaded"
OpenFile "&@theText"

window "OGS web inventory"

field undownloadedA
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyA",0,0)
field undownloadedB
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyB",0,0)
field undownloadedC
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyC",0,0)
field undownloadedD
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyD",0,0)
field undownloadedE
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyE",0,0)
field undownloadedF
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyF",0,0)
field undownloadedG
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyG",0,0)
field undownloadedH
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyH",0,0)
field undownloadedI
formulafill lookup("ogs_undownloaded","Item",«parent_code»,"qtyI",0,0)

field «inventory A»
formulafill zeroblank(«inventory A» - undownloadedA)
field «inventory B»
formulafill zeroblank(«inventory B» - undownloadedB)
field «inventory C»
formulafill zeroblank(«inventory C» - undownloadedC)
field «inventory D»
formulafill zeroblank(«inventory D» - undownloadedD)
field «inventory E»
formulafill zeroblank(«inventory E» - undownloadedE)
field «inventory F»
formulafill zeroblank(«inventory F» - undownloadedF)
field «inventory G»
formulafill zeroblank(«inventory G» - undownloadedG)
field «inventory H»
formulafill zeroblank(«inventory H» - undownloadedH)
field «inventory I»
formulafill zeroblank(«inventory I» - undownloadedI)

save

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

myfilename = "OGSInventory.csv"
;;export myfilename, exportline()+¶

export myfilename, str(parent_code)+","+«Tracking Preference»
+","+zbpattern(«A unit conversion»,"#.#")+","+zbpattern(«B unit conversion»,"#.#")+","+zbpattern(«C unit conversion»,"#.#")+","+zbpattern(«D unit conversion»,"#.#")+","+zbpattern(«E unit conversion»,"#.#")+","+zbpattern(«F unit conversion»,"#.#")+","+zbpattern(«G unit conversion»,"#.#")+","+zbpattern(«H unit conversion»,"#.#")+","+zbpattern(«I unit conversion»,"#.#")+","+«Web Inventory Units»
+","+zbpattern(«low A»,"#")+","+zbpattern(«low B»,"#")+","+zbpattern(«low C»,"#")+","+zbpattern(«low D»,"#")+","+zbpattern(«low E»,"#")+","+zbpattern(«low F»,"#")+","+zbpattern(«low G»,"#")+","+zbpattern(«low H»,"#")+","+zbpattern(«low I»,"#")+","+zbpattern(«low bulk»,"#")
+","+zbpattern(«oos A»,"#")+","+zbpattern(«oos B»,"#")+","+zbpattern(«oos C»,"#")+","+zbpattern(«oos D»,"#.#")+","+zbpattern(«oos E»,"#.#")+","+zbpattern(«oos F»,"#.#")+","+zbpattern(«oos G»,"#.#")+","+zbpattern(«oos H»,"#.#")+","+zbpattern(«oos I»,"#.#")+","+zbpattern(«oos bulk»,"#")
+","+zbpattern(«inventory A»,"#")+","+zbpattern(«inventory B»,"#")+","+zbpattern(«inventory C»,"#")+","+zbpattern(«inventory D»,"#")+","+zbpattern(«inventory E»,"#")+","+zbpattern(«inventory F»,"#")+","+zbpattern(«inventory G»,"#")+","+zbpattern(«inventory H»,"#")+","+zbpattern(«inventory I»,"#")+","+zbpattern(«inventory bulk»,"#")
+¶

;;; edit to blank out tracking preference after the first upload?

message "Done! Remember to upload 'OGSInventory.csv' to the website."

shellopendocument "https://fedcoseeds.com/manage_site/inventory/ogs"˛/Export Inventory for Webˇ˛Open RepackˇOpenfile "44ogsrepack"
gosheet˛/Open Repackˇ˛Repack Pending Reportˇ;;Searches for items that have have "Repack Pending" in the notes.

Field "Item"
sortup

Local fieldstoshow

fieldstoshow = "Item"+¶+"Description"+¶+"Sz."+¶+"Comments"+¶+"Notes"+¶+"44available"

Field "Item"

Select notes contains "Repack"

openform "Inventory Report"
˛/Repack Pending Reportˇ˛(Labels)ˇ˛/(Labels)ˇ˛OGS Product LabelˇOpenform "OGS Product Label"˛/OGS Product Labelˇ˛OGS Line LabelˇOpenform "OGSLineLabel"˛/OGS Line Labelˇ˛huhˇglobal vIDNumber
vIDNumber = IDNumber
lookup("44ogscomments.linked 12/27","Item",«Item»,"IDNumber",0,0)
message vIDNumber
stop‹  Ñ.warehousesupplier  ¿global forordering, itemlist, disorder, seconditemlist
//superobject "fromsupplier", "Open"
//activesuperobject "Clear"
//activesuperobject "Close"
forordering=""
itemlist=""
seconditemlist=""

window "44ogscomments.warehouse"
select SupplierNo_Primary=val(whichsupplier[1,"¬"])

arrayselectedbuild seconditemlist, ¶,"",Description

 = itemlist + ¶ + seconditemlist

window "44ogscomments.linked:Generate-POnew"

superobject "neworder", "FillList"h  ÑGenerate New PO@∂ Ïˇ    ≈  ˇˇ     wasWindow

ˇˇ    wasWindow = info("windowname") 1 ˇˇ: 
   "NewSupplier"m H ˇˇQ    "44ogscomments.warehouse"" l ˇˇs 	   wasWindow
R ~ ˇˇá    "Generate-POnew"ò local wasWindow

wasWindow = info("windowname")

openfile "NewSupplier"
openfile "44ogscomments.warehouse"

window wasWindow

openform "Generate-POnew"
  ÑFY44 Pounds SoldnÏˇ    ≈  ˇˇ     tempvariable, totalvariable
a" ˇˇ*    "What item number? XXXX",lˇˇD    tempvariable) Q ˇˇX    «Item» contains tempvariable u ˇˇ{ 
   "sparemoney3"
0 á ˇˇì    «ActWt»*«44sold»¬ § Â ™ ˇˇµ    totalvariable=sparemoney3Yœ ˇˇ·    {_DatabaseLib}ˇˇ·    {REMOVEALLSUMMARIES}¿‚ ˇˇÍ 9   "in FY44 we've sold "+str(totalvariable)+" pounds so far"Yálocal tempvariable, totalvariable
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Field sparemoney3
FormulaFill «ActWt»*«44sold»
Total
lastrecord
totalvariable=sparemoney3
removeallsummaries
message "in FY44 we've sold "+str(totalvariable)+" pounds so far"

;This is for automatically calculating how many total pounds we sold FY44 of a product 8/4/21 RM

 ‚  Ñ
.mixrepackhÏˇ    ƒ  ˇˇ Ì   vIngredient1, vIngredient1,vIngredient2,vIngredient3,vIngredient4,vIngredient5,vIngredient6,vIngredient7,vIngredient8,vIngredient9,vIngredient10,vIngredient11,
vIngredient12,vIngredient13,vIngredient14,vIngredient15,vIngredient16,vIngredient17, vPercentage1, vPercentage2, vPercentage3, vPercentage4, vPercentage5, vPercentage6, vPercentage7, vPercentage8, 
vPercentage9, vPercentage10, vPercentage11, vPercentage12, vPercentage13, vPercentage14, vPercentage15, vPercentage16, vPercentage17

 Ûˇˇ¸   "Mixes"2) ˇˇ.   str(«Mix Parent Code») contains left(vItem, 4)ˇˇ<"   vIngredient1 = «Ingredient 1 Item»ˇˇ_(   vPercentage1 = «Ingredient 1 Percentage»ˇˇà"   vIngredient2 = «Ingredient 2 Item»ˇˇ´(   vPercentage2 = «Ingredient 2 Percentage»ˇˇ‘"   vIngredient3 = «Ingredient 3 Item»ˇˇ˜(   vPercentage3 = «Ingredient 3 Percentage»ˇˇ "   vIngredient4 = «Ingredient 4 Item»ˇˇC(   vPercentage4 = «Ingredient 4 Percentage»ˇˇl"   vIngredient5 = «Ingredient 5 Item»ˇˇè(   vPercentage5 = «Ingredient 5 Percentage»ˇˇ∏"   vIngredient6 = «Ingredient 6 Item»ˇˇ€(   vPercentage6 = «Ingredient 6 Percentage»ˇˇ"   vIngredient7 = «Ingredient 7 Item»ˇˇ'(   vPercentage7 = «Ingredient 7 Percentage»ˇˇP"   vIngredient8 = «Ingredient 8 Item»ˇˇs(   vPercentage8 = «Ingredient 8 Percentage»ˇˇú"   vIngredient9 = «Ingredient 9 Item»ˇˇø(   vPercentage9 = «Ingredient 9 Percentage»ˇˇË$   vIngredient10 = «Ingredient 10 Item»ˇˇ
*   vPercentage10 = «Ingredient 10 Percentage»ˇˇ8#   vIngredient11= «Ingredient 11 Item»,ˇˇ\*   vPercentage11 = «Ingredient 11 Percentage»ˇˇá#   vIngredient12= «Ingredient 12 Item»Pˇˇ´*   vPercentage12 = «Ingredient 12 Percentage»ˇˇ÷$   vIngredient13 = «Ingredient 13 Item»ˇˇ˚)   vPercentage13= «Ingredient 13 Percentage»Gˇˇ%$   vIngredient14 = «Ingredient 14 Item»ˇˇJ*   vPercentage14 = «Ingredient 14 Percentage»ˇˇu$   vIngredient15 = «Ingredient 15 Item»ˇˇö*   vPercentage15 = «Ingredient 15 Percentage»ˇˇ≈$   vIngredient16 = «Ingredient 16 Item»ˇˇÍ*   vPercentage16 = «Ingredient 16 Percentage»ˇˇ$   vIngredient17 = «Ingredient 17 Item»ˇˇ:*   vPercentage17 = «Ingredient 17 Percentage»fglobal vIngredient1, vIngredient1,vIngredient2,vIngredient3,vIngredient4,vIngredient5,vIngredient6,vIngredient7,vIngredient8,vIngredient9,vIngredient10,vIngredient11,
vIngredient12,vIngredient13,vIngredient14,vIngredient15,vIngredient16,vIngredient17, vPercentage1, vPercentage2, vPercentage3, vPercentage4, vPercentage5, vPercentage6, vPercentage7, vPercentage8, 
vPercentage9, vPercentage10, vPercentage11, vPercentage12, vPercentage13, vPercentage14, vPercentage15, vPercentage16, vPercentage17

openfile "Mixes"

select str(«Mix Parent Code») contains left(vItem, 4)

vIngredient1 = «Ingredient 1 Item»
vPercentage1 = «Ingredient 1 Percentage»
vIngredient2 = «Ingredient 2 Item»
vPercentage2 = «Ingredient 2 Percentage»
vIngredient3 = «Ingredient 3 Item»
vPercentage3 = «Ingredient 3 Percentage»
vIngredient4 = «Ingredient 4 Item»
vPercentage4 = «Ingredient 4 Percentage»
vIngredient5 = «Ingredient 5 Item»
vPercentage5 = «Ingredient 5 Percentage»
vIngredient6 = «Ingredient 6 Item»
vPercentage6 = «Ingredient 6 Percentage»
vIngredient7 = «Ingredient 7 Item»
vPercentage7 = «Ingredient 7 Percentage»
vIngredient8 = «Ingredient 8 Item»
vPercentage8 = «Ingredient 8 Percentage»
vIngredient9 = «Ingredient 9 Item»
vPercentage9 = «Ingredient 9 Percentage»
vIngredient10 = «Ingredient 10 Item»
vPercentage10 = «Ingredient 10 Percentage»
vIngredient11= «Ingredient 11 Item»
vPercentage11 = «Ingredient 11 Percentage»
vIngredient12= «Ingredient 12 Item»
vPercentage12 = «Ingredient 12 Percentage»
vIngredient13 = «Ingredient 13 Item»
vPercentage13= «Ingredient 13 Percentage»
vIngredient14 = «Ingredient 14 Item»
vPercentage14 = «Ingredient 14 Percentage»
vIngredient15 = «Ingredient 15 Item»
vPercentage15 = «Ingredient 15 Percentage»
vIngredient16 = «Ingredient 16 Item»
vPercentage16 = «Ingredient 16 Percentage»
vIngredient17 = «Ingredient 17 Item»
vPercentage17 = «Ingredient 17 Percentage»

å  Ñ.showtallyorders∆ Ïˇ    ƒ  ˇˇ     vItem

ˇˇ    vItem = Item¿ ˇˇ$ 3   vItem

////Select items in tally that contain vIteml Y ˇˇb    "44ogstally") p ˇˇw 4   «Order» contains str(vItem) and sizeof("Status") = 0´ global vItem

vItem = Item

message vItem

////Select items in tally that contain vItem

Openfile "44ogstally"

Select «Order» contains str(vItem) and sizeof("Status") = 00  Ñ
.kitrepackÓÏˇ    ƒ˜ ˇˇ˝ ¿   vIngredient1, vIngredient1,vIngredient2,vIngredient3,vIngredient4,vIngredient5,vIngredient6,vIngredient7,vIngredient8,vIngredient9,vIngredient10,vIngredient11,
vIngredient12,vIngredient13,vIngredient14,vIngredient15,vIngredient16,vIngredient17, vPercentage1, vPercentage2, vPercentage3, vPercentage4, vPercentage5, vPercentage6, vPercentage7, vPercentage8, 
vPercentage9, vPercentage10, vPercentage11, vPercentage12, vPercentage13, vPercentage14

 Ωˇˇ∆   "Kits") Œˇˇ’   str(«Kit Item») contains vItemˇˇı"   vIngredient1 = «Ingredient 1 Item»¿ˇˇ    vIngredient1ˇˇ-$   vPercentage1 = «Amt of Ingredient 1»ˇˇR"   vIngredient2 = «Ingredient 2 Item»ˇˇu$   vPercentage2 = «Amt of Ingredient 2»ˇˇö"   vIngredient3 = «Ingredient 3 Item»ˇˇΩ$   vPercentage3 = «Amt of Ingredient 3»ˇˇ‚"   vIngredient4 = «Ingredient 4 Item»ˇˇ$   vPercentage4 = «Amt of Ingredient 4»ˇˇ*"   vIngredient5 = «Ingredient 5 Item»ˇˇM$   vPercentage5 = «Amt of Ingredient 5»ˇˇr"   vIngredient6 = «Ingredient 6 Item»ˇˇï$   vPercentage6 = «Amt of Ingredient 6»ˇˇ∫"   vIngredient7 = «Ingredient 7 Item»ˇˇ›$   vPercentage7 = «Amt of Ingredient 7»ˇˇ"   vIngredient8 = «Ingredient 8 Item»ˇˇ%$   vPercentage8 = «Amt of Ingredient 8»ˇˇJ"   vIngredient9 = «Ingredient 9 Item»ˇˇm$   vPercentage9 = «Amt of Ingredient 9»ˇˇí$   vIngredient10 = «Ingredient 10 Item»ˇˇ∑&   vPercentage10 = «Amt of Ingredient 10»ˇˇﬁ#   vIngredient11= «Ingredient 11 Item» ˇˇ&   vPercentage11 = «Amt of Ingredient 11»ˇˇ)#   vIngredient12= «Ingredient 12 Item» ˇˇM&   vPercentage12 = «Amt of Ingredient 12»ˇˇt$   vIngredient13 = «Ingredient 13 Item»ˇˇô%   vPercentage13= «Amt of Ingredient 13» ˇˇø$   vIngredient14 = «Ingredient 14 Item»ˇˇ‰&   vPercentage14 = «Amt of Ingredient 14»
///This Macro creates variables based on the kit that will be made. Each ingredient receives its own variable along with the number of ingredients needed for that kit.
///The variables are then used in the kit repack form in the repack database.

global vIngredient1, vIngredient1,vIngredient2,vIngredient3,vIngredient4,vIngredient5,vIngredient6,vIngredient7,vIngredient8,vIngredient9,vIngredient10,vIngredient11,
vIngredient12,vIngredient13,vIngredient14,vIngredient15,vIngredient16,vIngredient17, vPercentage1, vPercentage2, vPercentage3, vPercentage4, vPercentage5, vPercentage6, vPercentage7, vPercentage8, 
vPercentage9, vPercentage10, vPercentage11, vPercentage12, vPercentage13, vPercentage14

openfile "Kits"

select str(«Kit Item») contains vItem

vIngredient1 = «Ingredient 1 Item»
message vIngredient1
vPercentage1 = «Amt of Ingredient 1»
vIngredient2 = «Ingredient 2 Item»
vPercentage2 = «Amt of Ingredient 2»
vIngredient3 = «Ingredient 3 Item»
vPercentage3 = «Amt of Ingredient 3»
vIngredient4 = «Ingredient 4 Item»
vPercentage4 = «Amt of Ingredient 4»
vIngredient5 = «Ingredient 5 Item»
vPercentage5 = «Amt of Ingredient 5»
vIngredient6 = «Ingredient 6 Item»
vPercentage6 = «Amt of Ingredient 6»
vIngredient7 = «Ingredient 7 Item»
vPercentage7 = «Amt of Ingredient 7»
vIngredient8 = «Ingredient 8 Item»
vPercentage8 = «Amt of Ingredient 8»
vIngredient9 = «Ingredient 9 Item»
vPercentage9 = «Amt of Ingredient 9»
vIngredient10 = «Ingredient 10 Item»
vPercentage10 = «Amt of Ingredient 10»
vIngredient11= «Ingredient 11 Item»
vPercentage11 = «Amt of Ingredient 11»
vIngredient12= «Ingredient 12 Item»
vPercentage12 = «Amt of Ingredient 12»
vIngredient13 = «Ingredient 13 Item»
vPercentage13= «Amt of Ingredient 13»
vIngredient14 = «Ingredient 14 Item»
vPercentage14 = «Amt of Ingredient 14»


T    ÑLunarTestPOForm@ Ïˇ      ‘  Ñ	GetSource@Ë Ïˇnﬁ†≈  ˇˇ     Dictionary, ProcedureList
OX ˇˇi 
   {_UtilityLib} ˇˇi    {SAVEALLPROCEDURES},ˇˇj    "", ˇˇn 
   Dictionaryˇˇy Y   clipboard()=Dictionary
//now you can paste those into a text editor and make your changesA4 ” ÿ local Dictionary, ProcedureList
//this saves your procedures into a variable
//step one
saveallprocedures "", Dictionary
clipboard()=Dictionary
//now you can paste those into a text editor and make your changes
STOP
$   ÉCOLORS   @@@@@@@              0   É	FONT/PANE                             Ü   ÉCUSTMENU                                                                                                                        òŸ CATALOG äŸ Ñclover.pict      Ó ˇ ˇ˛   »   »      Ó     ° ‡l      happl   mntrGRAYXYZ ‹    . acspAPPL    none                  ˆ÷     ”-appl                                               desc   ¿   ydscm  <  Ëcprt  	$   #wtpt  	H   kTRC  	\  desc       Generic Gray Gamma 2.2 Profile                                                                                  mluc          skSK   .  ÑdaDK   8  ≤caES   8  ÍviVN   @  "ptBR   J  bukUA   ,  ¨frFU   >  ÿhuHU   4  zhTW     JnbNO   :  hcsCZ   (  ¢heIL   $   itIT   N  ÓroRO   *  <deDE   N  fkoKR   "  ¥svSE   8  ≤zhCN     ÷jaJP   &  ÙelGR   *  ptPO   R  DnlNL   @  ñesES   L  ÷thTH   2  "trTR   $  TfiFI   F  xhrHR   >  æplPL   J  ¸ruRU   :  FenUS   <  ÄarEG   ,  º Va e o b e c n ·   s i v ·   g a m a   2 , 2 G e n e r i s k   g r Â   2 , 2   g a m m a p r o f i l G a m m a   d e   g r i s o s   g e n Ë r i c a   2 . 2 C• u   h Ï n h   M ‡ u   x · m   C h u n g   G a m m a   2 . 2 P e r f i l   G e n È r i c o   d a   G a m a   d e   C i n z a s   2 , 2030;L=0   G r a y -30<0   2 . 2 P r o f i l   g È n È r i q u e   g r i s   g a m m a   2 , 2 ¡ l t a l · n o s   s z ¸ r k e   g a m m a   2 . 2êu(ppñéQI^¶   2 . 2  Çr_icœè G e n e r i s k   g r Â   g a m m a   2 , 2 - p r o f i l O b e c n ·  a e d ·   g a m a   2 . 2“–ﬁ‘  –‰’Ë  €‹‹Ÿ   2 . 2 P r o f i l o   g r i g i o   g e n e r i c o   d e l l a   g a m m a   2 , 2 G a m a   g r i   g e n e r i c   2 , 2 A l l g e m e i n e s   G r a u s t u f e n - P r o f i l   G a m m a   2 , 2«|º  ÷å¿…  ¨π»   2 . 2  ’∏\”«|fnêpp^¶|˚ep   2 . 2  cœèeáNˆN Ç,0∞0Ï0§0¨0Û0ﬁ   2 . 2  0◊0Ì0’0°0§0ÎìµΩπ∫Ã  ì∫¡π  ì¨ºº±   2 . 2 P e r f i l   g e n È r i c o   d e   c i n z e n t o s   d a   G a m m a   2 , 2 A l g e m e e n   g r i j s   g a m m a   2 , 2 - p r o f i e l P e r f i l   g e n È r i c o   d e   g a m m a   d e   g r i s e s   2 , 2#1*5A!!2@#"L1H'D   2 . 2 G e n e l   G r i   G a m a   2 , 2 Y l e i n e n   h a r m a a n   g a m m a   2 , 2   - p r o f i i l i G e n e r i
 k i   G r a y   G a m m a   2 . 2   p r o f i l U n i w e r s a l n y   p r o f i l   s z a r o[ c i   g a m m a   2 , 21I0O  A5@0O  30<<0   2 , 2 -?@>D8;L G e n e r i c   G r a y   G a m m a   2 . 2   P r o f i l e:'E'   2 . 2  DHF  1E'/J  9'Etext    Copyright Apple Inc., 2012  XYZ       ÛQ    Ãcurv           
     # ( - 2 7 ; @ E J O T Y ^ c h m r w | Å Ü ã ê ï ö ü § © Æ ≤ ∑ º ¡ ∆ À – ’ € ‡ Â Î  ˆ ˚
%+28>ELRY`gnu|Éãíö°©±π¡…—Ÿ·ÈÚ˙&/8AKT]gqzÑéò¢¨∂¡À’‡Îı !-8COZfr~äñ¢Æ∫«”‡Ï˘ -;HUcq~åö®∂ƒ”·˛
+:IXgwÜñ¶µ≈’Âˆ'7HYj{åùØ¿—„ı+=OatÜô¨ø“Â¯2FZnÇñ™æ“Á˚		%	:	O	d	y	è	§	∫	œ	Â	˚

'
=
T
j
Å
ò
Æ
≈
‹
Û"9QiÄò∞»·˘*C\uéß¿ŸÛ


&
@
Z
t
é
©
√
ﬁ
¯.Idõ∂“Ó	%A^zñ≥œÏ	&Ca~õπ◊ı1Omå™…Ë&EdÑ£√„#CcÉ§≈Â'Ijã≠Œ4VxõΩ‡&Ilè≤÷˙AeâÆ“˜@eäØ’˙ Ekë∑›*Qwû≈Ï;cä≤⁄*R{£ÃıGpô√Ï@jîæÈ>iîøÍ  A l ò ƒ !!H!u!°!Œ!˚"'"U"Ç"Ø"›#
#8#f#î#¬#$$M$|$´$⁄%	%8%h%ó%«%˜&'&W&á&∑&Ë''I'z'´'‹(
(?(q(¢(‘))8)k)ù)–**5*h*õ*œ++6+i+ù+—,,9,n,¢,◊--A-v-´-·..L.Ç.∑.Ó/$/Z/ë/«/˛050l0§0€11J1Ç1∫1Ú2*2c2õ2‘3
3F33∏3Ò4+4e4û4ÿ55M5á5¬5˝676r6Æ6È7$7`7ú7◊88P8å8»99B99º9˘:6:t:≤:Ô;-;k;™;Ë<'<e<§<„="=a=°=‡> >`>†>‡?!?a?¢?‚@#@d@¶@ÁA)AjA¨AÓB0BrBµB˜C:C}C¿DDGDäDŒEEUEöEﬁF"FgF´FG5G{G¿HHKHëH◊IIcI©IJ7J}JƒKKSKöK‚L*LrL∫MMJMìM‹N%NnN∑O OIOìO›P'PqPªQQPQõQÊR1R|R«SS_S™SˆTBTèT€U(UuU¬VV\V©V˜WDWíW‡X/X}XÀYYiY∏ZZVZ¶Zı[E[ï[Â\5\Ü\÷]']x]…^^l^Ω__a_≥``W`™`¸aOa¢aıbIbúbcCcócÎd@dîdÈe=eíeÁf=fífËg=gìgÈh?hñhÏiCiöiÒjHjüj˜kOkßkˇlWlØmm`mπnnknƒooxo—p+pÜp‡q:qïqrKr¶ss]s∏ttptÃu(uÖu·v>võv¯wVw≥xxnxÃy*yâyÁzFz•{{c{¬|!|Å|·}A}°~~b~¬#ÑÂÄGÄ®Å
ÅkÅÕÇ0ÇíÇÙÉWÉ∫ÑÑÄÑ„ÖGÖ´ÜÜrÜ◊á;áüààiàŒâ3âôâ˛ädä ã0ãñã¸åcå ç1çòçˇéféŒè6èûêênê÷ë?ë®íízí„ìMì∂î îäîÙï_ï…ñ4ñüó
óuó‡òLò∏ô$ôêô¸öhö’õBõØúúâú˜ùdù“û@ûÆüüãü˙†i†ÿ°G°∂¢&¢ñ££v£Ê§V§«•8•©¶¶ã¶˝ßnß‡®R®ƒ©7©©™™è´´u´È¨\¨–≠D≠∏Æ-Æ°ØØã∞ ∞u∞Í±`±÷≤K≤¬≥8≥Æ¥%¥úµµä∂∂y∂∑h∑‡∏Y∏—πJπ¬∫;∫µª.ªßº!ºõΩΩèæ
æÑæˇøzøı¿p¿Ï¡g¡„¬_¬€√X√‘ƒQƒŒ≈K≈»∆F∆√«A«ø»=»º…:…π 8 ∑À6À∂Ã5ÃµÕ5ÕµŒ6Œ∂œ7œ∏–9–∫—<—æ“?“¡”D”∆‘I‘À’N’—÷U÷ÿ◊\◊‡ÿdÿËŸlŸÒ⁄v⁄˚€Ä‹‹ä››ñﬁﬁ¢ﬂ)ﬂØ‡6‡Ω·D·Ã‚S‚€„c„Î‰s‰¸ÂÑÊ
ÊñÁÁ©Ë2ËºÈFÈ–Í[ÍÂÎpÎ˚ÏÜÌÌúÓ(Ó¥Ô@ÔÃXÂÒrÒˇÚåÛÛßÙ4Ù¬ıPıﬁˆmˆ˚˜ä¯¯®˘8˘«˙W˙Á˚w¸¸ò˝)˝∫˛K˛‹ˇmˇˇ ° ‡      
    Ó ö   ˇå    Ó        »   »                       Ó    Ó @ 0ÌˇÅˇÅˇ ‚˝ˇÅˇÅˇÅˇÅˇÅˇÅˇ ‚˝ˇÅˇÅˇÅˇÅˇÅˇÅˇ ‚ëˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ &ÚˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇÅˇ GôˇÅˇÅˇ}s˛ˇ `˝  sáˇÅˇÅˇÅˇÅˇÅˇ}s˛ˇ `˝  sáˇÅˇÅˇÅˇÅˇÅˇ}s˛ˇ `˝  sÔˇÅˇÅˇÅˇ GöˇÅˇÅˇı ≤®s˛  ÜêˇÅˇÅˇÅˇÅˇÅˇı ≤®s˛  ÜêˇÅˇÅˇÅˇÅˇÅˇı ≤®s˛  Ü˜ˇÅˇÅˇÅˇ Y£ˇÅˇÅˇ˙Å£˛ˇ ûÎ !ˇ∂Qs∂üˇÅˇÅˇÅˇÅˇÅˇ˙Å£˛ˇ ûÎ !ˇ∂Qs∂üˇÅˇÅˇÅˇÅˇÅˇ˙Å£˛ˇ ûÎ !ˇ∂Qs∂˝ˇÅˇÅˇÅˇ G™ˇÅˇÅˇ}ê˝ˇ ï›  }®ˇÅˇÅˇÅˇÅˇÅˇ}ê˝ˇ ï›  }®ˇÅˇÅˇÅˇÅˇÅˇ}ê˝ˇ ï›  }ˇˇÅˇÅˇÅˇ 8≠ˇÅˇÅˇ s”  Q¨ˇÅˇÅˇÅˇÅˇÅˇ s”  Q¨ˇÅˇÅˇÅˇÅˇÅˇ s”  Q ˇÅˇÅˇÅˇ 0ØˇÅˇÅˇ ÿœ ØˇÅˇÅˇÅˇÅˇÅˇ ÿœ ØˇÅˇÅˇÅˇÅˇÅˇ ÿœ ÅˇÅˇÅˇ r∑ˇÅˇÅˇãLC  !„ Ln0ÅÜÔ  L˛ˇ ∂˝ ¡ˇÅˇÅˇÅˇÅˇÅˇãLC  !„ Ln0ÅÜÔ  L˛ˇ ∂˝ ¡ˇÅˇÅˇÅˇÅˇÅˇãLC  !„ Ln0ÅÜÔ  L˛ˇ ∂˝ ãˇÅˇÅˇ <∑ˇÅˇÅˇ› ˚ˇÂ  ÿ√ˇÅˇÅˇÅˇÅˇÅˇ› ˚ˇÂ  ÿ√ˇÅˇÅˇÅˇÅˇÅˇ› ˚ˇÂ  ÿçˇÅˇÅˇ H∏ˇÅˇÅˇ Ê› ˚ˇ ïÂ  n≈ˇÅˇÅˇÅˇÅˇÅˇ Ê› ˚ˇ ïÂ  n≈ˇÅˇÅˇÅˇÅˇÅˇ Ê› ˚ˇ ïÂ  néˇÅˇÅˇ Z∏ˇÅˇÅˇ £Ó ˇˇ!Û ˚ˇ `·  s…ˇÅˇÅˇÅˇÅˇÅˇ £Ó ˇˇ!Û ˚ˇ `·  s…ˇÅˇÅˇÅˇÅˇÅˇ £Ó ˇˇ!Û ˚ˇ `·  síˇÅˇÅˇ Z¡ˇÅˇÅˇ˛  ≈¸ˇÌ ˛ˇÛ ˝ˇ ≠ﬁ “ˇÅˇÅˇÅˇÅˇÅˇ˛  ≈¸ˇÌ ˛ˇÛ ˝ˇ ≠ﬁ “ˇÅˇÅˇÅˇÅˇÅˇ˛  ≈¸ˇÌ ˛ˇÛ ˝ˇ ≠ﬁ íˇÅˇÅˇ Å¬ˇÅˇÅˇ !˝ 9ˇˇ≈˘ L0˜ ˛ˇ Qı 4 ˝ˇ‹  ≠’ˇÅˇÅˇÅˇÅˇÅˇ !˝ 9ˇˇ≈˘ L0˜ ˛ˇ Qı 4 ˝ˇ‹  ≠’ˇÅˇÅˇÅˇÅˇÅˇ !˝ 9ˇˇ≈˘ L0˜ ˛ˇ Qı 4 ˝ˇ‹  ≠îˇÅˇÅˇ Ñ¬ˇÅˇÅˇ˙  ¯ ˇˇ˜ ˇ≈˚  V˛ˇ ˘ˇ £⁄ s≤¿ŸˇÅˇÅˇÅˇÅˇÅˇ˙  ¯ ˇˇ˜ ˇ≈˚  V˛ˇ ˘ˇ £⁄ s≤¿ŸˇÅˇÅˇÅˇÅˇÅˇ˙  ¯ ˇˇ˜ ˇ≈˚  V˛ˇ ˘ˇ £⁄ s≤¿òˇÅˇÅˇ f ˇÅˇÅˇ ˝ˇıˇsÂ }ˇÜ˚ Ùˇ n÷ ‚ˇÅˇÅˇÅˇÅˇÅˇ ˝ˇıˇsÂ }ˇÜ˚ Ùˇ n÷ ‚ˇÅˇÅˇÅˇÅˇÅˇ ˝ˇıˇsÂ }ˇÜ˚ Ùˇ n÷ ôˇÅˇÅˇ ZÃˇÅˇÅˇﬁ ˇ‚ˇˇ˚  ®Ùˇ +’ ÂˇÅˇÅˇÅˇÅˇÅˇﬁ ˇ‚ˇˇ˚  ®Ùˇ +’ ÂˇÅˇÅˇÅˇÅˇÅˇﬁ ˇ‚ˇˇ˚  ®Ùˇ +’ öˇÅˇÅˇ cÕˇÅˇÅˇﬁ  ô˝ˇ˚  ˝ˇ˚ H≤ˇˇ” ÁˇÅˇÅˇÅˇÅˇÅˇﬁ  ô˝ˇ˚  ˝ˇ˚ H≤ˇˇ” ÁˇÅˇÅˇÅˇÅˇÅˇﬁ  ô˝ˇ˚  ˝ˇ˚ H≤ˇˇ” õˇÅˇÅˇ `ŒˇÅˇÅˇ› ˝ˇ £˚  ≠˛ˇ¯  0—  ŒÍˇÅˇÅˇÅˇÅˇÅˇ› ˝ˇ £˚  ≠˛ˇ¯  0—  ŒÍˇÅˇÅˇÅˇÅˇÅˇ› ˝ˇ £˚  ≠˛ˇ¯  0—  ŒùˇÅˇÅˇ cœˇÅˇÅˇË ûV˜ ˛ˇ V˙ ˛ˇ“  ÅÙ ÏˇÅˇÅˇÅˇÅˇÅˇË ûV˜ ˛ˇ V˙ ˛ˇ“  ÅÙ ÏˇÅˇÅˇÅˇÅˇÅˇË ûV˜ ˛ˇ V˙ ˛ˇ“  ÅÙ ûˇÅˇÅˇ x—ˇÅˇÅˇ ïÁ ˇˇ˜ ˇˇ&˘ ïˇã“ ˇ£Ò  ÊÛˇÅˇÅˇÅˇÅˇÅˇ ïÁ ˇˇ˜ ˇˇ&˘ ïˇã“ ˇ£Ò  ÊÛˇÅˇÅˇÅˇÅˇÅˇ ïÁ ˇˇ˜ ˇˇ&˘ ïˇã“ ˇ£Ò  Ê£ˇÅˇÅˇ l‘ˇÅˇÅˇﬂ Á ∂®¸ 9L„ ˇˇÔ ˜ˇÅˇÅˇÅˇÅˇÅˇﬂ Á ∂®¸ 9L„ ˇˇÔ ˜ˇÅˇÅˇÅˇÅˇÅˇﬂ Á ∂®¸ 9L„ ˇˇÔ §ˇÅˇÅˇ ê’ˇÅˇÅˇ Åﬂ ˇˇË ˇˇ≠ˇˇ˝ ≤ˇˇs˘ nÔ Lˇˇ ¯ˇÅˇÅˇÅˇÅˇÅˇ Åﬂ ˇˇË ˇˇ≠ˇˇ˝ ≤ˇˇs˘ nÔ Lˇˇ ¯ˇÅˇÅˇÅˇÅˇÅˇ Åﬂ ˇˇË ˇˇ≠ˇˇ˝ ≤ˇˇs˘ nÔ Lˇˇ §ˇÅˇÅˇ •’ˇÅˇÅˇ ãÈ &ˇ˙ ˇˇÈ ¸ˇ ı˝ ˝ˇ˙ ˝ˇ ≤˜  ®¸ ˛ˇ   e˘ˇÅˇÅˇÅˇÅˇÅˇ ãÈ &ˇ˙ ˇˇÈ ¸ˇ ı˝ ˝ˇ˙ ˝ˇ ≤˜  ®¸ ˛ˇ   e˘ˇÅˇÅˇÅˇÅˇÅˇ ãÈ &ˇ˙ ˇˇÈ ¸ˇ ı˝ ˝ˇ˙ ˝ˇ ≤˜  ®¸ ˛ˇ   e•ˇÅˇÅˇ Á’ˇÅˇÅˇÒ ˇˇ¸  ˛ˇ˚ ÊˇˇÛ Üˇˇn¸  £˝ˇ ”¸ ˝ˇ Ê¸  ›¸ˇ [˙ ˝ˇ˛  ˙˛ˇ˝ ïˇı ˘ˇÅˇÅˇÅˇÅˇÅˇÒ ˇˇ¸  ˛ˇ˚ ÊˇˇÛ Üˇˇn¸  £˝ˇ ”¸ ˝ˇ Ê¸  ›¸ˇ [˙ ˝ˇ˛  ˙˛ˇ˝ ïˇı ˘ˇÅˇÅˇÅˇÅˇÅˇÒ ˇˇ¸  ˛ˇ˚ ÊˇˇÛ Üˇˇn¸  £˝ˇ ”¸ ˝ˇ Ê¸  ›¸ˇ [˙ ˝ˇ˛  ˙˛ˇ˝ ïˇı •ˇÅˇÅˇ ˆ÷ˇÅˇÅˇ ˇˇ˚  ÿ˛ˇ Q˝ ›ˇˇŒ˜  >˛ ˝ˇ¸ ˇˇC¯ ˝ˇ 4˝  ‚˚ˇ !¸  Å˝ˇ” ∂˛ˇ ã˛  ÿ˛ˇÙ ˚ˇÅˇÅˇÅˇÅˇÅˇ ˇˇ˚  ÿ˛ˇ Q˝ ›ˇˇŒ˜  >˛ ˝ˇ¸ ˇˇC¯ ˝ˇ 4˝  ‚˚ˇ !¸  Å˝ˇ” ∂˛ˇ ã˛  ÿ˛ˇÙ ˚ˇÅˇÅˇÅˇÅˇÅˇ ˇˇ˚  ÿ˛ˇ Q˝ ›ˇˇŒ˜  >˛ ˝ˇ¸ ˇˇC¯ ˝ˇ 4˝  ‚˚ˇ !¸  Å˝ˇ” ∂˛ˇ ã˛  ÿ˛ˇÙ ¶ˇÅˇÅˇ “ŸˇÅˇÅˇ[Á  ª˛ˇ¸ ˛ˇ 	¯ iˇı˚ˇ¸ ª ˜ ¸ˇ˝   ˚ˇ˚  ª¸ˇ Î˝ˇ˛  [˛ˇ ÿÚ  ˇÅˇÅˇÅˇÅˇÅˇ[Á  ª˛ˇ¸ ˛ˇ 	¯ iˇı˚ˇ¸ ª ˜ ¸ˇ˝   ˚ˇ˚  ª¸ˇ Î˝ˇ˛  [˛ˇ ÿÚ  ˇÅˇÅˇÅˇÅˇÅˇ[Á  ª˛ˇ¸ ˛ˇ 	¯ iˇı˚ˇ¸ ª ˜ ¸ˇ˝   ˚ˇ˚  ª¸ˇ Î˝ˇ˛  [˛ˇ ÿÚ ®ˇÅˇÅˇ π⁄ˇÅˇÅˇ‰ ˇˇ∂¸ ˛ˇ ¯  V˙ˇ ÎÔ ˝ˇ x˛ ¸ˇ ≈˙  Ü¯ˇ V˛  n˛ˇÌ  CÜˇÅˇÅˇÅˇÅˇ‰ ˇˇ∂¸ ˛ˇ ¯  V˙ˇ ÎÔ ˝ˇ x˛ ¸ˇ ≈˙  Ü¯ˇ V˛  n˛ˇÌ  CÜˇÅˇÅˇÅˇÅˇ‰ ˇˇ∂¸ ˛ˇ ¯  V˙ˇ ÎÔ ˝ˇ x˛ ¸ˇ ≈˙  Ü¯ˇ V˛  n˛ˇÌ  C≠ˇÅˇÅˇ ≠€ˇÅˇÅˇ„ Êˇˇ˚ ˇˇnı  ˛ˇ nÌ  û˝ˇÅ  ®˛ˇ ≤˘ ˜ˇ˝  ≠˛ˇÎ àˇÅˇÅˇÅˇÅˇ„ Êˇˇ˚ ˇˇnı  ˛ˇ nÌ  û˝ˇÅ  ®˛ˇ ≤˘ ˜ˇ˝  ≠˛ˇÎ àˇÅˇÅˇÅˇÅˇ„ Êˇˇ˚ ˇˇnı  ˛ˇ nÌ  û˝ˇÅ  ®˛ˇ ≤˘ ˜ˇ˝  ≠˛ˇÎ ÆˇÅˇÅˇ å‹ˇÅˇÅˇ Åœ  CÂ  ®˝ˇ`  ›ˇˇ˜ ¯ˇ x˛ ˝ˇˆ sV˜ âˇÅˇÅˇÅˇÅˇ Åœ  CÂ  ®˝ˇ`  ›ˇˇ˜ ¯ˇ x˛ ˝ˇˆ sV˜ âˇÅˇÅˇÅˇÅˇ Åœ  CÂ  ®˝ˇ`  ›ˇˇ˜ ¯ˇ x˛ ˝ˇˆ sV˜ ÆˇÅˇÅˇ π‹ˇÅˇÅˇœ ûˇˇ`˜  VÒ Îˇ”˝ ˇˇ≈˜ ˇˇ˙	  ˇˇ˛  ®˝ˇ¯ ˝ˇ Ê¯  iäˇÅˇÅˇÅˇÅˇœ ûˇˇ`˜  VÒ Îˇ”˝ ˇˇ≈˜ ˇˇ˙	  ˇˇ˛  ®˝ˇ¯ ˝ˇ Ê¯  iäˇÅˇÅˇÅˇÅˇœ ûˇˇ`˜  VÒ Îˇ”˝ ˇˇ≈˜ ˇˇ˙	  ˇˇ˛  ®˝ˇ¯ ˝ˇ Ê¯  iØˇÅˇÅˇ ≥›ˇÅˇÅˇ” ‚i˛  [˝ˇ˘ ˇ0Î  ‚˛ˇ˜ ˇˇ>˛ +ˇ›˛ ˚ˇx¿Êˇˇ›˘ˇ¯ ãˇÅˇÅˇÅˇÅˇ” ‚i˛  [˝ˇ˘ ˇ0Î  ‚˛ˇ˜ ˇˇ>˛ +ˇ›˛ ˚ˇx¿Êˇˇ›˘ˇ¯ ãˇÅˇÅˇÅˇÅˇ” ‚i˛  [˝ˇ˘ ˇ0Î  ‚˛ˇ˜ ˇˇ>˛ +ˇ›˛ ˚ˇx¿Êˇˇ›˘ˇ¯ ØˇÅˇÅˇ ≥ﬂˇÅˇÅˇ Å˘ iﬁ  `˛ˇ˝ ¸ˇ¸ Hˇ[˚ ˇ	Û ˝ˇ˜ ˇˇ¸ ÎL˛ Ìˇ˜ éˇÅˇÅˇÅˇÅˇ Å˘ iﬁ  `˛ˇ˝ ¸ˇ¸ Hˇ[˚ ˇ	Û ˝ˇ˜ ˇˇ¸ ÎL˛ Ìˇ˜ éˇÅˇÅˇÅˇÅˇ Å˘ iﬁ  `˛ˇ˝ ¸ˇ¸ Hˇ[˚ ˇ	Û ˝ˇ˜ ˇˇ¸ ÎL˛ Ìˇ˜ ∞ˇÅˇÅˇ »‚ˇÅˇÅˇ ∂¯  }˝ˇ‡  }¸ˇ˛  }˝ˇ¸ Îˇ˙ ˛ˇ Lˆ  }¸ˇÎ  ı˘ˇã! ®˚ˇ xı  ÜîˇÅˇÅˇÅˇÅˇ ∂¯  }˝ˇ‡  }¸ˇ˛  }˝ˇ¸ Îˇ˙ ˛ˇ Lˆ  }¸ˇÎ  ı˘ˇã! ®˚ˇ xı  ÜîˇÅˇÅˇÅˇÅˇ ∂¯  }˝ˇ‡  }¸ˇ˛  }˝ˇ¸ Îˇ˙ ˛ˇ Lˆ  }¸ˇÎ  ı˘ˇã! ®˚ˇ xı  Ü≥ˇÅˇÅˇ Ú‰ˇÅˇÅˇ ›ˆ ›ˇˇÊQ˚ 	}È ˚ˇ˝ iˇÿ>¸  ã˘  ∂¸ˇ ®˚ >”¸ˇ 4 Vˇ	!≤˝ˇ¯  Ê˝ˇ ªÛ  0óˇÅˇÅˇÅˇÅˇ ›ˆ ›ˇˇÊQ˚ 	}È ˚ˇ˝ iˇÿ>¸  ã˘  ∂¸ˇ ®˚ >”¸ˇ 4 Vˇ	!≤˝ˇ¯  Ê˝ˇ ªÛ  0óˇÅˇÅˇÅˇÅˇ ›ˆ ›ˇˇÊQ˚ 	}È ˚ˇ˝ iˇÿ>¸  ã˘  ∂¸ˇ ®˚ >”¸ˇ 4 Vˇ	!≤˝ˇ¯  Ê˝ˇ ªÛ  0¥ˇÅˇÅˇ π‰ˇÅˇÅˇ ı  	˙  n˝ˇÈ  H˚ˇ V˜ ªï¯ ˙ˇ ˝ ˚ˇ ÅÔ ˙ˇ ˆ ˛ˇ ÅÒ óˇÅˇÅˇÅˇÅˇ ı  	˙  n˝ˇÈ  H˚ˇ V˜ ªï¯ ˙ˇ ˝ ˚ˇ ÅÔ ˙ˇ ˆ ˛ˇ ÅÒ óˇÅˇÅˇÅˇÅˇ ı  	˙  n˝ˇÈ  H˚ˇ V˜ ªï¯ ˙ˇ ˝ ˚ˇ ÅÔ ˙ˇ ˆ ˛ˇ ÅÒ ¥ˇÅˇÅˇ »‰ˇÅˇÅˇÏ  ®˝ˇ Ê ¸ˇ¯  ˇ˜  ≈¸ˇ ¿˛  ô˚ˇ¸ Îˇˇ®˜ ˚ˇ Êı ˛ˇ˜  0˚  LòˇÅˇÅˇÅˇÅˇÏ  ®˝ˇ Ê ¸ˇ¯  ˇ˜  ≈¸ˇ ¿˛  ô˚ˇ¸ Îˇˇ®˜ ˚ˇ Êı ˛ˇ˜  0˚  LòˇÅˇÅˇÅˇÅˇÏ  ®˝ˇ Ê ¸ˇ¯  ˇ˜  ≈¸ˇ ¿˛  ô˚ˇ¸ Îˇˇ®˜ ˚ˇ Êı ˛ˇ˜  0˚  LµˇÅˇÅˇ È‰ˇÅˇÅˇÎ Êˇˇ+Â  s¸ˇ ª˚ ˇˇı  [˛ˇ C˛ ˝ˇ V˙ ô®˛ˇ˜ ¸ˇ `¯ `Ln˛ˇ˜ ˇˇ˙ ˛ˇÎ‚ùˇÅˇÅˇÅˇÅˇÎ Êˇˇ+Â  s¸ˇ ª˚ ˇˇı  [˛ˇ C˛ ˝ˇ V˙ ô®˛ˇ˜ ¸ˇ `¯ `Ln˛ˇ˜ ˇˇ˙ ˛ˇÎ‚ùˇÅˇÅˇÅˇÅˇÎ Êˇˇ+Â  s¸ˇ ª˚ ˇˇı  [˛ˇ C˛ ˝ˇ V˙ ô®˛ˇ˜ ¸ˇ `¯ `Ln˛ˇ˜ ˇˇ˙ ˛ˇÎ‚∫ˇÅˇÅˇ πÂˇÅˇÅˇ Å  ˚ˇ˚ ˇˇÙ ıˇˇ˛  ≠˛ˇı ∂¯  `˝ˇ !¯  Î˝ˇı0˜ ˛ˇı üˇÅˇÅˇÅˇÅˇ Å  ˚ˇ˚ ˇˇÙ ıˇˇ˛  ≠˛ˇı ∂¯  `˝ˇ !¯  Î˝ˇı0˜ ˛ˇı üˇÅˇÅˇÅˇÅˇ Å  ˚ˇ˚ ˇˇÙ ıˇˇ˛  ≠˛ˇı ∂¯  `˝ˇ !¯  Î˝ˇı0˜ ˛ˇı ªˇÅˇÅˇ ïÊˇÅˇÅˇ 0…  x˝ˇ +¸ 	ˇˇÓ ˝ˇÈ ˇˇı  £˝ˇı ˛ˇ Îˆ †ˇÅˇÅˇÅˇÅˇ 0…  x˝ˇ +¸ 	ˇˇÓ ˝ˇÈ ˇˇı  £˝ˇı ˛ˇ Îˆ †ˇÅˇÅˇÅˇÅˇ 0…  x˝ˇ +¸ 	ˇˇÓ ˝ˇÈ ˇˇı  £˝ˇı ˛ˇ Îˆ ªˇÅˇÅˇ ÜËˇÅˇÅˇ ≈∆ ˝ˇ˚ ≠ˇˇ  ‚˛ˇ ≈È  ‰ ÎˇQ>ı ¢ˇÅˇÅˇÅˇÅˇ ≈∆ ˝ˇ˚ ≠ˇˇ  ‚˛ˇ ≈È  ‰ ÎˇQ>ı ¢ˇÅˇÅˇÅˇÅˇ ≈∆ ˝ˇ˚ ≠ˇˇ  ‚˛ˇ ≈È  ‰ ÎˇQ>ı ªˇÅˇÅˇ ™ÈˇÅˇÅˇ∆ 	‚ˇˇÅ˙ ˇˇ>˛ ˇ+ı  ≈˝ˇ ˇ˙ˇ	ˆ +QÌ ”ˇÚ  Œ§ˇÅˇÅˇÅˇÅˇ∆ 	‚ˇˇÅ˙ ˇˇ>˛ ˇ+ı  ≈˝ˇ ˇ˙ˇ	ˆ +QÌ ”ˇÚ  Œ§ˇÅˇÅˇÅˇÅˇ∆ 	‚ˇˇÅ˙ ˇˇ>˛ ˇ+ı  ≈˝ˇ ˇ˙ˇ	ˆ +QÌ ”ˇÚ  ŒºˇÅˇÅˇ ◊ÎˇÅˇÅˇ ˙« ¸ˇ Ê˘ ˇV˛ Hˇ”ı  ‚˛ˇ ê¯ [e¸ ˝ˇ ª˜  ›˛ˇ } £˝ ï®¯  	¶ˇÅˇÅˇÅˇÅˇ ˙« ¸ˇ Ê˘ ˇV˛ Hˇ”ı  ‚˛ˇ ê¯ [e¸ ˝ˇ ª˜  ›˛ˇ } £˝ ï®¯  	¶ˇÅˇÅˇÅˇÅˇ ˙« ¸ˇ Ê˘ ˇV˛ Hˇ”ı  ‚˛ˇ ê¯ [e¸ ˝ˇ ª˜  ›˛ˇ } £˝ ï®¯  	ºˇÅˇÅˇ ≈ÎˇÅˇÅˇ∆   ˝ˇ¯  n˝ ˛ˇı  ‚˛ˇ ã˘  ˇˇ˝  û˝ˇ Œ¸ Qô˙ˇ Î  +˚ ˛ˇ¯ ¶ˇÅˇÅˇÅˇÅˇ∆   ˝ˇ¯  n˝ ˛ˇı  ‚˛ˇ ã˘  ˇˇ˝  û˝ˇ Œ¸ Qô˙ˇ Î  +˚ ˛ˇ¯ ¶ˇÅˇÅˇÅˇÅˇ∆   ˝ˇ¯  n˝ ˛ˇı  ‚˛ˇ ã˘  ˇˇ˝  û˝ˇ Œ¸ Qô˙ˇ Î  +˚ ˛ˇ¯ ºˇÅˇÅˇ ÊÏˇÅˇÅˇ 0Ò  ˇˇı >Á `ˇˇÎÛ  x˝ˇˆ  Å˛ˇ¿  ï˝  ˛ˇ˛  ˝ˇ ï˛ s˜ˇË ˝ˇ 0˘ ®ˇÅˇÅˇÅˇÅˇ 0Ò  ˇˇı >Á `ˇˇÎÛ  x˝ˇˆ  Å˛ˇ¿  ï˝  ˛ˇ˛  ˝ˇ ï˛ s˜ˇË ˝ˇ 0˘ ®ˇÅˇÅˇÅˇÅˇ 0Ò  ˇˇı >Á `ˇˇÎÛ  x˝ˇˆ  Å˛ˇ¿  ï˝  ˛ˇ˛  ˝ˇ ï˛ s˜ˇË ˝ˇ 0˘ ΩˇÅˇÅˇ ˛ÌˇÅˇÅˇÔ ûˇˇ	ˆ ˝ˇ4  ûHÓ +QÚ ¸ˇ [ˆ ˘ˇ˛  ˇˇV˛ ˛ˇ  ˝ ÿˇ≤˛ˇ û¸ˇ Hˆ Åˇˇˆ ¸ˇ ”˘ ™ˇÅˇÅˇÅˇÅˇÔ ûˇˇ	ˆ ˝ˇ4  ûHÓ +QÚ ¸ˇ [ˆ ˘ˇ˛  ˇˇV˛ ˛ˇ  ˝ ÿˇ≤˛ˇ û¸ˇ Hˆ Åˇˇˆ ¸ˇ ”˘ ™ˇÅˇÅˇÅˇÅˇÔ ûˇˇ	ˆ ˝ˇ4  ûHÓ +QÚ ¸ˇ [ˆ ˘ˇ˛  ˇˇV˛ ˛ˇ  ˝ ÿˇ≤˛ˇ û¸ˇ Hˆ Åˇˇˆ ¸ˇ ”˘ æˇÅˇÅˇÓˇÅˇÅˇÓ ˛ˇ !˜  4˘ˇıŒﬂ  ¸ˇ ˆ ˘ˇ˛ £ˇê˝ ˇˇx˝  [˝ˇ  ˛  ª˛ˇ¸ ˇ≈¸ ˛ˇˆ  ≈¸ˇ 9˙  0¨ˇÅˇÅˇÅˇÅˇÓ ˛ˇ !˜  4˘ˇıŒﬂ  ¸ˇ ˆ ˘ˇ˛ £ˇê˝ ˇˇx˝  [˝ˇ  ˛  ª˛ˇ¸ ˇ≈¸ ˛ˇˆ  ≈¸ˇ 9˙  0¨ˇÅˇÅˇÅˇÅˇÓ ˛ˇ !˜  4˘ˇıŒﬂ  ¸ˇ ˆ ˘ˇ˛ £ˇê˝ ˇˇx˝  [˝ˇ  ˛  ª˛ˇ¸ ˇ≈¸ ˛ˇˆ  ≈¸ˇ 9˙  0øˇÅˇÅˇ ◊ÓˇÅˇÅˇÔ ‚ˇˇÜ˙ ≈ˇı®ıˇ ”‡ ÅˇÊ˛ˇı ˙ˇ Ò  ≠¸ˇ˝ CˇˇL˝ ˝ˇ˝ ˛ˇˆ  ˚ˇ˘ ¨ˇÅˇÅˇÅˇÅˇÔ ‚ˇˇÜ˙ ≈ˇı®ıˇ ”‡ ÅˇÊ˛ˇı ˙ˇ Ò  ≠¸ˇ˝ CˇˇL˝ ˝ˇ˝ ˛ˇˆ  ˚ˇ˘ ¨ˇÅˇÅˇÅˇÅˇÔ ‚ˇˇÜ˙ ≈ˇı®ıˇ ”‡ ÅˇÊ˛ˇı ˙ˇ Ò  ≠¸ˇ˝ CˇˇL˝ ˝ˇ˝ ˛ˇˆ  ˚ˇ˘ øˇÅˇÅˇÓˇÅˇÅˇ ˇˇ˘  ≤˙ˇ&!Î˙ˇ ≠¸ [Ë ıˇ˙ [	˚ ˚ˇ ôÒ  ˙˝ˇ £˝  s˛ˇ¸ ˙ˇˇ¿˝ ˛ˇ Êˆ  ÿ¸ˇ˘ ¨ˇÅˇÅˇÅˇÅˇ ˇˇ˘  ≤˙ˇ&!Î˙ˇ ≠¸ [Ë ıˇ˙ [	˚ ˚ˇ ôÒ  ˙˝ˇ £˝  s˛ˇ¸ ˙ˇˇ¿˝ ˛ˇ Êˆ  ÿ¸ˇ˘ ¨ˇÅˇÅˇÅˇÅˇ ˇˇ˘  ≤˙ˇ&!Î˙ˇ ≠¸ [Ë ıˇ˙ [	˚ ˚ˇ ôÒ  ˙˝ˇ £˝  s˛ˇ¸ ˙ˇˇ¿˝ ˛ˇ Êˆ  ÿ¸ˇ˘ øˇÅˇÅˇ ÏÓˇÅˇÅˇÒ ôˇ&¯ ˙ˇ˝  x˘ˇ˝ ˇˇÈ ˇˇ®˚ ≤ˇˇ¸ ˚ˇÒ  ô˝ˇ˚ ¸ˇ  ¸  9¸  x˝ˇı ¸ˇ˘  &≠ˇÅˇÅˇÅˇÅˇÒ ôˇ&¯ ˙ˇ˝  x˘ˇ˝ ˇˇÈ ˇˇ®˚ ≤ˇˇ¸ ˚ˇÒ  ô˝ˇ˚ ¸ˇ  ¸  9¸  x˝ˇı ¸ˇ˘  &≠ˇÅˇÅˇÅˇÅˇÒ ôˇ&¯ ˙ˇ˝  x˘ˇ˝ ˇˇÈ ˇˇ®˚ ≤ˇˇ¸ ˚ˇÒ  ô˝ˇ˚ ¸ˇ  ¸  9¸  x˝ˇı ¸ˇ˘  &¿ˇÅˇÅˇÓˇÅˇÅˇÒ ˇô˜ ¸ˇ ª˙  ¿˙ˇ˛ ®ˇÔ ï£0˛ ˝ˇ !¸ ôˇˇ˝  Q˛ˇı}˝ +xˆ  £˛ˇ C¸  Œ˚ˇ ≠˜ ˙ˇ 4¯ ˝ˇ e¯ ≠ˇÅˇÅˇÅˇÅˇÒ ˇô˜ ¸ˇ ª˙  ¿˙ˇ˛ ®ˇÔ ï£0˛ ˝ˇ !¸ ôˇˇ˝  Q˛ˇı}˝ +xˆ  £˛ˇ C¸  Œ˚ˇ ≠˜ ˙ˇ 4¯ ˝ˇ e¯ ≠ˇÅˇÅˇÅˇÅˇÒ ˇô˜ ¸ˇ ª˙  ¿˙ˇ˛ ®ˇÔ ï£0˛ ˝ˇ !¸ ôˇˇ˝  Q˛ˇı}˝ +xˆ  £˛ˇ C¸  Œ˚ˇ ≠˜ ˙ˇ 4¯ ˝ˇ e¯ ¿ˇÅˇÅˇÔˇÅˇÅˇ }Ò ˇ}˜  ≠¸ˇ¯  ã¸ˇ 	Ï ˆˇ ï¸ ıˇˇ[˛  ı˛ˇ ∂˝ ªˇˇˆ  Q˛ˇ¸  0¯ˇ˘  0˘ˇ ®˘ ˛ˇ ”˜ ÆˇÅˇÅˇÅˇÅˇ }Ò ˇ}˜  ≠¸ˇ¯  ã¸ˇ 	Ï ˆˇ ï¸ ıˇˇ[˛  ı˛ˇ ∂˝ ªˇˇˆ  Q˛ˇ¸  0¯ˇ˘  0˘ˇ ®˘ ˛ˇ ”˜ ÆˇÅˇÅˇÅˇÅˇ }Ò ˇ}˜  ≠¸ˇ¯  ã¸ˇ 	Ï ˆˇ ï¸ ıˇˇ[˛  ı˛ˇ ∂˝ ªˇˇˆ  Q˛ˇ¸  0¯ˇ˘  0˘ˇ ®˘ ˛ˇ ”˜ ¿ˇÅˇÅˇ „ˇÅˇÅˇ  ˇˇ˜  ˛ˇ +ˆ ˚ˇÏ ıˇ¸ ¸ˇ  ôªŒ˛  &¸ˇ ˆ ıˇ ˝  ¯ˇ¯  ¿¯ˇ˘ ˛ˇı ∞ˇÅˇÅˇÅˇÅˇ  ˇˇ˜  ˛ˇ +ˆ ˚ˇÏ ıˇ¸ ¸ˇ  ôªŒ˛  &¸ˇ ˆ ıˇ ˝  ¯ˇ¯  ¿¯ˇ˘ ˛ˇı ∞ˇÅˇÅˇÅˇÅˇ  ˇˇ˜  ˛ˇ +ˆ ˚ˇÏ ıˇ¸ ¸ˇ  ôªŒ˛  &¸ˇ ˆ ıˇ ˝  ¯ˇ¯  ¿¯ˇ˘ ˛ˇı ¡ˇÅˇÅˇˇÅˇÅˇÔ ˇˇˆ ”ˆ  i˚ˇ∂}˚ ≠Vˆ  ÿˆˇ˝  ≠˝ˇ Î˙  ∂¸ˇÛ Îˇ>˚ HCı  !¯ˇ[˙  >˝ˇˆ  ∂±ˇÅˇÅˇÅˇÅˇÔ ˇˇˆ ”ˆ  i˚ˇ∂}˚ ≠Vˆ  ÿˆˇ˝  ≠˝ˇ Î˙  ∂¸ˇÛ Îˇ>˚ HCı  !¯ˇ[˙  >˝ˇˆ  ∂±ˇÅˇÅˇÅˇÅˇÔ ˇˇˆ ”ˆ  i˚ˇ∂}˚ ≠Vˆ  ÿˆˇ˝  ≠˝ˇ Î˙  ∂¸ˇÛ Îˇ>˚ HCı  !¯ˇ[˙  >˝ˇˆ  ∂¬ˇÅˇÅˇ ˛ÒˇÅˇÅˇÓ ˇˇı `Cˆ  ª˘ˇ∂s˛ ›ˇˇÙ ÎV>®˚ˇ ã¯ˇ˚  Î¸ˇ ≈˚ &ˇL¸ ÎˇˇÔ  `˘ˇ Üˆ ¸ˇÙ  ê¥ˇÅˇÅˇÅˇÅˇÓ ˇˇı `Cˆ  ª˘ˇ∂s˛ ›ˇˇÙ ÎV>®˚ˇ ã¯ˇ˚  Î¸ˇ ≈˚ &ˇL¸ ÎˇˇÔ  `˘ˇ Üˆ ¸ˇÙ  ê¥ˇÅˇÅˇÅˇÅˇÓ ˇˇı `Cˆ  ª˘ˇ∂s˛ ›ˇˇÙ ÎV>®˚ˇ ã¯ˇ˚  Î¸ˇ ≈˚ &ˇL¸ ÎˇˇÔ  `˘ˇ Üˆ ¸ˇÙ  êƒˇÅˇÅˇ ˚ÚˇÅˇÅˇÌ ˇˇˆ 9Qı  	˝  ê˚ˇ  Q˛ˇ LÚ ˛ˇ∂`ˆˇ¸  x˚ˇ˚  9˛ˇ¸ ˛ˇ”Ú  	¯ˇ˚ ˇˇ˝ ¸ˇÚ ∂ˇÅˇÅˇÅˇÅˇÌ ˇˇˆ 9Qı  	˝  ê˚ˇ  Q˛ˇ LÚ ˛ˇ∂`ˆˇ¸  x˚ˇ˚  9˛ˇ¸ ˛ˇ”Ú  	¯ˇ˚ ˇˇ˝ ¸ˇÚ ∂ˇÅˇÅˇÅˇÅˇÌ ˇˇˆ 9Qı  	˝  ê˚ˇ  Q˛ˇ LÚ ˛ˇ∂`ˆˇ¸  x˚ˇ˚  9˛ˇ¸ ˛ˇ”Ú  	¯ˇ˚ ˇˇ˝ ¸ˇÚ ≈ˇÅˇÅˇÙˇÅˇÅˇ Ê ˇôn˛ˇ !˘ ˛ˇıx  9˚ˇã ˝ˇˆ H iLÿ˚  ®˛ˇ  ˇˇ¸ ˚ˇ˚ ¸ˇ¸  ®˝ˇıÅÙ ¯ˇ˚ ˇˇ˝ ¸ˇÒ πˇÅˇÅˇÅˇÅˇ Ê ˇôn˛ˇ !˘ ˛ˇıx  9˚ˇã ˝ˇˆ H iLÿ˚  ®˛ˇ  ˇˇ¸ ˚ˇ˚ ¸ˇ¸  ®˝ˇıÅÙ ¯ˇ˚ ˇˇ˝ ¸ˇÒ πˇÅˇÅˇÅˇÅˇ Ê ˇôn˛ˇ !˘ ˛ˇıx  9˚ˇã ˝ˇˆ H iLÿ˚  ®˛ˇ  ˇˇ¸ ˚ˇ˚ ¸ˇ¸  ®˝ˇıÅÙ ¯ˇ˚ ˇˇ˝ ¸ˇÒ ∆ˇÅˇÅˇ:ÙˇÅˇÅˇ  ˚ˇ 9˘ ¸ˇŒ”≠CÒ ˚ˇı ˜ e‚ˇÊ˛ˇ˙ +‚Q˛ ˇˇ›˛  ¿˚ˇ¸  ¸ˇ Ü˚ ¸ˇ ≈˜  [¯ˇ˚  ≈˛ˇ˝  ˝ˇ 0˝ ˇˇ˘ πˇÅˇÅˇÅˇÅˇ  ˚ˇ 9˘ ¸ˇŒ”≠CÒ ˚ˇı ˜ e‚ˇÊ˛ˇ˙ +‚Q˛ ˇˇ›˛  ¿˚ˇ¸  ¸ˇ Ü˚ ¸ˇ ≈˜  [¯ˇ˚  ≈˛ˇ˝  ˝ˇ 0˝ ˇˇ˘ πˇÅˇÅˇÅˇÅˇ  ˚ˇ 9˘ ¸ˇŒ”≠CÒ ˚ˇı ˜ e‚ˇÊ˛ˇ˙ +‚Q˛ ˇˇ›˛  ¿˚ˇ¸  ¸ˇ Ü˚ ¸ˇ ≈˜  [¯ˇ˚  ≈˛ˇ˝  ˝ˇ 0˝ ˇˇ˘ ∆ˇÅˇÅˇ%ıˇÅˇÅˇÔ ˙ˇ ”˘  	˘ˇ ∂˝ ‚£˜  û¸ˇˆ  }˚ˇ¯  0˝ ˝ˇ x˙ˇ ª˛  ˙ˇ˙  ê˝ˇ ∂¸ 0ïˆˇ˚ ¸ˇ¸  ≈˛ˇ H˛ +ˇˇ¯ ∫ˇÅˇÅˇÅˇÅˇÔ ˙ˇ ”˘  	˘ˇ ∂˝ ‚£˜  û¸ˇˆ  }˚ˇ¯  0˝ ˝ˇ x˙ˇ ª˛  ˙ˇ˙  ê˝ˇ ∂¸ 0ïˆˇ˚ ¸ˇ¸  ≈˛ˇ H˛ +ˇˇ¯ ∫ˇÅˇÅˇÅˇÅˇÔ ˙ˇ ”˘  	˘ˇ ∂˝ ‚£˜  û¸ˇˆ  }˚ˇ¯  0˝ ˝ˇ x˙ˇ ª˛  ˙ˇ˙  ê˝ˇ ∂¸ 0ïˆˇ˚ ¸ˇ¸  ≈˛ˇ H˛ +ˇˇ¯ ∆ˇÅˇÅˇ%˜ˇÅˇÅˇ ê˘  ˇ¯  £¯ˇ˙  Úˇ &¯ !ª¸ˇ˜  ª˝ˇ˜ &}˛  Œ˜ˇ  +˙ˇ &˜ Üs˝  ˙Ûˇ˚ ¸ˇ Å˚ ! +˝ ıˇ˜  iΩˇÅˇÅˇÅˇÅˇ ê˘  ˇ¯  £¯ˇ˙  Úˇ &¯ !ª¸ˇ˜  ª˝ˇ˜ &}˛  Œ˜ˇ  +˙ˇ &˜ Üs˝  ˙Ûˇ˚ ¸ˇ Å˚ ! +˝ ıˇ˜  iΩˇÅˇÅˇÅˇÅˇ ê˘  ˇ¯  £¯ˇ˙  Úˇ &¯ !ª¸ˇ˜  ª˝ˇ˜ &}˛  Œ˜ˇ  +˙ˇ &˜ Üs˝  ˙Ûˇ˚ ¸ˇ Å˚ ! +˝ ıˇ˜  i«ˇÅˇÅˇ¯ˇÅˇÅˇ¯ 0ˇ˘  ≈˜ˇ ≤˚ ˇˇ9˛ ˜ˇ ≤˜  ¿¸ˇ û¯ ˛ˇˆ ˝ˇ˛ ˝ˇ ¿˝ˇ˛  >˙ˇ  Ûˇ˙  ¸ˇ 4Ù ˇïÙ ¿ˇÅˇÅˇÅˇÅˇ¯ 0ˇ˘  ≈˜ˇ ≤˚ ˇˇ9˛ ˜ˇ ≤˜  ¿¸ˇ û¯ ˛ˇˆ ˝ˇ˛ ˝ˇ ¿˝ˇ˛  >˙ˇ  Ûˇ˙  ¸ˇ 4Ù ˇïÙ ¿ˇÅˇÅˇÅˇÅˇ¯ 0ˇ˘  ≈˜ˇ ≤˚ ˇˇ9˛ ˜ˇ ≤˜  ¿¸ˇ û¯ ˛ˇˆ ˝ˇ˛ ˝ˇ ¿˝ˇ˛  >˙ˇ  Ûˇ˙  ¸ˇ 4Ù ˇïÙ …ˇÅˇÅˇ"˘ˇÅˇÅˇ û˘ 0˙0˘  !˛ˇ ≠˛  Œ˛ˇÙ  H¯ˇˆ  e¸ˇ˘ ˇˇˆ ¸ˇ ‚˛ ˙ˇ> ˝ˇ ˛ ˘ˇ 0˚ êŒ9˘ û˜ˇ˜ ¸ˇ nÂ  ÿ¬ˇÅˇÅˇÅˇÅˇ û˘ 0˙0˘  !˛ˇ ≠˛  Œ˛ˇÙ  H¯ˇˆ  e¸ˇ˘ ˇˇˆ ¸ˇ ‚˛ ˙ˇ> ˝ˇ ˛ ˘ˇ 0˚ êŒ9˘ û˜ˇ˜ ¸ˇ nÂ  ÿ¬ˇÅˇÅˇÅˇÅˇ û˘ 0˙0˘  !˛ˇ ≠˛  Œ˛ˇÙ  H¯ˇˆ  e¸ˇ˘ ˇˇˆ ¸ˇ ‚˛ ˙ˇ> ˝ˇ ˛ ˘ˇ 0˚ êŒ9˘ û˜ˇ˜ ¸ˇ nÂ  ÿ ˇÅˇÅˇ˘ˇÅˇÅˇ¯ ˇˇ˜ ˛ˇ ˝ +i!Û ã  ˙ˇˆ  >¸ˇ˚  Å˛ˇ˜  +¸ˇ˘ ®ˇªô˛ ¯ˇ˚ ïˇˇÿ˜  ≈˘ˇ Å˜ ¸ˇ ïÌ  9˙ ¡ˇÅˇÅˇÅˇÅˇ¯ ˇˇ˜ ˛ˇ ˝ +i!Û ã  ˙ˇˆ  >¸ˇ˚  Å˛ˇ˜  +¸ˇ˘ ®ˇªô˛ ¯ˇ˚ ïˇˇÿ˜  ≈˘ˇ Å˜ ¸ˇ ïÌ  9˙ ¡ˇÅˇÅˇÅˇÅˇ¯ ˇˇ˜ ˛ˇ ˝ +i!Û ã  ˙ˇˆ  >¸ˇ˚  Å˛ˇ˜  +¸ˇ˘ ®ˇªô˛ ¯ˇ˚ ïˇˇÿ˜  ≈˘ˇ Å˜ ¸ˇ ïÌ  9˙ …ˇÅˇÅˇ È˘ˇÅˇÅˇ¯ Œ˜ 	[Ê  }¸ˇ ”ˆ ˚ˇ¸ ˛ˇˆ  ˝ˇ !Û  i¯ˇ˚ ÿˇˇ≠˜ ˘ˇ ®ˆ ¸ˇ  Ô  Ü˛ˇ˚ ¡ˇÅˇÅˇÅˇÅˇ¯ Œ˜ 	[Ê  }¸ˇ ”ˆ ˚ˇ¸ ˛ˇˆ  ˝ˇ !Û  i¯ˇ˚ ÿˇˇ≠˜ ˘ˇ ®ˆ ¸ˇ  Ô  Ü˛ˇ˚ ¡ˇÅˇÅˇÅˇÅˇ¯ Œ˜ 	[Ê  }¸ˇ ”ˆ ˚ˇ¸ ˛ˇˆ  ˝ˇ !Û  i¯ˇ˚ ÿˇˇ≠˜ ˘ˇ ®ˆ ¸ˇ  Ô  Ü˛ˇ˚ …ˇÅˇÅˇ ‘˘ˇÅˇÅˇÕ  ≈˝ˇ ãˆ ˚ˇ˝ ˛ˇı  ª˛ˇÚ ˜ˇ˚ ˛ˇ ®˜ ˙ˇ +˚ ¿≤¸ iˇı≠Ó  ª˛ˇ ¸ ¡ˇÅˇÅˇÅˇÅˇÕ  ≈˝ˇ ãˆ ˚ˇ˝ ˛ˇı  ª˛ˇÚ ˜ˇ˚ ˛ˇ ®˜ ˙ˇ +˚ ¿≤¸ iˇı≠Ó  ª˛ˇ ¸ ¡ˇÅˇÅˇÅˇÅˇÕ  ≈˝ˇ ãˆ ˚ˇ˝ ˛ˇı  ª˛ˇÚ ˜ˇ˚ ˛ˇ ®˜ ˙ˇ +˚ ¿≤¸ iˇı≠Ó  ª˛ˇ ¸ …ˇÅˇÅˇ Ô˙ˇÅˇÅˇ £Û ˇˇ€ ˝ˇÙ  ÿ˛ˇ C˛ ˇˇ Ù ˇˇôÛ  ˜ˇ˚ ˛ˇ˜  i¸ˇ˘ 0ˇ  ıˇˇ¯  û˛ˇ¸  ”√ˇÅˇÅˇÅˇÅˇ £Û ˇˇ€ ˝ˇÙ  ÿ˛ˇ C˛ ˇˇ Ù ˇˇôÛ  ˜ˇ˚ ˛ˇ˜  i¸ˇ˘ 0ˇ  ıˇˇ¯  û˛ˇ¸  ”√ˇÅˇÅˇÅˇÅˇ £Û ˇˇ€ ˝ˇÙ  ÿ˛ˇ C˛ ˇˇ Ù ˇˇôÛ  ˜ˇ˚ ˛ˇ˜  i¸ˇ˘ 0ˇ  ıˇˇ¯  û˛ˇ¸  ” ˇÅˇÅˇ Ê˙ˇÅˇÅˇÛ ïˇˇ≈‹ ˝ˇÛ ˝ˇÓ ˇ˝ ˛ˇ˘  	¯ˇ  ¸ ≈ˇˇ˜  `¸ˇ ≠˘ ˇˇÎÒ ˛ˇ Ê˜ ˛ˇ ï¸ √ˇÅˇÅˇÅˇÅˇÛ ïˇˇ≈‹ ˝ˇÛ ˝ˇÓ ˇ˝ ˛ˇ˘  	¯ˇ  ¸ ≈ˇˇ˜  `¸ˇ ≠˘ ˇˇÎÒ ˛ˇ Ê˜ ˛ˇ ï¸ √ˇÅˇÅˇÅˇÅˇÛ ïˇˇ≈‹ ˝ˇÛ ˝ˇÓ ˇ˝ ˛ˇ˘  	¯ˇ  ¸ ≈ˇˇ˜  `¸ˇ ≠˘ ˇˇÎÒ ˛ˇ Ê˜ ˛ˇ ï¸  ˇÅˇÅˇ¸ˇÅˇÅˇŒ9Û ¿Œ‚ˇˇ›ˇ”‡ ˝ˇÒ ÿˇÌ  s˛  ê˝ˇ˘  Ê˙ˇ ˙¸ 9ˇˇV˜ ¸ˇ˜ ˛ˇ ≤Ù  e˝ˇ 9˜ ˛ˇ ≈˚ 4®»ˇÅˇÅˇÅˇÅˇŒ9Û ¿Œ‚ˇˇ›ˇ”‡ ˝ˇÒ ÿˇÌ  s˛  ê˝ˇ˘  Ê˙ˇ ˙¸ 9ˇˇV˜ ¸ˇ˜ ˛ˇ ≤Ù  e˝ˇ 9˜ ˛ˇ ≈˚ 4®»ˇÅˇÅˇÅˇÅˇŒ9Û ¿Œ‚ˇˇ›ˇ”‡ ˝ˇÒ ÿˇÌ  s˛  ê˝ˇ˘  Ê˙ˇ ˙¸ 9ˇˇV˜ ¸ˇ˜ ˛ˇ ≤Ù  e˝ˇ 9˜ ˛ˇ ≈˚ 4®ÕˇÅˇÅˇ ·˝ˇÅˇÅˇÓ  £¸ˇ·  Q˝ˇÒ ˇÏ [  ˛ˇ ≈˜ ˙ˇ˚ ¿ˇˇ˜ ˝ˇ >ˆ ˝ˇ &˜ ˙ˇ˜  }˝ˇ¯ œˇ ˙˝ˇÅˇÅˇÅˇÅˇÓ  £¸ˇ·  Q˝ˇÒ ˇÏ [  ˛ˇ ≈˜ ˙ˇ˚ ¿ˇˇ˜ ˝ˇ >ˆ ˝ˇ &˜ ˙ˇ˜  }˝ˇ¯ œˇ ˙˝ˇÅˇÅˇÅˇÅˇÓ  £¸ˇ·  Q˝ˇÒ ˇÏ [  ˛ˇ ≈˜ ˙ˇ˚ ¿ˇˇ˜ ˝ˇ >ˆ ˝ˇ &˜ ˙ˇ˜  }˝ˇ¯ œˇ ˙ÅˇÅˇ ∞˛ˇÅˇÅˇÏ ˝ˇ· ˚ˇ ã‹ 9ˇ›˝ˇˆ ˚ˇ˙ ˛ˇ¯ ˝ˇı  [ˆˇÎxû˘ˇ˙ ˘ˇ¯ ÀˇÅˇÅˇÅˇÅˇÏ ˝ˇ· ˚ˇ ã‹ 9ˇ›˝ˇˆ ˚ˇ˙ ˛ˇ¯ ˝ˇı  [ˆˇÎxû˘ˇ˙ ˘ˇ¯ ÀˇÅˇÅˇÅˇÅˇÏ ˝ˇ· ˚ˇ ã‹ 9ˇ›˝ˇˆ ˚ˇ˙ ˛ˇ¯ ˝ˇı  [ˆˇÎxû˘ˇ˙ ˘ˇ¯ ŒˇÅˇÅˇ
ˇˇÅˇÅˇ Ï ˛ˇ Q˙  >Í ˘ˇË ˇˇ¯  e¸ˇ ˝ +∂  ˚ˇ ›˙ ˇˇL¸  i˚ˇ ≤ı ıˇª  ˙ˇ 4¯  `¸ˇ 0˘ ÃˇÅˇÅˇÅˇÅˇ Ï ˛ˇ Q˙  >Í ˘ˇË ˇˇ¯  e¸ˇ ˝ +∂  ˚ˇ ›˙ ˇˇL¸  i˚ˇ ≤ı ıˇª  ˙ˇ 4¯  `¸ˇ 0˘ ÃˇÅˇÅˇÅˇÅˇ Ï ˛ˇ Q˙  >Í ˘ˇË ˇˇ¯  e¸ˇ ˝ +∂  ˚ˇ ›˙ ˇˇL¸  i˚ˇ ≤ı ıˇª  ˙ˇ 4¯  `¸ˇ 0˘ ŒˇÅˇÅˇ
ˇˇÅˇÅˇÎ ˛ˇ¸ s˙˝ˇ CÔ  Ü¯ˇ ÜÍ  ¿˛ˇ n˘  ¿˝ˇ ˝ Ùˇ˙ sˇˇ¸  Ê˚ˇ êı  ¿ˆˇ ›˛ ¸ˇ ∂Ù  ¿˛ˇ¯  iÕˇÅˇÅˇÅˇÅˇÎ ˛ˇ¸ s˙˝ˇ CÔ  Ü¯ˇ ÜÍ  ¿˛ˇ n˘  ¿˝ˇ ˝ Ùˇ˙ sˇˇ¸  Ê˚ˇ êı  ¿ˆˇ ›˛ ¸ˇ ∂Ù  ¿˛ˇ¯  iÕˇÅˇÅˇÅˇÅˇÎ ˛ˇ¸ s˙˝ˇ CÔ  Ü¯ˇ ÜÍ  ¿˛ˇ n˘  ¿˝ˇ ˝ Ùˇ˙ sˇˇ¸  Ê˚ˇ êı  ¿ˆˇ ›˛ ¸ˇ ∂Ù  ¿˛ˇ¯  iœˇÅˇÅˇ" ˇÅˇÅˇ ÊÎ ≈ˇˇ¸ ˛ˇ4n˛ˇ”4˜ ˇˇ}4˛ˇ ∂¯ˇ9Ó  ¸ˇ ”˙ ˝ˇ ı˝ ıˇ ê˘ ˛ˇ¸ ˚ˇ ‚ı  ∂ˆˇ C˛  Î¸ˇ˚  !Ï ŒˇÅˇÅˇÅˇÅˇ ÊÎ ≈ˇˇ¸ ˛ˇ4n˛ˇ”4˜ ˇˇ}4˛ˇ ∂¯ˇ9Ó  ¸ˇ ”˙ ˝ˇ ı˝ ıˇ ê˘ ˛ˇ¸ ˚ˇ ‚ı  ∂ˆˇ C˛  Î¸ˇ˚  !Ï ŒˇÅˇÅˇÅˇÅˇ ÊÎ ≈ˇˇ¸ ˛ˇ4n˛ˇ”4˜ ˇˇ}4˛ˇ ∂¯ˇ9Ó  ¸ˇ ”˙ ˝ˇ ı˝ ıˇ ê˘ ˛ˇ¸ ˚ˇ ‚ı  ∂ˆˇ C˛  Î¸ˇ˚  !Ï œˇÅˇÅˇ% ˇÅˇÅˇ ≠Î >ˇˇx˝ ≤V˛  Ê¸ˇ C˘ ˚ˇ9  +¯ˇ ÊÔ  Ê˙ˇ n˝ ¸ˇ˝ Ùˇ˘  Ü˛ˇ¸ ¸ˇ˝ i∂9˚  £¯ˇ £˝ ˘ˇ¸ ûˇÌ ŒˇÅˇÅˇÅˇÅˇ ≠Î >ˇˇx˝ ≤V˛  Ê¸ˇ C˘ ˚ˇ9  +¯ˇ ÊÔ  Ê˙ˇ n˝ ¸ˇ˝ Ùˇ˘  Ü˛ˇ¸ ¸ˇ˝ i∂9˚  £¯ˇ £˝ ˘ˇ¸ ûˇÌ ŒˇÅˇÅˇÅˇÅˇ ≠Î >ˇˇx˝ ≤V˛  Ê¸ˇ C˘ ˚ˇ9  +¯ˇ ÊÔ  Ê˙ˇ n˝ ¸ˇ˝ Ùˇ˘  Ü˛ˇ¸ ¸ˇ˝ i∂9˚  £¯ˇ £˝ ˘ˇ¸ ûˇÌ œˇÅˇÅˇ% ˇÅˇÅˇ 4Í ˇˇ¯ ˙ˇ >˘  £˛ˇ Q˝  `¯ˇ  ˛ˇe ıˇˇ	˝ ˛ˇ Ê˝ Ûˇ˙  ê˝ˇ¸ ˝ˇ˛  !¸ˇ i˝ ˜ˇ˝ ˘ˇ˚ ”ˇˇÌ  eœˇÅˇÅˇÅˇÅˇ 4Í ˇˇ¯ ˙ˇ >˘  £˛ˇ Q˝  `¯ˇ  ˛ˇe ıˇˇ	˝ ˛ˇ Ê˝ Ûˇ˙  ê˝ˇ¸ ˝ˇ˛  !¸ˇ i˝ ˜ˇ˝ ˘ˇ˚ ”ˇˇÌ  eœˇÅˇÅˇÅˇÅˇ 4Í ˇˇ¯ ˙ˇ >˘  £˛ˇ Q˝  `¯ˇ  ˛ˇe ıˇˇ	˝ ˛ˇ Ê˝ Ûˇ˙  ê˝ˇ¸ ˝ˇ˛  !¸ˇ i˝ ˜ˇ˝ ˘ˇ˚ ”ˇˇÌ  e–ˇÅˇÅˇ= ˇÅˇÅˇÒ  V˙ ˛ˇ ª¯  ¿˚ˇ 	¯ CV˘  ª˙ˇÒ 4ˇˇ≤  C˙˛ !¿˛ˇ ≈˝  ≠Ûˇ ˚ ˙ˇ ô¸ˇ0 Lˆˇ Î˝ˇ 4˝ˇn 	¯ˇ >˝  `˝ˇÏ œˇÅˇÅˇÅˇÅˇÒ  V˙ ˛ˇ ª¯  ¿˚ˇ 	¯ CV˘  ª˙ˇÒ 4ˇˇ≤  C˙˛ !¿˛ˇ ≈˝  ≠Ûˇ ˚ ˙ˇ ô¸ˇ0 Lˆˇ Î˝ˇ 4˝ˇn 	¯ˇ >˝  `˝ˇÏ œˇÅˇÅˇÅˇÅˇÒ  V˙ ˛ˇ ª¯  ¿˚ˇ 	¯ CV˘  ª˙ˇÒ 4ˇˇ≤  C˙˛ !¿˛ˇ ≈˝  ≠Ûˇ ˚ ˙ˇ ô¸ˇ0 Lˆˇ Î˝ˇ 4˝ˇn 	¯ˇ >˝  `˝ˇÏ –ˇÅˇÅˇ ˇÅˇÅˇÒ ãû¸  Å¸ˇ +˙ Q¸ˇ ÿÎ ˙ˇÚ ˛ˇ˙  ≤˝ˇ˝  Åˇıne”ıˇH  >Òˇ n˛ˇÊ ô˙ˇ [¸  ‚˚ˇÌ  ≠–ˇÅˇÅˇÅˇÅˇÒ ãû¸  Å¸ˇ +˙ Q¸ˇ ÿÎ ˙ˇÚ ˛ˇ˙  ≤˝ˇ˝  Åˇıne”ıˇH  >Òˇ n˛ˇÊ ô˙ˇ [¸  ‚˚ˇÌ  ≠–ˇÅˇÅˇÅˇÅˇÒ ãû¸  Å¸ˇ +˙ Q¸ˇ ÿÎ ˙ˇÚ ˛ˇ˙  ≤˝ˇ˝  Åˇıne”ıˇH  >Òˇ n˛ˇÊ ô˙ˇ [¸  ‚˚ˇÌ  ≠—ˇÅˇÅˇ ˆÇˇÅˇ ôË ˚ˇˆ Lê˛ˇ 0Ï ˚ˇ ∂Û ˇˇ˘ >+!¸  ∂‚ˇ ª˝ ¸ˇHQ˜ˇ>  ˝ˇ ˙ˇ C¸  ¿˙ˇÌ  0“ˇÅˇÅˇÅˇÅˇ ôË ˚ˇˆ Lê˛ˇ 0Ï ˚ˇ ∂Û ˇˇ˘ >+!¸  ∂‚ˇ ª˝ ¸ˇHQ˜ˇ>  ˝ˇ ˙ˇ C¸  ¿˙ˇÌ  0“ˇÅˇÅˇÅˇÅˇ ôË ˚ˇˆ Lê˛ˇ 0Ï ˚ˇ ∂Û ˇˇ˘ >+!¸  ∂‚ˇ ª˝ ¸ˇHQ˜ˇ>  ˝ˇ ˙ˇ C¸  ¿˙ˇÌ  0—ˇÅˇÅˇ €ÉˇÅˇÁ  £˚ˇ ≈ı  ˛ˇ QÏ ˚ˇ ªÙ ÊˇQÒ ‚ˇ £˝ ˚ˇª ˜ˇ  ˝ˇ ı˚ˇ  ¸  s˘ˇÏ ”ˇÅˇÅˇÅˇÅˇÁ  £˚ˇ ≈ı  ˛ˇ QÏ ˚ˇ ªÙ ÊˇQÒ ‚ˇ £˝ ˚ˇª ˜ˇ  ˝ˇ ı˚ˇ  ¸  s˘ˇÏ ”ˇÅˇÅˇÅˇÅˇÁ  £˚ˇ ≈ı  ˛ˇ QÏ ˚ˇ ªÙ ÊˇQÒ ‚ˇ £˝ ˚ˇª ˜ˇ  ˝ˇ ı˚ˇ  ¸  s˘ˇÏ —ˇÅˇÅˇ ’ÖˇÅˇ sÊ ˇˇ˛ ãˇHÙ ªˇˇ&Ï ˘ˇı }ˇˇÒ „ˇ¸ ÓˇÎ ˜ˇ [˚  ≈˘ˇ˛  ˇÒ   ÷ˇÅˇÅˇÅˇÅˇ sÊ ˇˇ˛ ãˇHÙ ªˇˇ&Ï ˘ˇı }ˇˇÒ „ˇ¸ ÓˇÎ ˜ˇ [˚  ≈˘ˇ˛  ˇÒ   ÷˛/huhˇ˛.warehousesupplierˇ˛/.warehousesupplierˇ˛Generate New POˇlocal wasWindow

wasWindow = info("windowname")

openfile "NewSupplier"
openfile "44ogscomments.warehouse"

window wasWindow

openform "Generate-POnew"
˛/Generate New POˇ˛FY44 Pounds Soldˇlocal tempvariable, totalvariable
gettext "What item number? XXXX", tempvariable
Select «Item» contains tempvariable
Field sparemoney3
FormulaFill «ActWt»*«44sold»
Total
lastrecord
totalvariable=sparemoney3
removeallsummaries
message "in FY44 we've sold "+str(totalvariable)+" pounds so far"

;This is for automatically calculating how many total pounds we sold FY44 of a product 8/4/21 RM

˛/FY44 Pounds Soldˇ˛.mixrepackˇglobal vIngredient1, vIngredient1,vIngredient2,vIngredient3,vIngredient4,vIngredient5,vIngredient6,vIngredient7,vIngredient8,vIngredient9,vIngredient10,vIngredient11,
vIngredient12,vIngredient13,vIngredient14,vIngredient15,vIngredient16,vIngredient17, vPercentage1, vPercentage2, vPercentage3, vPercentage4, vPercentage5, vPercentage6, vPercentage7, vPercentage8, 
vPercentage9, vPercentage10, vPercentage11, vPercentage12, vPercentage13, vPercentage14, vPercentage15, vPercentage16, vPercentage17

openfile "Mixes"

select str(«Mix Parent Code») contains left(vItem, 4)

vIngredient1 = «Ingredient 1 Item»
vPercentage1 = «Ingredient 1 Percentage»
vIngredient2 = «Ingredient 2 Item»
vPercentage2 = «Ingredient 2 Percentage»
vIngredient3 = «Ingredient 3 Item»
vPercentage3 = «Ingredient 3 Percentage»
vIngredient4 = «Ingredient 4 Item»
vPercentage4 = «Ingredient 4 Percentage»
vIngredient5 = «Ingredient 5 Item»
vPercentage5 = «Ingredient 5 Percentage»
vIngredient6 = «Ingredient 6 Item»
vPercentage6 = «Ingredient 6 Percentage»
vIngredient7 = «Ingredient 7 Item»
vPercentage7 = «Ingredient 7 Percentage»
vIngredient8 = «Ingredient 8 Item»
vPercentage8 = «Ingredient 8 Percentage»
vIngredient9 = «Ingredient 9 Item»
vPercentage9 = «Ingredient 9 Percentage»
vIngredient10 = «Ingredient 10 Item»
vPercentage10 = «Ingredient 10 Percentage»
vIngredient11= «Ingredient 11 Item»
vPercentage11 = «Ingredient 11 Percentage»
vIngredient12= «Ingredient 12 Item»
vPercentage12 = «Ingredient 12 Percentage»
vIngredient13 = «Ingredient 13 Item»
vPercentage13= «Ingredient 13 Percentage»
vIngredient14 = «Ingredient 14 Item»
vPercentage14 = «Ingredient 14 Percentage»
vIngredient15 = «Ingredient 15 Item»
vPercentage15 = «Ingredient 15 Percentage»
vIngredient16 = «Ingredient 16 Item»
vPercentage16 = «Ingredient 16 Percentage»
vIngredient17 = «Ingredient 17 Item»
vPercentage17 = «Ingredient 17 Percentage»

˛/.mixrepackˇ˛.showtallyordersˇglobal vItem

vItem = Item

message vItem

////Select items in tally that contain vItem

Openfile "44ogstally"

Select «Order» contains str(vItem) and sizeof("Status") = 0˛/.showtallyordersˇ˛.kitrepackˇ///This Macro creates variables based on the kit that will be made. Each ingredient receives its own variable along with the number of ingredients needed for that kit.
///The variables are then used in the kit repack form in the repack database.

global vIngredient1, vIngredient1,vIngredient2,vIngredient3,vIngredient4,vIngredient5,vIngredient6,vIngredient7,vIngredient8,vIngredient9,vIngredient10,vIngredient11,
vIngredient12,vIngredient13,vIngredient14,vIngredient15,vIngredient16,vIngredient17, vPercentage1, vPercentage2, vPercentage3, vPercentage4, vPercentage5, vPercentage6, vPercentage7, vPercentage8, 
vPercentage9, vPercentage10, vPercentage11, vPercentage12, vPercentage13, vPercentage14

openfile "Kits"

select str(«Kit Item») contains vItem

vIngredient1 = «Ingredient 1 Item»
message vIngredient1
vPercentage1 = «Amt of Ingredient 1»
vIngredient2 = «Ingredient 2 Item»
vPercentage2 = «Amt of Ingredient 2»
vIngredient3 = «Ingredient 3 Item»
vPercentage3 = «Amt of Ingredient 3»
vIngredient4 = «Ingredient 4 Item»
vPercentage4 = «Amt of Ingredient 4»
vIngredient5 = «Ingredient 5 Item»
vPercentage5 = «Amt of Ingredient 5»
vIngredient6 = «Ingredient 6 Item»
vPercentage6 = «Amt of Ingredient 6»
vIngredient7 = «Ingredient 7 Item»
vPercentage7 = «Amt of Ingredient 7»
vIngredient8 = «Ingredient 8 Item»
vPercentage8 = «Amt of Ingredient 8»
vIngredient9 = «Ingredient 9 Item»
vPercentage9 = «Amt of Ingredient 9»
vIngredient10 = «Ingredient 10 Item»
vPercentage10 = «Amt of Ingredient 10»
vIngredient11= «Ingredient 11 Item»
vPercentage11 = «Amt of Ingredient 11»
vIngredient12= «Ingredient 12 Item»
vPercentage12 = «Amt of Ingredient 12»
vIngredient13 = «Ingredient 13 Item»
vPercentage13= «Amt of Ingredient 13»
vIngredient14 = «Ingredient 14 Item»
vPercentage14 = «Amt of Ingredient 14»


˛/.kitrepackˇ˛LunarTestPOFormˇ˛/LunarTestPOFormˇ˛GetSourceˇlocal Dictionary, ProcedureList
//this saves your procedures into a variable
//step one
saveallprocedures "", Dictionary
clipboard()=Dictionary
//now you can paste those into a text editor and make your changes
STOP
˛/GetSourceˇ