#check whether the GetAncestorDistance function works
#test with another map 
library(readr)
library(tidyverse)
library(igraph)
library(tidygraph)
library(ggraph)
library(visNetwork)

#Get raw data
nodes_leaders_idecointvalinstr <- read_csv("data/raw/nodes_leaders_idecointvalinstr.csv")
sumvalue_weighted_edges_leaders <- read_csv("data/raw/sumvalue_weighted_edges_leaders.csv")

#make edge node lists for Rutte
#get function
source(select_speaker_period_make_lists()) #check does not run automatically
#make lists
rutte_p2_nodelist <- select_speaker_period_make_lists ("Rutte Mark", "2010-05-01", "2012-07-25")[[1]]  #Saving nodelist
rutte_p2_edgelist <- select_speaker_period_make_lists ("Rutte Mark", "2010-05-01", "2012-07-25")[[2]]  #Saving edgelist

####LATER NOG TESTEN OP CYCLISCHE MAP: ZOALS MERKELP2
#MerkelP2Map <- calc_degrees_goW(edgelist_merkel_p2, nodelist_merkel_p2)
#map <- graph_from_data_frame(d = edgelist_merkel_p2, vertices = nodelist_merkel_p2, directed = TRUE)
#AH! deze map is cyclisch daarom gaat er vanalles mis
#is.dag(map)
#maar dan geeft ie toch een diameter
#diameter(map)

#draw a map
mapRutte_p2 <- graph_from_data_frame(d = rutte_p2_edgelist, vertices = rutte_p2_nodelist, directed = TRUE)

#get diameter of graph, you do not have to do more runs than this
diameter(mapRutte_p2, directed = TRUE, unconnected = TRUE, weights = NULL)

#Als je dan ego runt met diameter als order, dan zie je het max aantal neighboors
#mmm maar je ziet de diepte niet.NOG OPLOSSEN
f <- ego(mapRutte_p2, 5,25, mode = c("in"))

#check if the graph is directed and acyclical
is_dag(mapRutte_p2)

# deciding on the target
target<- 209

# Best option to get the position of the node I am interested in
target_position <- which(rutte_p2_nodelist[,1] == target)
# deriving first ancestors
first_anc_209 <- ego(mapRutte_p2,1,target_position, "in", mindist = 1)
# provides ancestors of one node, which I need
# mindist = 1, returns 0 for the target node>get eliminated in next step
# this maintains all attributes, which I need? You need the value=evaluation

# this derives the positions of the 1st level anc nodes
first_anc_209_position <- unlist(first_anc_209)

#get the ids for first_anc, may need later(?):
first_anc_209 <- rutte_p2_nodelist[c(first_anc_209_position),] #returns a df with all nodes info
# well that gives you the value/evaluation, might as well retain it

# and add distance column with distance 1
first_anc_209['Distance']= 1

#find the ancestors of the first ancestors > are the second ancestors
second_anc_209 <- vector(mode = "numeric", length = 0)# lege vector om in op te slaan
for (i in first_anc_209_position) {
  current_anc <- ego(mapRutte_p2,1,i,"in", mindist = 1)
  # The current_anc vector holds all the direct antecedents found in this run of the loop.
  second_anc_209 <- append(second_anc_209, current_anc)
} 
# interesting gives a list with the 2nd anc embedded with the 1st
# but I do not know how to unlist/unembeded maintaining that info

# this derives the positions of the 2nd level anc nodes
second_anc_209_position <- unlist(second_anc_209)

#get the ids for second_anc, may need later(?
second_anc_209 <- rutte_p2_nodelist[c(second_anc_209_position),] #returns a df with all nodes info
# well that gives you the value/evaluation, might as well retain it

# and add distance column with distance 2
second_anc_209['Distance']= 2

#starting to think I should actually get this stuff from the edgelist not the nodeslist
edges_209 <- which(rutte_p2_edgelist$to == target)
# but you need to do the previous stuff to know the second ancestors
# so get the id and then the edges from edgelist
###############
##############HIER BEN JE GEBLEVEN,second_anc_209[,1]

test <- as.data.frame(do.call(cbind, second_anc_209))
test2 <- as.data.frame(do.call(rbind, second_anc))
unlist(second_anc)# hier gooit hij dus de volgorde door elkaar
#maar die list van 3: daar zit 609 dus wel mooi achter 195 - hoe krijg ik dat er uit?
# en had ik dit al nog bij ego, order 2? Nope, toch niet

