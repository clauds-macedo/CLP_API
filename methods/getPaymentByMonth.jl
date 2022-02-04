function getPaymentByMonth(cpf)
   
    bank_statement = HTTP.get("https://tarry-malachite-divan.glitch.me/cpf/$cpf")

    statement = JSON.parse(String(bank_statement.body))
    
    todaysDate = (string(Dates.today()))

    if string(todaysDate[6]) == "0" monthLoopRange = parse(Int64, todaysDate[7])
    
    else monthLoopRange = parse(Int64, todaysDate[6:7]) end
    
    monthDict = Dict{String, Any}(
            "id" => statement["id"],
            "pagamentos" => []
    )
    
    currentYear = todaysDate[1:4]
    
    portugueseMonths = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto",
                        "Setembro", "Outubro", "Novembro", "Dezembro"];
    
    Dates.LOCALES["portuguese"] = Dates.DateLocale(portugueseMonths, [""], [""], [""])
    
    for i in 1:monthLoopRange
        
        
        monthName = Dates.monthname(i;locale="portuguese")
        
        paymentValue = 0
        moneyOut = 0
        moneyIn = 0
        
        monthBalance = Dict{String, Any}( 
            "saldoMensal" => paymentValue,
            "dinheiroSai" => moneyOut,
            "dinheiroEntra" => moneyIn
        )
        
        paymentByMonthDict = Dict{String, Any}(
            "$monthName" => []
        )
        
        append!(paymentByMonthDict["$monthName"], [monthBalance])
        
        for i in 1:length(statement["pagamentos"])
            
            paymentDate = statement["pagamentos"][i]["data"]
            valor = parse(Float64 ,statement["pagamentos"][i]["valor"])
            
            if string(paymentDate[6]) == "0" getMonthPosition = parse(Int64, paymentDate[7])
            else getMonthPosition = parse(Int64, paymentDate[6:7]) end
            
            if currentYear == paymentDate[1:4] && monthName == portugueseMonths[getMonthPosition]
                
                monthBalance["saldoMensal"] += valor

                if valor < 0 monthBalance["dinheiroSai"]+=valor
                else monthBalance["dinheiroEntra"] += valor end

                append!(paymentByMonthDict["$monthName"], [statement["pagamentos"][i]])
                
            end
            
        
        end
        append!(monthDict["pagamentos"], paymentByMonthDict)
    end
    
    return JSON.json(monthDict)

end