___ PROCEDURE GetSource ________________________________________________________
local Dictionary1, ProcedureList

exportallprocedures "", Dictionary1
clipboard()=Dictionary1

message "Macros are saved to your clipboard!"
//this saves your procedures into a variable
//test2
//test3
//test4
___ ENDPROCEDURE GetSource _____________________________________________________

___ PROCEDURE ImportSource _____________________________________________________
local Dictionary1,Dictionary2, ProcedureList
Dictionary1=""
Dictionary1=clipboard()
;noyes "Press yes to import all macros from clipboard"
if clipboard()="No"
stop
endif
//step one
importdictprocedures Dictionary1, Dictionary2
//changes the easy to read macros into a panorama readable file
message Dictionary2
 
//step 2
//this lets you load your changes back in from an editor and put them in
//copy your changed full procedure list back to your clipboard
//now comment out from step one to step 2
//run the procedure one step at a time to load the new list on your clipboard back in
//Dictionary2=clipboard()
loadallprocedures Dictionary2,ProcedureList
message ProcedureList //messages which procedures got changed
___ ENDPROCEDURE ImportSource __________________________________________________