ego_order2 <- ego(mapRutte_p2,2,25, "in")
b <- ego(mapRutte_p2,1,a, "in") #werkt ook :)
ego_size(mapRutte_p2,2,25, "in") #geeft hoeveel nodes het zijn incl eigen node

distances(mapRutte_p2, 25, c())
Rutte_distance <- distance(mapRutte_p2)
get.all.shortest.paths()


#reserve-bank

#neighborhood(mapRutte_p2,2, mode = ("in"))
#neighborhood geeft alle aanverwante nodes, dit rangschikt hij op volgorde van de nodeslist
# niet op mijn node-id, als je mode=ïn" doet, geeft hij alleen ancestors
# cijfer 1 of 2 etc geeft de diepte. Daarmee zou ik dus de distance kunnen berekenen
# maar ik heb nog steeds niet een pad en hij maakt lists van lists - zucht
# maar als eerste geeft hij wel de node zelf, dat is wel handig. 
# kan ik een matrix van de list van lists maken? dan hoef ik in principe maar 1 lijn terug steeds
# ff andere functies uitproberen# but how do I make a df out of the list of lists?
# first, find out automatically what the row is of the concept you are interested in
# a <- which(grepl ("^8$", rutte_p2_nodelist$id)) # werkt die gekke tekens moeten erbij
# want anders pakt hij alles waar een 8 in zit dus ook 78 oid
# a <- which(grepl("Euro-crisis", rutte_p2_nodelist$node_name)) #werkt ook 
#kijken of de ChatGpt versie ook werkt, nope

# try the original function - did not work for Merkel, works for Rutte2
# why?

#Anc_209 <- GetAncestors(rutte_p2_edgelist, 209) #

#check map if anc for Rutte are correct
#dit klopt maar hij geeft de verste als eerste en de derde is de intermediary - niet logisch dus
#dit kan makkelijker met de neighboorhood en ego functies uit igraph
#source(GetAncestorDistance())

#Anc_Dist_209 <- GetAncestorsDistance(rutte_p2_edgelist, 209)

#source("src/calc_degrees_goW.R")


#node_calc_Rutte_p2 <- calc_degrees_goW(rutte_p2_edgelist, rutte_p2_nodelist)
#does not work either

#edgelist aanpassen, alles eruit behalve de edges helpt niet
#er lijkt ook geen sprake van een package dat ik mis


#okay let's go step by step, does not get me very far:


#eerste ronde is gewoon uit de edgelist te halen:
targets <- unique(edgelist_merkel_p2[,2]) #extract only the 'to' nodes 
GoalConcept <- 39 #This is the concept for which we want to know the ancestors
Ancestors <- edgelist_merkel_p2[edgelist_merkel_p2$to == GoalConcept,] #df met alleen de ancestors van 39

#dan moeten we gaan loopen door die 1e ancestors
  Index <- vector(mode = "numeric", length = 0)
  Index <- which(edgelist_merkel_p2$to == GoalConcept)# F...dit geeft rijnummer niet de ancestor
  FirstLevelAncestors <- unlist(edgelist_merkel_p2[c(Index),"from"]) #Hiermee kun je ze wel achterhalen
  #die staan dan dus al in de Ancesters df hierboven
 
  #this is the part that gets you the secondlevel ancestors
  Secondlevel <- vector(mode = "numeric", length = 0)
 

  #dan de for-loop       
  for (i in 1:length(FirstLevelAncestors)) {
    Secondlevel <- which(edgelist_merkel_p2[,2] == FirstLevelAncestors[i])
                        } #hij slaat de rijen in df op ipv de ancestor

#hiermee kun je dan dus weer de ancestors krijgen
  SecondLevelAncestors <- unlist(edgelist_merkel_p2[c(Secondlevel),"from"])
  
   #dan die rijen isoleren uit de edgelist
  for (i in 1:length(Secondlevel)) {
    Ancestors <- edgelist_merkel_p2[edgelist_merkel_p2$to == Secondlevel[i],]
  } 

  ## hier ben je
  ### DIT GAAT NERGENS HEEN: Kijk op https://kateto.net/networks-r-igraph VOOR een GRAPH BASED METHODE
  
 
  
#dat is per ongeluk handig want daarmee kan ik die hele rijen uit de df halen
Ancestors2 <- edgelist_merkel_p2[c(SecondLevelAncestors),]    

  ThirdLevelAncestors<- vector(mode = "numeric", length = 0) #dit wordt dus niks,  dit moet ik gaan loopen.                         

  #dan de for-loop       
  for (i in 1:length(SecondLevelAncestors)) {
    Thirdlevel <- which(edgelist_merkel_p2[,2] == SecondLevelAncestors[i])
    ThirdLevelAncestors <- append (ThirdLevelAncestors, Thirdlevel)
  } #hij slaat de rijen in df op ipv de ancestor                        
                                   Ancestors <- data.frame(FirstLevelAncestors, SecondLevelAncestors)#werkt neit want niet evenveel rijen/cols
