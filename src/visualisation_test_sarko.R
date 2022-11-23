#first attempt at visualising overlap in maps with dplyr intersect and setdiff
#functions. let's try Merkel
##  relevante perioden 
#p0 <-interval(start = ymd (1945-01-01), end = ymd(2009-11-04))
#p1 <-interval(start = ymd (2009-11-05), end = ymd(2010-05-01))
#p2 <-interval(start = ymd (2010-05-02), end = ymd(2012-07-25))
#p3 <-interval(start = ymd (2012-07-26), end = ymd(2014-12-31))
#p4 <-interval(start = ymd (2015-01-01), end = ymd(2015-06-07))
#p5 <-interval(start = ymd (2015-06-08), end = ymd(2015-12-31))


#upload all packages
library(tidyverse)
library(igraph)
library(tidygraph)
library(ggraph)
library(visNetwork)

#load data
sumvalue_weighted_edges_leaders <- read.csv ("data/raw/sumvalue_weighted_edges_leaders.csv")
nodes_leaders_idecointvalinstr <- read.csv("data/raw/nodes_leaders_idecointvalinstr.csv")

#activate select_maps_make_list function
source("src/select_speaker_period_make_lists.R")

# check names & copy in
unique(sumvalue_weighted_edges_leaders$speaker)

#apply function and store the output
sarkozy_p1_p2_nodelist <- select_speaker_period_make_lists ("Sarkozy Nicolas", "2009-11-05", "2012-07-25")[[1]]  #Saving nodelist
sarkozy_p1_p2_edgelist <- select_speaker_period_make_lists ("Sarkozy Nicolas", "2009-11-05", "2012-07-25")[[2]]  

#dan moet je eerste de date nog in date format zetten
sarkozy_p1_p2_edgelist$map_date <- as.Date (sarkozy_p1_p2_edgelist$map_date)

str(sarkozy_p1_p2_edgelist)  #klopt 

# periode aan datum plakken want hieronder lijkt het anders niet goed te werken
sarkozy_p1_p2_edgelist <- sarkozy_p1_p2_edgelist %>% 
  mutate(period = ifelse(map_date<"2010-05-01", 1, 2))

# dan de calculaties doen, functie oproepen
source("src/calc_degrees_goW.R")

#apply function and store the nodes_calc list
#dit gaat dus mis als je de map per periode wilt vergelijken.
#nu calculeert hij de degrees etc over de hele map niet per periode
#ik ga nu even door omdat ik eigenlijk met de visualisatie bezig was
#maar voor de overlap moet dit dus anders en wel per map uitgerekend worden
node_calc_sarkozy_p1_p2 <- calc_degrees_goW(sarkozy_p1_p2_edgelist, sarkozy_p1_p2_nodelist)

##### visNetwork#####
# dit package heeft de juiste lay-out voor mij
# het struikelt over bepaalde col names
# je moet info in de edge & nodelist zetten om het te visualiseren ipv in de code toe te voegen

# start met een cm make van edge en node_calc list

cm_sarkozy_p1_p2 <- visNetwork(sarkozy_p1_p2_edgelist, node_calc_sarkozy_p1_p2)

#de colname "value" in mijn node_calc list geeft een probleem. 
#deze term is gereserveerd voor de grootte van de nodes
# mijn value een andere naam geven
nodes <- node_calc_sarkozy_p1_p2 %>% 
  rename(evaluation = value) %>% #rename, eerst de nieuwe naam, dan de oude
  rename(label = node_name) #om labels in de cm te krijgen moet col node_name, label heten

#Wdegree omzetten naar value, deze keer met mutate zodat scaling mogelijk wordt
# range w_degree is nu 1-25 dus /5+1 lijkt een goede scaling
nodes <- mutate(nodes, value = w_degree/5 + 1)

#eens kijken als ik eco omzet naar group, of hij de kleuren wel doet
# nodes <- mutate(nodes, group = eco) #meest simpele manier, maar dan gaat hij zelf inkleuren 
# dus beter in de tekenformule doen en dan kun je ook switchen tussen eco en int 
# alle na naar Neutral zetten
nodes$eco[nodes$eco==""] <- "Neutral"
nodes$int[nodes$int==""] <- "Neutral"
nodes$instr[nodes$instr==""] <- "Neutral"

#liever dan de kleur, wil ik graag de shape voor ordo en keyn aanpassen
#dus dan moet ik een col shape aanmaken obv eco of nu dan group, 

nodes <- nodes %>% 
  mutate(shape = case_when(
      eco == "Ordoliberal" ~ "square",
      eco == "Keynesian" ~ "triangleDown",
      eco == "Neutral" ~ "dot"))

#dit kan ik dan niet zomaar varieren per dimensie, of kan ik shape int aanmaken?
nodes <- nodes %>% 
  mutate(shape_int = case_when(
    int == "Intergovernmental" ~ "square",
    int == "Supranational" ~ "triangleDown",
    int == "Neutral" ~ "dot"))

# je wilt straks clusteren op group met instr, dus instr > group
nodes <- nodes %>% 
  mutate(group = instr)

