#=
Popis
  Funkcia vypocita priemernu hodnotu z najkratsich ciest v grafe.

Parametre
  g : datova struktura grafu :: GenericGraph
  dist_key : nazov atributu, v ktorom je ulozene ohodnotenie hrany :: String
  components : parameter pre prepinanie graf/komponent :: Bool

Navratova hodnota
  avg_distance : priemerna hodnota najkratsej cesty pre cely graf :: Float64
  avg_distance : slovnik s mapovanim (komponent_grafu => avg_distance) :: Dict{Array{ExVertex,1},Float64}

Poznamky
  Priemernu hodnotu najkratsej cesty je mozne nastavenim parametra components vypocitat bud pre cely graf
  alebo pre jednotlive komponenty.
=#

function average_shortest_distance(g::GenericGraph; dist_key::AbstractString="weight", components::Bool=false)
  
  epi = AttributeEdgePropertyInspector{Float64}(dist_key)

  if components
    
    comp = connected_components(g)
    avg_distance = [v => 0.0 for v = comp]
    paths = Float64[]

    for vector in comp

      for v in vector

        paths = [filter(x -> x != Inf, dijkstra_shortest_paths(g, epi, [v]).dists) for v = vector ]

      end

      avg_distance[vector] = sum([sum(x) for x = paths]) / (length(vector)*(length(vector) - 1))
      empty!(paths)

    end

    return avg_distance
    
  elseif !(components)
    
    avg_distance = 0.0
    paths = [filter(x -> x != Inf, dijkstra_shortest_paths(g, epi, [v]).dists) for v = vertices(g) ]
    avg_distance = sum([sum(x) for x = paths]) / (length(vertices(g))*(length(vertices(g)) - 1))
    
    return avg_distance
    
  end

end