### tot hier ben je  
  
  AllSecondLevelAncestors <- apply(seq_along (i in 1:length((FirstLevelAncestors))), function (i) {
    SecondLevelAncestors <- which(edgelist_merkel_p2[,2] == FirstLevelAncestors[i]
                                  distances <- 1
  }
  do.call(rbind, AllSecondLevelAncestors)
  rm(i)
  
  
  finishedAncestors <- vector(mode = "numeric", length = 0)
  distances <- c(node=0)
  
  while(length(intersect(unfinishedTargets, targets)) > 0) {
    newAncestors <- vector(mode = "numeric", length = 0)
    for(i in 1:length(unfinishedTargets)) {
      indexVector <- which(arcs[,2] == unfinishedTargets[i])
      if (length(indexVector) > 0) {
        for (j in 1:length(indexVector)) {
          currentAnc <- arcs[indexVector[j],1]
          newAncestors <- append(newAncestors, currentAnc)
          finishedAncestors <- append(finishedAncestors, newAncestors)
        }
      }
    }
    distances <- c(distances, rep(distances[unfinishedTargets]+1,length(newAncestors)))
    unfinishedTargets <- unique(newAncestors)
    cat("Ancestors found:", length(unique(finishedAncestors)), "\r")
  }
  
  return(list(ancestors=sort(unique(finishedAncestors), decreasing = TRUE), distances=distances[sort(finishedAncestors, decreasing = TRUE)]))
}

#asking ChatGPT to correct the code, it said: The code appears to be encountering 
#an issue because the finishedAncestors vector is being appended to with 
#newAncestors on every iteration of the loop, rather than with the newly found 
#ancestor. The corrected code is as follows:
GetAncestorsDistanceNew <- function (arcs, node) {
  targets <- unique(arcs[,2])
  unfinishedTargets <- node
  finishedAncestors <- vector(mode = "numeric", length = 0)
  distances <- c(node=0)
  
  while(length(intersect(unfinishedTargets, targets)) > 0) {
    newAncestors <- vector(mode = "numeric", length = 0)
    for(i in 1:length(unfinishedTargets)) {
      indexVector <- which(arcs[,2] == unfinishedTargets[i])
      if (length(indexVector) > 0) {
        for (j in 1:length(indexVector)) {
          currentAnc <- arcs[indexVector[j],1]
          newAncestors <- append(newAncestors, currentAnc)
        }
      }
    }
    finishedAncestors <- sort(unique(c(finishedAncestors,newAncestors)))
    distances <- c(distances, rep(distances[unfinishedTargets]+1,length(newAncestors)))
    unfinishedTargets <- unique(newAncestors)
    cat("Ancestors found:", length(unique(finishedAncestors)), "\r")
  }
  
  return(list(ancestors=sort(unique(finishedAncestors), decreasing = TRUE), distances=distances[sort(finishedAncestors, decreasing = TRUE)]))
}

#did not work, asked for alternative
GetAncestorsDistance3 <- function (arcs, node) {
  targets <- unique(arcs[,2])
  unfinishedTargets <- node
  finishedAncestors <- vector(mode = "numeric", length = 0)
  distances <- c(node=0)
  
  while(length(intersect(unfinishedTargets, targets)) > 0) {
    newAncestors <- vector(mode = "numeric", length = 0)
    for(i in 1:length(unfinishedTargets)) {
      indexVector <- which(arcs[,2] == unfinishedTargets[i])
      if (length(indexVector) > 0) {
        for (j in 1:length(indexVector)) {
          currentAnc <- arcs[indexVector[j],1]
          newAncestors <- append(newAncestors, currentAnc)
        }
      }
    }
    finishedAncestors <- c(finishedAncestors, newAncestors)
    distances <- c(distances, rep(distances[unfinishedTargets]+1,length(newAncestors)))
    unfinishedTargets <- unique(newAncestors)
    cat("Ancestors found:", length(unique(finishedAncestors)), "\r")
  }
  
  return(list(ancestors=sort(unique(finishedAncestors), decreasing = TRUE), distances=distances[sort(finishedAncestors, decreasing = TRUE)]))
}

