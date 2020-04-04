#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19')

dados <- read.table("03-2020.txt", header = FALSE, dec = ",")
dados
colnames(dados) <- c("dia_mes", "dia","cont_dia", "mort_dia")
dados

lm(cont_dia ~dia, data = dados)
summary(lm(cont_dia ~dia, data = dados))

lm(mort_dia ~dia, data = dados)
summary(lm(mort_dia ~dia, data = dados))

plot(dados$dia,dados$cont_dia)
plot(dados$dia,dados$mort_dia)



## FAZENDO OS ACUMULADOS EM CONTAMINADO E MORTES


acum_cont <- c()

acum_cont[1] <- dados$cont_dia[1]

for (i in 2:nrow(dados)){

	acum_cont[i] <- acum_cont[i-1]+dados$cont_dia[i] 

}

acum_cont



acum_mort <- c()

acum_mort[1] <- dados$mort_dia[1]

for (i in 2:nrow(dados)){

	acum_mort[i] <- acum_mort[i-1]+dados$mort_dia[i] 

}

acum_mort



## APLICANDO AS REGRESSÕES

lm(acum_cont ~dia, data = dados)
summary(lm(acum_cont ~dia, data = dados))

lm(acum_mort ~dia, data = dados)
summary(lm(acum_mort ~dia, data = dados))

## PLOTANDO GRAFICOS

plot(dados$dia,acum_cont)
plot(dados$dia,acum_mort)



taxa_diaria <- c()
taxa_diaria <- acum_mort / acum_cont * 100
taxa_diaria
plot(dados$dia,taxa_diaria)







