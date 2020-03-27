#Configurando o diretorio de trabalho
setwd('C:/Users/OW/Documents/R-Studies/Analise industrial2')


valores <- read.table("valores.txt", header = FALSE, dec = ",")
rotulos <- read.table("rotulos.txt", header = FALSE, dec = ",")
periodo <- read.table("periodo.txt", header = FALSE, dec = ",")

# Analisando o tamanho das tabelas de dodos
nrow(valores)
ncol(valores)

nrow(rotulos)
ncol(rotulos)

nrow(periodo)
ncol(periodo)


# Analisando categorias exixtentes

#Só da primeira linha
temp <- as.data.frame(table(unlist(rotulos[1,])))
subset(temp, Freq > 0 )


# Plotando alguns valores

mes_1_201 <- c(1:201)
plot(mes_1_201,valores[,1],type = "l")
lines(mes_1_201, valores[,2], col="red")
lines(mes_1_201, valores[,3], col="green")


colnames(rotulos) 


#        maq_equip    7
#         prod_mad    7
#      maq_ap_elet    7
#         prod_div    7
#       metalurgia    7
# ot_equip_transp    7
#  prod_farm_quim    7
#    veic_reb_car    7
#        prod_tex    7
#     confec_vest    7
#    ind_transfor   14
#       prod_alim    7
#    imp_rep_grav    7
#        quimicos    7
#   celu_prod_pap    7
#   prod_min_nmet    7
#          moveis    7
#    prod_met_emq    7
#         bebidas    7
#  prod_bor_plast    7
#  couro_via_calc    7
#  coq_petr_biocb    7





segmento <- 'prod_mad'

occorrencias <- c()
j <- 1
for (i in 1:ncol(rotulos)) {
  if (rotulos[1,i] == segmento){
	print(i)
	occorrencias[j] <- i
	j <- j+1
  }
}
occorrencias

par(mfrow=c(3,3))
for (i in 1:7) {
	EixoY <- paste( rotulos[2,occorrencias[i]] , "(" ,rotulos[3,occorrencias[i]] , ")" )
	plot(valores[,occorrencias[i]],type = "l",pch = i, xlab = "Periodo(meses)", ylab = EixoY , main = rotulos[1,occorrencias[i]])
}



resultados <- subset(temp, Freq >0)
resultados_filt <- c()

for (i in 1:nrow(resultados)) {
	resultados_filt[i] <- resultados[1,i]
}
resultados_filt




resultados_filt <- resultados[,1]



for (i in 1:nrow(resultados)) {


segmento <- toString(resultados_filt[i])
occorrencias <- c()
j <- 1
for (i in 1:ncol(rotulos)) {
  if (rotulos[1,i] == segmento){
	print(i)
	occorrencias[j] <- i
	j <- j+1
  }
}
occorrencias

par(mfrow=c(3,3))
for (i in 1:7) {
	EixoY <- paste( rotulos[2,occorrencias[i]] , "(" ,rotulos[3,occorrencias[i]] , ")" )
	plot(valores[,occorrencias[i]],type = "l",pch = i, xlab = "Periodo(meses)", ylab = EixoY , main = rotulos[1,occorrencias[i]])
}

dev.copy(pdf, paste(segmento,'.pdf'))
dev.off()



}







