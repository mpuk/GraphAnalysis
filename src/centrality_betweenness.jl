#=
Popis
  Funkcia vypocita pre kazdy vrchol hodnotu jeho betweenness centrality.

Parametre
  g : datova struktura grafu :: GenericGraph
  dist_key : nazov atributu, v ktorom je ulozena vlastnost vrchola :: String
  normalize : parameter pre aplikovanie normalizacie :: Bool
  endpoints : parameter pre zahrnutie koncovych bodov :: Bool
  k : parameter pre pouzitie k vzrokov pre odhad centrality :: Int64

Navratova hodnota
  betweenness : slovnik obsahujuci mapovanie vrcholov a k nim prisluchajucich hodnot
           closeness centrality (index_vrchola => hodnota_betweenness_centrality) :: Dict{Int64, Float64}()

Poznamky
  Hodnota centrality moze byt normalizovana nastavenim parametra normalize na True/False.
  
  Pre odhad centrality je mozne urcenim parametru k pouzit k vzorkov pricom k <= pocet_vrcholov(g). Vyssia hodnota
  k ma za nasledok lepsiu avsak pomalsiu aproximaciu a naopak.

  Parametrom endpoints je mozne zahrnut do vypoctu centrality zdrojove, cielove vrcholy najkratsich ciest.
  Pri pouziti endpoints sa centralita vrcholov zvysuje v zavislosti od poctu vrcholov, ktore su dosiahnutelne
  z vrchola V a zaroven poctu vrcholov, z ktorych je vrchol V dosiahnutelny.
=#

function centrality_betweenness(g::GenericGraph; dist_key::AbstractString="weight",  normalize::Bool=true, endpoints::Bool=true, k=nothing)

    betweenness = [v.index => 0.0 for v = vertices(g)]

    if k == nothing

        vert = [v.index for v = vertices(g)]

    else

        vert = sample([v.index for v = vertices(g)], k, replace=false)

    end

    for s in vert

      S, P, sigma = assemble_shortest_paths(g, s, dist_key)

      if endpoints

        betweenness = assemble_endpoints(betweenness, S, P, sigma, s)

      else

        betweenness = assemble_basic(betweenness, S, P, sigma, s)

      end

    end

    betweenness = rescale_graph(betweenness, num_vertices(g), normalize, k)

    return betweenness

end
