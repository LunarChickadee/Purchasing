global ordersize, export, given, pon, suppinfo, intorder, progress, poitemarray
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
