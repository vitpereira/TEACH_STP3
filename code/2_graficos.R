  

# Abre a base do TEACH e faz os reshapes
# Vitor Pereira, Set 2022

rm(list=ls()) # apaga tudo no ambiente

pacman:: p_load(tidylog, dplyr, readr, writexl, ggplot2,
                janitor, readxl, epiDisplay, stringr, stringi,
                tidyr, purrr)

# Paths
root     <- "C:/Users/vitor/Dropbox (Personal)/Sao Tome e Principe/2022/TEACH_STP/"
input    <- paste0(root, "input/")
output   <- paste0(root, "output/")
tmp      <- paste0(root, "tmp/")
code     <- paste0(root, "code/")
setwd(root)

# Hora de STP
Sys.setenv(TZ="UCT")

######################################

teach_limpo <- readRDS(paste0(tmp, "teach_limpo.RData"))

### Todos os graficos ###


# Primeiro vou fazer apenas um grafico isoladamente para mostrar como faze-lo.
# Depois vou fazer todos automatcamente através de uma função

teach_limpo$a1_apoio_aprend_1_f <- 
  factor(teach_limpo$a1_apoio_aprend_1, 
              levels=c("A: Alta",
                      "M: Médio",
                      "B: Baixo"))

grafico1 <- teach_limpo %>% 
  ggplot(aes(x= a1_apoio_aprend_1_f, 
             fill= a1_apoio_aprend_1_f ))+
  geom_bar()+
  scale_fill_manual("Legenda", 
                    values=c("A: Alta"= "green",
                             "M: Médio" = "yellow",
                             "B: Baixo" = "red")) +
  xlab("A professora trata todos os alunos com respeito") +
  ylab("Contagem") +
  labs(title="A professora trata todos os alunos com respeito")

grafico1


#########################################
# Graficos automatizados ################


my_plots <- function(variable, titulo) {

# Observe como a variável entrou aqui:!! rlang::sym(variable)

  teach_limpo %>% 
    ggplot(aes(x= !! rlang::sym(variable), 
           fill= !! rlang::sym(variable))) +
    geom_bar() +
    scale_fill_manual("Legenda", 
                      values=c("A: Alta"= "#169233",
                               "M: Médio" = "#E2930A",
                               "B: Baixo" = "#CE0E0E", 
                               "N/A: Não aplicável" = "#0707A2")) +
    theme(legend.position = "bottom") +
    xlab("") +
    ylab("Contagem") +
# Observe que titulo entrou normalmente
        labs(title= titulo)
}

titulo <- c(	
  "A professora trata todos os alunos com respeito"				                      	          	,															
  "A professora usa uma linguagem positiva com os alunos"								                      ,
  "A professora corresponde as necessidades dos alunos"                      			            ,
  "A professora nao apresenta preconceitos de genero"                                         ,
  "A professora define claramente as expectativas"                                            ,
  "A professora reconhece o comportamento positivo dos alunos"                                ,
  "A professora redireciona o mau comportamento"                                              ,
  "A professora articula explicitamente os objetivos da aula"                                 ,
  "A explicacao da professora sobre o conteudo e clara"                                       ,
  "A durante a aula a professora estabelece conexoes"                                         ,
  "A professora exemplifica demonstrando ou pensando em voz alta"                             ,
  "A professora faz perguntas para determinar qual e o nivel de compreensao dos alunos"       ,
  "A professora monitoriza a maioria dos alunos"                                              ,
  "A professora ajusta o ensino ao nivel dos alunos"                                          ,
  "A professora faz comentarios que ajudam a esclarecer os equivocos dos alunos"              ,
  "A professora faz comentarios que ajudam os alunos a identificarem os seus sucessos"	      ,
  "A professora faz perguntas de resposta aberta"                                             ,
  "A professora propoe atividades de raciocinio"							                                ,
  "Os alunos fazem perguntas de resposta aberta ou desenvolvem atividades de raciocinio"      ,                   			
  "A professora proporciona escolhas aos alunos"                                              ,
  "A professora oferece oportunidades aos alunos para assumirem papeis na sala de aula"	     	,					
  "Os alunos voluntariam se para participar na aula"	                                        ,
  "A professora reconhece o esforco dos alunos"							                                  ,
  "A professora tem uma atitude positiva em relacao aos desafios dos alunos"					        ,				
  "A professora incentiva a definicao de objetivos"			                                      ,
  "A professora promove a colaboracao entre alunos atraves da interacao entre colegas"		    ,						
  "A professora promove as capacidades interpessoais dos alunos"				                      ,
  "Os alunos colaboram uns com os outros atraves da interacao entre eles"						)

vetor <-c("a1_apoio_aprend_1"		,
          "a1_apoio_aprend_2"		,
          "a1_apoio_aprend_3"		,
          "a1_apoio_aprend_4"		,
          "a1_expect_posit_1"		,
          "a1_expect_posit_2"		,
          "a1_expect_posit_3"		,
          "a2_licao_clara_1"		,
          "a2_licao_clara_2"		,
          "a2_licao_clara_3"		,
          "a2_licao_clara_4"		,
          "a2_compreens_1"		  ,
          "a2_compreens_2"		  ,
          "a2_compreens_3"		  ,
          "a2_coment_const_1"		,
          "a2_coment_const_2"		,
          "a2_racioc_crit_1"		,
          "a2_racioc_crit_2"		,
          "a2_racioc_crit_3"		,
          "a3_autonomia_1"		  ,
          "a3_autonomia_2"		  ,
          "a3_autonomia_3"		  ,
          "a3_persev_1"	        ,
          "a3_persev_2"	        ,
          "a3_persev_3"	        ,
          "a3_cap_soc_colab_1"	,
          "a3_cap_soc_colab_2"	,
          "a3_cap_soc_colab_3")

