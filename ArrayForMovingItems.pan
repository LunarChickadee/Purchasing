global ItemArray, arraychoice, counter

counter=1

loop
window "NewSupplier2.0"


arraychoice=
SupplierIDNumber+¬+
"SupplierProductID"+str(counter)+¬+
SupplierDescription+counter+¬+
OurProductID+counter+¬+
Item+counter+¬+
Description+counter+¬+
Unit+counter+¬+
LotSize+counter+¬+
LotCost+counter+¬+
Intrucking+counter+¬+
IntruckingEA+counter+¬+
UnitPrice+counter+¬+
cost+counter+¬+
PriceUpdateDate+counter

arraylinebuild ItemArray,¬,"",arraychoice

Window "SupplierInventories2.0"
addrecord
SupplierIDNum=val(array(ItemArray,1,¬))







