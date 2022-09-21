

* Checagens de qualidade

* IN
global TMPDIR 			"D:\Dropbox (Personal)\Angola\Dados e analise\5_TEACH\Supervisao\tmp"
local TEACH				"$TMPDIR/base_obs_teach.dta"
local SORTEADAS			"$TMPDIR/turmas_sorteadas.dta"
local PLAN				"D:\Dropbox (Personal)\Angola\Dados e analise\5_TEACH\Supervisao\input/Base_escolas_campo_v12 - 22-12-2021_VP.xlsx"

* OUT


*********************************************

* Base de campo da Plurália
//{
clear
import excel "$INPDIR/Base_turmas_campo_TEACH FINAL_ NOTAS DE CAMPO (1).xlsx", sheet("TEACh Inq_Sup") firstrow
rename *, lower
gen double cod_teach = real(cd_escola_old) 
rename cd_escola sige
save "$TMPDIR/notas_campo_pluralia.dta" , replace

gsort sige -observaÇÕes
bysort sige: gen n=_n
keep if n == 1
drop n
save "$TMPDIR/notas_campo_pluralia_escolas.dta" , replace
//}

* Base de sorteio das escolas
//{
use "$TMPDIR/selecao1.dta" , clear

* escolas que tinham algum problema no nome
//{
rename precode_* *
replace school 				= 100 																				if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name_manual	= "Escola Primária 14 de Abril da Kalonga" 											if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace province            = "CUNENE" 																			if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace municipality        = "CUVELAI" 																		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace commune             = "CALONGA" 																		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace cod_sige            = 1015 																				if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace cod_novo            = 1705040017	  																	if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name_pull    = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE" 						if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name         = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE//CALONGA//CUVELAI" 		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694

replace school 				= 49 																				if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name_manual	= "Esc. Primária Adriano Kapumba Nº 36" 											if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace province            = "BIÉ" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace municipality        = "CUITO (KUITO)" 																	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace commune             = "CUNJE" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace cod_sige            = 13639 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace cod_novo            = 1203030005  																		if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name_pull    = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ" 						if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name         = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ//CUNJE//CUITO (KUITO)" 	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
//}

count
distinct school_name_pull

drop if today >22701
count
distinct school_name_pull
//}

* Base de observações
//{
use "$TMPDIR/teach_angola1.dta", clear

* escolas que tinham algum problema no nome
//{
rename precode_* *
replace school 				= "100" 																			if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name_manual	= "Escola Primária 14 de Abril da Kalonga" 											if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace province            = "CUNENE" 																			if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace municipality        = "CUVELAI" 																		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace commune             = "CALONGA" 																		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace cod_sige            = "1015" 																			if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace cod_novo            = "1705040017"  																	if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name_pull    = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE" 						if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name         = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE//CALONGA//CUVELAI" 		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
																																										  
replace school 				= "49" 																				if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name_manual	= "Esc. Primária Adriano Kapumba Nº 36" 											if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace province            = "BIÉ" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace municipality        = "CUITO (KUITO)" 																	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace commune             = "CUNJE" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace cod_sige            = "13639" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace cod_novo            = "1203030005"  																	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name_pull    = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ" 						if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name         = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ//CUNJE//CUITO (KUITO)" 	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
//}

count
distinct school_name_pull

drop if today >22702
count
distinct school_name_pull
//}

***********************

* Cruzamento Plurália e observações:
//{
use "$TMPDIR/teach_angola1.dta", clear

* escolas que tinham algum problema no nome
//{
rename precode_* *
replace school 				= "100" 																			if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name_manual	= "Escola Primária 14 de Abril da Kalonga" 											if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace province            = "CUNENE" 																			if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace municipality        = "CUVELAI" 																		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace commune             = "CALONGA" 																		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace cod_sige            = "1015" 																			if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace cod_novo            = "1705040017"  																	if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name_pull    = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE" 						if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
replace school_name         = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE//CALONGA//CUVELAI" 		if deviceid == "collect:b6gyhCCumDxV1ojd" & today == 22694
																																										  
replace school 				= "49" 																				if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name_manual	= "Esc. Primária Adriano Kapumba Nº 36" 											if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace province            = "BIÉ" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace municipality        = "CUITO (KUITO)" 																	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace commune             = "CUNJE" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace cod_sige            = "13639" 																			if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace cod_novo            = "1203030005"  																	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name_pull    = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ" 						if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
replace school_name         = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ//CUNJE//CUITO (KUITO)" 	if deviceid == "collect:MzsMnfCPns0gnS7z" & today == 22697
//}

gen double sige = real(cod_sige)
gen double cod_teach = real(cod_novo)

/*. gen double cod_teach = real(cod_novo)
(2 missing values generated)  */

bysort sige: gen n=_n
keep if n==1

keep today deviceid username school province sige cod_teach school_name_pull school_name _local_gps_latitude _local_gps_longitude _local_gps_altitude n_total_turmas date coder_label

merge 1:1 sige using "$TMPDIR/notas_campo_pluralia_escolas.dta"
 

/*   Result                           # of obs.
    -----------------------------------------
    not matched                            42
        from master                         5  (_merge==1)
        from using                         37  (_merge==2)

    matched                               264  (_merge==3)
    ----------------------------------------- */

gen id = _n	
tab _merge if today  <= 22701 	
gen escola_marco = !missing(today) & today  > 22701
drop if _merge ==3

gen situacao = ""
replace situacao = "Escola não possui turmas na base de observações do TEACH" if _merge == 2
replace situacao = "Escola não consta nas notas de campo (possivelmente substituidas)" if _merge == 1
drop if _merge ==1

