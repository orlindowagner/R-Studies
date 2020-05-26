#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19/Evolution_covid/Modelos')

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

x = c(79:86)
x


# MODELO LOGÍSTICO

modelo.logistico <- nls(acum_mort ~ a/(1+b*exp(-c* dia)), data=dados, start = list( a=3000, b=2000, c=0.104))
summary(modelo.logistico)
coef.log <- coef(modelo.logistico)

a <- coef.log[1]
b <- coef.log[2]
c <- coef.log[3]

y.log <- a/(1+b*exp(-c*x))
y.log


# MODELO EXPONENCIAL
modelo.exp <- nls(acum_mort ~d+e*exp(f*dia), data=dados, start = list( d=0, e=20, f=0.2))
summary(modelo.exp)
coef.exp <- coef(modelo.logistico)

d <- coef.exp[1]
e <- coef.exp[2]
f <- coef.exp[3]

y.exp <- d+e*exp(f*x)
y.exp



# REGRESSÃO LINEAR

modelo.linear <- lm(acum_cont ~dia, data = dados)
summary(modelo.linear)
coef.lin <- coef(modelo.linear)

g <- coef.lin[1]
h <- coef.lin[2]

y.lin <- h*x + g
y.lin


verif <-c(14817, 15633, 16118, 16792, 17971, 18859, 20047, 21048)
dados_projecoes <- data.frame(x, y.log, y.exp, y.lin, verif )
dados_projecoes




# ESTUDO DE ERROS: AVALIANDO A QUALIDADE DO MODELO

## ESTATISTICA DE ERRO PERCENTUAL

Erro_Perc <- function(x,observado, estimado){
	Erro_Perc <- (observado-estimado)/observado * 100	
	plot(x,Erro_Perc)
	lines(x, Erro_Perc)
	return(Erro_Perc)
}

Erro.log = Erro_Perc(dados_projecoes$x,dados_projecoes$verif, dados_projecoes$y.log)
Erro.exp = Erro_Perc(dados_projecoes$x,dados_projecoes$verif, dados_projecoes$y.exp)
Erro.lin = Erro_Perc(dados_projecoes$x,dados_projecoes$verif, dados_projecoes$y.lin)

#medias dos erros percentuais
mean(dados_projecoes$y.log)
mean(dados_projecoes$y.exp)
mean(dados_projecoes$y.lin)

mean(Erro.log)
mean(Erro.exp)
mean(Erro.lin)


Modelo = c("Logistico", "Exponencial", "Linear")
Modelo

Erro_Perc_med = c(mean(Erro.log), mean(Erro.exp), mean(Erro.lin))
Erro_Perc_med

Resultados <- data.frame(Modelo,Erro_Perc_med)
Resultados



## ESTATISTICA RQEM

RQEM <- function(observado, estimado,n){
	RQEM <- 100/mean(observado) * sqrt((sum(observado - estimado)^2)/n)
	return(RQEM)
}

n <- nrow(data.frame(dados_projecoes$y.log))
RQEM.log <- RQEM(dados_projecoes$verif, dados_projecoes$y.log, n)
RQEM.exp <- RQEM(dados_projecoes$verif, dados_projecoes$y.exp, n)
RQEM.lin <- RQEM(dados_projecoes$verif, dados_projecoes$y.lin, n)

RQEM <- c(RQEM.log, RQEM.exp, RQEM.lin)
RQEM

Resultados <- data.frame(Modelo,Erro_Perc_med,RQEM)
Resultados


## ESTATISTICA MAE

MAE <- function(observado, estimado,n){
	MAE = sum(abs(observado - estimado))/n
	return(MAE)
}

n <- nrow(data.frame(dados_projecoes$y.log))
MAE.log <- MAE(dados_projecoes$verif, dados_projecoes$y.log, n)
MAE.exp <- MAE(dados_projecoes$verif, dados_projecoes$y.exp, n)
MAE.lin <- MAE(dados_projecoes$verif, dados_projecoes$y.lin, n)

MAE <- c(MAE.log, MAE.exp, MAE.lin)
MAE

Resultados <- data.frame(Modelo,Erro_Perc_med,RQEM,MAE)
Resultados


## ESTATISTICA r_xy

r_xy <- function(observado, estimado){
	x <- estimado
	y <- observado
	numerador <- sum( (x - mean(x)) * (y - mean(y)) )
	denominador <- sqrt( (sum((x - mean(x))^2)) * (sum((y - mean(y))^2)) )
	r_xy <- numerador / denominador
	return(r_xy)
}

r_xy.log <- r_xy(dados_projecoes$verif, dados_projecoes$y.log)
r_xy.exp <- r_xy(dados_projecoes$verif, dados_projecoes$y.exp)
r_xy.lin <- r_xy(dados_projecoes$verif, dados_projecoes$y.lin)


r_xy <- c(r_xy.log, r_xy.exp, r_xy.lin)
r_xy

Resultados <- data.frame(Modelo,Erro_Perc_med,RQEM,MAE,r_xy)
Resultados





