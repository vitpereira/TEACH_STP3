
* Faz o reshape dos dados de OBSERVACOES do TECH- Inferno fazer reshape no R

* IN
local TEACH  "$TMPDIR/teach_angola1.dta"


* OUT

*****************

use "$TMPDIR/teach_angola1.dta", clear
gen id = _n

* Renames
//{

* Identificadores
//{
rename grade            grade__x1 
rename turno            turno__x1 
rename nome_turma_obs   nome_turma_obs__x1
rename period           period__x1 
rename date             date__x1
rename teacherpresent   teacherpresent__x1
rename teacher_sex      teacher_sex__x1
rename substitute       substitute__x1
rename substitute_sex	substitute_sex__x1
//}

* Time on learning
//{
rename tol1_segment_time1					segment_time1__x1
rename tol1_s1_seca0_snap1_s1_0_1_1        s1_0_1_1__x1
rename tol1_s1_seca0_snap1_s1_0_1_2        s1_0_1_2__x1
rename tol1_s1_seca0_snap2_s1_0_2_1        s1_0_2_1__x1
rename tol1_s1_seca0_snap2_s1_0_2_2        s1_0_2_2__x1
rename tol1_s1_seca0_snap3_s1_0_3_1        s1_0_3_1__x1
rename tol1_s1_seca0_snap3_s1_0_3_2        s1_0_3_2__x1
rename tol2_segment_time2                   segment_time2__x1	
rename tol2_s2_seca0_snap1_s2_0_1_1        s2_0_1_1__x1
rename tol2_s2_seca0_snap1_s2_0_1_2        s2_0_1_2__x1
rename tol2_s2_seca0_snap2_s2_0_2_1        s2_0_2_1__x1
rename tol2_s2_seca0_snap2_s2_0_2_2        s2_0_2_2__x1
rename tol2_s2_seca0_snap3_s2_0_3_1        s2_0_3_1__x1
rename tol2_s2_seca0_snap3_s2_0_3_2        s2_0_3_2__x1
rename tol1_2_segment_time1_2				segment_time1__x2
rename tol1_2_s1_seca0_snap1_2_s1_0_1_1    s1_0_1_1__x2
rename tol1_2_s1_seca0_snap1_2_s1_0_1_2    s1_0_1_2__x2
rename tol1_2_s1_seca0_snap2_2_s1_0_2_1    s1_0_2_1__x2
rename tol1_2_s1_seca0_snap2_2_s1_0_2_2    s1_0_2_2__x2
rename tol1_2_s1_seca0_snap3_2_s1_0_3_1    s1_0_3_1__x2
rename tol1_2_s1_seca0_snap3_2_s1_0_3_2    s1_0_3_2__x2
rename tol2_2_segment_time2_2				segment_time2__x2
rename tol2_2_s2_seca0_snap1_2_s2_0_1_1    s2_0_1_1__x2
rename tol2_2_s2_seca0_snap1_2_s2_0_1_2    s2_0_1_2__x2
rename tol2_2_s2_seca0_snap2_2_s2_0_2_1    s2_0_2_1__x2
rename tol2_2_s2_seca0_snap2_2_s2_0_2_2    s2_0_2_2__x2
rename tol2_2_s2_seca0_snap3_2_s2_0_3_1    s2_0_3_1__x2
rename tol2_2_s2_seca0_snap3_2_s2_0_3_2    s2_0_3_2__x2
rename tol1__x3_segment_time1__x3			segment_time1__x3
rename tol1__x3_s1_seca0_snap1__x3_s1_0    s1_0_1_1__x3
rename tol1__x3_s1_seca0_snap1__x3_s1_0    s1_0_1_2__x3
rename tol1__x3_s1_seca0_snap2__x3_s1_0    s1_0_2_1__x3
rename tol1__x3_s1_seca0_snap2__x3_s1_0    s1_0_2_2__x3
rename tol1__x3_s1_seca0_snap3__x3_s1_0    s1_0_3_1__x3
rename tol1__x3_s1_seca0_snap3__x3_s1_0    s1_0_3_2__x3
rename tol2__x3_segment_time2__x3			segment_time2__x3
rename tol2__x3_s2_seca0_snap1__x3_s2_0    s2_0_1_1__x3
rename tol2__x3_s2_seca0_snap1__x3_s2_0    s2_0_1_2__x3
rename tol2__x3_s2_seca0_snap2__x3_s2_0    s2_0_2_1__x3
rename tol2__x3_s2_seca0_snap2__x3_s2_0    s2_0_2_2__x3
rename tol2__x3_s2_seca0_snap3__x3_s2_0    s2_0_3_1__x3
rename tol2__x3_s2_seca0_snap3__x3_s2_0    s2_0_3_2__x3
rename tol1__x4_segment_time1__x4			segment_time1__x4
rename tol1__x4_s1_seca0_snap1__x4_s1_0    s1_0_1_1__x4
rename tol1__x4_s1_seca0_snap1__x4_s1_0    s1_0_1_2__x4
rename tol1__x4_s1_seca0_snap2__x4_s1_0    s1_0_2_1__x4
rename tol1__x4_s1_seca0_snap2__x4_s1_0    s1_0_2_2__x4
rename tol1__x4_s1_seca0_snap3__x4_s1_0    s1_0_3_1__x4
rename tol1__x4_s1_seca0_snap3__x4_s1_0    s1_0_3_2__x4
rename tol2__x4_segment_time2__x4			segment_time2__x4
rename tol2__x4_s2_seca0_snap1__x4_s2_0    s2_0_1_1__x4
rename tol2__x4_s2_seca0_snap1__x4_s2_0    s2_0_1_2__x4
rename tol2__x4_s2_seca0_snap2__x4_s2_0    s2_0_2_1__x4
rename tol2__x4_s2_seca0_snap2__x4_s2_0    s2_0_2_2__x4
rename tol2__x4_s2_seca0_snap3__x4_s2_0    s2_0_3_1__x4
rename tol2__x4_s2_seca0_snap3__x4_s2_0    s2_0_3_2__x4
//}

