˛createlineitemsˇlocal n
n=1
loop
addfield "SupplierProductID"+str(n)
addfield "SupplierDescription"+str(n)
addfield "OurProductID"+str(n)
addfield "Description"+str(n)
addfield "Unit"+str(n)
addfield "LotSize"+str(n)
addfield "LotCost"+str(n)
addfield "Intrucking"+str(n)
addfield "IntruckingEA"+str(n)
addfield "UnitPrice"+str(n)
addfield "BasePrice"+str(n)
addfield "PriceUpdateDate"+str(n)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
n=n+1
until n=36
˛/createlineitemsˇ˛.Inititalizeˇfileglobal varship
window "NewSupplier"
windowbox "120 70 280 440"

field "Supplier"
sortup

openform "Supplier"

if info("formname")=Supplier
drawobjects
endif


˛/.Inititalizeˇ˛.findsupplierˇfind Supplier=findsupplier˛/.findsupplierˇ˛.shipping_costˇcase info("trigger")="Button.Dollar"
IntruckingΩ=LotCostΩ*varship
UnitPriceΩ=(LotCostΩ+IntruckingΩ)/LotSizeΩ
case info("trigger")="Button.ByPiece"
IntruckingΩ=varship
UnitPriceΩ=(LotCostΩ+IntruckingΩ)/LotSizeΩ
case info("trigger")="Button.NoShipping"
IntruckingΩ=0
UnitPriceΩ=(LotCostΩ+IntruckingΩ)/LotSizeΩ

endcase
save˛/.shipping_costˇ˛changenameˇlocal newfield
newfield=""
loop
loop
right 
until info("fieldname") contains "BasePrice"
newfield=info("fieldname")
fieldname replace(newfield,"BasePrice","37cost")
stoploopif info("fieldname") contains "35"
while forever˛/changenameˇ˛fillitemˇglobal n, idfield,itemfield
n=5
field «Item1»
loop
loop
idfield="OurProductID"+str(n)
itemfield="Item"+str(n)
right
until info("fieldname")="Item"+str(n)
formulafill
lookup("38ogscomments.linked","IDNumber",datavalue(idfield), "Item", "",0)
n=n+1
stoploopif n=36
while forever
˛/fillitemˇ˛.updatecostsˇ˛/.updatecostsˇ˛gotosupplier/1ˇlocal suppa
gettext "Which Supplier?",suppa
if striptoalpha(suppa)=""
find SupplierIDNumber=val(suppa)
else
find Supplier contains suppa
endif˛/gotosupplier/1ˇ˛findanitem/2ˇlocal thing
gettext "Which Item",thing
find lineitemarray("DescriptionΩ",",") contains thing˛/findanitem/2ˇ˛fix itemsˇfirstrecord
loop
;case val(striptonum(ItemΩ))=0
;downrecord
case val(striptonum(ItemΩ))>10000
«ItemΩ»=lookup("40ogscomments.warehouse","IDNumber",«OurProductIDΩ»,"Item","",0)
downrecord
defaultcase
«ItemΩ»=lookup("40ogscomments-newnumbers","IDNumber",«OurProductIDΩ»,"Item","",0)
downrecord
endcase
until info("stopped")
˛/fix itemsˇ˛Archive Selected Supplierˇokcancel "Careful! Make sure you have only the items you want appended selected. Continue?"
    if clipboard() = "Cancel"
        stop
    endif
 openfile "NewSupplier.archive"
 openfile "++NewSupplier" 
 window "NewSupplier"

;Delete appended records from NewSupplier

noyes "Do you wish to delete appended items?"  

if clipboard() = "Yes"
   Loop
   Lastrecord
   Deleterecord
   until info("selected") = 1
endif˛/Archive Selected Supplierˇ˛GetSourceˇlocal Dictionary, ProcedureList
//this saves your procedures into a variable
//step one
saveallprocedures "", Dictionary
clipboard()=Dictionary
//now you can paste those into a text editor and make your changes
STOP˛/GetSourceˇ