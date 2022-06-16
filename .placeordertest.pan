global orderline, orderquantity, test2, intorder, ordersize
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
