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

nls(acum_cont ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.5))

summary(nls(acum_cont ~a+b*exp(c*dia), data=dados, start = list( a=0, b=20, c=0.5)))

# Tentando aplicar o modelo 
a <- -188.91388
b <- 45.3396
c <- 0.14411

dados$acum_estimado <- a+b*exp(c*dados$dia)
dados$erro_quadrado <- (dados$acum_cont - dados$acum_estimado)^2

#plotando os dados e o modelo encontrado
plot(dados$dia,acum_cont)
lines(dados$dia, dados$acum_estimado)

# Verificando para o dia 50 (16 abr 2020 - quase 61 mil contaminados pelo vírus...
dia_50 <- a+b*exp(c*50)
dia_50

#Ponto de verificação de atualização dos dados
acum_mort
acum_cont


#OBS: estou com a impressão que os dados do site da globo estão sendo modificados muito frequentemente

