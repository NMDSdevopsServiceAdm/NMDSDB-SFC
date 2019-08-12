-- PROCEDURE: migration.migratebits()

-- DROP FUNCTION migration.migratebits();

-- Top level function to trigger migration of Establishments and all sub-elements.
-- RUN with call migration.migratebits();

CREATE OR REPLACE PROCEDURE migration.migrate7(
)
 LANGUAGE plpgsql
AS $BODY$
DECLARE
        Allestbid  REFCURSOR;
        currentestbid record;
Begin 

--truncate migration.errorlog;
--truncate migration.runlog;

OPEN Allestbid  for 
        select id from (
values

(	2452	),
(	3571	),
(	3587	),
(	3595	),
(	3658	),
(	3667	),
(	3672	),
(	3677	),
(	3679	),
(	3700	),
(	3720	),
(	3751	),
(	3783	),
(	3837	),
(	3853	),
(	3899	),
(	3900	),
(	3904	),
(	3983	),
(	4009	),
(	4030	),
(	4038	),
(	4039	),
(	4077	),
(	4079	),
(	4080	),
(	4091	),
(	4115	),
(	4116	),
(	4119	),
(	4139	),
(	4151	),
(	4190	),
(	4197	),
(	4242	),
(	4298	),
(	4437	),
(	4445	),
(	4451	),
(	4473	),
(	4523	),
(	4530	),
(	4615	),
(	4637	),
(	4878	),
(	5030	),
(	5099	),
(	5130	),
(	5189	),
(	5209	),
(	5311	),
(	5312	),
(	5347	),
(	5579	),
(	5587	),
(	5719	),
(	5735	),
(	5843	),
(	5965	),
(	6242	),
(	6301	),
(	6328	),
(	6350	),
(	6759	),
(	6768	),
(	6788	),
(	6833	),
(	6849	),
(	6877	),
(	6909	),
(	6999	),
(	7003	),
(	7006	),
(	7007	),
(	7008	),
(	7009	),
(	7011	),
(	7015	),
(	7115	),
(	7398	),
(	7467	),
(	7487	),
(	7494	),
(	7504	),
(	7640	),
(	7643	),
(	7649	),
(	7663	),
(	7669	),
(	7710	),
(	7802	),
(	7805	),
(	7825	),
(	7839	),
(	7887	),
(	8011	),
(	8014	),
(	8040	),
(	8058	),
(	8132	),
(	8144	),
(	8171	),
(	8209	),
(	8223	),
(	8228	),
(	8250	),
(	8360	),
(	8409	),
(	8521	),
(	8581	),
(	8783	),
(	8802	),
(	8823	),
(	9048	),
(	9074	),
(	9124	),
(	9184	),
(	9186	),
(	9187	),
(	9189	),
(	9288	),
(	9292	),
(	9418	),
(	9508	),
(	9545	),
(	9549	),
(	9625	),
(	9661	),
(	9700	),
(	9726	),
(	9767	),
(	9769	),
(	10007	),
(	10070	),
(	10142	),
(	10245	),
(	10277	),
(	10321	),
(	10324	),
(	10327	),
(	10329	),
(	10331	),
(	10332	),
(	10333	),
(	10337	),
(	10338	),
(	10339	),
(	10340	),
(	10342	),
(	10344	),
(	10346	),
(	10347	),
(	10348	),
(	10349	),
(	10403	),
(	10433	),
(	10442	),
(	10443	),
(	10445	),
(	10447	),
(	10451	),
(	10452	),
(	10453	),
(	10599	),
(	10654	),
(	10684	),
(	10822	),
(	10908	),
(	10952	),
(	10957	),
(	10967	),
(	10973	),
(	10981	),
(	10985	),
(	11000	),
(	11080	),
(	11081	),
(	11082	),
(	11101	),
(	11102	),
(	11103	),
(	11107	),
(	11126	),
(	11127	),
(	11129	),
(	11130	),
(	11224	),
(	11285	),
(	11286	),
(	11287	),
(	11330	),
(	11331	),
(	11332	),
(	11333	),
(	11334	),
(	11336	),
(	11338	),
(	11364	),
(	11483	),
(	11495	),
(	11518	),
(	11561	),
(	11562	),
(	11563	),
(	11685	),
(	11688	),
(	11739	),
(	11740	),
(	11741	),
(	11742	),
(	11745	),
(	11747	),
(	11749	),
(	11750	),
(	11757	),
(	11853	),
(	11903	),
(	11961	),
(	12027	),
(	12029	),
(	12121	),
(	12156	),
(	12189	),
(	12196	),
(	12203	),
(	12300	),
(	12333	),
(	12348	),
(	12365	),
(	12368	),
(	12372	),
(	12373	),
(	12391	),
(	12410	),
(	12412	),
(	12413	),
(	12415	),
(	12418	),
(	12419	),
(	12422	),
(	12439	),
(	12477	),
(	12488	),
(	12493	),
(	12501	),
(	12505	),
(	12509	),
(	12521	),
(	12522	),
(	12527	),
(	12528	),
(	12529	),
(	12530	),
(	12532	),
(	12567	),
(	12619	),
(	12623	),
(	12635	),
(	12694	),
(	12703	),
(	12714	),
(	12793	),
(	12877	),
(	13016	),
(	13053	),
(	13064	),
(	13110	),
(	13131	),
(	13135	),
(	13399	),
(	13446	),
(	13490	),
(	13540	),
(	13589	),
(	13606	),
(	13613	),
(	13663	),
(	13665	),
(	13667	),
(	13733	),
(	13767	),
(	13779	),
(	13783	),
(	13801	),
(	13802	),
(	13804	),
(	13805	),
(	13806	),
(	13807	),
(	13808	),
(	13810	),
(	13812	),
(	13814	),
(	13816	),
(	13822	),
(	13823	),
(	13825	),
(	13828	),
(	13829	),
(	13830	),
(	13831	),
(	13832	),
(	13834	),
(	13835	),
(	13837	),
(	13840	),
(	13841	),
(	13843	),
(	13844	),
(	13845	),
(	13846	),
(	13847	),
(	13850	),
(	13867	),
(	13874	),
(	13876	),
(	13877	),
(	13897	),
(	13898	),
(	13899	),
(	13900	),
(	13904	),
(	13905	),
(	13906	),
(	13907	),
(	13908	),
(	13946	),
(	14045	),
(	14062	),
(	14135	),
(	14162	),
(	14163	),
(	14181	),
(	14207	),
(	14235	),
(	14248	),
(	14261	),
(	14300	),
(	14329	),
(	14333	),
(	14334	),
(	14349	),
(	14385	),
(	14397	),
(	14401	),
(	14415	),
(	14455	),
(	14475	),
(	14489	),
(	14492	),
(	14510	),
(	14514	),
(	14529	),
(	14536	),
(	14543	),
(	14569	),
(	14608	),
(	14693	),
(	14722	),
(	14723	),
(	14724	),
(	14726	),
(	14727	),
(	14728	),
(	14729	),
(	14730	),
(	14731	),
(	14732	),
(	14733	),
(	14734	),
(	14735	),
(	14736	),
(	14737	),
(	14738	),
(	14740	),
(	14741	),
(	14742	),
(	14743	),
(	14744	),
(	14745	),
(	14746	),
(	14747	),
(	14748	),
(	14749	),
(	14750	),
(	14751	),
(	14752	),
(	14754	),
(	14755	),
(	14756	),
(	14757	),
(	14758	),
(	14759	),
(	14760	),
(	14761	),
(	14762	),
(	14763	),
(	14764	),
(	14765	),
(	14766	),
(	14769	),
(	14786	),
(	14815	),
(	14834	),
(	14910	),
(	15281	),
(	15310	),
(	15311	),
(	15320	),
(	15321	),
(	15322	),
(	15375	),
(	15600	),
(	15601	),
(	15602	),
(	15603	),
(	15604	),
(	15605	),
(	15621	),
(	15622	),
(	15623	),
(	15644	),
(	15746	),
(	15794	),
(	15880	),
(	15887	),
(	15895	),
(	15911	),
(	15976	),
(	15977	),
(	15978	),
(	15979	),
(	15980	),
(	15981	),
(	15982	),
(	15983	),
(	15984	),
(	15985	),
(	16089	),
(	16092	),
(	16167	),
(	16172	),
(	16182	),
(	16186	),
(	16189	),
(	16190	),
(	16192	),
(	16194	),
(	16202	),
(	16222	),
(	16228	),
(	16229	),
(	16232	),
(	16243	),
(	16244	),
(	16247	),
(	16248	),
(	16318	),
(	16382	),
(	16405	),
(	16441	),
(	16445	),
(	16540	),
(	16598	),
(	16599	),
(	16642	),
(	16678	),
(	16724	),
(	16782	),
(	16791	),
(	16831	),
(	16832	),
(	16848	),
(	16880	),
(	16883	),
(	16959	),
(	17055	),
(	17057	),
(	17059	),
(	17063	),
(	17064	),
(	17083	),
(	17130	),
(	17135	),
(	17138	),
(	17139	),
(	17140	),
(	17142	),
(	17147	),
(	17148	),
(	17200	),
(	17203	),
(	17238	),
(	17242	),
(	17279	),
(	17281	),
(	17282	),
(	17464	),
(	17526	),
(	17533	),
(	17536	),
(	17647	),
(	17663	),
(	17666	),
(	17694	),
(	17882	),
(	17927	),
(	17989	),
(	18181	),
(	18197	),
(	18213	),
(	18265	),
(	18396	),
(	18417	),
(	18418	),
(	18424	),
(	18425	),
(	18445	),
(	18458	),
(	18460	),
(	18461	),
(	18463	),
(	18464	),
(	18512	),
(	18527	),
(	18528	),
(	18529	),
(	18530	),
(	18532	),
(	18533	),
(	18534	),
(	18535	),
(	18536	),
(	18542	),
(	18608	),
(	18609	),
(	18610	),
(	18611	),
(	18686	),
(	18866	),
(	18923	),
(	18992	),
(	18997	),
(	19012	),
(	19128	),
(	19439	),
(	19445	),
(	19506	),
(	19507	),
(	19573	),
(	19647	),
(	19651	),
(	19654	),
(	19660	),
(	19742	),
(	19769	),
(	19856	),
(	20068	),
(	20071	),
(	20079	),
(	20081	),
(	20082	),
(	20084	),
(	20146	),
(	20221	),
(	20335	),
(	20336	),
(	20337	),
(	20338	),
(	20339	),
(	20342	),
(	20372	),
(	20512	),
(	20518	),
(	20521	),
(	20522	),
(	20523	),
(	20524	),
(	20525	),
(	20526	),
(	20527	),
(	20528	),
(	20529	),
(	20530	),
(	20531	),
(	20532	),
(	20533	),
(	20534	),
(	20535	),
(	20536	),
(	20537	),
(	20540	),
(	20541	),
(	20542	),
(	20543	),
(	20544	),
(	20545	),
(	20546	),
(	20547	),
(	20548	),
(	20549	),
(	20550	),
(	20551	),
(	20767	),
(	21024	),
(	21129	),
(	21132	),
(	21133	),
(	21134	),
(	21135	),
(	21305	),
(	21370	),
(	21453	),
(	21502	),
(	21534	),
(	21544	),
(	21558	),
(	21609	),
(	21732	),
(	21738	),
(	21822	),
(	21965	),
(	22157	),
(	22158	),
(	22161	),
(	22162	),
(	22165	),
(	22260	),
(	22289	),
(	22369	),
(	22530	),
(	22531	),
(	22532	),
(	22533	),
(	22534	),
(	22535	),
(	22536	),
(	22540	),
(	22548	),
(	22549	),
(	23006	),
(	23007	),
(	23017	),
(	23023	),
(	23060	),
(	23180	),
(	23285	),
(	23288	),
(	23301	),
(	23557	)

)  as t (id) order by 1 asc
;
Loop
Begin
FETCH Allestbid INTO currentestbid;
 EXIT WHEN NOT FOUND;

PERFORM  migration.MigrateEstablishments(currentestbid.id);            
PERFORM  migration.MigrateUsers(currentestbid.id);            
PERFORM  migration.MigrateWorkers(currentestbid.id);            
PERFORM  migration.worker_bulk_training(currentestbid.id);            
PERFORM  migration.worker_bulk_qualifications(currentestbid.id);            

END;
END LOOP;

PERFORM migration.setparents();
COMMIT;

END;
$BODY$;

ALTER PROCEDURE migration.migrate7()
    OWNER TO postgres;