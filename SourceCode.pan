˛.InitializeˇPermanent vpo, session
global wt, polist, vreceiver, addship
addship=0
wt=0
polist=""
selectall
Field PO sortup
goform "Entry"
;openfile "44OGSinvoices"
Message "Done"˛/.Initializeˇ˛.openPOˇLocal given 
OpenForm "Entry"
selectall
field PO sortdown
firstrecord
given=PO
AddLine
PO=given+1
«PO Line No»=1
Date=today()˛/.openPOˇ˛ctrladdtopoˇLocal selecter
selectall
selecter=info("selected")
getscrap "What PO# would you like to add to. To search by supplier, leave blank."

if clipboard()=""
    getscrap "What supplier are you looking for???"
    select Company contains Clipboard()
else
    select PO = val(clipboard())
endif

if info("selected")=selecter
    message "Search failed. Try again."
    stop 
endif

goform "Entry"
call .additem



˛/ctrladdtopoˇ˛.additemˇlocal fuzz
;message "yo"


fuzz=PO
select PO=fuzz




AddRecord
UpRecord
field PO
CopyCell
DownRecord
PasteCell

UpRecord
field Company
CopyCell
DownRecord
PasteCell
UpRecord

field Contact
CopyCell
DownRecord
PasteCell
UpRecord

field Fax
CopyCell
DownRecord
PasteCell
UpRecord

field Email
CopyCell
DownRecord
PasteCell
UpRecord

field Phone
CopyCell
DownRecord
PasteCell
UpRecord

field Address
CopyCell
DownRecord
PasteCell
UpRecord

field City
CopyCell
DownRecord
PasteCell
UpRecord

field State
CopyCell
;message clipboard()
DownRecord
PasteCell
UpRecord

field Zip
CopyCell
DownRecord
PasteCell
UpRecord

field Date
CopyCell
DownRecord
PasteCell
UpRecord

;field SentDate
;CopyCell
;DownRecord
;PasteCell
;UpRecord

field «PO Line No»
CopyCell
DownRecord
PasteCell
UpRecord

field «PO Line No»
CopyCell
DownRecord
PasteCell
«PO Line No»=«PO Line No»+1

Date=today()
Time=str(now())
save
field «Product No»˛/.additemˇ˛.checkˇItem=?(striptonum(Item)="0","9999-A",Item)˛/.checkˇ˛.uprecˇlocal jib

jib=«PO Line No»

UpRecord

if jib=«PO Line No»
    message "No more this way."
endif
˛/.uprecˇ˛.downrecˇlocal jib

jib=«PO Line No»

DownRecord

if jib=«PO Line No»
    message "No more this way."
endif
˛/.downrecˇ˛.cutˇyesno "You want to drop this item from the order?"
if clipboard() contains "n"
    stop
else
DeleteRecord

endif
save˛/.cutˇ˛setreceiverˇvreceiver=Receiver˛/setreceiverˇ˛.gorecˇsave
goform "Receiving"˛/.gorecˇ˛.goentˇ
save
goform "Entry"˛/.goentˇ˛.completeˇsave
goform "Control"
Message "PO Received"
˛/.completeˇ˛.checkpoˇgetscrap "What's the PO number?"
select PO =val(clipboard())
goform "Entry"˛/.checkpoˇ˛.closewindowˇfield PO
sortup
lastrecord
save˛/.closewindowˇ˛.receivedˇglobal waswindow, $Shipping, ItemCount, PieceCount, wgh, inv, wt, itemfind, suppliername, newcost, itemsoffered, raymond, idfind, polines, alsodowarehouse, po, already, originalPOqty
local a, b, c, d, stopper, n, m
waswindow=info("windowname")
already=0
originalPOqty=0
newcost=0
itemsoffered=""
raymond=0
already=0
suppliername=""
stopper=0
n=0
m=1
itemfind=0
idfind=0
po=PO
select PO=po
polines=info("selected") ;; number of items on the PO
alsodowarehouse=0

call .QtyCheck

