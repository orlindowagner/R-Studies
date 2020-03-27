library(ggplot2)

df <-cbind.data.frame("Category"=c("A","A","A","A","A","A","A","A","A","A"), 
                   "Y1"=c(1,2,3,4,5,4,6,7,8,9),
			 "Y2"=c(1,2,3,4,5,4,6,7,8,9),
                   "X1"=c(0,10,20,30,40,50,60,70,80,90),
                   "X2"=c(0,1,2,3,4,5,6,7,8,9))
ggplot(data=df) + 
 geom_path(aes(y=Y1,x=X1),color="red")+ 
 geom_path(aes(y=Y1,x=X2*10.5),color="blue")+ 
 scale_y_continuous("Eixo Y1",sec.axis = sec_axis(~ .*1/5, "Eixo Y2"))+   
 scale_x_continuous("Eixo X1",sec.axis = sec_axis(~ .*1/0.5, "Eixo X2"))



#Colocando nome da categoria "A"

ggplot(data=df) + 
 geom_path(aes(y=Y1,x=X1),color="red")+ 
 geom_path(aes(y=Y1,x=X2*10.5),color="blue")+ 
 facet_wrap(~Category)+ 
 scale_y_continuous("Eixo Y1",sec.axis = sec_axis(~ .*1/5, "Eixo Y2"))+   
 scale_x_continuous("Eixo X1",sec.axis = sec_axis(~ .*1/0.5, "Eixo X2"))

