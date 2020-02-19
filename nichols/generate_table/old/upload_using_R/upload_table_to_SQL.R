load("strain1_strain2_pcc_spearman_manyMI.RData")

library(RMySQL)

#I suspect the incomplete upload of table to SQL is due to timeout of connection. Therefore I slice the df into 2 and do it in 2 steps:
#!(1/9/2020: paritioning doesn't work. Nor did using monotonic rows that have the same row number)

total=7914231
partition_size=10000

subset_=1:partition_size
df=strain1_strain2_pcc_spearman_manyMI[subset_,]
#================================================================================================================
#Connect DB 
con = dbConnect(MySQL(), user='peterwu1230', password='G45fd8YI', dbname='chemgen', host='127.0.0.1',port=3308)

#If the table doesn't exist, it will be created
dbWriteTable(con, name='strain_similarities', value=df,overwrite=T)
dbDisconnect(con)
#================================================================================================================


i=1
while(tail(subset_)[6]<total){
  
  subset_=subset_+partition_size
  if(tail(subset_)[6]>total) subset_=subset_[1]:total
  df=strain1_strain2_pcc_spearman_manyMI[subset_,]
  #================================================================================================================
  #Connect DB 
  con = dbConnect(MySQL(), user='peterwu1230', password='G45fd8YI', dbname='chemgen', host='127.0.0.1',port=3308)
  
  #If the table doesn't exist, it will be created
  dbWriteTable(con, name='strain_similarities', value=df,append=TRUE)
  dbDisconnect(con)
  #================================================================================================================
  
  cat(paste0("partition ",i," done"))
  i=i+1
}







