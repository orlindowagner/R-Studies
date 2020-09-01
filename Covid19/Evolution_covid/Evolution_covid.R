#Configurando o diretorio de trabalho
setwd('C:/Users/OW/Desktop/R-Studies/Covid19/Evolution_covid')



dados <- read.table("dados.txt", header = TRUE, dec = ",")
dados


#TENTATIVA DE APLICAR A REGRESSÃO LINEAR NOS DADOS DE TAXAS DIÁRIA

lm(cont_dia ~dia, data = dados)
summary(lm(cont_dia ~dia, data = dados))

lm(mort_dia ~dia, data = dados)
summary(lm(mort_dia ~dia, data = dados))

plot(dados$dia,dados$cont_dia)
plot(dados$dia,dados$mort_dia)



## APLICANDO AS REGRESSÕES PARA OS ACUMULADOS

lm(dados$cont_acum ~dia, data = dados)
summary(lm(dados$cont_acum  ~dia, data = dados))

lm(dados$mort_acum  ~dia, data = dados)
summary(lm(dados$mort_acum  ~dia, data = dados))


## PLOTANDO GRAFICOS DOS VALORES ACUMULADOS

plot(dados$dia,dados$cont_acum )
plot(dados$dia,dados$mort_acum )


## AVALIANDO TAXA DE LETALIDADE
letalidade_dia <- c()
letalidade_dia <- dados$mort_acum / dados$cont_acum  * 100
letalidade_dia
plot(dados$dia,letalidade_dia)
lines(dados$dia,letalidade_dia)

# APLICANDO A REGRESSÃO LINEAR PARA A TAXA DE LETALIDADE
summary(lm(letalidade_dia ~dia, data = dados))



## TENTANDO UM AJUSTE POR UMA FUNÇÃO EXPONENCIAL LINARIZADA - log(y) = log(x)

#Funciona perfeitamente para acum_cont resultando em R-squared = 0.8652 
summary(lm(log(dados$cont_acum+1)~ log(dados$dia+1) ))

# Foi necessário adicionar 1 para evitar a situação de log(0), resultando R-squared 0.4949
summary(lm(log(dados$mort_acum+1)~ log(dados$dia+1) ))


## TENTANDO UM AJUSTE POR UMA EXPONENCIAL DIRETAMENTE - MODELO EXPONENCIAL


modelo.exponencial = nls(dados$cont_acum ~a+b*exp(c*dia), data=dados, start = list( a=0, b=200, c=0.02))

summary(modelo.exponencial)
coeficientes <- coef(modelo.exponencial)
coeficientes
a <- coeficientes[1]
b <- coeficientes[2]
c <- coeficientes[3]


#plotando os dados e o modelo encontrado
plot(dados$dia,dados$cont_acum)
lines(dados$dia, a+b*exp(c*dados$dia))


#### SEGUNDA PARTE DO ESTUDO - NOS INTERESSAREMOS PELO NÚMERO DE MORTES

## AJUSTE DE MODELO NÃO LINEAR PARA NUMERO DE MORTES POR COVID19

#plotando par numero de mortos - novo foco do estudo
plot(dados$dia,dados$mort_acum)
lines(dados$dia,dados$mort_acum)


modelo.exponencial = nls(dados$mort_acum ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.02))


summary(modelo.exponencial)
coeficientes <- coef(modelo.exponencial)
coeficientes
a <- coeficientes[1]
b <- coeficientes[2]
c <- coeficientes[3]




#plotando os dados e o modelo encontrado
plot(dados$dia,dados$mort_acum)
lines(dados$dia, a+b*exp(c*dados$dia))


###########


# ESTIMANDO MODELO LOGÍSTICO ATRAVÉS DA FUNÇÃO nls() do R

modelo.logistico <- nls(dados$mort_acum ~ a/(1+b*exp(-c* dia)), data=dados, start = list( a=8000, b=200, c=0.102))
modelo.logistico

coeficientes <- coef(modelo.logistico)
coeficientes
a <- coeficientes[1]
b <- coeficientes[2]
c <- coeficientes[3]



## PROJEÇÕES DO DIA 0 AO DIA 120

dias_proj <- c(0:270)
projecoes_logi <- a/(1+b*exp(-c* dias_proj))
projecoes_logi

#data.frame(dias_proj, projecoes_logi)


## MORTES DIARIAS

# Acumulado no numero de mortes
mortes_diarias <- c()
mortes_diarias[1] <- 0



n <- nrow(data.frame(dias_proj, projecoes_logi))

for (i in 2:n){

	mortes_diarias[i] <- projecoes_logi[i] - projecoes_logi[i-1] 

}
#mortes_diarias


#GERANDO GRÁFICOS PARA APRESENTAÇÕES

png(filename="Graphs/Mortes_diarias_covid19_BR.png") 
plot(dados$dia, dados$mort_dia, xlim = c(1,n), main="Mortes diárias por covid19  no Brasil e estimativa",xlab = "dias corridos (desde 25-fev-2020)", ylab="mortes diárias",col='blue')
lines(dados$dia, dados$mort_dia, col='blue')
lines(dias_proj, mortes_diarias, col='red')
dev.off()


png(filename="Graphs/Evolution_covid19_BR.png") 
plot(dados$dia, dados$mort_acum,main=paste("Brasil:", round(sum(dados$mort_dia)),"mortes; Cálculo:",round(max(projecoes_logi)),"mortes" ),xlab = "dias corridos (desde 25-fev-2020)", ylab="Total de mortes", xlim = c(1,n),ylim = c(1,a), col='blue')
lines(dias_proj, projecoes_logi,col='red')
dev.off()

