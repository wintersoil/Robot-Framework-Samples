*** Settings ***
Documentation    Amazon sign in, search for a product, filter by price, add to cart and checkout
Library    SeleniumLibrary
Library    String

*** Variables ***
${email}    your_email@gmail.com
${password}    ******
${name}    Your First Name
${product}    Apple Watch
${keep_searching}    True
${product_number}    ${1}
${product_scroll}    ${2}
${price_no}    ${0}

*** Keywords ***
Looping
    go to    http://www.amazon.com
    wait until element contains    css:#nav-link-accountList .nav-line-1    Hello, ${name}
    wait until element contains    id:glow-ingress-line1    Deliver to ${name}
    wait until element contains    css:#nav-your-amazon-text .nav-shortened-name    ${name}
    click element    id:twotabsearchtextbox
    input text    id:twotabsearchtextbox    ${product}
    click element    css:.nav-search-submit.nav-sprite
    sleep    2 seconds
    click element    css:.aok-inline-block.a-spacing-none .a-button-inner .a-button-text.a-declarative
    click element    css:.a-popover-wrapper .a-popover-inner #s-result-sort-select_3
    sleep    1 s
    scroll element into view   css:.s-result-item.s-asin:nth-child(${product_scroll}) .a-link-normal.a-text-normal
    sleep    1 s
    click element    css:.s-result-item.s-asin:nth-child(${product_number}) .a-link-normal.a-text-normal
    sleep    2 seconds
    ${status}    ${temp}=    run keyword and ignore error    evaluate    ${product_number} + 1
    set test variable    ${product_number}    ${temp}
    ${status}    ${temp_scroll}=    run keyword and ignore error    evaluate    ${product_scroll} + 1
    set test variable    ${product_scroll}    ${temp_scroll}
    element should be visible    id:priceblock_ourprice


ComparePrice
    ${status}    ${price}=    run keyword and ignore error    get text    id:priceblock_ourprice
    ${status}    ${test1}=    run keyword and ignore error    String.Get Substring    ${price}    1
    ${status}    ${price_no}=    run keyword and ignore error    convert to number    ${test1}
    run keyword if    ${price_no} < 50    AddToCart
    run keyword if    ${price_no} > 50    KeepLooping

AddToCart
    click element    id:add-to-cart-button
    sleep    3 seconds
    click element    id:hlb-ptc-btn
    wait until element is visible    id:ap_password
    input text    id:ap_password    ${password}
    click element    id:signInSubmit

KeepLooping
    wait until keyword succeeds    200    1 s    Looping
    run keyword    compareprice

*** Test Cases ***
Amazon sign in, filter, add to cart, checkout
    [Documentation]    User signs in, searches for product, filters by price below a threshold, adds to cart and checks out.
    [Tags]    Smoke
    open browser    http://www.amazon.com    chrome    alias=Chrome
    Add Cookie    i18n-prefs    USD
    Add Cookie    lc-main    en_US
    Add Cookie    aws-session-id    xxxxxxxxxxxxxxxxxxx
    Add Cookie    aws-session-id-time    xxxxxxxxxxxxxx
    Add Cookie    csm-hit    xxxxxxxxxxxxxxxxxxxxxxxxxx
    Add Cookie    sid    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    Add Cookie    sess-at-main    xxxxxxxxxxxxxxxxxxxxx
    Add Cookie    session-id    xxxxxxxxxxxxxxxxxxxxxxx
    Add Cookie    session-id-time    xxxxxxxxxxxxxxxxxx
    Add Cookie    skin    noskin
    Add Cookie    sp-cdn    xxxxxxxxxxxxxxxxxxxxxxxxxxx
    Add Cookie    ubid-main    xxxxxxxxxxxxxxxxxxxxxxxx
    Add Cookie    x-main    xxxxxxxxxxxxxxxxxxxxxxxxxxx
    Add Cookie    sst-main    xxxxxxxxxxxxxxxxxxxxxxxxx
    Add Cookie    session-token    xxxxxxxxxxxxxxxxxxxx
    Add Cookie    at-main    xxxxxxxxxxxxxxxxxxxxxxxxxx
    maximize browser window
    ${product_number}=    Set Variable    ${1}
    wait until keyword succeeds    200    1 s    Looping
    run keyword    compareprice

    close browser