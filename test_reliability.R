### test de la fiabilité du test t de student ###


n=c(2, 6, 8, 10, 15, 30) #tailles des échantillons
e=1      #ecart type de base
f=4      #facteur multiplicateur max
s=0.5    #step des facteurs
ni=10000 #nombre d'itérations du test

set.seed(1)


                                                        #Itérations du t.test 

ttest_ratio = function(ne, facteur, n_iteration){
  ratio = array(0, dim=c(1, 2))
  CompteAvec = 0
  CompteSans = 0
  for(i in 1:n_iteration){
    echA = rnorm(ne, 0, e)
    echB = rnorm(ne, 0, e*facteur)
    if (t.test(echA, echB, var.eq = FALSE)$p.value < 0.05){
      CompteAvec = CompteAvec + 1
    }
    if (t.test(echA, echB, var.eq = TRUE)$p.value < 0.05){
      CompteSans = CompteSans + 1  
    }
  }
  ratio[,1] = CompteSans / n_iteration
  ratio[,2] = CompteAvec / n_iteration
  return(ratio)
}


                                        #Permutations for t.test with Welch correction

ratio = vector()
ratioW = vector()
names = NULL
size=NULL
factors=NULL
factor=seq(1,f,s)
for (i in n){
  for (j in factor){
    ratio = append(ratio, ttest_ratio(i, j, ni)[,1]*100)
    ratioW = append(ratioW, ttest_ratio(i, j, ni)[,2]*100)
    names = append(names, paste("echB_n", i, "_f", j, sep = ""))
    size = append(size, i)
    factors = append(factors, j)
  }
}
liste = list(size, factors, ratio, ratioW)
table_ratio=data.frame(liste)
colnames(table_ratio)=c("size", "factor", "ttest", "welch")
rownames(table_ratio)=names
print(table_ratio)


#export data to excel file

write_xlsx(table_ratio,"C:\\User\\Username\\...\\ReliabilityR.xlsx")
