///Note: This uses global variables from .BuildData

global ParentDict, SoldArray, ParentCode, counter, Name,Lbs

ParentDict=""
SoldArray=""



///loop1
window wComments
firstrecord
loop
field (CurrentYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsThisYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop2
window wComments
firstrecord
loop
field (PrevYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field LbsLastYear
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsLastYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (TwoYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs2YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs2YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (ThreeYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs3YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs3YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")