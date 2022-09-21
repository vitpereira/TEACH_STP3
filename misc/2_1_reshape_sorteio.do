

* Faz o reshape dos dados de sorteio do TECH- Inferno fazer reshape no R

* IN
local SORTEIO_TURMAS  "$TMPDIR/selecao1.dta"

* OUT

*****************

use "$TMPDIR/selecao1.dta", clear

* Limpa um pouco
//{
drop *random* *version* mod1* c_p1* *sem_sorteio* mostra_sorteio_c_p1_*
rename amostra_4am  amostra_4m
rename amostra_4at  amostra_4t
rename amostra_6am  amostra_6m
rename amostra_6at  amostra_6t

rename group_fx7ba83_obs_turmas_4a_m_to		tot_turmas_4m
rename group_lv6ei26_obs_turmas_4a_t_to     tot_turmas_4t
rename group_kv9ra51_obs_turmas_6a_m_to     tot_turmas_6m
rename group_qi5ae64_obs_turmas_6a_t_to     tot_turmas_6t
rename group_fx7ba83_turmas_4a_m			disp_turmas_4m
rename group_lv6ei26_turmas_4a_t			disp_turmas_4t
rename group_kv9ra51_turmas_6a_m			disp_turmas_6m
rename group_qi5ae64_turmas_6a_t			disp_turmas_6t

destring tot_turmas* , replace force
destring disp_turmas* , replace force

rename precode_* *
rename _local_gps_* gps_*
//}

* Prepara para nao utilizar as turmas que nao deveriam ser preenchuidas
//{

foreach ct in 4m 4t 6m 6t {
	forv i = 1/99 {
    *capture confirm variable _`i'__Prof_turma_`ct',  exact
*		if !_rc{
		cap replace _`i'__Nome_turma_`ct' = "INVALIDO" if  `i' > disp_turmas_`ct'
		cap replace _`i'__Cod_turma_`ct'  = "INVALIDO" if  `i' > disp_turmas_`ct'
		cap replace _`i'__Prof_turma_`ct' = "INVALIDO" if  `i' > disp_turmas_`ct'
		
		cap replace _`i'__Nome_turma_`ct' = "RESP EM BRANCO" if  _`i'__Nome_turma_`ct' == ""
		cap replace _`i'__Cod_turma_`ct'  = "RESP EM BRANCO" if  _`i'__Cod_turma_`ct'  == ""
		cap replace _`i'__Prof_turma_`ct' = "RESP EM BRANCO" if  _`i'__Prof_turma_`ct' == ""
					
*		}
	}
}

* Reshape em 2 etapas
//{
reshape long "_@__Nome_turma_4m" "_@__Cod_turma_4m" "_@__Prof_turma_4m" ///
			 "_@__Nome_turma_4t" "_@__Cod_turma_4t" "_@__Prof_turma_4t" ///
			 "_@__Nome_turma_6m" "_@__Cod_turma_6m" "_@__Prof_turma_6m" ///
			 "_@__Nome_turma_6t" "_@__Cod_turma_6t" "_@__Prof_turma_6t" ///		
 , i("ID") j(obs_ord)

rename ___* * 

reshape long "amostra_@ tot_turmas_@ disp_turmas_@ Nome_turma_@  Cod_turma_@ Prof_turma_@  mostra_sorteio_selecionada_1_@ mostra_sorteio_selecionada_2_@ " , i(ID obs_ord) j(classe_turno) string
//}

* Limpa um pouco mais
//{
rename mostra_sorteio_selecionada* selecionada*
rename mostra_sorteio_n_total_turmas  n_turmas_sorteadas
drop if Nome_turma == "INVALIDO"
drop if Nome_turma == ""   // sera que aqui acabo tirando quem deixou de preencher? Acho que nao. quem deixou em branco fica com "EM BRANCO"

gen grade = substr(classe_turno, 1, 1)
gen turno = substr(classe_turno, 2, 1)

destring grade, replace force
rename turno turno_old
gen turno = .
replace turno = 1 if turno_old == "m"
replace turno = 2 if turno_old == "t"

//}

* Salva as bases

* Base de todas as turmas disponiveis
save "$TMPDIR/todas_turmas_disp.dta" , replace

* Base de todas as turmas sorteadas
keep if Nome_turma == selecionada_1 | Nome_turma == selecionada_2
save "$TMPDIR/turmas_sorteadas.dta" , replace







