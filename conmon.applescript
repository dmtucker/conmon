global ready, theService, thePeriod
on run
    set ready to false
    set theTitle to "Connection Monitor"
    set theIntro to "This application periodically checks a Network Service to ensure it remains connected."

    tell application "System Events"
        tell network preferences
            set theServices to the name of every service
        end tell
    end tell
    choose from list theServices with prompt theIntro & " Select a Network Service to monitor." with title theTitle
    set theResult to the result
    if theResult is false then quit
    set theName to theResult as text
    tell application "System Events"
        tell network preferences
            set theService to the service theName
        end tell
    end tell

    try
        display dialog "How often should " & theName & " be checked (in seconds)?" default answer "30" with title theTitle
        set thePeriod to the text returned of the result as number
        display dialog theName & " will be checked approximately every " & (thePeriod as string) & " seconds." with title theTitle
    on error
        return
    end try
    set ready to true
end run
on idle
    if ready then
        tell application "System Events"
            tell network preferences
                if current configuration of theService is not connected then connect theService
            end tell
            return thePeriod
        end tell
    else
        quit
    end if
end idle