# maak een lijst vne de instr namen
linstr <- unique(nodes$instr)
# nr 1 is de neutral, eraf halen
# maar als je hem laat staan, kun je de relaties tussen de instrumenten zien
# bij Sarkozy zie je dat alleen eco stim een relatie heeft met een ander instrument:
# leidt to struct reforms. De rest heeft alleen effect op de neutral categorie
# zo zou je dus ook de crisis concepten kunnen groeperen - interessant

linstr <- linstr[2:6]
  
#er is meer mogelijk: https://www.rdocumentation.org/packages/visNetwork/versions/2.1.0/topics/visNodes


#ook aan de edgelist moet je col aanpassen om te doen wat je wilt
#title geeft het label van de edge als je er met je cursor boven hangt
#ik neem edge_value, dit is weight en sign samen
edges <- sarkozy_p1_p2_edgelist %>% 
  rename(title = edge_value) 

#width attribute does not scale the values, so we have to do this manually
#voorbeeld om col toe te voegen met scaling: edges <- mutate(edges, width = weight/5 + 1)
#is dat nodig bij mijn data? ja, maar het moet groter ipv kleiner
# de column hiervoor moet blijkbaar value heten
edges <- mutate(edges, value = weight/5+1)

#laat is dashed lines doen als het p2 is, gaat blijkbaar met true false
edges <- mutate(edges, dashes = (ifelse(period == "2", TRUE, FALSE)))

#ik wil gekleurde edges afhankelijk van - of + of 0
edges <- edges %>% 
  mutate(
    color = case_when (
      title > 0 ~ "green",
      title == 0 ~ "black",
      title < 0 ~ "red"))

#ik wil geen label, maar dit kan wel maar moet dus een characterstring zijn
#edges <- edges %>% 
#  mutate(label = case_when(
#    title > 0 ~ "pos",
#    title == 0 ~ "null",
#    title < 0 ~ "neg"))

# add legends for both nodes and edges, edges first
ledges <- data.frame(color = c("green", "red", "black"),
                     label = c("positive", "negative", "neutral"))

# then for the nodes
lnodes_eco <- data.frame(shape = c("square", "triangleDown","dot"),
                         label = c("Ordoliberal", "Keynesian", "Neutral"))

lnodes_int <- data.frame(shape = c("square", "triangleDown","dot"),
                         label = c("Intergovernmental", "Supranational", "Neutral"))


# things to set in the drawing code, are thing that do not vary:
  # width and height of the picture
  # title of the graph
  # size and color of the nodes
  # arrows: direction, scale factor
  # Options: can you select certain nodes
  # Lay-out: type, separation & fixed(randomseed)
  # interactie opties

#kijken of level werkt met gow in de hierarchical layout, yes, wow.
nodes <- nodes %>% 
  rename(level = gow)

#eens proberen wat er gebeurt, als je wilt bewaren zet ervoor: cognitive_map <- 
 visNetwork(nodes, edges, width = "100%", height = "600px", 
           main = "Cognitive Map of Nicolas Sarkozy",
           submain = "combined CM of period 1 and 2",
           footer = "solid line: period 1, dashed line: period 2") %>% 
  visNodes(color = "lightblue") %>%
  visEdges(shadow = TRUE,
          arrows =list(to = list(enabled = TRUE, scaleFactor = 2))) %>%
   visOptions(selectedBy = "eco", 
            nodesIdSelection = TRUE) %>%   #alleen karakteristieken van de Node, period gaat dus niet
  visLegend(addEdges = ledges, addNodes = lnodes_eco, useGroups = FALSE) %>% 
  visIgraphLayout(layout = "layout_nicely") %>% 
  visClusteringByGroup(groups = linstr) %>% 
  visInteraction(dragNodes = TRUE,
                 dragView = TRUE,
                 zoomView = TRUE,
                 navigationButtons = TRUE) %>% 
  visLayout(randomSeed = 12) # to have always the same network
  
# cm opslaan
cognitive_map %>% visSave(file = "results/cognitive_map.html")

# containers are real big, let's check
instr <- nodes %>% group_by(instr) %>% 
  summarise(sum=sum(w_degree),
            .groups = 'drop')


####################################################
# hierarchical layout, met gow als levels: 
# visHierarchicalLayout(direction = "LR", levelSeparation = 800) %>% 
# met VisIgraphLayout() kun je nodes verplaatsen zonder dat ze terugschieten
# je kunt de gelinkte nodes highlighten als je er met je cursor overheen gaat:
# met ik vind het niks.
# je kunt ook iets met collapse, maar ik zie niet wat hij precies doet



nodes <- data.frame(id = 1:4, group = sample(c("ordo", "keyn")))
edges <- data.frame(from = c(2,4,3,2), to = c(1,2,4,3)) 

visNetwork(nodes, edges, width = "100%") %>% 
  visNodes(shape = "circel",
           font = "25px arial darkblue") %>%
  visEdges(shadow = TRUE,
           arrows =list(to = list(enabled = TRUE, scaleFactor = 2)),
           color = list(color = "lightblue", highlight = "red")) %>%
  visGroups(groupname = "ordo") %>% 
  visGroups(groupname = "keyn") %>% 
  visHierarchicalLayout(direction = "RL", levelSeparation = 300) %>% 
  visClusteringByGroup(groups = c("ordo")) %>%
visLayout(randomSeed = 12) # to have always the same network   



