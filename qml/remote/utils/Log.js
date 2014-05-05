.pragma library
Qt.include("Utility.js")
function warning(rootObject, message) {
    ___log("warning", rootObject, message);
}

function notice(rootObject, message)
{
    ___log("notice", rootObject, message);
}

function objectDump(rootObject, objectToDump)
{
    ___log("objectDump", rootObject, mydump(objectToDump, 1));
}

function jsonDump(rootObject, objectToDump, pretty)
{
    if(pretty)
    {
        ___log("objectDump", rootObject, JSON.stringify(objectToDump, null, 2));
    } else
    {
        ___log("objectDump", rootObject, JSON.stringify(objectToDump));
    }
}

function modelDump(rootObject, modelToDump)
{
    if(modelToDump.count)
    {
        for(var i = 0; i < modelToDump.count; i++)
        {

                jsonDump(rootObject, modelToDump.get(i), true);
        }
    }
}

function ___log(type, rootObject, message)
{

    var objString = rootObject.toString().split("_")[0] + ".qml";
    console.log(type.toUpperCase() + ": " + objString + " - " + message);
}

function hash(character)
{
    var a = character ? character : "#"
    var h = ""; for(var j = 0; j < 15; j++) { h+=a; }
    for(var i = 0; i < 3; i++) { console.log(h); }
}
function empty(times)
{
    var m = times?times:1;
    for(var i = 0; i < m*3; i++) { console.log(" "); }
}


