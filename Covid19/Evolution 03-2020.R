#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19')

dados <- read.table("03-2020.txt", header = FALSE, dec = ",")
dados
colnames(dados) <- c("dia_mes", "dia","cont_dia", "mort_dia")
dados

#TENTATIVA DE APLICAR A REGRESSÃO LINEAR NOS DADOS DE TAXAS DIÁRIA

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



## APLICANDO AS REGRESSÕES

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

# APLICANDO A REGRESSÃO LINEAR PARA A TAXA DE LETALIDADE (Incriveis R^2 ~0.907 )
summary(lm(taxa_diaria ~dia, data = dados))

## CONFERINDO DADOS ATUALIZADOS
acum_cont
acum_mort


## TENTANDO UM AJUSTE POR UMA FUNÇÃO EXPONENCIAL LINARIZADA - log(y) = log(x)

#Funciona perfeitamente para acum_cont resultando em R-squared = 0.8652 
summary(lm(log(acum_cont)~ log(dados$dia+1) ))

# Foi necessário adicionar 1 para evitar a situação de laog(0), resultando R-squared 0.4949
summary(lm(log(acum_mort+1)~ log(dados$dia+1) ))


## TENTANDO UM AJUSTE POR UMA EXPONENCIAL DIRETAMENTE - MODELO NÃO LINEAR

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

# Verificando para o dia 50 (16 abr 2020 - cerca de 32,5 mil contaminados pelo vírus...
dia_50 <- a+b*exp(c*50)
dia_50

#Ponto de verificação de atualização dos dados
acum_mort
acum_cont


#### SEGUNDA PARTE DO ESTUDO

## AJUSTE DE MODELO NÃO LINEAR PARA NUMERO DE MORTOS POR COVID19

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

#VERIFICANDO À PARTIR DO DIA 51

dias <- c(52:58)
valores_estimados <- a+b*exp(c*dias)
valores_estimados

dados_projecoes <- data.frame(dias, valores_estimados)
dados_projecoes$valores_observados <- c(2141,2347,2462,2575,2757,2906,3313)
dados_projecoes


# SALVANDO O TXT COM OS VALORES OBSERVADOS NA SEMANA 
write.table(dados_projecoes, "Dados_Projecoes.txt", row.names=FALSE, dec=",", quote=FALSE, sep="\t")



