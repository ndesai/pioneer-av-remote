.pragma library
var callback;

/**
* This method converts a millisecond
* value into a string representation
* as hh:mm:ss, or mm:ss if hours < 1
*/
function ms2string(millis)
{

    var ret = "";
    var hours = Math.floor(millis / 36e5),
            mins = Math.floor((millis % 36e5) / 6e4),
            secs = Math.floor((millis % 6e4) / 1000);

    var ret_hours  = "", ret_mins = "", ret_secs = "";

    if(hours < 10)
    {
        ret_hours += "0";
    }
    ret_hours += hours;


    if(mins < 10)
    {
        ret_mins += "0";
    }
    ret_mins += mins;

    if(secs < 10)
    {
        ret_secs += "0";
    }
    ret_secs += secs;


    if(hours === 0)
    {
        ret = ret_mins + ":" + ret_secs;
    } else {
        ret = ret_hours + ":" + ret_mins + ":" + ret_secs;
    }


    return ret;
}

function milliseconds2string(millis)
{
    var ret = "";
    var hours = Math.floor(millis / 36e5),
            mins = Math.floor((millis % 36e5) / 6e4),
            secs = Math.floor((millis % 6e4) / 1000);

    var ret_hours  = "", ret_mins = "", ret_secs = "";

    if(hours < 10)
    {
        ret_hours += "0";
    }
    ret_hours += hours;


    if(mins < 10)
    {
        ret_mins += "0";
    }
    ret_mins += mins;

    if(secs < 10)
    {
        ret_secs += "0";
    }
    ret_secs += secs;


    if(hours === 0)
    {
        ret = ret_mins + ":" + ret_secs;
    } else {
        ret = ret_hours + ":" + ret_mins + ":" + ret_secs;
    }


    return ret;

}
function trackLengthToString(millis)
{
    var ret = "";
    var hours = Math.floor(millis / 36e5),
            mins = Math.floor((millis % 36e5) / 6e4),
            secs = Math.floor((millis % 6e4) / 1000);

    var ret_hours  = "", ret_mins = "", ret_secs = "";


    ret_hours += hours;
    ret_mins += mins;

    if(secs < 10)
    {
        ret_secs += "0";
    }
    ret_secs += secs;




    if(hours === 0)
    {
        ret = ret_mins + ":" + ret_secs;
    } else {
        if(mins < 10)
        {
            ret_mins = "0";
        }
        ret_mins += mins;
        ret = ret_hours + ":" + ret_mins + ":" + ret_secs;
    }


    return ret;
}

function vodMillisecondsToString(millis)
{
    var ret = "";
    var hours = Math.floor(millis / 36e5),
            mins = Math.floor((millis % 36e5) / 6e4),
            secs = Math.floor((millis % 6e4) / 1000);

    var ret_hours  = "", ret_mins = "", ret_secs = "";

    if(hours < 10)
    {
        ret_hours += "0";
    }
    ret_hours += hours;


    if(mins < 10)
    {
        ret_mins += "0";
    }
    ret_mins += mins;

    if(secs < 10)
    {
        ret_secs += "0";
    }
    ret_secs += secs;


    if(hours === 0)
    {
        ret = "0" + ":" + ret_mins;
    } else {
        ret = ret_hours + ":" + ret_mins;
    }
    return ret;
}

function vodSecondsToString(seconds)
{
    return vodMillisecondsToString(seconds*1000);
}

function hmsToSeconds(hms)
{
    var s = hms.split(':'); // split it at the colons
    return (+s[0]) * 60 * 60 + (+s[1]) * 60 + (+s[2]);
}

function hmsToMinutes(hms)
{
    return Math.round(hmsToSeconds(hms)/60);
}

function hhmmssToPretty(hhmmssString)
{
    if(typeof hhmmssString === "undefined" || hhmmssString === "") return "fail";
    var s = hhmmssString.split(":");
    if(s.length < 3) return "fail";
    var ret = "";
    if(s[0] !== "00")
    {
        if(s[0][0]==="0")
        {
            ret += s[0][1] + " hours"
        } else
        {
            ret += s[0] + " hours"
        }
    }

    if(s[1] !== "00")
    {
        if(s[1][0]==="0")
        {
            ret += s[1][1] + " mins"
        } else
        {
            ret += s[1] + " mins"
        }
    }

    if(s[2] !== "00")
    {
        if(s[2][0]==="0")
        {
            ret += s[2][1] + " secs"
        } else
        {
            ret += s[2] + " secs"
        }
    }
    return ret;
}

