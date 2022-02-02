function doCPFexists(cpf)
    
    response = HTTP.get("https://tarry-malachite-divan.glitch.me/cpf/")
    cpf = parse(Int64, cpf)
    cpfExists = false
    
    data = JSON.parse(String(response.body))
    
    for index in 1:length(data) 
        if values(data[index]["id"]) == cpf
            cpfExists = true
            break
        end
    end
    
    return cpfExists
    
end

doCPFexists("13663922222")