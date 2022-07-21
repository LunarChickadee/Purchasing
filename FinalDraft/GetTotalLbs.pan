global YrCount,counter4, MixDictArray,FHold1,FHold2,LbsArray1

YrCount=0

NextYear:
YrCount=YrCount+1
firstrecord
loop
    LbsArray1=0
    FHold1="MixLbsYr"+str(YrCount)
    FHold2="MixWeightDictYr"+str(YrCount)
    field (FHold2)
    clipboard()=«»
    MixDictArray=clipboard()


    counter4=1

        loop
        LbsArray1=LbsArray1+val(arraycolumn(array(MixDictArray,counter4,¶),2,¶,"="))
        increment counter4
        until counter4>arraysize(MixDictArray,¶)

    Field (FHold1)
    «» = LbsArray1
    counter4=1
    LbsArray1=0
    downrecord
    until info("stopped")

    if YrCount≠4
    goto NextYear
endif