map2(vetor, titulo, ~my_plots( variable=.x, titulo=.y))



#################################################

# Calcula as médias por construto

# O across roda interativamente para cada variável do vetor

#################
teach_limpo2 <-
  teach_limpo %>% 
  mutate(across(c(a1_apoio_aprend_1:a3_cap_soc_colab_3), 

# observe que precisamos colocar o ~ antes do case_when
              
       ~case_when(      .  ==  "A: Alta"   ~ "1",
                        .  ==  "M: Médio"  ~ "3",
                        .  ==  "B: Baixo"  ~ "5")))
######################

# Transforma as colunas que só possuem numeros para formato numerico
# Esse pedacinho de c[odigo eu tirei das  nossas primeiras aulas, 
# quando fizemos o bind_rows de 2 bases
teach_limpo3 <- readr::type_convert(teach_limpo2) 


#####################
# Aplica o rowMeans para tirar a media dos construtos

teach_limpo4 <- teach_limpo3 %>% 
  
# Observe o across aqui, que me permite fazer o rowMeans para várias colunas 
  mutate(apoio_aprend = rowMeans(across(c(a1_apoio_aprend_1:a1_apoio_aprend_4))  , na.rm=TRUE), 
         expec_pos    = rowMeans(across(c(a1_expect_posit_1:a1_expect_posit_3))  , na.rm=TRUE),
         clar_licao   = rowMeans(across(c(a2_licao_clara_1:	a2_licao_clara_4))   , na.rm=TRUE),
         ver_compr    = rowMeans(across(c(a2_compreens_1:a2_compreens_3))        , na.rm=TRUE),
         com_constr   = rowMeans(across(c(a2_coment_const_1:a2_coment_const_2))  , na.rm=TRUE),
         rac_critico  = rowMeans(across(c(a2_racioc_crit_1:a2_racioc_crit_3))    , na.rm=TRUE),
         autonomia    = rowMeans(across(c(a3_autonomia_1:a3_autonomia_3))        , na.rm=TRUE),
         persev       = rowMeans(across(c(a3_persev_1:a3_persev_3))              , na.rm=TRUE),
         capac_soc_col= rowMeans(across(c(a3_cap_soc_colab_1:a3_cap_soc_colab_3)), na.rm=TRUE) ) %>% 
  
    mutate( cultura_sala_aula = rowMeans(across(c(apoio_aprend:expec_pos)) , na.rm=TRUE),
            instrucao         = rowMeans(across(c(clar_licao:rac_critico)) , na.rm=TRUE),
            socio_emoc        = rowMeans(across(c(autonomia:capac_soc_col)), na.rm=TRUE) )

#######################

# Media geral
medias_constr_geral <- teach_limpo4 %>% 
    summarise(
    mean_apoio_aprend            = mean(apoio_aprend 		    , na.rm=TRUE),
    mean_expec_pos               = mean(expec_pos           , na.rm=TRUE),
    mean_clar_licao              = mean(clar_licao          , na.rm=TRUE),
    mean_ver_compr               = mean(ver_compr           , na.rm=TRUE),
    mean_com_constr              = mean(com_constr          , na.rm=TRUE),
    mean_rac_critico             = mean(rac_critico         , na.rm=TRUE),
    mean_autonomia               = mean(autonomia           , na.rm=TRUE),
    mean_persev                  = mean(persev              , na.rm=TRUE),
    mean_capac_soc_col           = mean(capac_soc_col       , na.rm=TRUE),
    mean_cultura_sala_aula       = mean(cultura_sala_aula   , na.rm=TRUE),
    mean_instrucao               = mean(instrucao           , na.rm=TRUE),
    mean_socio_emoc        		   = mean(socio_emoc          , na.rm=TRUE) )


#########################
# Grafico das médias gerais

#grafico_construtos <- medias_constr_geral <-
#  ggplot(x=)


#################
# Médias por classe

medias_constr_classe <- teach_limpo4 %>% 
  group_by(classe) %>% 
  summarise(
    mean_apoio_aprend            = mean(apoio_aprend 		    , na.rm=TRUE),
    mean_expec_pos               = mean(expec_pos           , na.rm=TRUE),
    mean_clar_licao              = mean(clar_licao          , na.rm=TRUE),
    mean_ver_compr               = mean(ver_compr           , na.rm=TRUE),
    mean_com_constr              = mean(com_constr          , na.rm=TRUE),
    mean_rac_critico             = mean(rac_critico         , na.rm=TRUE),
    mean_autonomia               = mean(autonomia           , na.rm=TRUE),
    mean_persev                  = mean(persev              , na.rm=TRUE),
    mean_capac_soc_col           = mean(capac_soc_col       , na.rm=TRUE),
    mean_cultura_sala_aula       = mean(cultura_sala_aula   , na.rm=TRUE),
    mean_instrucao               = mean(instrucao           , na.rm=TRUE),
    mean_socio_emoc        		   = mean(socio_emoc          , na.rm=TRUE) )
    
  


