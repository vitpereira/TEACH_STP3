
##################################
# Histograma dos construtos #
##################################

# Vitor Pereira, Set 2022

rm(list=ls()) # apaga tudo no ambiente

pacman:: p_load(dplyr, readr, writexl, ggplot2,
                janitor, readxl, epiDisplay, stringr, stringi,
                tidyr, purrr, tidylog)

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

# Abre a base
teach_limpo4 <- readRDS(paste0(tmp, "teach_construtos.RData")) %>% 
  dplyr::select( c(
    "apoio_aprend" 	,
    "expec_pos"    	,
    "clar_licao"   	,
    "ver_compr"    	,
    "com_constr"  	,
    "rac_critico"  	,
    "autonomia"    	,
    "persev"       	,
    "capac_soc_col"	,
    "cultura_sala_aula",
    "instrucao"        ,
    "socio_emoc"       ))

#################################################

# Transforma os construtos

# O across roda interativamente para cada variável do vetor

#################
teach_limpo5 <-
  teach_limpo4 %>% 
  mutate(across(c(apoio_aprend:socio_emoc), 
                
                # observe que precisamos colocar o ~ antes do case_when
                
                ~case_when( . >=0 & . <= 1 ~ "1",
                            . >1  & . <= 2 ~ "2",
                            . >2  & . <= 3 ~ "3",
                            . >3  & . <= 4 ~ "4",
                            . >4  & . <= 5 ~ "5")))  

################################################# 

# Graficos de distribuição dos escores, automatizados

my_plots <- function(variable, titulo) {
  
  # Observe como a variável entrou aqui:!! rlang::sym(variable)
  
  teach_limpo5 %>% 
    ggplot(aes(x= !! rlang::sym(variable), 
               fill= !! rlang::sym(variable))) +
    geom_bar() +
    scale_fill_manual(values=c("1" = "#CA0D0D",
                               "2" = "#CA910D",
                               "3" = "#E8E842", 
                               "4" = "#1CBC11", 
                               "5" = "#14720A")) +
    theme(legend.position = "none") +
    xlab("") +
    ylab("Contagem dos escores por faixa") +
    # Observe que titulo entrou normalmente
    labs(title= titulo)
}

vetor = c(
"apoio_aprend" 	,
"expec_pos"    	,
"clar_licao"   	,
"ver_compr"    	,
"com_constr"  	,
"rac_critico"  	,
"autonomia"    	,
"persev"       	,
"capac_soc_col"	,
"cultura_sala_aula",
"instrucao"        ,
"socio_emoc")

titulo = c(
    "1. Ambiente de apoio à aprendizagem" 	,
    "2. Expectativas comportamentais positivas"    	,
    "3. Clarificação da lição"   	,
    "4. Verificação da compreensão"    	,
    "5. Comentários construtivos"  	,
    "6. Raciocínio crítico"  	,
    "7. Autonomia"    	,
    "8. Perseverança"       	,
    "9. Capacidades sociais e colaorativas"	,
    "Cultura de sala de aula",
    "Instrução"        ,
    "Capacidades sócio-emocionais")
  
map2(vetor, titulo, ~my_plots( variable=.x, titulo=.y))