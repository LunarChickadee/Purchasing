

global vPercent, vInMixes, vMix, vItem, FdName, Counter,strItemIng,strvItem,vClip

local wMixesDB

vPercent = ""
vInMixes = ""
vItem = ""
wMixesDB = ""

vItem=ItemNum

wMixesDB = info("windowname")
firstrecord

loop

vItem=""
vItem=ItemNum

window "Mixes"


;vItem=8001
Counter=1
FdName="ItemIngredient"+str(Counter)
strvItem=str(vItem)

loop
Field (FdName)
Copycell
  vClip=str(clipboard())
     If vClip≠strvItem
          Increment Counter
        Endif
Stoploopif Counter=18 
Until vClip=strvItem
