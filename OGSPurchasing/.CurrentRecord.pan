global polist, po_number, one_less, one_more, max_po, position, keydown_parameter

//using the PONav macro as a base and adding an if to see if I can get an array to load when it's not loading
if info("Formname")="Entry" 

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
select PO = po_number

endif