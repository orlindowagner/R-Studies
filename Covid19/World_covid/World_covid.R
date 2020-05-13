#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19/World_covid')

cont_dia <- read.table("cont_dia.txt", header = TRUE, dec = ",")
mort_dia <- read.table("mort_dia.txt", header = TRUE, dec = ",")



## FAZENDO FUNÇÃO ACUMULADORA

acum <- function(serie) {
	acum <- c()
	acum[1] <- serie[1]

	for (i in 2:nrow(data.frame(serie))){
		acum[i] <- acum[i-1]+serie[i] 
	}
	return(acum)
}


modelo.logistico <- function(serie, pontos, dados){

	# ESTIMANDO MODELO LOGÍSTICO ATRAVÉS DA FUNÇÃO nls() do R
	
	modelo.logistico <- nls(serie ~ a/(1+b*exp(-c* pontos)), dados, start = list( a=max(serie), b=a*1.3, c=0.1))

	coeficientes <- coef(modelo.logistico)
	return(coeficientes)

}

teste <- acum(mort_dia$bra)
coef = modelo.logistico(serie = teste, pontos = mort_dia$dia, dados = mort_dia)
coef
a = coef[1]
b = coef[2]
c = coef[3]

proj = c(60:180)

plot(mort_dia$dia, teste, xlab = 'Dia do ano', ylab = 'Total de mortes', xlim = c(50,max(proj)), ylim = c(1,a*1.05))
lines(proj, a*1/(1+b*exp(-c*proj)), col='red' )



