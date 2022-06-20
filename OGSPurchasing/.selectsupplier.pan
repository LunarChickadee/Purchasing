global forordering, itemlist, disorder, seconditemlist
superobject "fromsupplier", "Open"
activesuperobject "Clear"
activesuperobject "Close"
forordering=forordering
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

superobject "neworder", "FillList"