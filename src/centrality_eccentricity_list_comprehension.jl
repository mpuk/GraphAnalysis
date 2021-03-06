#=
Popis
  Funkcia vypocita hodnotu eccentricity centrality pre kazdy vrchol.

Parametre
  g : datova struktura grafu :: GenericGraph
  dist_key : nazov atributu, v ktorom je ulozene ohodnotenie hrany :: String

Navratova hodnota
  eccentricity : slovnik s mapovanim (kluc=vrchol_grafu => hodnota=eccentricita) :: Dict{Int64, Float64}

Poznamky
  Implementacia tejto funkcie vyuziva schopnost poli, ktora sa nazyva list comprehension. 
  Vdaka tejto vlastnosti je mozne vykonat zlozitejsie operacie, funkcie, podmienky priamo pri tvorbe pola.
=#

function centrality_eccentricity_list_comprehension(g::GenericGraph; dist_key::AbstractString="weight")
  
  return eccentricity = [ v.index => (z = 1.0/maximum(filter(x -> x != Inf, dijkstra_shortest_paths(g, AttributeEdgePropertyInspector{Float64}(dist_key), [v]).dists))) == Inf ? 0.0 : z  for v = vertices(g) ]

end
