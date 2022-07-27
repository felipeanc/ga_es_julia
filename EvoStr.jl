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

function testesEE(i, j, k)
  if j == 1
      s = :comma
      printstyled("Seleção: ")
      printstyled("(σ/ρ, λ)\n", color = :cyan)
  else
      s = :plus
      printstyled("Seleção: ")
      printstyled("(σ/ρ + λ)\n", color = :cyan)
  end

  if k == 1
      c = Evolutionary.average
      printstyled("Cruzamento: ")
      printstyled("Média\n", color = :cyan)
  else
      c = Evolutionary.marriage
      printstyled("Cruzamento: ")
      printstyled("Casamento\n", color = :cyan)
  end

  return ES(initStrategy = IsotropicStrategy(i),
      recombination = Evolutionary.average,
      srecombination = c,
      mutation = Evolutionary.gaussian,
      smutation = Evolutionary.gaussian,
      selection = s)
end

d = 4
result = Evolutionary.optimize(
        f,
        BoxConstraints([-d for i in 1:d], [d for i in 1:d]),
        ES(
            initStrategy = IsotropicStrategy(d),
            recombination = Evolutionary.average,
            srecombination = Evolutionary.average,
            mu = 200,
            rho = 100,
            lambda = 400,
            mutation = Evolutionary.gaussian,
            smutation = Evolutionary.gaussian,
            selection = :plus
        ),
        Evolutionary.Options(iterations = 30000, successive_f_tol = 10000)
    )

println(result)
# for i = 1:5
#   for j = 1:3
#       for k = 1:2
#           dimensao = 2^i
#           printstyled(">Teste $i\n", color = :light_blue, blink = true)
#           result = Evolutionary.optimize(f, zeros(dimensao), testesEE(i, j, k))
#           println("Dimensão: ", 2^i)
#           println("Resultado ótimo: 0, ", [1/x for x = 1:dimensao])
#           println("Iterações executadas: ", Evolutionary.iterations(result))
#           println("Resultado obtido: ", minimum(result), ", ", Evolutionary.minimizer(result))
#           println()
#       end
#   end
#   x = readline()
# end