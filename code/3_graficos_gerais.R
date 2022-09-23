  

# Abre a base do TEACH e faz os reshapes
# Vitor Pereira, Set 2022

rm(list=ls()) # apaga tudo no ambiente

pacman:: p_load(tidylog, dplyr, readr, writexl, ggplot2,
                janitor, readxl, epiDisplay, stringr, stringi,
                tidyr, purrr)

# Paths
root     <- "C:/Users/vitor/Dropbox (Personal)/Sao Tome e Principe/2022/TEACH_STP3/"
input    <- paste0(root, "input/")
output   <- paste0(root, "output/")
tmp      <- paste0(root, "tmp/")
code     <- paste0(root, "code/")
setwd(root)

# Hora de STP
Sys.setenv(TZ="UCT")

######################################
# Funcoes

percentagem <- function(x, digits = 1, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}

######################################


teach_limpo4 <- readRDS(paste0(tmp, "teach_construtos.RData"))


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

teach_transposto_medias <- as.data.frame(t
                            (medias_constr_geral))

v<-c(seq(1:12))

teach_junto <- cbind(teach_transposto_medias, v) 




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
    
  
#################################

num_escolas <- teach_limpo4 %>% 
  distinct(escola) %>% 
  summarise(v=n())

num_prof <- teach_limpo4 %>% 
  distinct(professor, escola) %>% 
  summarise(v=n())

prop_prof_sexo <- teach_limpo4 %>% 
  mutate(prof_F= ifelse(professor_sexo=="Feminino", 1, 0), 
         prof_M= ifelse(professor_sexo=="Masculino", 1, 0))%>% 
  summarise(v_F= percentagem(mean(prof_F, na.rm=TRUE)), 
            v_M= percentagem(mean(prof_M, na.rm=TRUE)))

prop_prof_sexo2 <- as.data.frame(t(prop_prof_sexo)) %>% 
  rename(v=V1)

obs_teach <- teach_limpo4 %>% 
  summarise(v=n())
  
tamanho_sala <- teach_limpo4 %>% 
  mutate(alunos=meninos_sala+meninas_sala) %>% 
  summarise(v=formatC(mean(alunos, na.rm= TRUE), digits=2, format= "f")) %>% 
  mutate(v=as.numeric(v))

total_alunos <- teach_limpo4 %>%   
  mutate(alunos=meninos_sala+meninas_sala) %>% 
            summarise(v=sum(alunos))

tamanho_sala2 <- as.data.frame(t(tamanho_sala)) %>% 
  rename(v=V1) 

mediana_tamanho_sala <- teach_limpo4 %>% 
  mutate(alunos=meninos_sala+meninas_sala) %>% 
  summarise(v=median(alunos, na.rm=TRUE))

raparigas <- teach_limpo4 %>% 
  summarise(v =mean(meninas_sala))

v=percentagem((raparigas$v /tamanho_sala$v))

prop_raparigas =as.data.frame(v)  
  
proporcoes <- teach_limpo4 %>% 
  mutate(classe1= ifelse(classe=="1a. Classe",1,0), 
         classe2= ifelse(classe=="2a. Classe",1,0), 
         classe6= ifelse(classe=="6a. Classe",1,0)) %>%  
  summarise(prop_classe1 = percentagem(mean(classe1, na.rm= TRUE) ),
            prop_classe2 = percentagem(mean(classe2, na.rm= TRUE) ),
            prop_classe6 = percentagem(mean(classe6, na.rm= TRUE) ),
    
            prop_mat = percentagem(mean(disciplina_matematica, na.rm= TRUE) ), 
            prop_lp  = percentagem(mean(disciplina_portugues, na.rm= TRUE) ),
            prop_cn  = percentagem(mean(disciplina_ciencias_naturais, na.rm= TRUE)), 
            prop_cs  = percentagem(mean(disciplina_ciencias_sociais, na.rm= TRUE) ),
            prop_out = percentagem(mean(disciplina_outra, na.rm= TRUE) ))
  

proporcoes2 <- as.data.frame(t(proporcoes)) %>% 
  rename(v=V1)

v=c("São Tomé e Príncipe")

local <-as.data.frame(v)

# Montando a tabela para o relatorio

tab_relat_col2 <- rbind(
          local,
          num_escolas, 
          num_prof, 
          prop_prof_sexo2,
          obs_teach, 
          tamanho_sala2,
          mediana_tamanho_sala,
          total_alunos,
          prop_raparigas, 
          proporcoes2)

tab_relat_col1 <- c(
  "Local", 
  "Número de escolas", 
  "Número de professores", 
  "Professores do sexo feminino", 
  "Professores do sexo masculino", 
  "Número de observações do Teach",
  "Tamanho médio da sala",
  "Mediana do tamanho da sala",
  "Número de alunos",
  "Proporção de raparigas",
  "Percentagem das classes observadas: 1a classe",
  "Percentagem das classes observadas: 2a classe",
  "Percentagem das classes observadas: 6a classe",
  "Percentagem de disciplina: Matemática", 
  "Percentagem de disciplina: Língua Portuguesa", 
  "Percentagem de disciplina: Ciências Naturais", 
  "Percentagem de disciplina: Ciências Sociais", 
  "Percentagem de disciplina: Outra disciplina")

######## Tabela 1 do relatorio
tabela_relatorio <- cbind(tab_relat_col1, tab_relat_col2)
