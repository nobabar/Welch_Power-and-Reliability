### Test de l'influence de la correction de Welch sur le t.test dans le cas d'échantillons à distribution normale ###



n=30     #taille max des échantillons
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
sizes=NULL
factors=NULL
size=seq(5, n, 5)
factor=seq(1,f,s)
for (i in size){
  for (j in factor){
    ratio = append(ratio, ttest_ratio(i, j, ni)[,1]*100)
    ratioW = append(ratioW, ttest_ratio(i, j, ni)[,2]*100)
    names = append(names, paste("echB_n", i, "_f", j, sep = ""))
    sizes = append(sizes, i)
    factors = append(factors, j)
  }
}
liste = list(sizes, factors, ratio, ratioW)
table_ratio=data.frame(liste)
colnames(table_ratio)=c("size", "factor", "ttest", "welch")
rownames(table_ratio)=names
print(table_ratio)


#export data to excel file

write_xlsx(table_ratio,"D:\\Data\\Fac\\L3\\S6\\Info-Stat\\Stat\\Project - Welch\\ReliabilityR.xlsx")


                                                #Représentation des résultats

# windows()
# 
# p = ggplot() +
#   geom_point(data = table_ratio, aes(x = factor, y = ttest)) +
#   geom_point(data = table_ratio, aes(x = factor, y = welch)) +
#   geom_line(data = table_ratio, aes(x = factor, y = ttest), size = 0.8, colour = "darkred") +
#   geom_line(data = table_ratio, aes(x = factor, y = welch), size = 0.8, colour = "steelblue") +
#   theme_bw() +
#   xlim(1, 4) +
#   ylim(0, 15)
# 
# n = p +
#   labs(title = 'T test reliability for n=10',
#        subtitle = 'plot for factors applied on sd',
#        x = 'factors',
#        y= 'reliability'
#   ) +
#   scale_fill_discrete(name = 'Caption', labels = c('Without Welch', 'With Welch')) +
#   theme(
#     plot.title = element_text(color = "black", size = 12, face = "bold"),
#     plot.subtitle = element_text(color = "darkgrey"),
#     plot.caption = element_text(color = "green", face = "italic")
#   )
# print(n)