* Prefixos
//{
rename precode_* *
rename cb1* *
rename cb2* *

rename _s1_seca1* *
rename _s1_seca2* *
rename _s1_seca3* *
rename _s1_seca4* *
rename _s1_seca5* *
rename _s1_seca6* *
rename _s1_seca7* *
rename _s1_seca8* *
rename _s1_seca9* *

rename _s2_seca1* *
rename _s2_seca2* *
rename _s2_seca3* *
rename _s2_seca4* *
rename _s2_seca5* *
rename _s2_seca6* *
rename _s2_seca7* *
rename _s2_seca8* *
rename _s2_seca9* *

rename _2_s1_seca1_2* *
rename _2_s1_seca2_2* *
rename _2_s1_seca3_2* *
rename _2_s1_seca4_2* *
rename _2_s1_seca5_2* *
rename _2_s1_seca6_2* *
rename _2_s1_seca7_2* *
rename _2_s1_seca8_2* *
rename _2_s1_seca9_2* *

rename _2_s2_seca1_2* *
rename _2_s2_seca2_2* *
rename _2_s2_seca3_2* *
rename _2_s2_seca4_2* *
rename _2_s2_seca5_2* *
rename _2_s2_seca6_2* *
rename _2_s2_seca7_2* *
rename _2_s2_seca8_2* *
rename _2_s2_seca9_2* *

rename __x3_s1_seca1__x3*score *score__x3
rename __x3_s1_seca2__x3*score *score__x3
rename __x3_s1_seca3__x3*score *score__x3
rename __x3_s1_seca4__x3*score *score__x3
rename __x3_s1_seca5__x3*score *score__x3
rename __x3_s1_seca6__x3*score *score__x3
rename __x3_s1_seca7__x3*score *score__x3
rename __x3_s1_seca8__x3*score *score__x3
rename __x3_s1_seca9__x3*score *score__x3

rename __x3_s2_seca1__x3*score *score__x3
rename __x3_s2_seca2__x3*score *score__x3
rename __x3_s2_seca3__x3*score *score__x3
rename __x3_s2_seca4__x3*score *score__x3
rename __x3_s2_seca5__x3*score *score__x3
rename __x3_s2_seca6__x3*score *score__x3
rename __x3_s2_seca7__x3*score *score__x3
rename __x3_s2_seca8__x3*score *score__x3
rename __x3_s2_seca9__x3*score *score__x3

rename __x3_s1_seca1__x3* *
rename __x3_s1_seca2__x3* *
rename __x3_s1_seca3__x3* *
rename __x3_s1_seca4__x3* *
rename __x3_s1_seca5__x3* *
rename __x3_s1_seca6__x3* *
rename __x3_s1_seca7__x3* *
rename __x3_s1_seca8__x3* *
rename __x3_s1_seca9__x3* *

rename __x3_s2_seca1__x3* *
rename __x3_s2_seca2__x3* *
rename __x3_s2_seca3__x3* *
rename __x3_s2_seca4__x3* *
rename __x3_s2_seca5__x3* *
rename __x3_s2_seca6__x3* *
rename __x3_s2_seca7__x3* *
rename __x3_s2_seca8__x3* *
rename __x3_s2_seca9__x3* *

rename __x4_s1_seca1__x4*score *score__x4
rename __x4_s1_seca2__x4*score *score__x4
rename __x4_s1_seca3__x4*score *score__x4
rename __x4_s1_seca4__x4*score *score__x4
rename __x4_s1_seca5__x4*score *score__x4
rename __x4_s1_seca6__x4*score *score__x4
rename __x4_s1_seca7__x4*score *score__x4
rename __x4_s1_seca8__x4*score *score__x4
rename __x4_s1_seca9__x4*score *score__x4

rename __x4_s2_seca1__x4*score *score__x4
rename __x4_s2_seca2__x4*score *score__x4
rename __x4_s2_seca3__x4*score *score__x4
rename __x4_s2_seca4__x4*score *score__x4
rename __x4_s2_seca5__x4*score *score__x4
rename __x4_s2_seca6__x4*score *score__x4
rename __x4_s2_seca7__x4*score *score__x4
rename __x4_s2_seca8__x4*score *score__x4
rename __x4_s2_seca9__x4*score *score__x4

rename __x4_s1_seca1__x4* *
rename __x4_s1_seca2__x4* *
rename __x4_s1_seca3__x4* *
rename __x4_s1_seca4__x4* *
rename __x4_s1_seca5__x4* *
rename __x4_s1_seca6__x4* *
rename __x4_s1_seca7__x4* *
rename __x4_s1_seca8__x4* *
rename __x4_s1_seca9__x4* *

rename __x4_s2_seca1__x4* *
rename __x4_s2_seca2__x4* *
rename __x4_s2_seca3__x4* *
rename __x4_s2_seca4__x4* *
rename __x4_s2_seca5__x4* *
rename __x4_s2_seca6__x4* *
rename __x4_s2_seca7__x4* *
rename __x4_s2_seca8__x4* *
rename __x4_s2_seca9__x4* *

rename *__x3*__x3 *_2*__x3 
rename *__x4*__x4 *_2*__x4 

rename _s*_*__x3__  _s*_*_2__x3
rename _s*_*__x4__  _s*_*_2__x4

