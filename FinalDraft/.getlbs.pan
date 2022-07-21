
global Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsDict, DictNamesArray,DictSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,counter3,YrHolder,MixYrHold

Yr1="45 Mix Pounds Sold"
Yr2="44 Mix Pounds Sold"
Yr3="43 Mix Pounds Sold"
Yr4="42 Mix Pounds Sold"
MixLbsDict=""
PercHold=""


//Builds Dictionary of MixNumber and The Total Pounds Sold for X Year
Window wMixes
selectall
firstrecord

counter=1
ChangeYr:
    loop
        YrHolder=arraybuild(¶,"","Yr1+¶+Yr2+¶+Yr3+¶+Yr4")
        YrHolder=array(YrHolder,counter,¶)
        field (YrHolder)
        clipboard()=«»
        LbsHold=str(clipboard())
        setDictionaryValue MixLbsDict, str(«Mix Parent Code»), LbsHold
        downrecord
    until info("stopped")
counter2=counter
counter=counter+1
///Makes an array of the Names (Mix #'s) in the Dictionary 
//this lets us iterate through using the array fuction
listDictionarynames MixLbsDict,DictNamesArray


//find the percentage to do math with for each Mix Number
//loop through the whole DictNames array
counter3=1
MixYrHold="MixWeightDictYr"+str(counter2)
loop
    if counter3<arraysize(DictNamesArray,¶)+1
        window wPurch
        field (MixYrHold)
        DictSelect=array(DictNamesArray,counter3,¶)
        select MixPercDict contains DictSelect
            if info("empty")
                counter3=counter3+1
                repeatloopif counter<info("records")+1
            endif
        counter3=counter3+1

        LbsHold=val(getdictionaryvalue(MixLbsDict,DictSelect))
        


        ///The next part is a complicated
        /*
        The arraycolumn is looking at the values that are ex. 1234=0.4 and saying to treat it
        like if it was a tiny database where the fields looked like
        column1     column2
        1234            0.04
        and I'm using that ability to separate them to find the correct value
        and then to extract the correct percentage to do math with
        */
        loop
            PercChoice=arraysearch(arraycolumn(DictSelect,1,¶,"="),DictSelect,1,¶)
            MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
            field (MixYrHold)
            if «» > 1
            «»=float(«»)+(float(MixPercChoice)*float(LbsHold))
            else 
            «»=(float(MixPercChoice)*float(LbsHold))
            endif
            downrecord
        until info("stopped")  
    endif
until counter3>arraysize(DictNamesArray,¶)


