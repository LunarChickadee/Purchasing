local POnum1, vTotal

POnum1=0
vTotal=0


POnum1=«PO»
Select «PO»=POnum1

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

vTotal=float(«Subtotal»)+float(«Shipping»)+float(«Tax»)
Field «Total»
formulafill float(vTotal)

«Itemtotal»=float(Qty)*float(Price)



«Total»=float(Subtotal)+float(Shipping)+float(Tax)
