options(stringsAsFactors = FALSE)

file_index=1:5
for(i in file_index){
  if(!exists("dat")){
    dat=read.table(paste0("strain1_strain2_pcc_spearman_manyMI_",i,".txt"),header = T)    
  }else{
    dat=rbind(dat,
              read.table(paste0("Data/strain1_strain2_pcc_spearman_manyMI_",i,".txt"),header = T))
  }
}

file_name="strain1_strain2_pcc_spearman_manyMI.txt"
write.table(dat,file=file_name,row.names=F,sep="\t") 