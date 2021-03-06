#=
Popis
  Funkcia vypocita hodnotu radiality centrality pre kazdy vrchol.

Parametre
  g : datova struktura grafu :: GenericGraph
  dist_key : nazov atributu, v ktorom je ulozene ohodnotenie hrany :: String
  normalize : parameter pre aplikovanie normalizacie :: Bool

Navratova hodnota
  radiality : slovnik s mapovanim (kluc=vrchol_grafu => hodnota=radiality) :: Dict{Int64, Float64}

Poznamky
  Implementacia tejto funkcie vyuziva schopnost poli, ktora sa nazyva list comprehension. 
  Vdaka tejto vlastnosti je mozne vykonat zlozitejsie operacie, funkcie, podmienky priamo pri tvorbe pola.
=#

function centrality_radiality_list_comprehension(g::GenericGraph; dist_key::AbstractString="weight", normalize::Bool=true)

  dia = graph_diameter(g)

  if normalize
    return radiality = [v.index => ((sum([ x!= Inf ? dia+1-x : 0.0 for x=dijkstra_shortest_paths(g, AttributeEdgePropertyInspector{Float64}(dist_key), [v]).dists])-dia-1)/(num_vertices(g) - 1))/dia for v=vertices(g)]
  elseif !(normalize)
    return radiality = [v.index => ((sum([ x!= Inf ? dia+1-x : 0.0 for x=dijkstra_shortest_paths(g, AttributeEdgePropertyInspector{Float64}(dist_key), [v]).dists])-dia-1)/(num_vertices(g) - 1)) for v=vertices(g)]
  end

end
