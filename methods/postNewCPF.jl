function postCPF(cpf, name)
    
    newCPF = Dict{String, Any}(
        "id" => "$cpf",
        "name" => "$name",
        "pagamentos" => []
    )
    
    newCPF = JSON.json(newCPF)
    
    return HTTP.post("https://tarry-malachite-divan.glitch.me/cpf/", [("Content-Type", "application/json")], newCPF)
    
end