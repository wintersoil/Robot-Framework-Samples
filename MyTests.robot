*** Settings ***
Documentation   This is some basic info about the whole suite
Library    SeleniumLibrary

*** Variables ***

*** Test Cases ***
Page must open search results for ipad
    [Documentation]    This is some basic info about the test
    [Tags]    Smoke
    Open Browser    http://www.amazon.com   chrome
    click element    id:twotabsearchtextbox
    Input text    twotabsearchtextbox    ipad    clear=False
    click element    class:nav-input
    sleep    10 seconds
    Close Browser