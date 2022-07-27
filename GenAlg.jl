using Evolutionary

function f(xx)
    b = 100
    d = length(xx)
    ii = [n for n = 1:d]
    jj = mapreduce(permutedims, vcat, [ii for _ in 1:d])
    xxmat = mapreduce(permutedims, vcat, [xx for _ in 1:d])

    inner = (jj .+ b) .* (xxmat .^ ii .- (1 ./ jj) .^ ii)
    inner = sum(inner, dims = 2)
    sum(inner .^ 2)
end

function testesGA(i, j, k)
    if j == 1
        s = rouletteinv
        printstyled("Seleção: ")
        printstyled("Roleta Invertida\n", color = :cyan)
    else
        s = susinv
        printstyled("Seleção: ")
        printstyled("SUS Invertida\n", color = :cyan)
    end

    if k == 1
        c = DC
        printstyled("Cruzamento: ")
        printstyled("DC - Discreto\n", color = :cyan)
    elseif k == 2
        c = AX
        printstyled("Cruzamento: ")
        printstyled("AX - Média\n", color = :cyan)
    else
        c = WAX
        printstyled("Cruzamento: ")
        printstyled("WAX - Média\n", color = :cyan)
    end

    if i == 1
        printstyled("Tam. população: ")
        printstyled("50\n", color = :cyan)
        return GA(populationSize = 50, 
                  selection = s,
                  crossover = c, 
                  mutation = uniform(2 ^ i))
    elseif i == 2
        printstyled("Tam. população: ")
        printstyled("100\n", color = :cyan)
        return GA(populationSize = 100, 
                  selection = s,
                  crossover = c, 
                  mutation = uniform(2 ^ i))
    elseif i == 3
        printstyled("Tam. população: ")
        printstyled("200\n", color = :cyan)
        return GA(populationSize = 200, 
                  selection = s,
                  crossover = c, 
                  mutation = uniform(2 ^ i))
    elseif i == 4
        printstyled("Tam. população: ")
        printstyled("500\n", color = :cyan)
        return GA(populationSize = 500, 
                  selection = s,
                  crossover = c, 
                  mutation = uniform(2 ^ i))
    elseif i == 5
        printstyled("Tam. população: ")
        printstyled("1000\n", color = :cyan)
        return GA(populationSize = 1000, 
                  selection = s,
                  crossover = c, 
                  mutation = uniform(2 ^ i))
    end
end

# for i = 1:5
#     for j = 1:3
#         for k = 1:2
#             dimensao = 2^i
#             printstyled(">Teste $i\n", color = :light_blue, blink = true)
#             result = Evolutionary.optimize(f, zeros(dimensao), testesGA(i, j, k))
#             println("Dimensão: ", 2^i)
#             println("Resultado ótimo: 0, ", [1/x for x = 1:dimensao])
#             println("Iterações executadas: ", Evolutionary.iterations(result))
#             println("Resultado obtido: ", minimum(result), ", ", Evolutionary.minimizer(result))
#             println()
#         end
#     end
#     x = readline()
# end

dimensao = 8
result = Evolutionary.optimize(f, zeros(dimensao), GA(
    populationSize = 5000,
    crossoverRate = 0.8,
    mutationRate = 0.2,
    epsilon = 100,
    selection = tournament(10),
    crossover = Evolutionary.IC(1),
    mutation = Evolutionary.gaussian(0.5)
))

println(result)