rename _s*_a1_0			_s*_a1_0__x1
rename _s*_a1_1         _s*_a1_1__x1
rename _s*_a1_2         _s*_a1_2__x1
rename _s*_a1_3         _s*_a1_3__x1
rename _s*_a1_4         _s*_a1_4__x1
rename _s*_a1_score     _s*_a1_score__x1
rename _s*_a1           _s*_a1__x1
rename _s*_a1_mean      _s*_a1_mean__x1
rename _s*_a1_diff      _s*_a1_diff__x1
rename _s*_a1_abs       _s*_a1_abs__x1
rename _s*_a2_0         _s*_a2_0__x1
rename _s*_a2_1         _s*_a2_1__x1
rename _s*_a2_2         _s*_a2_2__x1
rename _s*_a2_3         _s*_a2_3__x1
rename _s*_a2_score     _s*_a2_score__x1
rename _s*_a2           _s*_a2__x1
rename _s*_a2_mean      _s*_a2_mean__x1
rename _s*_a2_diff      _s*_a2_diff__x1
rename _s*_a2_abs       _s*_a2_abs__x1
rename _s*_b3_0         _s*_b3_0__x1
rename _s*_b3_1         _s*_b3_1__x1
rename _s*_b3_2         _s*_b3_2__x1
rename _s*_b3_3         _s*_b3_3__x1
rename _s*_b3_4         _s*_b3_4__x1
rename _s*_b3_score     _s*_b3_score__x1
rename _s*_b3           _s*_b3__x1
rename _s*_b3_mean      _s*_b3_mean__x1
rename _s*_b3_diff      _s*_b3_diff__x1
rename _s*_b3_abs       _s*_b3_abs__x1
rename _s*_b4_0         _s*_b4_0__x1
rename _s*_b4_1         _s*_b4_1__x1
rename _s*_b4_2         _s*_b4_2__x1
rename _s*_b4_3         _s*_b4_3__x1
rename _s*_b4_score     _s*_b4_score__x1
rename _s*_b4           _s*_b4__x1
rename _s*_b4_mean      _s*_b4_mean__x1
rename _s*_b4_diff      _s*_b4_diff__x1
rename _s*_b4_abs       _s*_b4_abs__x1
rename _s*_b5_0         _s*_b5_0__x1
rename _s*_b5_1         _s*_b5_1__x1
rename _s*_b5_2         _s*_b5_2__x1
rename _s*_b5_score     _s*_b5_score__x1
rename _s*_b5           _s*_b5__x1
rename _s*_b5_mean      _s*_b5_mean__x1
rename _s*_b5_diff      _s*_b5_diff__x1
rename _s*_b5_abs       _s*_b5_abs__x1
rename _s*_b6_0         _s*_b6_0__x1
rename _s*_b6_1         _s*_b6_1__x1
rename _s*_b6_2         _s*_b6_2__x1
rename _s*_b6_3         _s*_b6_3__x1
rename _s*_b6_score     _s*_b6_score__x1
rename _s*_b6           _s*_b6__x1
rename _s*_b6_mean      _s*_b6_mean__x1
rename _s*_b6_diff      _s*_b6_diff__x1
rename _s*_b6_abs       _s*_b6_abs__x1
rename _s*_c7_0         _s*_c7_0__x1
rename _s*_c7_1         _s*_c7_1__x1
rename _s*_c7_2         _s*_c7_2__x1
rename _s*_c7_3         _s*_c7_3__x1
rename _s*_c7_score     _s*_c7_score__x1
rename _s*_c7           _s*_c7__x1
rename _s*_c7_mean      _s*_c7_mean__x1
rename _s*_c7_diff      _s*_c7_diff__x1
rename _s*_c7_abs       _s*_c7_abs__x1
rename _s*_c8_0         _s*_c8_0__x1
rename _s*_c8_1         _s*_c8_1__x1
rename _s*_c8_2         _s*_c8_2__x1
rename _s*_c8_3         _s*_c8_3__x1
rename _s*_c8_score     _s*_c8_score__x1
rename _s*_c8           _s*_c8__x1
rename _s*_c8_mean      _s*_c8_mean__x1
rename _s*_c8_diff      _s*_c8_diff__x1
rename _s*_c8_abs       _s*_c8_abs__x1
rename _s*_c9_0         _s*_c9_0__x1
rename _s*_c9_1         _s*_c9_1__x1
rename _s*_c9_2         _s*_c9_2__x1
rename _s*_c9_3         _s*_c9_3__x1
rename _s*_c9_score     _s*_c9_score__x1
rename _s*_c9           _s*_c9__x1
rename _s*_c9_mean      _s*_c9_mean__x1
rename _s*_c9_diff      _s*_c9_diff__x1
rename _s*_c9_abs       _s*_c9_abs__x1

rename *_2     *__x2
rename *_2*_2  *_s2*__x2
rename _2_s* _s*
rename _s*_2 _s*__x2
rename _s*_2_001 _s*__x2

rename __x3_s*__x3 _s*__x3
rename __x4_s*__x4 _s*__x4
//}

* General Observations
//{
rename go_2_subject_Other__x3 go__x3_subject_Other__x3
rename go_2_subject_Other__x4 go__x4_subject_Other__x4

rename go__*_class_size__*_nb_boys__x class_size_nb_boys__*
rename go__*_class_size__*_nb_girls__ class_size_nb_girls__*

rename go__*_subject__*__x2 go__*_subject__*_2

rename go__x3_subject__x3_* subject_*__x3
rename go__x4_subject__x4_* subject_*__x4

rename go__*_subject_Other__* subject_Other__*

rename go__x3_teachermat__x3_* teachermat__x3_*
rename go__x4_teachermat__x4_* teachermat__x4_*

rename teachermat__*__x2 teachermat__*_2

