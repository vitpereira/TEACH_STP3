

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

base_teach <- read_excel(paste0(input,
                                "Teach_STP_2022.xlsx"))

base_teach2 <- janitor::clean_names(base_teach)


#######################################


grafico1 <- base_teach2 %>% 
  ggplot(aes(x=os_rapazes_terao_mais_sucesso_que_as_raparigas_na_vida, 
             fill= os_rapazes_terao_mais_sucesso_que_as_raparigas_na_vida))+
  geom_bar() +
  scale_fill_manual("legend",
          values = c("Concordo" = "green",
                     "Discordo" = "red",
                     "NA" = "yellow"))

grafico1


func_graf <- function(var) {

grafico_var <- base_teach2 %>% 
               ggplot(aes(x=var, 
                          fill= var))+
               geom_bar() +
               scale_fill_manual("legend",
                                 values = c("Concordo" = "green",
                                            "Discordo" = "red",
                                            "NA" = "yellow"))
grafico_var             
}

vetor_var <-  c(
    "a_inteligencia_e_algo_inato_que_nao_pode_ser_profundamente_modificado"													,
    "pode_se_aprender_coisas_novas_mas_nao_se_pode_mudar_o_nivel_de_inteligencia_que_uma_pessoa_possui"                     ,
    "ter_um_bom_desempenho_na_tarefa_e_uma_boa_maneira_de_o_estudante_mostrar_aos_outros_que_e_inteligente"                 ,
    "um_estudante_se_sai_mal_numa_tarefa_eu_questiono_sua_inteligencia_ou_aptidao"                                          ,
    "quando_o_aluno_faz_muito_esforco_para_aprender_algo_ele_revela_que_nao_e_muito_inteligente"                            ,
    "preparar_se_bem_antes_de_enfrentar_uma_tarefa_e_uma_maneira_do_estudante_desenvolver_sua_propria_inteligencia"         ,
    "os_rapazes_terao_mais_sucesso_que_as_raparigas_na_vida"                                                                ,
    "diante_das_dificuldades_desta_escola_um_pequeno_aprendizado_dos_alunos_ja_e_um_bom_resultado"                          ,
    "com_as_familias_que_os_alunos_dessa_escola_tem_a_possibilidade_de_aprendizagem_fica_muito_comprometida"                ,
    "a_quantidade_dos_alunos_por_turma_e_a_principal_razao_que_a_maioria_dos_alunos_nao_aprendem"                           ,
    "os_alunos_dessa_escola_nao_tem_vontade_de_aprender"                                                                    )

map(vetor_var, func_graf)