;*******************************************************************************************************************************************
;This macro functions when the PO is received it checks for errors in the order and updates the inventoy and contact info previous pricing last PO rec'd etc.
;*******************************************************************************************************************************************
;We start by checking to see if this has already recieved
window waswindow
    field ListQty
    copycell 
    pastecell
    already=Qty
    if ReceivedDate>0
        ;stop
        ;message "It seems that this order has already been received."
        ;if addship≠0
        ;    goto ahead
        ;endif
        Yesno "Would you like to edit this PO?"
       
        if clipboard()≠"Yes"
            stop
        else
            stopper=1
            openfile "44ogscomments.linked"
            showallfields
            gosheet
           
            select IDNumber=lookupselected("44OGSpurchasing","IDNumber",IDNumber,"IDNumber",0,0)
            b=info("selected")
           
            if  info("empty") OR info("selected") <> polines
                ;; then we need to also look in ogscomments.warehouse
                alsodowarehouse=1
            endif
           
            updateinventory:
           
            firstrecord
            field
            «On Order»
            n=info("selected")
            loop
                ;if «On Order»=already 
                    ;message "This item seems to have been fully received."
                    Yesno "Do you want to edit the purchased numbers for "+Description+"?"
                    if Clipboard()="Yes"
                         ;goto nohead
                         ;downrecord
                    ;else
                        ;;goto behead
                        ;Yesno "Would you like to change "+Description+"'s amount rec'd?"
                        ;if clipboard()="Yes"
                            getscrap "How many came in? (enter additional received qty.) Write a negative number to un-receive."
                            a=val(clipboard())
                            itemfind=Item
                            idfind=IDNumber
                            window waswindow
                            if idfind=0
                                find Item=itemfind
                            else
                                find IDNumber=idfind
                            endif
                            Received=Received+a
                          
                            window "44ogscomments.linked"
                       
                            «Purchased»=«Purchased»+val(clipboard())
                            field «Purchased»
                            copy
                            paste
                            if a=0
                                message "None came in? What are we doing??"
                                stop
                            endif
                            if a≠0
                                «On Order»=«On Order»-a
                            endif
                              if «On Order»>0
                                noyes "Is this Item still on order?"
                                if clipboard()="No"
                                    «On Order»=0
                                    message "On Order has been set to 0"
                                endif
                            ;endif
                      
                            ;message "You have just changed the inventory. You should check and be sure you're happy with numbers in the comments file."
                    
                        endif
                    endif
                
                ;endif
 
                downrecord
                m=m+1
                  
            stoploopif m>n
            while forever
            ;stoploopif m>n
         
         
         
         
          
            if alsodowarehouse=1
            ;message "open sesame"
                stopper=1 ;;???
                ;openfile "44ogscomments.warehouse"
                openfile "44ogscomments.warehouse"
                gosheet
           
                select IDNumber=lookupselected("44OGSpurchasing","IDNumber",IDNumber,"IDNumber",0,0)
                alsodowarehouse=0
                if  info("empty")
               
               
               
               
               
                else
                    goto updateinventory
                endif
               
            endif
          
        endif
    endif
    if stopper=1
    message "that's that!"
    stop
    endif
   
 window waswindow
if wt=0
    Message "Select a shipping cost allocation method. WT. or Item or Cost"
    stop
endif
local po
po=PO
select PO=po
noyes "Is there tax?"

if clipboard() contains "Y"
    ;call .additem
    ;Description="Tax"
    getscrap "How much was the tax?"
    Tax=val(clipboard())
    if Tax=0
    message "Tax Price Failed."
    endif
    Field
    Tax
    call .ordernotes
endif
;*******************************************************************************************************************************************
loop

    If Price=0
        getscrap "Whats the price of "+Description+"?"
        Price=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif
    If BaseUnit=0
        getscrap "Whats the base unit (items per case) for "+Description+"?"
        BaseUnit=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif
    If Qty=0
        getscrap "How many "+Description+" did you order to begin with?"
        Qty=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif
    If Received=0
        getscrap "How many "+Description+" arrived?"
        Received=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif
    downrecord
