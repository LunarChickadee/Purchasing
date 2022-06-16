
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

message "Done!!"
;gototal=Total
;openfile "44OGSinvoices"
;select PO=po

;«Exp PO total»=gototal
;selectall
;save