rename teachermat__x3_* teachermat_*__x3
rename teachermat__x4_* teachermat_*__x4

rename go_2_class_size_2_nb_boys__x2       class_size_nb_boys__x2 
rename go_2_class_size_2_nb_girls__x2      class_size_nb_girls__x2
rename go_2_subject_2_1                    subject_1__x2 
rename go_2_subject_2__x2                  subject_2__x2 
rename go_2_subject_2_3                    subject_3__x2 
rename go_2_subject_2_4                    subject_4__x2 
rename go_2_subject_2__99                  subject__99__x2 
rename go_2_subject_Other__x2			   subject_Other__x2

rename go_2_teachermat_2__x2 go_2_teachermat_2_2
rename go_2_teachermat_2_*  teachermat_*__x2

rename go_class_size_nb_boys 				class_size_nb_boys__x1 
rename go_class_size_nb_girls               class_size_nb_girls__x1 
rename go_subject_1                         subject_1__x1 
rename go_subject__x2                       subject_2__x1 
rename go_subject_3                         subject_3__x1 
rename go_subject_4                         subject_4__x1 
rename go_subject__99                       subject__99__x1 
rename go_subject_Other                     subject_Other__x1

rename go_teachermat__x2 go_teachermat_2
rename go_teachermat_*  teachermat_*__x1
//}
//}

* Reshape
//{
tostring _all, replace force

#delimit ;
reshape long
grade__x@
turno__x@ 
nome_turma_obs__x@
period__x@
date__x@
teacherpresent__x@
teacher_sex__x@
substitute__x@
substitute_sex__x@

_s1_a1_0__x@
_s1_a1_1__x@
_s1_a1_2__x@
_s1_a1_3__x@
_s1_a1_4__x@
_s1_a1_score__x@
_s1_a1__x@
_s1_a1_mean__x@
_s1_a1_diff__x@
_s1_a1_abs__x@
_s1_a2_0__x@
_s1_a2_1__x@
_s1_a2_2__x@
_s1_a2_3__x@
_s1_a2_score__x@
_s1_a2__x@
_s1_a2_mean__x@
_s1_a2_diff__x@
_s1_a2_abs__x@
_s1_b3_0__x@
_s1_b3_1__x@
_s1_b3_2__x@
_s1_b3_3__x@
_s1_b3_4__x@
_s1_b3_score__x@
_s1_b3__x@
_s1_b3_mean__x@
_s1_b3_diff__x@
_s1_b3_abs__x@
_s1_b4_0__x@
_s1_b4_1__x@
_s1_b4_2__x@
_s1_b4_3__x@
_s1_b4_score__x@
_s1_b4__x@
_s1_b4_mean__x@
_s1_b4_diff__x@
_s1_b4_abs__x@
_s1_b5_0__x@
_s1_b5_1__x@
_s1_b5_2__x@
_s1_b5_score__x@
_s1_b5__x@
_s1_b5_mean__x@
_s1_b5_diff__x@
_s1_b5_abs__x@
_s1_b6_0__x@
_s1_b6_1__x@
_s1_b6_2__x@
_s1_b6_3__x@
_s1_b6_score__x@
_s1_b6__x@
_s1_b6_mean__x@
_s1_b6_diff__x@
_s1_b6_abs__x@
_s1_c7_0__x@
_s1_c7_1__x@
_s1_c7_2__x@
_s1_c7_3__x@
_s1_c7_score__x@
_s1_c7__x@
_s1_c7_mean__x@
_s1_c7_diff__x@
_s1_c7_abs__x@
_s1_c8_0__x@
_s1_c8_1__x@
_s1_c8_2__x@
_s1_c8_3__x@
_s1_c8_score__x@
_s1_c8__x@
_s1_c8_mean__x@
_s1_c8_diff__x@
_s1_c8_abs__x@
_s1_c9_0__x@
_s1_c9_1__x@
_s1_c9_2__x@
_s1_c9_3__x@
_s1_c9_score__x@
_s1_c9__x@
_s1_c9_mean__x@
_s1_c9_diff__x@
_s1_c9_abs__x@

_s2_a1_0__x@
_s2_a1_1__x@
_s2_a1_2__x@
_s2_a1_3__x@
_s2_a1_4__x@
_s2_a1_score__x@
_s2_a1__x@
_s2_a1_mean__x@
_s2_a1_diff__x@
_s2_a1_abs__x@
_s2_a2_0__x@
_s2_a2_1__x@
_s2_a2_2__x@
_s2_a2_3__x@
_s2_a2_score__x@
_s2_a2__x@
_s2_a2_mean__x@
_s2_a2_diff__x@
_s2_a2_abs__x@
_s2_b3_0__x@
_s2_b3_1__x@
_s2_b3_2__x@
_s2_b3_3__x@
_s2_b3_4__x@
_s2_b3_score__x@
_s2_b3__x@
_s2_b3_mean__x@
_s2_b3_diff__x@
_s2_b3_abs__x@
_s2_b4_0__x@
_s2_b4_1__x@
_s2_b4_2__x@
_s2_b4_3__x@
_s2_b4_score__x@
_s2_b4__x@
_s2_b4_mean__x@
_s2_b4_diff__x@
_s2_b4_abs__x@
_s2_b5_0__x@
_s2_b5_1__x@
_s2_b5_2__x@
_s2_b5_score__x@
_s2_b5__x@
_s2_b5_mean__x@
_s2_b5_diff__x@
_s2_b5_abs__x@
_s2_b6_0__x@
_s2_b6_1__x@
_s2_b6_2__x@
_s2_b6_3__x@
_s2_b6_score__x@
_s2_b6__x@
_s2_b6_mean__x@
_s2_b6_diff__x@
_s2_b6_abs__x@
_s2_c7_0__x@
_s2_c7_1__x@
_s2_c7_2__x@
_s2_c7_3__x@
_s2_c7_score__x@
_s2_c7__x@
_s2_c7_mean__x@
_s2_c7_diff__x@
_s2_c7_abs__x@
_s2_c8_0__x@
_s2_c8_1__x@
_s2_c8_2__x@
_s2_c8_3__x@
_s2_c8_score__x@
_s2_c8__x@
_s2_c8_mean__x@
_s2_c8_diff__x@
_s2_c8_abs__x@
_s2_c9_0__x@
_s2_c9_1__x@
_s2_c9_2__x@
_s2_c9_3__x@
_s2_c9_score__x@
_s2_c9__x@
_s2_c9_mean__x@
_s2_c9_diff__x@
_s2_c9_abs__x@