until info("stopped")
;Repeats one more time to get that last record the loop stops at.
    If Price=0
        getscrap "Whats the price of "+Description+"?"
        Price=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif
    If BaseUnit=0
        getscrap "Whats the base unit (items per case) for "+Description+"?"
        BaseUnit=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif
    If Qty=0
        getscrap "How many "+Description+" did you order to begin with?"
        Qty=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif
    If Received=0
        getscrap "How many "+Description+" arrived?"
        Received=Val(clipboard())
        If error
            beep
            message "Not a valid entry."
            stop
        endif
    endif

inv=Received*BaseUnit

call .shipping

ReceivedDate=today()
Field ReceivedDate
propagateUP

                                                       ;  Heads over to Comments file to check ordered against received and update the inventory and other information.
;*******************************************************************************************************************************************

if stopper=1
    ;; we've already updated warehouse comments--skip this section
    goto ahead
endif

idfind=IDNumber

openfile "44ogscomments.linked"
gosheet
if idfind=0
    select Item=lookupselected("44OGSpurchasing","Item",Item,"Item",0,0)
else
    select IDNumber=lookupselected("44OGSpurchasing","IDNumber",IDNumber,"IDNumber",0,0)
endif

if  info("empty") OR info("selected") <> polines
    ;; then we need to also look in ogscomments.warehouse
    alsodowarehouse=1
else
    alsodowarehouse=0
;endif

;++++++++++++++++++++++++updateinventory2:+++++++++++++++++++++++++++++++++++++
updateinventory2:

Field
«Purchased»
if idfind=0
    formulafill ?(«Purchased»=0,lookupselected("44OGSpurchasing","Item",Item,"Received",0,0),datavalue(«Purchased»)+lookupselected("44OGSpurchasing","Item",Item,"Received",0,0))
else
    formulafill ?(«Purchased»=0,lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0),datavalue(«Purchased»)+lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0))
endif

firstrecord
loop
copy
paste
downrecord
until info("stopped")

;message "jhgjh"


Field
«On Order»
if idfind=0
    formulafill ?(lookupselected("44OGSpurchasing","Item",Item,"Received",0,0)≥«On Order»,0,datavalue(«On Order»)-lookupselected("44OGSpurchasing","Item",Item,"Received",0,0))
else
    formulafill ?(lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0)≥«On Order»,0,datavalue(«On Order»)-lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0))
endif

find «On Order»≠0

;This loop checks if the order was filled as anticipated and if not asks if the undelivered portion is still pending arrival. Hopefully this works as we intend.
loop
   Field
   «On Order»
    if «On Order»=0
        DownRecord
    else
        Noyes "Is this item "+Description+" "+str(«Sz.»)+" still on order???"
        if clipboard() contains "n"
       «On Order»=0
        endif
        downrecord
    endif
until info("stopped")


;This loop checks if the items received have B/O or O/S in the comments field and cleans the comments out.
loop
field
Comments
if Comments notcontains "dropship"
clearcell
 endif
 downrecord
 until info("stopped")
 

 

;*******************************************************************************************************************************************
; Repeats to catch that last record the loop stops at.
;*******************************************************************************************************************************************

Field
«On Order»
if «On Order»=0
    DownRecord
else
Noyes "Is this item "+Description+" "+str(«Sz.»)+" still pending???"
   if clipboard() contains "n"
   «On Order»=0
   endif
endif
; ***************************************************************************************************

     field
    Comments
    if Comments notcontains "dropship"
      clearcell
       endif
  ;***************************************************************************************************

 endif

if alsodowarehouse=1
message "alsodowarehouse=1"
    openfile "44ogscomments.warehouse"
    gosheet
    message "open sesame open"
    if idfind=0
        select Item=lookupselected("44OGSpurchasing","Item",Item,"Item",0,0)
    else
        select IDNumber=lookupselected("44OGSpurchasing","IDNumber",IDNumber,"IDNumber",0,0)
    endif
   
    alsodowarehouse=0
    if info("empty")
    else
      
        ;+++++++++++++++++++                     +++++++++++++++++++++++++++
