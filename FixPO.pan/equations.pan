

Item
.check

Qty
«ItemWt.»=?(Received=0,«ListWt.»*Qty,Received*«ListWt.»)


ListQty
ListQty=?(Received=0,Qty*BaseUnit,Received*BaseUnit)
Itemshipping=divzero(Costshipping,ListQty)
CostPerUnit=?(Received=0
,divzero(divzero(Itemtotal,Qty),BaseUnit),
divzero(divzero(Itemtotal,Received),BaseUnit))

Price
Itemtotal=?(Received=0,float(Qty)*float(Price),float(Received)*float(Price))
CostPerUnit=?(Received=0
,divzero(divzero(Itemtotal,Qty),BaseUnit),
divzero(divzero(Itemtotal,Received),BaseUnit))

Costshipping
.itemship%

Itemshipping
.itemship%

BaseUnit
ListQty=?(Received=0,Qty*BaseUnit,Received*BaseUnit)
CostPerUnit=?(Received=0
,divzero(divzero(Itemtotal,Qty),BaseUnit),
divzero(divzero(Itemtotal,Received),BaseUnit))

CostPerUnit
CostPerUnit=?(Received=0
,divzero(divzero(Itemtotal,Qty),BaseUnit),
divzero(divzero(Itemtotal,Received),BaseUnit))


Tax
.ordernotes

Subtotal
Itemtotal=?(Received=0,float(Qty)*float(Price),float(Received)*float(Price))

Itemtotal
Itemtotal=?(Received=0,float(Qty)*float(Price),Received*Price)

ItemWt.
«ItemWt.»=?(Received=0,«ListWt.»*Qty,Received*«ListWt.»)

Total Wt.
.ordernotes

Shipping
.itemship%


Received
Itemtotal=?(Received=0,Qty*Price,Received*Price)
ListQty=?(Received=0,Qty*BaseUnit,Received*BaseUnit)
CostPerUnit=?(Received=0
,divzero(divzero(Itemtotal,Qty),BaseUnit),
divzero(divzero(Itemtotal,Received),BaseUnit))
«ItemWt.»=?(Received=0,«ListWt.»*Qty,Received*«ListWt.»)

Ordernotes
.ordernotes

disco
.ordernotes

discount
.ordernotes