segment_time1__x@
s1_0_1_1__x@
s1_0_1_2__x@
s1_0_2_1__x@
s1_0_2_2__x@
s1_0_3_1__x@
s1_0_3_2__x@

segment_time2__x@	
s2_0_1_1__x@
s2_0_1_2__x@
s2_0_2_1__x@
s2_0_2_2__x@
s2_0_3_1__x@
s2_0_3_2__x@

class_size_nb_boys__x@
class_size_nb_girls__x@
subject_1__x@
subject_2__x@
subject_3__x@
subject_4__x@
subject__99__x@
subject_Other__x@
teachermat_1__x@
teachermat_2__x@
teachermat_3__x@
teachermat_5__x@
teachermat_8__x@
teachermat_10__x@
teachermat_11__x@
teachermat_12__x@
teachermat_13__x@
teachermat_15__x@
teachermat_18__x@
teachermat_19__x@
teachermat_20__x@
teachermat_21__x@

, i("id") j(obs_ord) string;

#delimit cr
//}

* Renames after reshape
//{

rename *__x *
rename _s*__x _s*
rename _s* s*
//}

* Varlabels
//{
label var id					"ID da observação"
label var obs_ord               "Ordem da turma no preenchimento do formulário"
label var start                 "Horário de início do preenchimento"
label var end                   "Horário de fim do preenchimento"
label var today                 "Dia do preenchimento"
label var username              "Nome do usuário"
label var deviceid              "ID do tablet"
label var coder                 "Código do observador"
label var coder_name            "Nome observador"
label var coder_label           "Código e nome do observador"
label var school                "Código SIGE"
label var school_name_manual    "Nome da escola"
label var province              "Província"
label var municipality          "Município"
label var commune               "Comuna"
label var cod_sige              "Codigo Sige"
label var cod_novo              "Codigo completo novo"
label var school_name_pull      "Nome da escola com municipio e provincia"
label var school_name           "Nome da escola com comuna"
label var local_gps             "Posição de GPS"
label var _local_gps_latitude   "latitude"
label var _local_gps_longitude  "longitude"
label var _local_gps_altitude   "altitude"
label var _local_gps_precision  "precisão"
label var n_total_turmas        "turmas observadas"

label var grade				"Classe"
label var turno				"Turno da turma"
label var nome_turma_obs	"Escreva o nome da turma, exatamente como escreveste anteriormente"
label var period			"Período"
label var date				"Data em que a aula está a ocorrer"
label var teacherpresent	"O professor titular está presente?"
label var teacher_sex		"Sexo do professor titular"
label var substitute		"Se o professor titular faltou, tem algum professor suplente?"
label var substitute_sex	"Sexo do professor suplente"