;===========       
Field
«Purchased»
if idfind=0
    formulafill ?(«Purchased»=0,lookupselected("44OGSpurchasing","Item",Item,"Received",0,0),datavalue(«Purchased»)+lookupselected("44OGSpurchasing","Item",Item,"Received",0,0))
else
    formulafill ?(«Purchased»=0,lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0),datavalue(«Purchased»)+lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0))
endif

firstrecord
loop
copy
paste
downrecord
until info("stopped")

;message "jhgjh"


Field
«On Order»
if idfind=0
    formulafill ?(lookupselected("44OGSpurchasing","Item",Item,"Received",0,0)≥«On Order»,0,datavalue(«On Order»)-lookupselected("44OGSpurchasing","Item",Item,"Received",0,0))
else
    formulafill ?(lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0)≥«On Order»,0,datavalue(«On Order»)-lookupselected("44OGSpurchasing","IDNumber",IDNumber,"Received",0,0))
endif

find «On Order»≠0

;This loop checks if the order was filled as anticipated and if not asks if the undelivered portion is still pending arrival. Hopefully this works as we intend.
loop
   Field
   «On Order»
    if «On Order»=0
        DownRecord
    else
        Noyes "Is this item "+Description+" "+str(«Sz.»)+" still pending???"
        if clipboard() contains "n"
       «On Order»=0
        endif
        downrecord
    endif
until info("stopped")
;===========
    endif
endif

;*******************************************************************************************************************************************
;This is where the macro fills the comments file with the last price we paid, the last PO rec'd, the date it was rec'd and fills in any contact changes you have made.
;*******************************************************************************************************************************************
selectall

window waswindow
;message "go fill.."
;call ".fillnewcost"
;message "filled.."


;*******************************************************************************************************************************************
;We head back to the purchasing DB
;*******************************************************************************************************************************************
window waswindow
ahead:

$Shipping=Shipping

Field
«PO Line No»
lastrecord
ItemCount=«PO Line No»
;message ItemCount

Field
ListQty
firstrecord
loop
    copy
    paste
    downrecord
until info("stopped")

Field
CostPerUnit
firstrecord
loop
    copy
    paste
    downrecord
until info("stopped")

Field
Itemtotal
firstrecord
loop
    copy
    paste
    downrecord
until info("stopped")

call .total
;*******************************************************************************************************************************************
;This next little ditty is to check the way you allocate the shipping costs to items in the order.
;*******************************************************************************************************************************************
if wt=1
    Field
    Costshipping
    firstrecord
    loop
    Costshipping=divzero(«$Shipping»,ItemCount)
    downrecord
    until info("stopped")
    Field
    Itemshipping
    firstrecord
    loop
    Itemshipping=divzero(Costshipping,ListQty)
    copycell
    pastecell
    downrecord
    until info("stopped")
endif

if wt=2
    Field
    Costshipping
    firstrecord
    loop
    wgh=divzero(«ItemWt.»,«Total Wt.»)
    Costshipping=«$Shipping»*wgh
    downrecord
    until info("stopped")
    Field
    Itemshipping
    firstrecord
    loop
    Itemshipping=divzero(Costshipping,ListQty)
    copycell
    pastecell
    downrecord
    until info("stopped")
endif

if wt=3
    Field
    Costshipping
    firstrecord
    loop
    wgh=divzero(Itemtotal,Subtotal)
    Costshipping=«$Shipping»*wgh
    downrecord
    until info("stopped")
    Field
    Itemshipping
    firstrecord
    loop
    Itemshipping=divzero(Costshipping,ListQty)
    copycell
    pastecell
    downrecord
    until info("stopped")
endif
addship=0
save



˛/.receivedˇ˛.shippingˇif «Shipping»=0

    getscrap "What is the shipping cost for this PO?"
    Field 
    «Shipping»
    formulafill 
    val(clipboard())
endif
˛/.shippingˇ˛CreatePOˇGlobal pobuild
pobuild=""

field
Itemtotal
firstrecord
loop
    cut
    paste
    downrecord
until info("stopped")

