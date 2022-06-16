if info("trigger")="Button.Total"
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
Field BaseUnit
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


