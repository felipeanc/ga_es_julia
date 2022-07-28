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

function testes(i, j, k, f)
    if j == 1
        s = rouletteinv
        write(f, "> Seleção: Roleta Invertida")
    elseif j == 2
        s = tournament(100)
        write(f, "> Seleção: Torneio")
    else
      s = susinv
      write(f, "> Seleção: Roleta Invertida")
    end

    write(f, "\n")

    if k == 1
        c = DC
        write(f, "> Cruzamento: Discreto")
    elseif k == 2
        c = AX
        write(f, "> Cruzamento: Média")
    else
        c = IC(1)
        write(f, "> Cruzamento: IC(1)")
    end

    write(f, "\n")

    if i == 1
      p = 5000
      write(f, "> Tam. população: 5000")
    elseif i == 2
      p = 6000
      write(f, "> Tam. população: 6000")
    elseif i == 3
      p = 7000
      write(f, "> Tam. população: 7000")
    elseif i == 4
      p = 8000
      write(f, "> Tam. população: 8000")
    elseif i == 5
      p = 10000
      write(f, "> Tam. população: 10000")
    end

    write(f, "\n")

    return GA(
      populationSize = p,
      crossoverRate = 0.9,
      mutationRate = 0.2,
      epsilon = 0.3,
      selection = s,
      crossover = c,
      mutation = Evolutionary.gaussian(0.5)
    )
end

# for i = 1:5
#     for j = 1:3
#         for k = 1:2
#             dimensao = 2^i
#             printstyled(">Teste $i\n", color = :light_blue, blink = true)
#             result = Evolutionary.optimize(f, zeros(dimensao), testesGA(i, j, k))
#             println("Dimensão: ", 2^i)
#             println()
#             println("Iterações executadas: ", Evolutionary.iterations(result))
#             println("Resultado obtido: ", minimum(result), ", ", Evolutionary.minimizer(result))
#             println()
#         end
#     end
#     x = readline()
# end

results = open("ga_results.txt", "w");
write(results, "############### ALGORITMO GENÉTICO ###############\n\n")
for i = 1:5
  for j = 1:3
    for k = 1:3
      dimensao = 2^i
      println("$i, $j, $k")
      write(results, "CASO $i\n")
      write(results, "> Dimensão: $dimensao\n")
      opts = Evolutionary.Options(abstol = 10e-18, reltol = 10e-18, iterations = 10000, time_limit = 600.0, parallelization=:thread)
      result = Evolutionary.optimize(f, zeros(dimensao), testes(i, j, k, results), opts)
      msg = "> Mínimo esperado: 0 \n"
      write(results, msg)
      msg = "> Minimizador: " * string([1/x for x = 1:dimensao]) * "\n"
      write(results, msg)
      msg = "> Mínimo encontrado: " * string(minimum(result)) * "\n"
      write(results, msg)
      msg = "> Minimizador: " * string(Evolutionary.minimizer(result)) * "\n\n"
      write(results, msg)    
    end
  end
  write(results, "\n") 
end

