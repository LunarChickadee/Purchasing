local sumqty

//updated 6-22 by lunar for PO entry error
if info("formname") contains "Entry"
stop
endif
//endupdate

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

Itemshipping=divzero(Shipping,sumqty)