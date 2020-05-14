#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19/World_covid')

#cont_dia <- read.table("cont_dia.txt", header = TRUE, dec = ",")
mort_dia <- read.table("new_deaths.txt", header = TRUE, dec = ",")



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
	a=8000
	modelo.logistico <- nls(serie ~ a/(1+b*exp(-c* pontos)), dados, start = list( a=max(serie)*0.45, b=a*5.5, c=0.109))
	coeficientes <- coef(modelo.logistico)
	print(coeficientes)
	a = coeficientes[1]
	b = coeficientes[2]
	c = coeficientes[3]
	x = c(0:180)
	y = a*1/(1+b*exp(-c*x))
	return(y)
}






plot_country <- function(serie, name){
	teste = acum(serie)
	x = c(0:180)
	y = coef = modelo.logistico(serie = teste, pontos = mort_dia$day, dados = mort_dia)

	par(mfrow=c(2,2))
	plot(mort_dia$day, teste, xlab = 'dia do ano (início em 01-Jan-2020)', ylab = 'mortes acumuladas',xlim = c(50,max(x)), ylim = c(1,max(y)*1.05),main = paste(name,": ", round(max(y)),"mortes (estimativa)" ) )
	lines(x,y , col='red' )

	print(max(y))


	## MORTES DIARIAS

	# Acumulado no numero de mortes
	mortes_diarias <- c()
	mortes_diarias[1] <- 0
	n <- nrow(data.frame(x,x))
	for (i in 2:n){
	mortes_diarias[i] <- y[i] - y[i-1] 
	}

	plot(mort_dia$day, serie, xlim = c(50,max(x)), main=paste("Mortes diárias (estimativa)"),xlab = "dia do ano (início em 01-Jan-2020)", ylab="mortes diárias",col='blue')
	lines(mort_dia$day, serie, col='blue') 
	lines(x, mortes_diarias, col='red')

	total = round(max(y))
	dev.copy(pdf, paste("Graphs/",total,"_",name,'.pdf'))
	dev.off()

}


plot_country(mort_dia$Algeria,"Argélia")
plot_country(mort_dia$Argentina,"Argentina")
plot_country(mort_dia$Australia,"Austrália")
plot_country(mort_dia$Austria,"Austria")
plot_country(mort_dia$Belgium,"Bégica")
plot_country(mort_dia$Brazil,"Brasil")
plot_country(mort_dia$Canada,"Canadá")
plot_country(mort_dia$Chile,"Chile")
plot_country(mort_dia$Colombia,"Colômbia")
plot_country(mort_dia$France,"França")
plot_country(mort_dia$Germany,"Alemanha")
plot_country(mort_dia$Iran,"Irã")
plot_country(mort_dia$Israel,"Israel")
plot_country(mort_dia$Italy,"Itália")
plot_country(mort_dia$Japan,"Japão")
plot_country(mort_dia$Saudi_Arabia,"Arábia Saudita")
plot_country(mort_dia$South_Africa,"África do Sul")
plot_country(mort_dia$South_Korea,"Coréia do Sul")
plot_country(mort_dia$United_Kingdom,"Reino Unido")
plot_country(mort_dia$United_States,"EUA")
plot_country(mort_dia$Mexico,"México")
plot_country(mort_dia$Russia,"Rússia")
plot_country(mort_dia$Sweden,"Suécia")
plot_country(mort_dia$Norway,"Noruega")
plot_country(mort_dia$Spain,"Espanha")
plot_country(mort_dia$India,"Índia")
plot_country(mort_dia$Turkey,"Turquia")
plot_country(mort_dia$Indonesia,"Indonésia")
plot_country(mort_dia$Ecuador,"Equador")
plot_country(mort_dia$Egypt,"Egito")
plot_country(mort_dia$Ukraine,"Ucrânia")
plot_country(mort_dia$Pakistan,"Paquistão")
plot_country(mort_dia$Peru,"Peru")
plot_country(mort_dia$China,"China")
plot_country(mort_dia$Portugal,"Portugal")
plot_country(mort_dia$Total_Geral,"94_Percent")



