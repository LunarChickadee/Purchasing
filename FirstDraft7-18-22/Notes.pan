///Loop4
firstrecord
loop

    if info("summary")>0
        arraystrip Yr4Array,¶
        field (3YearsAgo)
        «» = float(arraynumerictotal(Yr4Array,¶))
        Yr4Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (3YearsAgo)
        copycell
        SoldHold=clipboard()
        Yr4Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr4Array)
    downrecord
until info("stopped")