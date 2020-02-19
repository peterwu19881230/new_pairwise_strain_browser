#run this via terminal. cd into this folder first

source("https://raw.githubusercontent.com/peterwu19881230/R_Utility/master/functions.R")

load("Data/strain1strain2_allDistances.RData")
load("Data/id_allAttributes.RData")
load("Data/All_Data_NAimputed.RData")


id_ECK=unique(id_allAttributes[,c("ids","ECK")])
id_ECK['ids']=as.numeric(id_ECK[,'ids'])


strain1_strain2_pcc_spearman_manyMI=strain1strain2_allDistances[,c("strain1","strain2",
                                                                   "pcc","spearman","mi","mi_ternary","mi_ternary_collapsedCond")]

#pcc and spearman here are correlation based distance, so I have to re-calculate to get real coefficients

pcc=(melt_dist(as.dist( (cor(t(All_Data_NAimputed))))))$value 
spearman=(melt_dist(as.dist(cor(t(All_Data_NAimputed),method="spearman"))))$value

strain1_strain2_pcc_spearman_manyMI['pcc']=pcc
strain1_strain2_pcc_spearman_manyMI['spearman']=spearman

#mi, ternary_mi and mi_ternary_collapsedCond are now all similarity based distance. I have to convert them back to original mi
strain1_strain2_pcc_spearman_manyMI$mi=1-strain1_strain2_pcc_spearman_manyMI$mi
strain1_strain2_pcc_spearman_manyMI$mi_ternary=1-strain1_strain2_pcc_spearman_manyMI$mi_ternary
strain1_strain2_pcc_spearman_manyMI$mi_ternary_collapsedCond=1-strain1_strain2_pcc_spearman_manyMI$mi_ternary_collapsedCond

#I had to use the following round2() function because the original round() in R doesn't process 0.5 -> 1 but 0.5 ->0(ref: https://stackoverflow.com/questions/12688717/round-up-from-5)
round2 = function(x, n) {
  posneg = sign(x)
  z = abs(x)*10^n
  z = z + 0.5
  z = trunc(z)
  z = z/10^n
  z*posneg
}


count=0
for(similarity in strain1_strain2_pcc_spearman_manyMI[,c("pcc","spearman","mi","mi_ternary","mi_ternary_collapsedCond")]){
  strain1_strain2_pcc_spearman_manyMI[[3+count]]=round2(similarity,4)
  count=count+1
}



ECK_index_1=base::match(strain1strain2_allDistances[,'strain1'],id_ECK[,'ids'])
ECK_index_2=base::match(strain1strain2_allDistances[,'strain2'],id_ECK[,'ids'])

strain1_strain2_pcc_spearman_manyMI['strain1']=id_ECK[['ECK']][ECK_index_1]
strain1_strain2_pcc_spearman_manyMI['strain2']=id_ECK[['ECK']][ECK_index_2]

#correct the escape character issue (there are ' in some ECKs). They seem to mean nothing, so I will just remove them
strain1_strain2_pcc_spearman_manyMI$strain1=stringr::str_replace_all(strain1_strain2_pcc_spearman_manyMI$strain1,"'","")
strain1_strain2_pcc_spearman_manyMI$strain2=stringr::str_replace_all(strain1_strain2_pcc_spearman_manyMI$strain2,"'","")


names(strain1_strain2_pcc_spearman_manyMI)[1:2]=c("Strain 1","Strain 2")




#save(strain1_strain2_pcc_spearman_manyMI,file="strain1_strain2_pcc_spearman_manyMI.RData")

chunk2 = function(x,n) split(x, cut(seq_along(x), n, labels = FALSE)) #https://stackoverflow.com/questions/3318333/split-a-vector-into-chunks-in-r

total_length=dim(strain1_strain2_pcc_spearman_manyMI)[1]
n=5
partitions=chunk2(seq(total_length),n)

i=1
for(parition in partitions){
  dat=strain1_strain2_pcc_spearman_manyMI[parition,]
  file_name=paste0("Data/strain1_strain2_pcc_spearman_manyMI_",i,".txt")
  write.table(dat,file=file_name,row.names=F,sep="\t") 
  i=i+1
}


