include("package.jl")
import JSON, HTTP

using Genie, Dates
using Genie.Router: route, Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json, Genie.Requests, Genie.Configuration
using Logging

include("methods/getBankStatement.jl")
include("methods/addPayment.jl")
include("methods/verifyCPFexistence.jl")
include("methods/postNewCPF.jl")

route("/") do
    return "Conectado com sucesso"
end

route("/v1/extrato/", method = "GET") do
    
    cpf = params(:cpf, "")
    
    if cpf == ""
        return "Parâmetro CPF vazio"
    elseif doCPFexists(cpf)
        return get_bankStatement(cpf)
    end
    
end

route("/v1/addPagamento", method = "PUT") do
    
    cpf = params(:cpf, "")
    valor = params(:valor, "")
    date = params(:date, "")
    details = params(:details, "")
      
    if doCPFexists(cpf) 
        addPayment(cpf,valor,date,details)
    end

end

route("/v1/todos", method = "GET") do
    return HTTP.get("https://tarry-malachite-divan.glitch.me/cpf/")
end

route("/v1/novoCPF", method = "POST") do
       
    cpf = params(:cpf, "")
    name = params(:name, "")
    
    if !doCPFexists(cpf)
       return postCPF(cpf, name)
    else return "O CPF já existe." end
    
end

up(parse(Int64, ENV["PORT"]), "0.0.0.0" ,async = false)