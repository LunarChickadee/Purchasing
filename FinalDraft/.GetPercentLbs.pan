window wPurch

global strItemArray, counter, 
MixLbsDict, ItemSelection,NumGet,PercGet,LbsGet,
IngPer,LineArrayIngs,checkSelect

IngPer=""

MixLbsDict=""

arraybuild strItemArray, ¶,"",«ItemNum»

counter=1
loop
    window wMixes
    selectall
    ItemSelection=array(strItemArray,counter,¶)
    select exportline() contains ItemSelection
        if info("empty")
        counter=counter+1
        repeatloopif counter<info("records")+1
        endif
    checkSelect=info("selected")
    RepeatFind:
    LineArrayIngs=lineitemarray(ItemIngredientΩ,¶)
    NumGet=arraysearch(LineArrayIngs,ItemSelection,1,¶ )
        if val(NumGet)<1
            message "Error"
            stop
            downrecord
        endif
    ;NumGet=striptonum(info("fieldname"))
    IngPer="IngredientPercentage"+str(NumGet)
    field (IngPer)
    PercGet=«»/100
    setdictionaryvalue MixLbsDict,str(«Mix Parent Code»),str(PercGet)
    ;next
    ;debug
    downrecord
        if info("stopped")
            goto Skip
        else 
            goto RepeatFind
        endif
    ;repeatloopif info("found")

    Skip:
    window wPurch

    select ItemNum contains ItemSelection
    dumpdictionary MixLbsDict, MixPercDict
    MixLbsDict=""
    counter=counter+1
until counter>info("records")
//needs tweaking