arrayselectedbuild pobuild,¬,""," "+str(«PO Line No»)+"   "+rep(chr(32),6-length(Item))+Item+"   "+rep(chr(32),31-length(Description[1,30]))+
     Description[1,30]+" "+rep(chr(32),5-length(str(Qty)))+str(Qty)+"     "+rep(chr(32),7-length(str(Price)))+str(Price)+" "+rep(chr(32),12-length(str(Itemtotal)))+str(Itemtotal)+¶

pobuild=" "+pobuild
tallmessage pobuild
object "POBUILD"˛/CreatePOˇ˛.totalˇif info("trigger")="Button.Total"
    if Shipping=0
        Noyes "Do you know the shipping costs???"
        if clipboard() contains "Y"
            call .shipping
        endif
    endif
endif
local po 
po=PO
select PO=po
;*******************************************************************************************************************************************
Firstrecord
Field Itemtotal
loop
    cut
    paste
    downrecord
until info("stopped")
Total
copy

Field
Subtotal
formulafill val(clipboard())
cutrecord

Field
«Total»
formulafill Subtotal+Shipping+Tax-discount

Firstrecord
Field
BaseUnit
loop
    cut
    paste
    downrecord
until info("stopped")

Firstrecord
Field 
Qty
loop
    cut
    paste
    downrecord
until info("stopped")
;message "before"
;call .selectpo          


˛/.totalˇ˛Gatherˇ
global po, gototal
if info("selected")= info("Records") 
    message "select your PO"
    stop 
endif

field Qty
firstrecord
loop
    cut 
    paste
    downrecord 
until info("stopped")
clipboard()=""
po=PO

field
«ItemWt.»
Total
CopyCell

field
«Total Wt.»
message "Wt: "+str(clipboard())
fill val(clipboard())
DeleteRecord
Yesno "Do you have the pricing information for the products you ordered???"
if clipboard() contains "Y"
    firstrecord
    loop
        If Price=0
            getscrap "Whats the price of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
            Price=Val(clipboard())
            If Price=0
                beep
                   Noyes "Are you sure you don't have the price of "+«Item»+"  "+Description+"  "+str(«ListWt.»)
                   if clipboard() contains "No"
                   getscrap "Whats the price of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
                   Price=Val(clipboard())
                   endif 
                ;stop
            endif
        endif
        If BaseUnit=0
            getscrap "Whats the base unit (items/case)of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
            BaseUnit=Val(clipboard())
            If BaseUnit=0
                beep
                message "Not a valid entry.Try a number, higher than zero!"
                getscrap "Whats the base unit (items/case)of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
                BaseUnit=Val(clipboard())
                ;stop
            endif
        endif
        If Qty=0
            getscrap "Whats the order Qty of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
            Qty=Val(clipboard())
            If Qty=0
                beep
                message "Not a valid entry. Surely you want to order more than Zero?!"
                getscrap "Whats the order Qty of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
                Qty=Val(clipboard())
                ;stop
            endif
          endif
     else
     stop
        endif
                downrecord
    until info("EOF")
    
    ;Repeats one more time to get that last record the loop stops at.
    
    If Price=0
        getscrap "Whats the price of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
        Price=Val(clipboard())
        If Price=0
            beep
            Noyes "Are you sure you don't have the price of "+«Item»+"  "+Description+"  "+str(«ListWt.»)
            if clipboard() contains "No"
            getscrap "Whats the price of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
            Price=Val(clipboard())
            endif 
            ;stop
      endif
    endif
    If BaseUnit=0
        getscrap "Whats the base unit (items/case)of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
        BaseUnit=Val(clipboard())
        If BaseUnit=0
            beep
            message "Not a valid entry.Try a number, higher than zero!"
                getscrap "Whats the base unit (items/case)of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
                BaseUnit=Val(clipboard())
            ;stop
       endif
    endif
    If Qty=0
        getscrap "Whats the order Qty of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
        Qty=Val(clipboard())
        If Qty=0
            beep
             message "Not a valid entry. Surely you want to order more than Zero?!"
                getscrap "Whats the Qty of "+«Item»+"  "+Description+"  "+str(«ListWt.»)+"#'s"
                Qty=Val(clipboard())
            ;stop
        endif

