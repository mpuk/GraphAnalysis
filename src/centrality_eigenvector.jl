#=
Popis
  Funkcia vypocita pre kazdy vrchol hodnotu jeho eigenvector centrality.

Parametre
  g : datova struktura grafu :: GenericGraph
  dist_key : nazov atributu, v ktorom je ulozena vlastnost vrchola :: String

Navratova hodnota
  eigenvector : slovnik obsahujuci mapovanie vrcholov a k nim prisluchajucich hodnot
           eigenvector centrality (index_vrchola => hodnota_eigenvector_centrality) :: Dict{Int64, Float64}()

Poznamky
  Eigen vector a eigen hodnoty su pocitane pomocou externeho procesu. Vzhladom na problemy implementacie
  je vysledok vypoctu nedeterministicky. Graf nesmie obsahovat paralelne hrany.
=#

function centrality_eigenvector(g::GenericGraph; dist_key::AbstractString="weight")
  
  if GraphAnalysis.contains_parallel_edges(g)
      println("Graf obsahuje paralelne hrany!")
      return false
  end

  matrix = sparse(weight_matrix(g,map(x->x.attributes[dist_key],edges(g))))
  matrix = matrix+matrix'

  (d, v) = eigs(matrix, nev=1, which=:LR, maxiter=50)

  largest = vec(v)
  x = vecnorm(largest)
  map!(v -> real(v), largest)
  norm = sign(sum(largest))*x

  eigenvector = DataStructures.OrderedDict(zip([v.index for v=vertices(g)],map(float,largest/norm)))

  return eigenvector

end
