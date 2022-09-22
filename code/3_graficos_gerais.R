  

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

teach_limpo <- readRDS(paste0(tmp, "teach_construtos.RData"))


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
    
  