*1o segmento
//{
label var    	s1_0_1_1	            "0.1. A professora promove uma atividade de aprendizagem para a maioria dos alunos	"
label var    	s1_0_1_2	            "0.2. Os alunos estão envolvidos na tarefa	"
label var    	s1_0_2_1	            "0.1. A professora promove uma atividade de aprendizagem para a maioria dos alunos	"
label var    	s1_0_2_2	            "0.2. Os alunos estão envolvidos na tarefa	"
label var    	s1_0_3_1	            "0.1. A professora promove uma atividade de aprendizagem para a maioria dos alunos	"
label var    	s1_0_3_2	            "0.2. Os alunos estão envolvidos na tarefa	"
label var    	s1_a1_0	            "AMBIENTE DE APOIO À APRENDIZAGEM	"
label var    	s1_a1_1	            "1.1 A professora trata todos os alunos com respeito	"
label var    	s1_a1_2	            "1.2 A professora usa uma linguagem positiva com os alunos	"
label var    	s1_a1_3	            "1.3 A professora corresponde às necessidades dos alunos	"
label var    	s1_a1_4	            "1.4 A professora não apresenta preconceitos de género e rejeita estereótipos de género na sala de aula	"
label var    	s1_a1_score	        "	"
label var    	s1_a1	            	"AMBIENTE DE APOIO À APRENDIZAGEM: Pontuação"
label var    	s1_a1_mean	            "	"
label var    	s1_a1_diff	            "	"
label var    	s1_a1_abs	            "	"
label var    	s1_a2_0	            "EXPECTATIVAS COMPORTAMENTAIS POSITIVAS	"
label var    	s1_a2_1	            "2.1 A professora define claramente as expetativas de comportamento para as atividades na sala de aula	"
label var    	s1_a2_2	            "2.2 A professora reconhece o comportamento positivo dos alunos	"
label var    	s1_a2_3	            "2.3 A professora redireciona o mau comportamento e concentra-se no comportamento esperado em vez de no comportamento indesejado	"
label var    	s1_a2_score	        "	"
label var    	s1_a2	            	"EXPECTATIVAS COMPORTAMENTAIS POSITIVAS: Pontuação"
label var    	s1_a2_mean	            "	"
label var    	s1_a2_diff	            "	"
label var    	s1_a2_abs	            "	"
label var    	s1_b3_0	            "CLARIFICAÇÃO DA LIÇÃO	"
label var    	s1_b3_1	            "3.1 A professora articula explicitamente os objetivos da aula e relaciona as atividades da turma com os objetivos	"
label var    	s1_b3_2	            "3.2 A explicação da professora sobre o conteúdo é clara	"
label var    	s1_b3_3	            "3.3 Durante a aula, a professora estabelece conexões e relaciona-as com outros conteúdos conhecidos ou com a vida quotidiana dos alunos	"
label var    	s1_b3_4	            "3.4 A professora exemplifica demonstrando ou pensando em voz alta	"
label var    	s1_b3_score	        "	"
label var    	s1_b3	            	"CLARIFICAÇÃO DA LIÇÃO: Pontuação"
label var    	s1_b3_mean	            "	"
label var    	s1_b3_diff	            "	"
label var    	s1_b3_abs	            "	"
label var    	s1_b4_0	            "VERIFICAÇÃO DA COMPREENSÃO	"
label var    	s1_b4_1	            "4.1 A professora faz perguntas, dá pistas ou usa outras estratégias para determinar qual é o nível de compreensão dos alunos	"
label var    	s1_b4_2	            "4.2 A professora monitoriza a maioria dos alunos durante o trabalho individual ou de grupo	"
label var    	s1_b4_3	            "4.3 A professora ajusta o ensino ao nível dos alunos	"
label var    	s1_b4_score	        "	"
label var    	s1_b4	            	"VERIFICAÇÃO DA COMPREENSÃO: Pontuação"
label var    	s1_b4_mean	            "	"
label var    	s1_b4_diff	            "	"
label var    	s1_b4_abs	            "	"
label var    	s1_b5_0	            "COMENTÁRIOS CONSTRUTIVOS	"
label var    	s1_b5_1	            "5.1 A professora faz comentários específicos ou dá pistas que ajudam a esclarecer os equívocos dos alunos	"
label var    	s1_b5_2	            "5.2 A professora comentários específicos ou dá pistas que ajudam os alunos a identificarem os seus sucessos	"
label var    	s1_b5_score	        "	"
label var    	s1_b5	            	"COMENTÁRIOS CONSTRUTIVOS: Pontuação"
label var    	s1_b5_mean	            "	"
label var    	s1_b5_diff	            "	"
label var    	s1_b5_abs	            "	"
label var    	s1_b6_0	            "RACIOCÍNIO CRÍTICO	"
label var    	s1_b6_1	            "6.1 A professora faz perguntas de resposta aberta	"
label var    	s1_b6_2	            "6.2 A professora propõe atividades de raciocínio	"
label var    	s1_b6_3	            "6.3 Os alunos fazem perguntas de resposta aberta ou desenvolvem atividades de raciocínio	"
label var    	s1_b6_score	        "	"
label var    	s1_b6	           	 	"RACIOCÍNIO CRÍTICO: Pontuação"
label var    	s1_b6_mean	            "	"
label var    	s1_b6_diff	            "	"
label var    	s1_b6_abs	            "	"
label var    	s1_c7_0	            "AUTONOMIA	"
label var    	s1_c7_1	            "7.1 A professora proporciona escolhas aos alunos	"
label var    	s1_c7_2	            "7.2 A professora oferece oportunidades aos alunos para assumirem papéis na sala de aula	"
label var    	s1_c7_3	            "7.3 Os alunos voluntariam-se para participar na aula	"
label var    	s1_c7_score	        "	"
label var    	s1_c7	            	"AUTONOMIA: Pontuação"
label var    	s1_c7_mean	            "	"
label var    	s1_c7_diff	            "	"
label var    	s1_c7_abs	            "	"
label var    	s1_c8_0	            "PERSEVERANÇA	"
label var    	s1_c8_1	            "8.1 A professora reconhece o esforço dos alunos	"
label var    	s1_c8_2	            "8.2 A professora tem uma atitude positiva em relação aos desafios dos alunos	"
label var    	s1_c8_3	            "8.3 A professora incentiva a definição de objetivos	"
label var    	s1_c8_score	        "	"
label var    	s1_c8	            	"PERSEVERANÇA: Pontuação"
label var    	s1_c8_mean	            "	"
label var    	s1_c8_diff	            "	"
label var    	s1_c8_abs	            "	"
label var    	s1_c9_0	            "CAPACIDADES SOCIAIS E COLABORATIVAS	"
label var    	s1_c9_1	            "9.1 A professora promove a colaboração entre alunos através da interação entre colegas	"
label var    	s1_c9_2	            "9.2 A professora promove as capacidades interpessoais dos alunos	"
label var    	s1_c9_3	            "9.3 Os alunos colaboram uns com os outros através da interação entre eles	"
label var    	s1_c9_score	        "	"
label var    	s1_c9	            	"CAPACIDADES SOCIAIS E COLABORATIVAS: Pontuação"
label var    	s1_c9_mean	            "	"
label var    	s1_c9_diff	            "	"
label var    	s1_c9_abs	            "	"
//}

