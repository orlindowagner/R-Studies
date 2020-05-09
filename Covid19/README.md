# COVID19

## Objetivo

- Estudar a evolução da COVID19 e ajustar modelos matemáticos para predição.

## Entradas
- Número de contaminados à cada dia;
- Número de mortos à cada dia;
- Número de recuperados à cada dia.

### Fontes de coleta diária dos dados

- [Dados do Ministério da Saúde](https://covid.saude.gov.br/) - Número de contaminados por dia
- [Rastreador covid19 do Bing](https://www.bing.com/covid/local/brazil?vert=graph) - Número de curados por dia


## Saídas
### Gráficos
- Curva do número acumulado de contaminados;
- Curva do número acumulado de mortos;
- Curva da taxa de letalidade;


### Modelos matemáticos ajustados aos gráficos
- Regressão Linear aplicada na taxa de letalidade;
- Ajuste de modelo não linear para a curva do numero acumulado de contaminados e mortos;
- Estimar acontecimentos futuros:
``` 
# Predizer o número de mortos em dado dia

y = M/( 1+A*exp(-kx) )  # modelo logístico

# Predizer quando irá parar de morrer gente devido o Covid19
```
## Observações sobre últimos acontecimentos

- Suspeita de subnotificação do número de contaminados;


## Sugestão de tomadas de decisão para direcionamento do estudo
- Considerar mais relevante para predição os número de mortos;
- Avaliar qualidade do modelo em um intervalo de predição de uma semana;
- Deixar claro os critérios para utilização do modelo escolhido.

## Sugestão de outros estudos

- Criar algoritmo de ajuste diário do modelo. Basicamente captar os coeficientes dia à dia;
- Verificar a diferença de um modelo que inicie somente quando houve o primeiro caso de morte e comparar com o caso do modelo que considera a série constante.
- [Modelo Logístico](http://w3.im.ufrj.br/~flavia/mac128/aulas/mac128_2019_08_14.pdf) - Estudo de outros modelos que podem ser ajustados
- [Astúcias no R](http://ecologia.ib.usp.br/bie5782/doku.php?id=bie5782:03_apostila:03-funcoes) - Site que ensina recursos do R


## Resultados até então obtidos

- Gráficos de ajuste do modelo
- Estatísticas para os modelos