endif
;message "hobo"
call .total

message "nogo"
;gototal=Total
;openfile "44OGSinvoices"
;select PO=po

;«Exp PO total»=gototal
;selectall
;save˛/Gatherˇ˛POnavˇglobal polist, po_number, one_less, one_more, max_po, position, keydown_parameter

;;; check to see whether a parameter ("left" or "right") was passed
;;; from .KeyDown due to user pressing left or right arrow 

keydown_parameter = parameter(1)
if error
    keydown_parameter = ""
endif
     
;;; check which button was pressed: Select, Next, or Prev. PO

case info("trigger")="Button.Select PO"
    po_number = PO
    select PO = po_number

case info("trigger")="Button.NextPO" or keydown_parameter="right"
    po_number = PO
    one_more = po_number+1
    select PO = one_more
    
    ;;; following statements are intended to deal with the
    ;;; case in which there is a break in the PO numbering
    if PO=po_number
            selectall
            field PO
            sortup
            lastrecord
            max_po = PO 
            select PO = po_number
        loop
            one_more = one_more +1
            select PO = one_more
        ;;; following line prevents infinite loop by stopping
        ;;; when the last PO number is reached
        until PO > po_number or one_more >=max_po
    endif
    
case info("trigger")="Button.Prev.PO" or keydown_parameter="left"
    po_number = PO
    one_less = po_number-1
    select PO = one_less 
    if PO=po_number
       loop
          one_less = one_less - 1
          select PO = one_less
       until PO < po_number or one_less <=1
    endif
    
endcase  
  
polist=""
position=PO
    
case info("Formname")="Entry" or info("Formname")="PO"
  arrayselectedbuild polist,¬,"",?(PO=position," "+str(«PO Line No»)+rep(chr(32),16-length(str(«Product No»)[1,15]))+STR(«Product No»)[1,15]+"   "
  +rep(chr(32),31-length(Description[1,30]))+Description[1,30]
  +" "+rep(chr(32),5-length(str(Qty)))+str(Qty)+"    "+rep(chr(32),7-length(str(Price)))+"$"+str(Price)+"   "
  +rep(chr(32),10-length(str(Itemtotal)))+str(Itemtotal)+¶+rep(chr(32),200-length(Notes))+Notes+¶,"")

   polist=" "+polist+¶+"Purchase Order"+¶+str(PO)+"-Entry"
    ;message polist
case info("Formname")="POrec'd" or info("formname")="Receiving"
    arrayselectedbuild polist,¬,"",?(PO=position," "+str(«PO Line No»)+"   "+rep(chr(32),6-length(«Item»))+Item+"   "+rep(chr(32),31-length(«Cat.Description»[1,30]))+
    «Cat.Description»[1,30]+" "+rep(chr(32),5-length(str(Received)))+str(Received)+"    "+rep(chr(32),7-length(str(Price)))
    +str(Price)+"       "+rep(chr(32),12-length(str(Itemtotal)))+str(Itemtotal)+¶+rep(chr(32),82-length(Notes))+Notes+¶,"")

    polist=" "+polist+¶+"Purchase Order"+¶+str(PO)+"-Receiving" 
    
endcase

;;; these are the magic lines that make the items 
;;; show up when you go next or previous order
po_number = PO
select PO = po_number˛/POnavˇ˛.gopoˇgoform "PO"

˛/.gopoˇ˛.goporecˇgoform "POrec'd"˛/.goporecˇ˛.ordernotesˇlocal girls
copy
girls=PO
select PO=girls
fill clipboard()˛/.ordernotesˇ˛.searchpoˇLocal selecter
selectall
selecter=info("selected")

getscrap "What PO# would you like to add to. To search by supplier, leave blank."
if clipboard()=""
    getscrap "What supplier are you looking for???"
    select Company contains Clipboard()
else
    select PO = val(clipboard())
endif

if info("selected")=selecter
    message "Search failed. Try again."
    stop 
endif
˛/.searchpoˇ˛.blowmeˇlocal sporks, knives, spoons
spoons=PO
select PO=spoons

