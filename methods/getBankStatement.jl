function get_bankStatement(cpf)
    
    bank_statement = HTTP.get("https://tarry-malachite-divan.glitch.me/cpf/$cpf")
    
    dateFormat = DateFormat("y-m-d")
    lastMonth = JSON.parse(String(bank_statement.body))
    
    todaysDate = Date(string(Dates.today()), dateFormat)
    
    lastMonthDict = Dict{String, Any}(
            "name" => lastMonth["name"],
            "id" => lastMonth["id"],
            "pagamentos" => []
    )
        
    for i in 1:length(lastMonth["pagamentos"])
        
        paymentDate = Date(lastMonth["pagamentos"][i]["data"], dateFormat)
        previousMonthPaymentDate = (paymentDate - Month(1)) 
        paymentDateToTodayDateComparison = (todaysDate - paymentDate)
        paymentDateToTodayDateComparison = parse(Int64, string(paymentDateToTodayDateComparison)[1:2])
#         println(todaysDate-previousMonthPaymentDate)
#         println("$paymentDate - $previousMonthPaymentDate")
        if paymentDateToTodayDateComparison <= 30
            append!(lastMonthDict["pagamentos"], [lastMonth["pagamentos"][i]])
        end
    end
    return JSON.json(lastMonthDict)
        
end