*2o segmento
//{
label var    	s2_0_1_1	            "0.1. A professora promove uma atividade de aprendizagem para a maioria dos alunos	"
label var    	s2_0_1_2	            "0.2. Os alunos estão envolvidos na tarefa	"
label var    	s2_0_2_1	            "0.1. A professora promove uma atividade de aprendizagem para a maioria dos alunos	"
label var    	s2_0_2_2	            "0.2. Os alunos estão envolvidos na tarefa	"
label var    	s2_0_3_1	            "0.1. A professora promove uma atividade de aprendizagem para a maioria dos alunos	"
label var    	s2_0_3_2	            "0.2. Os alunos estão envolvidos na tarefa	"
label var    	s2_a1_0	            "AMBIENTE DE APOIO À APRENDIZAGEM	"
label var    	s2_a1_1	            "1.1 A professora trata todos os alunos com respeito	"
label var    	s2_a1_2	            "1.2 A professora usa uma linguagem positiva com os alunos	"
label var    	s2_a1_3	            "1.3 A professora corresponde às necessidades dos alunos	"
label var    	s2_a1_4	            "1.4 A professora não apresenta preconceitos de género e rejeita estereótipos de género na sala de aula	"
label var    	s2_a1_score	        "	"
label var    	s2_a1	            	"AMBIENTE DE APOIO À APRENDIZAGEM: Pontuação"
label var    	s2_a1_mean	            "	"
label var    	s2_a1_diff	            "	"
label var    	s2_a1_abs	            "	"
label var    	s2_a2_0	            "EXPECTATIVAS COMPORTAMENTAIS POSITIVAS	"
label var    	s2_a2_1	            "2.1 A professora define claramente as expetativas de comportamento para as atividades na sala de aula	"
label var    	s2_a2_2	            "2.2 A professora reconhece o comportamento positivo dos alunos	"
label var    	s2_a2_3	            "2.3 A professora redireciona o mau comportamento e concentra-se no comportamento esperado em vez de no comportamento indesejado	"
label var    	s2_a2_score	        "	"
label var    	s2_a2	            	"EXPECTATIVAS COMPORTAMENTAIS POSITIVAS: Pontuação"
label var    	s2_a2_mean	            "	"
label var    	s2_a2_diff	            "	"
label var    	s2_a2_abs	            "	"
label var    	s2_b3_0	            "CLARIFICAÇÃO DA LIÇÃO	"
label var    	s2_b3_1	            "3.1 A professora articula explicitamente os objetivos da aula e relaciona as atividades da turma com os objetivos	"
label var    	s2_b3_2	            "3.2 A explicação da professora sobre o conteúdo é clara	"
label var    	s2_b3_3	            "3.3 Durante a aula, a professora estabelece conexões e relaciona-as com outros conteúdos conhecidos ou com a vida quotidiana dos alunos	"
label var    	s2_b3_4	            "3.4 A professora exemplifica demonstrando ou pensando em voz alta	"
label var    	s2_b3_score	        "	"
label var    	s2_b3	            	"CLARIFICAÇÃO DA LIÇÃO: Pontuação"
label var    	s2_b3_mean	            "	"
label var    	s2_b3_diff	            "	"
label var    	s2_b3_abs	            "	"
label var    	s2_b4_0	            "VERIFICAÇÃO DA COMPREENSÃO	"
label var    	s2_b4_1	            "4.1 A professora faz perguntas, dá pistas ou usa outras estratégias para determinar qual é o nível de compreensão dos alunos	"
label var    	s2_b4_2	            "4.2 A professora monitoriza a maioria dos alunos durante o trabalho individual ou de grupo	"
label var    	s2_b4_3	            "4.3 A professora ajusta o ensino ao nível dos alunos	"
label var    	s2_b4_score	        "	"
label var    	s2_b4	            	"VERIFICAÇÃO DA COMPREENSÃO: Pontuação"
label var    	s2_b4_mean	            "	"
label var    	s2_b4_diff	            "	"
label var    	s2_b4_abs	            "	"
label var    	s2_b5_0	            "COMENTÁRIOS CONSTRUTIVOS	"
label var    	s2_b5_1	            "5.1 A professora faz comentários específicos ou dá pistas que ajudam a esclarecer os equívocos dos alunos	"
label var    	s2_b5_2	            "5.2 A professora comentários específicos ou dá pistas que ajudam os alunos a identificarem os seus sucessos	"
label var    	s2_b5_score	        "	"
label var    	s2_b5	            	"COMENTÁRIOS CONSTRUTIVOS: Pontuação"
label var    	s2_b5_mean	            "	"
label var    	s2_b5_diff	            "	"
label var    	s2_b5_abs	            "	"
label var    	s2_b6_0	            "RACIOCÍNIO CRÍTICO	"
label var    	s2_b6_1	            "6.1 A professora faz perguntas de resposta aberta	"
label var    	s2_b6_2	            "6.2 A professora propõe atividades de raciocínio	"
label var    	s2_b6_3	            "6.3 Os alunos fazem perguntas de resposta aberta ou desenvolvem atividades de raciocínio	"
label var    	s2_b6_score	        "	"
label var    	s2_b6	           	 	"RACIOCÍNIO CRÍTICO: Pontuação"
label var    	s2_b6_mean	            "	"
label var    	s2_b6_diff	            "	"
label var    	s2_b6_abs	            "	"
label var    	s2_c7_0	            "AUTONOMIA	"
label var    	s2_c7_1	            "7.1 A professora proporciona escolhas aos alunos	"
label var    	s2_c7_2	            "7.2 A professora oferece oportunidades aos alunos para assumirem papéis na sala de aula	"
label var    	s2_c7_3	            "7.3 Os alunos voluntariam-se para participar na aula	"
label var    	s2_c7_score	        "	"
label var    	s2_c7	            	"AUTONOMIA: Pontuação"
label var    	s2_c7_mean	            "	"
label var    	s2_c7_diff	            "	"
label var    	s2_c7_abs	            "	"
label var    	s2_c8_0	            "PERSEVERANÇA	"
label var    	s2_c8_1	            "8.1 A professora reconhece o esforço dos alunos	"
label var    	s2_c8_2	            "8.2 A professora tem uma atitude positiva em relação aos desafios dos alunos	"
label var    	s2_c8_3	            "8.3 A professora incentiva a definição de objetivos	"
label var    	s2_c8_score	        "	"
label var    	s2_c8	            	"PERSEVERANÇA: Pontuação"
label var    	s2_c8_mean	            "	"
label var    	s2_c8_diff	            "	"
label var    	s2_c8_abs	            "	"
label var    	s2_c9_0	            "CAPACIDADES SOCIAIS E COLABORATIVAS	"
label var    	s2_c9_1	            "9.1 A professora promove a colaboração entre alunos através da interação entre colegas	"
label var    	s2_c9_2	            "9.2 A professora promove as capacidades interpessoais dos alunos	"
label var    	s2_c9_3	            "9.3 Os alunos colaboram uns com os outros através da interação entre eles	"
label var    	s2_c9_score	        "	"
label var    	s2_c9	            	"CAPACIDADES SOCIAIS E COLABORATIVAS: Pontuação"
label var    	s2_c9_mean	            "	"
label var    	s2_c9_diff	            "	"
label var    	s2_c9_abs	            "	"
//}
//}