rename ag substituida

replace nm_escola = school_name_pull if nm_escola == ""

gsort situacao -substituida

/* Substituidas
Complexo Escolar Nº 21CCM1,  4 de Abril	SUBSTITUÍDA POR Escola Primária No 07CCM2 do Popular - FEZ UMA 4ª E  UMA 6ª
Escola Primária de Muquinda	SUBSTITUÍDA PELO COMPLEXO ESCOLAR Nº 268 SEBASTIANA GARCIA
Escola Primária de Ngumbe	SUBSTITUÍDA PELA ESCOLA PRIMÁRIA DE SÃO PAULO - CHINGUAR */
drop if id == 281 | id == 286 | id == 305 
drop if sige ==. 

sort  nm_prov supervisor inquiridorteach
order nm_prov nm_municipio sige cod_teach nm_escola  situacao  substituida observaÇÕes  inquiridorteach supervisor  
keep  nm_prov nm_municipio sige cod_teach nm_escola  situacao  substituida observaÇÕes  inquiridorteach supervisor  
//}

export excel using "$OUTDIR/Escolas_sem_observacao.xlsx", firstrow(variables) replace




* Base original
import excel "`PLAN'", sheet("Amostra") firstrow clear

keep CD_ESCOLA CD_ESCOLA_OLD NM_ESCOLA NM_PROV turmas_4_turno1 turmas_4_turno2 turmas_4_amostra_1_turno turmas_4_amostra_2_turno turmas_6_turno1 turmas_6_turno2 turmas_6_amostra_1_turno turmas6_amostra_2_turno Difícilacesso Observações

rename CD_ESCOLA 	 cod_sige 
rename CD_ESCOLA_OLD cod_novo 

save "$TMPDIR/orig_plan.dta" , replace

*****************************************


* Check: Observacoes duplicadas
use "$TMPDIR/turmas_sorteadas.dta" , replace
rename Nome_turma_ nome_turma_obs
duplicates list coder_name province cod_sige grade turno nome_turma_obs

/* +-----------------------------------------------------+
  | group:   obs:   cod_sige   grade   turno   nome_t~s |
  |-----------------------------------------------------|
  |      1    135       8180       4       2        T-C |
  |      1    137       8180       4       2        T-C |
  |      2    136       8180       6       1        T-A |
  |      2    138       8180       6       1        T-A |
  |      3    145       9990       4       1         8M |
  |-----------------------------------------------------|
  |      3    148       9990       4       1         8M |
  |      4     34      15908       6       2      Sala1 |
  |      4    124      15908       6       2      Sala1 |
  |      5      1      16500       4       1          1 |
  |      5      2      16500       4       1          1 |
  |-----------------------------------------------------|
  |      5     29      16500       4       1          1 |
  |      6    117      22649       4       1      �nica |
  |      6    119      22649       4       1      �nica |
  |      7    118      22649       6       1      �nica |
  |      7    120      22649       6       1      �nica |
  +-----------------------------------------------------+ */

bysort cod_sige grade turno nome_turma_obs: gen n= _n
keep if n ==1
save "$TMPDIR/turmas_sorteadas2.dta" , replace

************
use "$TMPDIR/base_obs_teach.dta" , replace
duplicates list coder_name province cod_sige grade turno nome_turma_obs

/*
  +----------------------------------------------------------------+
  | group:   obs:   cod_sige   grade   turno        nome_turma_obs |
  |----------------------------------------------------------------|
  |      1    116       3095       4       2       Fernando Njundo |
  |      1    118       3095       4       2       Fernando Njundo |
  |      2    115       3095       6       2   Ant�nio Miguel Cata |
  |      2    117       3095       6       2   Ant�nio Miguel Cata |
  |      3    140       3545       4       1                 Linda |
  |----------------------------------------------------------------|
  |      3    141       3545       4       1                 Linda |
  |      4     19      17943       4       2                    4A |
  |      4     21      17943       4       2                    4A |
  |      5    201      18192       4       1               Turma A |
  |      5    205      18192       4       1               Turma A |
  +----------------------------------------------------------------+ */

bysort cod_sige grade turno nome_turma_obs: gen n= _n
keep if n ==1
save "$TMPDIR/base_obs_teach2.dta" , replace


* Check 1- Sorteio com planejamento

use "$TMPDIR/turmas_sorteadas2.dta" , replace
duplicates drop username coder coder_name school cod_sige school_name , force
duplicates drop cod_sige, force

merge 1:1 cod_sige using "$TMPDIR/orig_plan.dta" , force
drop _merge

merge 1:m cod_sige using "$TMPDIR/teach_coments.dta"

destring n_turmas_sorteadas, replace force

egen amostra_prevista = rowtotal(turmas_4_amostra_1_turno turmas_4_amostra_2_turno turmas_6_amostra_1_turno turmas6_amostra_2_turno)

tab n_turmas_sorteadas amostra_prevista
gen suspeita_forte = n_turmas_sorteadas < amostra_prevista-1

groups coder_name province n_turmas_sorteadas amostra_prevista if suspeita_forte == 1



* Check 2- Sorteio com TEACH
//{
use "$TMPDIR/turmas_sorteadas2.dta" , replace
merge 1:1 cod_sige grade turno nome_turma_obs using  "$TMPDIR/base_obs_teach2.dta" , force

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                           206
        from master                       103  (_merge==1)
        from using                        103  (_merge==2)

    matched                               103  (_merge==3)
    ----------------------------------------- */

order _merge coder_name school_name grade turno nome_turma_obs

sort  coder_name school_name grade turno nome_turma_obs _merge




//}

* Check 3- Duplicadas

use "$TMPDIR/base_obs_teach.dta", clear





