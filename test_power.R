### test de la puissance du test t de student ###


n=c(2, 6, 8, 10, 15, 30) #tailles des échantillons
m=5      #moyenne
e=1      #ecart type
d=2      #distance max de la moyenne
ni=10000 #nombre d'itérations du test

set.seed(1)


                                                      #Itérations du t.test 

ttest_ratio = function(ne, distance, n_iteration){
  ratio = array(0, dim=c(1, 2))
  CompteAvec = 0
  CompteSans = 0
  for(i in 1:n_iteration){
    echA = rnorm(ne, m, e)
    echB = rnorm(ne, m+distance, e)
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
deltas=NULL
delta=seq(0.2,d,0.2)
for (i in n){
  for (j in delta){
    ratio = append(ratio, ttest_ratio(i, j, ni)[1])
    ratioW = append(ratioW, ttest_ratio(i, j, ni)[2])
    names = append(names, paste("echB_n", i, "_d", j, sep = ""))
    size = append(size, i)
    deltas = append(deltas, j)
  }
}
liste = list(size,deltas,ratio, ratioW)
table_ratio=data.frame(liste)
colnames(table_ratio)=c("size", "delta", "ttest", "welch")
rownames(table_ratio)=names
print(table_ratio)


#export data to excel

write_xlsx(table_ratio,"D:\\Data\\Fac\\L3\\S6\\Info-Stat\\Stat\\Project - Welch\\PowerR.xlsx")


#Représentation des résultats

# windows()
# par(mfrow=c(2, 3))
# p = ggplot() +
#       geom_point(data = table_ratio, aes(x = delta, y = ttest)) +
#       geom_point(data = table_ratio, aes(x = delta, y = welch)) +
#       geom_line(data = table_ratio, aes(x = delta, y = ttest), size = 0.8, colour = "darkred") +
#       geom_line(data = table_ratio, aes(x = delta, y = welch), size = 0.8, colour = "steelblue") +
#       theme_bw() +
#       xlab('factors') +
#       ylab('power')