/**
* Output [Object object]
*/
function mydump(arr,level) {
    var dumped_text = "";
    if(!level) level = 0;

    var level_padding = "";
    for(var j=0;j<level+1;j++) level_padding += "    ";

    if(typeof(arr) == 'object') {
        for(var item in arr) {
            var value = arr[item];

            if(typeof(value) == 'object') {
                dumped_text += level_padding + "'" + item + "' ...\n";
                dumped_text += mydump(value,level+1);
            } else {
                dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n";
            }
        }
    } else {
        dumped_text = "===>"+arr+"<===("+typeof(arr)+")";
    }
    return dumped_text;
}


/**
  Fisher-Yates Shuffle implementation
  */

function shuffle(array) {
    var tmp, current, top = array.length;
    if(top) while(--top) {
            current = Math.floor(Math.random() * (top + 1));
            tmp = array[current];
            array[current] = array[top];
            array[top] = tmp;
        }
    return array;
}


// returns true if 'haystack' contains 'needle'
function stringContains(haystack, needle)
{
    return (haystack.indexOf(needle) !== -1);
}


function eliminateDuplicates(arr) {
    var i,
            len=arr.length,
            out=[],
            obj={};

    for (i=0;i<len;i++) {
        obj[arr[i]]=0;
    }
    for (i in obj) {
        out.push(i);
    }
    return out;
}

/**
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XandYAxis
        }
        onXChanged: console.log("X is now " + x);
        onYChanged: console.log("Y is now " + y);

  */

function secondsTo24FormatString(timeInt){
    var sec_numb    = parseInt(timeInt);

    if (sec_numb == 0) {
        return "--:--"
    }

    var hours   = Math.floor(sec_numb / 3600);
    var minutes = Math.floor((sec_numb - (hours * 3600)) / 60);
    var ret_hours  = "0", ret_mins = "0"

    if (hours < 10) {
        ret_hours = ret_hours+hours
    } else {
        ret_hours = hours
    }
    if (minutes < 10) {
        ret_mins = ret_mins+minutes
    } else {
        ret_mins = minutes
    }
    return ret_hours + ":" + ret_mins
}

function webRequest(requestUrl, callback){
    var request = new XMLHttpRequest();
    request.onreadystatechange = function() {
        var response;
        response = JSON.parse(request.responseText);
        callback(response, request, requestUrl)
    }
    //var encodedString = encodeURIComponent(postString);
    request.open("GET", requestUrl, true); // only async supported
    //var requestString = "text=" + encodedString;
    request.send();
}

function getRandomInt (min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getRequestObject() {
    var request = new Object
    request.name = ""
    request.params = new Object
    return request
}

function validateEmail(email)
{
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
}

function createLidObject()
{
    return {
        "soundtrack" : {
            "lid" : 1,
            "type" : 2,
            "iso" : "ENG"
        },
        "subtitle" : {
            "lid" : -1,
            "type" : -1,
            "iso" : "OFF"
        }
    }
}

function createOrderDetailObject()
{
    return {
        "orderId" : "1234",
        "merchantId" : "",
        "price" : 0.00,
        "currency" : "",
        "currency_code" : {
            "left" : "NZD$",
            "right" : ""
        },
        "description" : "Order",
        "tabTotal" : 0.00
    }
}

function isValidSeatNumber(seatNumber) 
{
    var isEmpty = (!seatNumber || /^\s*$/.test(seatNumber))
    var isValidFormat = /^\d+[a-zA-Z]$/.test(seatNumber)
    return !isEmpty && isValidFormat
}

// untested
function validateDateOfBirth(ddmmyyy)
{
    // Input
    // dd/mm/yyyy or dd-mm-yyyy or dd.mm.yyyy
    var re = /^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/;
    return re.test(ddmmyyy);
}
