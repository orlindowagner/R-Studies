#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19/Evolution_covid')

dados <- read.table("dados.txt", header = FALSE, dec = ",")
dados
colnames(dados) <- c("dia_mes", "dia","cont_dia", "mort_dia", "recup_dia")
dados

#TENTATIVA DE APLICAR A REGRESS�O LINEAR NOS DADOS DE TAXAS DI�RIA

lm(cont_dia ~dia, data = dados)
summary(lm(cont_dia ~dia, data = dados))

lm(mort_dia ~dia, data = dados)
summary(lm(mort_dia ~dia, data = dados))

plot(dados$dia,dados$cont_dia)
plot(dados$dia,dados$mort_dia)



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



## APLICANDO AS REGRESS�ES

lm(acum_cont ~dia, data = dados)
summary(lm(acum_cont ~dia, data = dados))

lm(acum_mort ~dia, data = dados)
summary(lm(acum_mort ~dia, data = dados))


## PLOTANDO GRAFICOS DOS VALORES ACUMULADOS

plot(dados$dia,acum_cont)
plot(dados$dia,acum_mort)


## AVALIANDO TAXA DE LETALIDADE
taxa_diaria <- c()
taxa_diaria <- acum_mort / acum_cont * 100
taxa_diaria
plot(dados$dia,taxa_diaria)
lines(dados$dia,taxa_diaria)

# APLICANDO A REGRESS�O LINEAR PARA A TAXA DE LETALIDADE (Incriveis R^2 ~0.907 )
summary(lm(taxa_diaria ~dia, data = dados))

## CONFERINDO DADOS ATUALIZADOS
acum_cont
acum_mort


## TENTANDO UM AJUSTE POR UMA FUN��O EXPONENCIAL LINARIZADA - log(y) = log(x)

#Funciona perfeitamente para acum_cont resultando em R-squared = 0.8652 
summary(lm(log(acum_cont)~ log(dados$dia+1) ))

# Foi necess�rio adicionar 1 para evitar a situa��o de laog(0), resultando R-squared 0.4949
summary(lm(log(acum_mort+1)~ log(dados$dia+1) ))


## TENTANDO UM AJUSTE POR UMA EXPONENCIAL DIRETAMENTE - MODELO N�O LINEAR

dados$acum_cont <- acum_cont

nls(acum_cont ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.2))

summary(nls(acum_cont ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.2)))

# Tentando aplicar o modelo 
a <- -1.098e+03 # -1.008e+03 # -949.94794 # -814.8117 # -188.91388
b <-  3.194e+02 # 2.878e+02 #  267.44862 # 221.0916  # 45.3396
c <-  9.314e-02 # 9.555e-02 #  0.09727   # 0.1019    # 0.14411

dados$acum_estimado <- a+b*exp(c*dados$dia)
#dados$erro_quadrado <- (dados$acum_cont - dados$acum_estimado)^2

#plotando os dados e o modelo encontrado
plot(dados$dia,acum_cont)
lines(dados$dia, dados$acum_estimado)

# Verificando para o dia 50 (16 abr 2020 - cerca de 32,5 mil contaminados pelo v�rus...
dia_50 <- a+b*exp(c*50)
dia_50

#Ponto de verifica��o de atualiza��o dos dados
acum_mort
acum_cont


#### SEGUNDA PARTE DO ESTUDO

## AJUSTE DE MODELO N�O LINEAR PARA NUMERO DE MORTOS POR COVID19

#plotando par numero de mortos - novo foco do estudo
plot(dados$dia,acum_mort)
lines(dados$dia,acum_mort)

dados$acum_mort <- acum_mort

nls(acum_mort ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.2))
summary(nls(acum_mort ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.2)))

# aplicando o modelo 
a <- -38.362738 # -35.257387 # -33.0562 
b <-   4.553727 # 4.032916 #   3.6604
c <-   0.122112 # 0.124889 #   0.1272

dados$acum_mort_estim <- a+b*exp(c*dados$dia)
#dados$erro_quadrado <- (dados$acum_mort - dados$acum_mort_estimado)^2

#plotando os dados e o modelo encontrado
plot(dados$dia,acum_mort)
lines(dados$dia, dados$acum_mort_estim)

# Verificando para o dia 50 (16 abr 2020 - cerca de ~2 mil mortes pelo covid19)
dia_mort_50 <- a+b*exp(c*50)
dia_mort_50

# Estima-se que no dia 22 abril teremos 488 mortes em um dia
mort_dia_500 = a+b*exp(c*56)-(a+b*exp(c*55))
mort_dia_500



