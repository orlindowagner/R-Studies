#Configurando o diretorio de trabalho
setwd('C:/Users/solarius/Google Drive/R-Studies/Covid19')

dados <- read.table("03-2020.txt", header = FALSE, dec = ",")
dados
colnames(dados) <- c("dia_mes", "dias_corridos","num_contaminados", "n_mortes")
dados