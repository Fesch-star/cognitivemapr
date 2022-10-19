# EVALUATION uitrekenen in edgelist - MOETEN NOG LOOPS IN 
Evaluation_step <- function(edgelist, nodelist){

#evaluation calculations - HIER ZOU LOOP BEGINNEN 
edgelist$val_xt1 <- edgelist$value.y*edgelist$edge_value #xt1 berekeken
edgelist$val_xt1 <- edgelist$val_xt1/sqrt(edgelist$val_xt1 ^2) #xt1 unweighted maken
edgelist$val_xt1[is.na(edgelist$val_xt1)] <- 0 #nan omzetten in 0

# xt1 values met ID in een df zetten
xt1 <- edgelist[,c("from", "val_xt1")]

#nu moeten de xt1 scores per ID worden opgeteld - opgeslagen in xt1
xt1 <- xt1 %>%
  group_by(from) %>%
  summarise (val_xt1_sum = sum(val_xt1))

#moeten nog unweighted gemaakt worden
xt1$val_xt1_sum <- xt1$val_xt1_sum/sqrt(xt1$val_xt1_sum ^2)

# en nan vervangen door 0
xt1$val_xt1_sum[is.na(xt1$val_xt1_sum)] <- 0


#HIER GA JE VALUE Y AANPASSEN: rename from=to en x=y
xt1_to_yt1 <-
  rename(xt1, to = from)

xt1_to_yt1 <-   
  rename(xt1_to_yt1, val_yt1 = val_xt1_sum)

#dan moet dit gejoined worden met edgelist
edgelist <- edgelist %>% 
  left_join(xt1_to_yt1, by = c("to" = "to"))

#na vervangen door value.y (DUS WAAR Y ALLEEN TO IS EN NIET TOT DE LIJST FROM BEHOORT)
edgelist$val_yt1[is.na(edgelist$val_yt1)] <- edgelist$value.y[is.na(edgelist$val_yt1)]


#nu moeten values naar nodeslist  en kijken of consistent is over de from/to lijsten. Voor x staan waarden in xt1
#naam val veranderen
xt1 <- rename (xt1,val_run1 = val_xt1_sum)

xt1 <- rename (xt1,id = from)

yt1 <- unique(edgelist[, c("to", "val_yt1")]) %>% #haal unieke yt1 uit tabel met ids
  rename (val_run1 = val_yt1) %>% 
  rename (id=to)

node_val_run1 <- merge(xt1, yt1, all=TRUE) #merge xt2 en yt1 dfs alles behouden, overlap samenvoegen

nodelist <- nodelist %>% 
  left_join(node_val_run1, by = "id") #node_val_run1 aan nodelist binden

edgelist$value.x <- edgelist$val_xt1
edgelist$value.y <- edgelist$val_yt1

edgelist <- select(edgelist, -c(val_xt1, val_yt1))

return(list(edgelist, nodelist))
}

