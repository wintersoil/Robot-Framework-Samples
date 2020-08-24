*** Settings ***
Documentation    Amazon select a product, checkout and verify sign in page
Library    SeleniumLibrary

*** Variables ***
${PRODUCT_NUMBER}    3
${PRODUCT_NUMBER_DOWN}    4

*** Keywords ***
Amazon_Check1
    wait until element contains    id:huc-v2-order-row-with-divider    Added to Cart
Amazon_Check1_1
    click element    id:hlb-ptc-btn-native
Amazon_Check2
    wait until element contains    class:a-alert-heading    Added to Cart
Amazon_Check2_1
    click element    id:attach-sidesheet-checkout-button
Amazon_Check3
    click element    id:add-to-cart-button
Amazon_Check4
    click element    id:add-to-cart-button-ubb

*** Test Cases ***
User must sign in to purchase product
    [Documentation]    Amazon select a product, checkout and verify sign in page
    [Tags]    Smoke
    Open browser    http://www.amazon.com    chrome
    maximize browser window
    click element    id:twotabsearchtextbox
    Input text    twotabsearchtextbox    Playstation 4    clear=False
    click element    css:.nav-search-submit.nav-sprite
    wait until page contains    results for "Playstation 4"
    wait until element contains    css:.s-main-slot.s-result-list.s-search-results.sg-row   Playstation 4
    scroll element into view    css:.s-result-item.s-asin:nth-child(${PRODUCT_NUMBER_DOWN}) .a-link-normal.a-text-normal
    sleep    2 seconds
    click element    css:.s-result-item.s-asin:nth-child(${PRODUCT_NUMBER}) .a-link-normal.a-text-normal
    sleep    4 seconds
    Element should contain    id:titleSection    PlayStation 4    case_sensitive=False
    sleep    3 seconds
    ${present3}=    Run Keyword And Return Status    element should be visible    id:add-to-cart-button
    run keyword If    ${present3}    Amazon_Check3
    ${present4}=    Run Keyword And Return Status    element should be visible    id:add-to-cart-button-ubb
    run keyword If    ${present4}    Amazon_Check4
    sleep    4 seconds
    ${present}=    Run Keyword And Return Status    element should contain    id:huc-v2-order-row-with-divider    Added to Cart
    run keyword If    ${present}    Amazon_Check1
    ${present1}=    Run Keyword And Return Status    element should contain    class:a-alert-heading    Added to Cart
    run keyword If    ${present1}    Amazon_Check2
    ${present}=    Run Keyword And Return Status    element should contain    id:huc-v2-order-row-with-divider    Added to Cart
    run keyword If    ${present}    Amazon_Check1_1
    ${present1}=    Run Keyword And Return Status    element should contain    id:attach-added-to-cart-message    Added to Cart
    run keyword If    ${present1}    Amazon_Check2_1
    wait until element contains    class:a-section    Sign-In
    Close browser