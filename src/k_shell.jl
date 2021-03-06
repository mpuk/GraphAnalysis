#=
Popis
  Funkcia vrati podgraf s vrcholmi ktore patria do k_shell.

Parametre
  g : datova struktura grafu :: GenericGraph
  k : stupen k_shell :: Int64
  core_numbers : slovnik obsahujuci indexy vrcholov a ich hodnotu jadra :: Dict{Int64,Int64}()

Navratova hodnota
  : k_shell podgraf vstupneho grafu :: GenericGraph

Poznamky
  Hodnota core_numbers je volitelna, ak nieje zadana tak prislusnost jednotlivych vrcholov
  do jadier je vypocitana funkciou coreness() zo vstupneho grafu.
  
  K_shell je podgraf, v ktorom vrcholi maju hodnotu jadra == k.
=#

function k_shell(g::GenericGraph; k=nothing, core_numbers::Dict{Int64,Int64}=Dict{Int64,Int64}())

  if core_numbers == Dict{Int64,Int64}()
    core_numbers=coreness(g)
  end

  if k == nothing
    k=maximum(values(core_numbers))
  end

  verts = collect(keys(filter((key, value) -> value == k, core_numbers)))

  return get_subgraph(verts, g)

end