;for discounts that are a percent of the subtotal (ex.  10% discount!!!)

if info("trigger")="Button.discount by percent"
getscrap "What's the discount percentage (.1 for 10%)"
message clipboard()
;if val(clipboard())<1
sporks=val(clipboard())*.01
message sporks
;endif
field
disco
formulafill sporks
field
discount
formulafill Subtotal*disco
endif


;for fixed discounts (ex. $20 off!!!)

if info("trigger")="Button.absolute discount"
getscrap "what's the discount or coupon value DT?"
message clipboard()
knives=val(clipboard())

field
disco
formulafill knives
field
discount
formulafill disco
endif˛/.blowmeˇ˛whyˇdisco=100˛/whyˇ˛.lastˇlocal sprout
selectall
field PO
sortup
lastrecord
sprout=PO
select PO=sprout

˛/.lastˇ˛gogopoˇlocal gogopo
GetscrapOK "What's the PO# ?"
gogopo=val(clipboard())
Select PO=gogopo
˛/gogopoˇ˛.KeyDownˇ
local KeyStroke, po_number, one_more, max_po

KeyStroke=info("trigger")[5,-1] 
;;;;;;; New function... left and right arrows go to previous and next PO
case KeyStroke=chr(29)

        call POnav, "right"        
        
case KeyStroke=chr(28)

        call POnav, "left"
        
defaultcase
    key info("modifiers"),KeyStroke
endcase
˛/.KeyDownˇ˛PObyCompanyˇlocal lale
GetScrapOk "What's the Company Name?"
lale=clipboard()
Select Company contains lale
call POnav˛/PObyCompanyˇ˛AddShippingˇglobal addship
if info("trigger")="Button.Add Shipping"
if info("selected")= info("Records") 
    message "select your PO"
    stop 
endif    
if wt=0
    Message "Select a shipping cost allocation method. WT. or Item or Cost"
    stop
endif

   if Shipping≠0
   YesNo "This PO already has a shipping cost of "+str(Shipping)+". Do you want to change the shipping cost for this PO?"
         if Clipboard()="Yes"
         
         getscrap "What is the shipping cost for this PO?"
    Field 
    «Shipping»
    formulafill 
    val(clipboard())
    addship=1
         else
         stop
         endif
    else
   
    getscrap "What is the shipping cost for this PO?"
    Field 
    «Shipping»
    formulafill 
    val(clipboard())
    addship=1
    endif
endif         ˛/AddShippingˇ˛.itemship%ˇlocal sumqty
if info("selected")= info("Records") 
    message "select your PO"
    stop 
endif

field 
ListQty
total
copycell
sumqty=val(clipboard())
Removesummaries 7

Itemshipping=divzero(Shipping,sumqty)˛/.itemship%ˇ˛tabsdownˇfirstrecord
field Shipping
loop
CopyCell
PasteCell
downrecord
until info("stopped")˛/tabsdownˇ˛forcesynchronizeˇforcesynchronize
field
PO
sortup˛/forcesynchronizeˇ˛.fillnewcostˇ;message "here"

debug


suppliername=Company
firstrecord

openfile "NewSupplier"
find Supplier=suppliername
itemsoffered=lineitemarray("OurProductIDΩ", ¶)
displaydata itemsoffered
window waswindow 

loop
;message Item
raymond=arraysearch(itemsoffered, Item, 1, ¶)
message "raymond is " + str(raymond)
newcost=Price
window "NewSupplier"
clipboard()=newcost
message newcost
field ("cost"+str(raymond))
pastecell

;fill newcost

window waswindow
downrecord
until info("eof")

raymond=arraysearch(itemsoffered, Item, 1, ¶)
newcost=Price
window "NewSupplier"
clipboard()=newcost
field ("cost"+str(raymond))
pastecell
window waswindow


 
 
˛/.fillnewcostˇ˛testttˇglobal numb,
numb=4
window "NewSupplier"

