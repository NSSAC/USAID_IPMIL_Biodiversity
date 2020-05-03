###########################################################################
# Calculating Boyce index
###########################################################################

library(ecospat)

# load data
df=read.csv(file='observations_predictions.csv')
#x=ecospat.boyce(fit=df$p,df$obs, nclass=0, window.w="default", res=100, PEplot = TRUE)
#x
pdf(file='boyce.pdf')
res=ecospat.boyce(fit=df$p,df$ptest, nclass=0, window.w="default", res=100, PEplot = TRUE)
title(cat('Boyce index: ',res$Spearman.cor))
res
browser()
