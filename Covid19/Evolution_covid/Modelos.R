#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19/Evolution_covid')

dados <- read.table("dados.txt", header = FALSE, dec = ",")
dados
colnames(dados) <- c("dia_mes", "dia","cont_dia", "mort_dia", "recup_dia")
dados

#TENTATIVA DE APLICAR A REGRESSÃO LINEAR NOS DADOS DE TAXAS DIÁRIA

lm(cont_dia ~dia, data = dados)
summary(lm(cont_dia ~dia, data = dados))

lm(mort_dia ~dia, data = dados)
summary(lm(mort_dia ~dia, data = dados))

plot(dados$dia,dados$cont_dia)
plot(dados$dia,dados$mort_dia)
lines(dados$dia,dados$mort_dia)


## FAZENDO OS ACUMULADOS EM CONTAMINADO E MORTES

# Acumulado no numero de contaminados
acum_cont <- c()

acum_cont[1] <- dados$cont_dia[1]

for (i in 2:nrow(dados)){

	acum_cont[i] <- acum_cont[i-1]+dados$cont_dia[i] 

}

acum_cont


# Acumulado no numero de mortes
acum_mort <- c()

acum_mort[1] <- dados$mort_dia[1]

for (i in 2:nrow(dados)){

	acum_mort[i] <- acum_mort[i-1]+dados$mort_dia[i] 

}

acum_mort




## AULA DOS TRÊS MODELOS

# MODELO LOGÍSTICO

modelo.logistico <- nls(acum_mort ~ a/(1+b*exp(-c* dia)), data=dados, start = list( a=3000, b=2000, c=0.104))
modelo.logistico
coeficientes <- coef(modelo.logistico)
summary(modelo.logistico)


# REGRESSÃO LINEAR

lm(acum_cont ~dia, data = dados)
summary(lm(acum_cont ~dia, data = dados))

# MODELO EXPONENCIAL
summary(nls(acum_mort ~d+e*exp(f*dia), data=dados, start = list( d=0, e=20, f=0.2)))