field ("cost"+str(numb))˛/testttˇ˛dummyˇlocal ttt
message itemsoffered
ttt=arraysearch(itemsoffered, Item, 1, ¶)
message ttt˛/dummyˇ˛.gopo-2ˇgoform "PO-2"˛/.gopo-2ˇ˛PrintPOˇ
firstrecord
printonerecord dialog
if arraysize(polist,¬) >15
openform "PO-2"
message "Don't forget to print second page!"
printonerecord dialog
endif ˛/PrintPOˇ˛clear recdateˇlocal tallish
tallish=PO
select PO=tallish
firstrecord
loop

field ReceivedDate
ReceivedDate=0
downrecord
until stopped˛/clear recdateˇ˛.QtyCheckˇglobal vPermId, vCount, vRecords

yesno "Are you receiving a partially received PO?"
    if clipboard() = "No"
        vRecords=info("selected")
        vCount=1

        arrayselectedbuild vPermId, ¶,"",IDNumber
        if
            IDNumber < 800000
            window "44ogscomments.linked"
            selectall

            loop

            find extract(vPermId,¶,vCount) contains str(IDNumber)

                if «On Order»=0
                    message extract(vPermId,¶,vCount)+" does not have a qty on order. Stopped"
                    window waswindow    
                    stop
                endif
    
            vCount=vCount+1

            until vCount=vRecords+1

        else
            window "44ogscomments.warehouse"
            selectall

            loop

            find extract(vPermId,¶,vCount) contains str(IDNumber)

            if «On Order»=0
                    message extract(vPermId,¶,vCount)+" does not have a qty on order. Stopped"
                    window waswindow    
                    stop
            endif
    
    vCount=vCount+1

    until vCount=vRecords+1
    endif
endif




˛/.QtyCheckˇ˛Delete POˇGlobal vRecords, vCount
selectall
call gogopo


vRecords=info("selected")

noyes "Is this the PO you want to delete?"

if clipboard()="Yes"
    window "44ogscomments.linked"

    select lookupselected("44OGSpurchasing",IDNumber,IDNumber,IDNumber,0,0)
    
    
    field «On Order» 
    noyes "Is this the correct selection to clear?"
    if clipboard()="Yes"
        formulafill 0
    else
        stop
    endif

        
    window "44OGSpurchasing"
    lastrecord
    addrecord

    firstrecord
    vCount=0

    loop
        deleterecord
        vCount=vCount+1
    until vCount=vRecords

    selectall

    lastrecord
    Yesno "Delete Record?"
    if clipboard()="Yes"
        deleterecord
    endif
endif˛/Delete POˇ˛fieldnamesˇlocal Dictionary, ProcedureList
//this saves your procedures into a variable
//step one
saveallprocedures "", Dictionary
clipboard()=Dictionary
//now you can paste those into a text editor and make your changes
STOP
 
//step 2
//this lets you load your changes back in from an editor and put them in
//copy your changed full procedure list back to your clipboard
//now comment out from step one to step 2
//run the procedure one step at a time to load the new list on your clipboard back in
Dictionary=clipboard()
loadallprocedures Dictionary,ProcedureList
message ProcedureList //messages which procedures got changed˛/fieldnamesˇ˛.POrecalcˇlocal POnum1, vTotal

POnum1=0
vTotal=0


POnum1=«PO»
Select «PO»=POnum1

Field Itemtotal
    loop
    «Itemtotal»=float(«Qty»)*float(«Price»)
    downrecord
    until info("stopped")
Total
copy

Field
Subtotal
formulafill val(clipboard())
cutrecord

vTotal=float(«Subtotal»)+float(«Shipping»)+float(«Tax»)
Field «Total»
formulafill float(vTotal)

«Total»=float(Subtotal)+float(Shipping)+float(Tax)
˛/.POrecalcˇ˛.tabdownˇ;; a helper macro that triggers equations to recalculate

firstrecord
loop
Cell «»
downrecord
until info("stopped")˛/.tabdownˇ˛SourceGetˇlocal Dictionary, ProcedureList
//this saves your procedures into a variable
//step one
saveallprocedures "", Dictionary
clipboard()=Dictionary
//now you can paste those into a text editor and make your changes
STOP
˛/SourceGetˇ