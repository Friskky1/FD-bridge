


CreateThread(function()
    Wait(5000)
    if not Config.Debug then return end

    print(Config.Banner)
    while Config.Debug do
        print('^6------------------------------------------------------------------------------------------')
        print('^6 DEVELOPMENT MODE: DEBUG ENABLED, DISABLE IF NOT IN USE, ^1IT WILL LEAD TO PERFORMANCE ISSUES!!!')
        print('^6------------------------------------------------------------------------------------------')
        Wait(300000)
    end
end)
