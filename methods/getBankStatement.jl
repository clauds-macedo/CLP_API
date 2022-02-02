function get_bankStatement(cpf)
    
    bank_statement = HTTP.get("https://tarry-malachite-divan.glitch.me/cpf/$cpf")
    
    dateFormat = DateFormat("y-m-d")
    lastMonth = JSON.parse(String(bank_statement.body))
    
    todaysDate = Date(string(Dates.today()), dateFormat)
    
    saldo = 0
    
    lastMonthDict = Dict{String, Any}(
            "name" => lastMonth["name"],
            "id" => lastMonth["id"],
            "saldo" => saldo,
            "pagamentos" => []
    )

    for i in 1:length(lastMonth["pagamentos"])
        
        paymentDate = Date(lastMonth["pagamentos"][i]["data"], dateFormat)

        paymentDateToTodayDateComparison = (todaysDate - paymentDate)
        paymentDateToTodayDateComparison = parse(Int64, string(paymentDateToTodayDateComparison)[1:2])
        
        lastMonth["pagamentos"][i]["valor"] = string(lastMonth["pagamentos"][i]["valor"])
        lastMonthDict["saldo"] += parse(Float64, lastMonth["pagamentos"][i]["valor"])
        
        if paymentDateToTodayDateComparison <= 30
            append!(lastMonthDict["pagamentos"], [lastMonth["pagamentos"][i]])
        end
    end

    return JSON.json(lastMonthDict)
        
end