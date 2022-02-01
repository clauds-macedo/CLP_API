function addPayment(cpf, valor, date, details)
    
    if occursin("/", date) || date[3] == "-" || date[6] == "-"
        exDate = Dates.today()
        return "Data inválida. Formato de data deve ser AAAA-MM-DD ($exDate)"
    end
    
    tipo = ""
    if parse(Float64, valor) > 0 tipo = "c" else tipo = "d" end
    bank_statement = HTTP.get("https://tarry-malachite-divan.glitch.me/cpf/$cpf")
    data = JSON.parse(String(bank_statement.body))
    
    newPayment = [Dict{String, Any}(
        "tipo" => "$tipo",
        "valor" => "$valor",
        "data" => "$date",
        "detalhes" => "$details"
    )]
    
    append!(data["pagamentos"], newPayment)
    newDATA = (JSON.json(data))
    return HTTP.put("https://tarry-malachite-divan.glitch.me/cpf/$cpf", [("Content-Type", "application/json")], newDATA)

end