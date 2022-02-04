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
        
        paymentByMonthDict = Dict{String, Any}(
            "$monthName" => []
        )
        
        for i in 1:length(statement["pagamentos"])
            
            paymentDate = statement["pagamentos"][i]["data"]
            
            if string(paymentDate[6]) == "0" getMonthPosition = parse(Int64, paymentDate[7])
            else getMonthPosition = parse(Int64, paymentDate[6:7]) end
            
            if currentYear == paymentDate[1:4] && monthName == portugueseMonths[getMonthPosition]
                append!(paymentByMonthDict["$monthName"], [statement["pagamentos"][i]])
            end
            
            
        end
        
        append!(monthDict["pagamentos"], paymentByMonthDict)
    end
    
    return JSON.json(monthDict)

    
end