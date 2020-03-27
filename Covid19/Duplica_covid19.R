#Configurando o diretorio de trabalho
#setwd('C:/Users/OW/Documents/R-Studies/Covid19')

setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19')

dados <- read.table("dados.txt", header = FALSE, dec = ",")

colnames(dados) <- c("dias", "italia","alemanha", "brasil","argentina")

modelo_italia <- lm(dados$italia ~ dados$dias)
modelo_italia
summary(modelo_italia)


modelo_alemanha <- lm(dados$alemanha ~ dados$dias)
modelo_alemanha
summary(modelo_alemanha)


dados_brasil <- dados[13:19, ]
dados_brasil
modelo_brasil <- lm(dados_brasil$brasil ~ dados_brasil$dias)
modelo_brasil
summary(modelo_brasil)


italia_alemanha <- lm(dados$italia ~ dados$alemanha)
italia_alemanha
summary(italia_alemanha)



vetor <- array(0:100)
vetor

horas <- 0.8929*vetor + 40.25
horas

n_dobras = log(40*10^6)/log(2)
n_dobras
n_d = as.integer(n_dobras)
n_d



modelo_italia <- lm(dados$italia ~ dados$dias)
modelo_italia
summary(modelo_italia)

horas_dobra = 46.54

for (i in 2:20){

	horas_dobra[i] = 46.54 + 3.07*dados$italia[i-1]/24 
 	
}
horas_dobra



horas_acum = 46.54

for (i in 2:20){

	horas_acum[i] = horas_acum[i-1]+horas_dobra[i] 
 	
}
horas_acum

dias_acum <- sum(horas_dobra)/24
dias_acum