* Um pouco mais de limpeza
//{

* escolas que tinham algum problema no nome
replace school 				= "100" 																		if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace school_name_manual	= "Escola Primária 14 de Abril da Kalonga" 										if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace province            = "CUNENE" 																		if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace municipality        = "CUVELAI" 																	if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace commune             = "CALONGA" 																	if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace cod_sige            = "1015" 																		if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace cod_novo            = "1705040017"  																if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace school_name_pull    = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE" 					if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"
replace school_name         = "Escola Primária 14 de Abril da Kalonga//CUVELAI//CUNENE//CALONGA//CUVELAI" 	if id == "167" & deviceid == "collect:b6gyhCCumDxV1ojd" & today == "22694"

replace school 				= "49" 																				if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace school_name_manual	= "Esc. Primária Adriano Kapumba Nº 36" 											if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace province            = "BIÉ" 																			if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace municipality        = "CUITO (KUITO)" 																	if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace commune             = "CUNJE" 																			if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace cod_sige            = "13639" 																			if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace cod_novo            = "1203030005"  																	if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace school_name_pull    = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ" 						if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"
replace school_name         = "Esc. Primária Adriano Kapumba Nº 36//CUITO (KUITO)//BIÉ//CUNJE//CUITO (KUITO)" 	if id == "242" & deviceid == "collect:MzsMnfCPns0gnS7z" & today == "22697"


* Destrings
foreach var of varlist _all {
replace `var' = "." if `var' == "n/a"
cap destring `var' , replace
}

drop if date == "."
drop *score *mean *diff *abs  simserial subscriberid showscores phonenumber sensitivity coder_name_manual


* Variáveis do arquivo de tabelas e graficos

gen school_name_fixid = school_name
gen school_id = cod_sige

gen grade_fixid = grade
gen classletter_fixid = nome_turma_obs

rename class_size_nb_boys  nb_boys 
rename class_size_nb_girls nb_girls
//}

* Merge com dados originais para pegar rural e urbano
gen CD_ESCOLA = cod_sige
merge m:1 CD_ESCOLA using "$TMPDIR/campo_short.dta" , gen(merge)
drop if merge ==2

* Escolas substituidas
cap replace DC_LOCALIZACAO = "Periurbana"	if cod_sige == 12027
cap replace DC_LOCALIZACAO = "Periurbana"	if cod_sige == 27133
cap replace DC_LOCALIZACAO = "Periurbana"	if cod_sige == 27101
cap replace DC_LOCALIZACAO = "Rural"		if cod_sige == 14369
cap replace DC_LOCALIZACAO = "Rural"		if cod_sige == 25120
cap replace DC_LOCALIZACAO = "Rural"		if cod_sige == 12857
cap replace DC_LOCALIZACAO = "Periurbana"	if cod_sige == 17477
cap replace DC_LOCALIZACAO = "Rural"		if cod_sige == 2291
cap replace DC_LOCALIZACAO = "Rural"		if cod_sige == 1059
cap replace DC_LOCALIZACAO = "Urbana"		if cod_sige == 3676
cap replace DC_LOCALIZACAO = "Rural"		if cod_sige == 3731
cap replace DC_LOCALIZACAO = "Periurbana"	if cod_sige == 673
cap replace DC_LOCALIZACAO = "Rural"		if cod_sige == 23527
cap replace DC_LOCALIZACAO = "Periurbana"	if cod_sige == 18689

* Acentos nas provincias

replace province = "BIE" if regexm(province, "^BI")
replace province = "HUILA" if regexm(province, "^HU.LA")
replace province = "UIGE" if regexm(province, "^U.GE")


* localidade
gen locality = 0 // urbana ou periurbana
replace locality = 1 if DC_LOCALIZACAO == "Rural"

* Teacher sex
rename teacher_sex main_teacher_sex
gen teacher_sex = main_teacher_sex
replace teacher_sex = substitute_sex if teacher_sex == . 

* Subject
foreach i in 1 2 3 4 _99 {
replace subject_`i' = "1" if subject_`i' == "True" 
replace subject_`i' = "0" if subject_`i' == "False"
destring  subject_`i'  , replace
}

label var subject_1 	"Disciplina: Matemática"
label var subject_2 	"Disciplina: Português"
label var subject_3 	"Disciplina: Ciências Naturais"
label var subject_4 	"Disciplina: Ciências Sociais"
label var subject__99 	"Disciplina: Outra"

rename subject__99 subject_99

* Tira as obs de depois de 26 de fevereiro

drop if today >  22702

save "$OUTDIR/Angola_2022_teach_clean.dta" , replace


