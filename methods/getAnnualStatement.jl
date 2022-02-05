function getPaymentByYear(cpf)
    
    bank_statement = HTTP.get("https://tarry-malachite-divan.glitch.me/cpf/$cpf")

    statement = JSON.parse(String(bank_statement.body))
    payments = statement["pagamentos"]
    yearsArray = []
    paymentByYearDict = Dict{String, Any}(
            "pagamentos" => []
    )
    
    for i in 1:length(payments)
        date = payments[i]["data"][1:4]
        if date ∉ yearsArray push!(yearsArray, date) end
    end
    
    for i in 1:length(yearsArray)
        
        year = yearsArray[i]
        YearDict = Dict{String, Any}(
            "$year" => []
        )
        push!(paymentByYearDict["pagamentos"], YearDict)
    end

    for i in 1:length(payments)
        date = payments[i]["data"][1:4]
        payment = payments[i]

        for i in 1:length(paymentByYearDict["pagamentos"])
            if string([date]) == string(keys(paymentByYearDict["pagamentos"][i]))
                push!(paymentByYearDict["pagamentos"][i]["$date"], payment)
            end
        end
    end
    
    for i in 1:length(paymentByYearDict["pagamentos"])
    
        byYear = paymentByYearDict["pagamentos"][i]
        index = string(keys(byYear))[3:6]
        
        paymentValue = 0
        moneyOut = 0
        moneyIn = 0

        monthBalance = Dict{String, Any}( 
            "saldoAnual" => paymentValue,
            "dinheiroSai" => moneyOut,
            "dinheiroEntra" => moneyIn
        )
        
        
        for j in 1:length(byYear[index])
        
            valor = parse(Float64, byYear[index][j]["valor"])
            monthBalance["saldoAnual"] += valor
            if valor < 0 monthBalance["dinheiroSai"]+=valor
            else monthBalance["dinheiroEntra"] += valor end
            if j == length(byYear[index]) push!(byYear[index], monthBalance) end
            
            
        end
    end
    
    return JSON.json(paymentByYearDict)

end