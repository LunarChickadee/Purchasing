
global Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsDict, DictNamesArray,ItemSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,ItemNumCounter,YrHolder,MixYrHold,
MixLbsItem, MixWeightItemDict,YrCounter,AppendToMixWeight

Yr1="45 Mix Pounds Sold"
Yr2="44 Mix Pounds Sold"
Yr3="43 Mix Pounds Sold"
Yr4="42 Mix Pounds Sold"
MixLbsDict=""
PercHold=""
MixWeightItemDict=""


//Builds Dictionary of MixNumber and The Total Pounds Sold for X Year
Window wMixes
selectall
YrCounter=0

;debug
firstrecord
    ChangeYr:
    Window wMixes
    firstrecord
    YrCounter=YrCounter+1
    deletedictionaryvalue MixLbsDict,""
        loop
            //programatically picks a year and gets the Mix LBS sold for it
            //puts those into a dictionary of Code=Lbs
            YrHolder=arraybuild(¶,"","Yr1+¶+Yr2+¶+Yr3+¶+Yr4")
            YrHolder=array(YrHolder,YrCounter,¶)
            field (YrHolder)
            clipboard()=«»
            LbsHold=str(clipboard())
            setDictionaryValue MixLbsDict, str(«Mix Parent Code»), LbsHold
            downrecord
        until info("stopped")
    ;counter2=YrCounter
    ;YrCounter=YrCounter+1
    ///Makes an array of that Dictionary's Parent Codes
    //this lets us iterate through using the array fuction
    listDictionarynames MixLbsDict,DictNamesArray


    //find the percentage to do math with for each Mix Number
    //loop through the whole DictNames array
    ItemNumCounter=0
    MixYrHold="MixWeightDictYr"+str(YrCounter)
  ;  debug
    RepeatDictLoop:
    loop
    ItemNumCounter=ItemNumCounter+1
        if ItemNumCounter<arraysize(DictNamesArray,¶)+1
            window wPurch
            field (MixYrHold)
            ItemSelect=array(DictNamesArray,ItemNumCounter,¶)
            select MixPercDict contains ItemSelect
                if info("empty")
                    ItemNumCounter=ItemNumCounter+1
                    repeatloopif YrCounter<info("records")+1
                endif

            LbsHold=val(getdictionaryvalue(MixLbsDict,ItemSelect))   

            ///The next part is a complicated
            /*
            The arraycolumn is looking at the values that are ex. 1234=0.4 and saying to treat it
            like if it was a tiny database where the fields looked like
            column1     column2
            1234            0.04
            and I'm using that ability to separate them to find the correct value
            and then to extract the correct percentage to do math with
            */
           ; debug 
            loop
                //this finds which element of the array of x=y pairs (Dumped Dictionary) 
                //in MixPercDict
                //has the value we're looking for
                PercChoice=arraysearch(arraycolumn(ItemSelect,1,¶,"="),ItemSelect,1,¶)
                //this uses that element choice to grab the percent
                MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
                field (MixYrHold)                        
                //This does the appropriate math
                MixLbsItem=0
                MixLbsItem=float(MixPercChoice)*float(LbsHold)
                //then adds to a dictionary that we'll use later
                deletedictionaryvalue MixWeightItemDict,""    
                setdictionaryvalue MixWeightItemDict, ItemSelect,str(MixLbsItem)
                ;debug
                AppendToMixWeight=""
                dumpdictionary MixWeightItemDict, AppendToMixWeight
                AppendToMixWeight=«»+¶+AppendToMixWeight
                //This Makes sure that any duplicate entries are deleted
                //instead of making a mess of doubled totals
                arraydeduplicate AppendToMixWeight,AppendToMixWeight,¶
                arraystrip AppendToMixWeight, ¶
                «» = AppendToMixWeight
                AppendToMixWeight=""
                downrecord
            until info("stopped")  
        endif
    until ItemNumCounter>arraysize(DictNamesArray,¶)

if YrCounter≠4
goto ChangeYr
endif


