*** Settings ***
Documentation    Visit Expedia.org and book a hotel for the price mentioned in the location mentioned, opens all hotels less than the threshold in that area.
Library    SeleniumLibrary
Library    String

*** Variables ***
${CheckInDay}    ${11}
${CheckOutDay}    ${21}
${price_threshold}    ${130}
${city}    New York

*** Keywords ***
firstPath
    click element    css:button[data-testid='travelers-field-trigger']
    sleep    1 s
    click element    css:.roomPickerRoom .adultStepInput button:nth-child(3)
    sleep    1 s
    click element    css:.roomPickerRoom .childStepInput button:nth-child(3)
    click element    css:.roomPickerRoom .childStepInput button:nth-child(3)
    click element    css:.guestsDoneBtn button
    click element    css:button[data-testid='submit-button']
    sleep    3 s
    ${elements}=    Get WebElements    css:.price.listing__price.all-t-padding-half [data-stid='content-hotel-lead-price']
    ${a-elements}=    Get WebElements    css:.results-list [data-stid='open-hotel-information']
    sleep    2 s
    set test variable    ${pointer}    ${0}
    set test variable    ${pointer_beg_1}    ${1}
    FOR    ${element}    IN    @{elements}
        ${price_all}=    get text    ${element}
        ${price_clipped}=    String.get substring    ${price_all}    1
        ${price_commas_rm}=    String.replace string    ${price_clipped}    ,    ${EMPTY}    count=99
        run keyword if    ${price_commas_rm} < ${price_threshold}   click element    ${a-elements}[${pointer}]
        run keyword if    ${price_commas_rm} < ${price_threshold}    capture element screenshot    css:.results-list li[tabindex='-1']:nth-of-type(${pointer_beg_1})    Relevant_Hotels/Hotel${pointer_beg_1}.png
        ${status}=    run keyword and return status    Evaluate    ${price_commas_rm} < ${price_threshold}
        run keyword if    ${status} == True    IncrementAgainPointer    ${pointer}
        ${status}    ${temp_1}=    run keyword and ignore error    Evaluate    ${pointer_beg_1} + 1
        set test variable    ${pointer_beg_1}    ${temp_1}
        run keyword    LoopAndRemoveIrrelevantLi    ${pointer_beg_1}
    END
    sleep    3 s
    ${title_var}        get browser ids
    switch browser    id={title_var}[1]
    sleep    2 s
    close browser
    sleep    2 s
    wait until element is visible    css:[data-stid='section-room-list'] [data-stid='submit-hotel-reserve']
    scroll element into view    css:[data-stid='section-room-list'] [data-stid='submit-hotel-reserve']
    sleep    10 s
secondPath
    click element    css:a[data-testid='travelers-field']
    sleep    1 s
    click element    css:.roomPickerRoom .adultStepInput button:nth-child(3)
    sleep    1 s
    click element    css:.roomPickerRoom .childStepInput button:nth-child(3)
    click element    css:.roomPickerRoom .childStepInput button:nth-child(3)
    click element    css:.guestsDoneBtn button
    click element    css:button[data-testid='submit-button']
    sleep    3 s
    ${elements}=    Get WebElements    css:.price.listing__price.all-t-padding-half [data-stid='content-hotel-lead-price']
    ${a-elements}=    Get WebElements    css:.results-list [data-stid='open-hotel-information']
    sleep    2 s
    set test variable    ${pointer}    ${0}
    set test variable    ${pointer_beg_1}    ${1}
    FOR    ${element}    IN    @{elements}
        ${price_all}=    get text    ${element}
        ${price_clipped}=    String.get substring    ${price_all}    1
        ${price_commas_rm}=    String.replace string    ${price_clipped}    ,    ${EMPTY}    count=99
        run keyword if    ${price_commas_rm} < ${price_threshold}   click element    ${a-elements}[${pointer}]
        run keyword if    ${price_commas_rm} < ${price_threshold}    capture element screenshot    css:.results-list li[tabindex='-1']:nth-of-type(${pointer_beg_1})    Relevant_Hotels/Hotel${pointer_beg_1}.png
        ${status}=    run keyword and return status    Evaluate    ${price_commas_rm} < ${price_threshold}
        run keyword if    ${status} == True    IncrementAgainPointer    ${pointer}
        ${status}    ${temp_1}=    run keyword and ignore error    Evaluate    ${pointer_beg_1} + 1
        set test variable    ${pointer_beg_1}    ${temp_1}
        run keyword    LoopAndRemoveIrrelevantLi    ${pointer_beg_1}

    END
    sleep    3 s
    ${title_var}        get browser ids
    switch browser    id={title_var}[1]
    sleep    2 s
    close browser
    sleep    2 s
    wait until element is visible    css:[data-stid='section-room-list'] [data-stid='submit-hotel-reserve']
    scroll element into view    css:[data-stid='section-room-list'] [data-stid='submit-hotel-reserve']
    sleep    10 s

LoopAndRemoveIrrelevantLi
    [Arguments]    ${pointer_beg_1}
    FOR    ${i}    IN RANGE    1    7
                ${status}=    run keyword and return status    page should contain element    css:.results-list li[tabindex='-1']:nth-of-type(${pointer_beg_1})
                run keyword if    ${status} == False    IncrementAgainPointerBeg    ${pointer_beg_1}
    END

Additional Setup
    Open browser    http://www.expedia.org    chrome
    Add Cookie    intentmedia_user_id    OptOut
    Add Cookie    OptanonConsent    consentId=7b24c8c3-1234-4b8c-908d-4c4b4e876e8a&datestamp=Mon+Aug+24+2020+19%3A02%3A29+GMT-0400+(Eastern+Daylight+Time)&version=5.10.0&interactionCount=1&isIABGlobal=false&landingPath=NotLandingPage&groups=C0001%3A1%2CC0004%3A1%2CC0002%3A1%2CC0003%3A1&hosts=&geolocation=CA%3BON&AwaitingReconsent=false
    Add Cookie    OptanonAlertBoxClosed    2020-08-24T23:02:26.458Z
    sleep    2 s

IncrementAgainPointer
    [Arguments]    ${pointer}
    ${status}    ${temp}=    run keyword and ignore error    Evaluate    ${pointer} + 1
    set test variable    ${pointer}    ${temp}

IncrementAgainPointerBeg
    [Arguments]    ${pointer_beg_1}
    ${status}    ${temp}=    run keyword and ignore error    Evaluate    ${pointer_beg_1} + 1
    set test variable    ${pointer_beg_1}    ${temp}

*** Test Cases ***
Visit expedia and get the best deal for Toronto to New York
    [Documentation]    Visit Expedia.org and book the best value ticket from Toronto to New York
    [Tags]    Smoke
    run keyword    Additional Setup
    maximize browser window
    click element    class:uitk-faux-input
    input text    id:location-field-destination    ${city}    clear=False
    sleep    1 s
    click element    css:.uitk-typeahead-result-item.has-subtext:nth-child(1)
    sleep    1 s
    click element    id:d1-btn
    sleep    1 s
    click element    css:.uitk-new-date-picker-day[data-day='${CheckInDay}']
    sleep    1 s
    click element    css:.uitk-new-date-picker-day[data-day='${CheckOutDay}']
    sleep    1 s
    click element    css:button[data-stid='apply-date-picker']
    sleep    1 s
    ${present1}=    run keyword and return status    element should be visible    css:button[data-testid='travelers-field-trigger']
    run keyword if    ${present1}    firstPath
    ${present2}=    run keyword and return status    element should be visible    css:a[data-testid='travelers-field']
    run keyword if    ${present2}    secondPath
    sleep    3 s
    close browser