# ESTUDANDO UMA MANEIRA DE CAPTAR OS COEFICIENTES 

equacao <- nls(acum_mort ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.2))
coef(equacao)
coeficientes <- coef(equacao)
coeficientes
coeficientes[1]
coeficientes[2]
coeficientes[3]


## TESTANDO A QUALIDADE DO MODELO

#VERIFICANDO � PARTIR DO DIA 51

dias <- c(52:58)
valores_estimados <- a+b*exp(c*dias)
valores_estimados

dados_projecoes <- data.frame(dias, valores_estimados)
dados_projecoes$valores_observados <- c(2141,2347,2462,2575,2757,2906,3313)
dados_projecoes


# SALVANDO O TXT COM OS VALORES OBSERVADOS NA SEMANA 
write.table(dados_projecoes, "Dados_Projecoes.txt", row.names=FALSE, dec=",", quote=FALSE, sep="\t")


# ESTUDO DE ERROS: AVALIANDO A QUALIDADE DO MODELO

## ESTATISTICA DE ERRO PERCENTUAL

observado <- dados_projecoes$valores_observados
estimado <- valores_estimados

Erro_Perc <- (observado-estimado)/observado * 100

Erro_Perc

plot(dias,Erro_Perc)
lines(dias, Erro_Perc)

dados_projecoes$Erro_Perc <- Erro_Perc
dados_projecoes


## ESTATISTICA RQEM

mean(dados_projecoes$Erro_Perc)

Obs_Est <- (dados_projecoes$valores_estimados - dados_projecoes$valores_observados) ^2
Obs_Est

dados_projecoes$Obs_Est <- Obs_Est
dados_projecoes

RQEM = 100/mean(observado) * sqrt((sum(observado - estimado)^2)/nrow(dados_projecoes))

RQEM


## ESTATISTICA MAE

MAE = sum(abs(observado - estimado))/nrow(dados_projecoes)

MAE

## tentativa de calculo o coeficiente de correla��o
#### essa correla��o para esse caso � entre os observados e estimados

x <- estimado
y <- observado

numerador <- sum( (x - mean(x)) * (y - mean(y)) )
numerador

denominador <- sqrt( (sum((x - mean(x))^2)) * (sum((y - mean(y))^2)) )
denominador


r_xy <- numerador / denominador

r_xy




## TESTANDO MODELOS DIFERENTES - MODELO LOGISTICO (ajuste manual)
#plotando os dados e o modelo encontrado


sigmoides <- read.table("sigmoides.txt", header = FALSE, dec = ",")
colnames(sigmoides) <- c("M", "k","A")
sigmoides

#Basta mudar o indice i para ajustar a curva desejada

i <- 65
k <- sigmoides$k[i]
M <- sigmoides$M[i]
A <- sigmoides$A[i]

plot(dados$dia,acum_mort)
#lines(dados$dia, dados$acum_mort_estim)
lines(dados$dia, (M/(1+A*exp(-k*dados$dia)) ) )

(M/(1+A*exp(-k*dados$dia)) )
acum_mort

(M/(1+A*exp(-k*dados$dia)) ) - acum_mort


M
k
A


# APLICA��O DAS ESTAT�STICAS PARA A AS SIGMOIDES
# GERAR

for (i in 1:nrow(sigmoides)){

	k <- sigmoides$k[i]
	M <- sigmoides$M[i]
	A <- sigmoides$A[i]

	observado <- dados$acum_mort
	estimado <- (M/(1+A*exp(-k*dados$dia)) )


	RQEM[i] <- 100/mean(observado) * sqrt((sum(observado - estimado)^2)/nrow(dados))

	MAE[i] = sum(abs(observado - estimado))/nrow(dados)


	x <- estimado
	y <- observado

	numerador <- sum( (x - mean(x)) * (y - mean(y)) )
	denominador <- sqrt( (sum((x - mean(x))^2)) * (sum((y - mean(y))^2)) )


	r_xy[i] <- numerador / denominador


}
RQEM
MAE
r_xy




estatisticas <- c()
estatisticas$RQEM <- RQEM
estatisticas$MAE <- MAE
estatisticas$r_xy <- r_xy
estatisticas


data.frame(estatisticas)

# SALVANDO O TXT COM AS VALORES DAS ESTATISTICAS 
write.table(estatisticas, "estatisticas.txt", row.names=FALSE, dec=",", quote=FALSE, sep="\t")


# PONTO DE VERIFICA��O DOS DADOS ATUALIZADOS
dados
## PARENTESIS - NUMERO DE RECUPERADOS
sum(dados$cont_dia)
sum(dados$mort_dia)
sum(dados$recup_dia)


