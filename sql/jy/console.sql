select * from bf_collection;
select * from inv_bus_history i where i.inv_username=10000 order by i.hy_application_no desc;

select * from inv_bus_history i where i.inv_username=10000 and i.bus_type = 3000 order by i.hy_application_no desc;
select * from inv_bus_history i where i.hy_application_no = 31801041801277;

select * from (
  select
    b.id,
    b.APP_NO,
    b.CREATE_TIME,
    b.COLLECTION_DATE,
    b.BANK_RETURN_MSG,
    b.RESP_MSG,
    'bf' as type
  from bf_collection b
  where b.APP_NO is not null and b.CREATE_TIME >= DATE('2018-04-24') and b.CREATE_TIME < DATE('2018-04-25')
  union all
  select
    x.id,
    x.APP_NO,
    x.CREATE_TIME,
    x.COLLECTION_DATE,
    x.BANK_RETURN_MSG,
    x.RESP_MSG,
    'xf' as type
  from xf_collection x
  where x.APP_NO is not null and x.CREATE_TIME >= DATE('2018-04-24') and x.CREATE_TIME < DATE('2018-04-25')
) t where t.ID = 589395 ;


SELECT k.amount AS 放款金额,k.app_no 扣款单号, k.collection_no 银生宝单号 ,k.bank_code 银行,k.create_time 代付时间,
k.collection_date 代付结果时间, t2.create_time 代扣时间,t2.bank_return_msg 代扣失败原因,t2.resp_msg AS 代付失败自定义描述 from (
  select id,create_time,COLLECTION_DATE,BANK_RETURN_MSG,RESP_MSG,type,
    if(@appNo = t.APP_NO, @rank:=@rank+1, @rank:=1) as rank, (@appNo := t.APP_NO ) app_no
  from (
         select
           b.id,
           b.APP_NO,
           b.CREATE_TIME,
           b.COLLECTION_DATE,
           b.BANK_RETURN_MSG,
           b.RESP_MSG,
           'bf' as type
         from bf_collection b
         where b.APP_NO is not null and  b.CREATE_TIME >= DATE('2018-04-24') and b.CREATE_TIME < DATE('2018-04-25')
         union all
         select
           x.id,
           x.APP_NO,
           x.CREATE_TIME,
           x.COLLECTION_DATE,
           x.BANK_RETURN_MSG,
           x.RESP_MSG,
           'xf' as type
         from xf_collection x
         where x.APP_NO is not null and  x.CREATE_TIME >= DATE('2018-04-24') and x.CREATE_TIME < DATE('2018-04-25')
       ) t, (select @rank:=0,@appNo:=null) b  order by t.APP_NO, t.CREATE_TIME
) t2 , kq_daifu k where t2.app_no = k.APP_NO and t2.rank =1;



SELECT a.APP_NO,a.CREATE_TIME, a.COLLECTION_DATE, ROUND((UNIX_TIMESTAMP(a.COLLECTION_DATE)-UNIX_TIMESTAMP(a.CREATE_TIME))/60) gap
FROM kq_daifu a WHERE DATE(a.CREATE_TIME) = '2018-04-25' AND a.COLLECTION_STATUS = 'WHSU' order by a.CREATE_TIME;


SELECT DISTINCT PROXY_BANKCARD,realname,identityno,mobileno  FROM d_input_app;
select DISTINCT PROXY_BANKCARD,realname,identityno,mobileno,PROXY_OPENBANK from d_input_app d where d.PROXY_OPENBANK = 'BOC';
select count(1) from d_input_app d where d.PROXY_BANKCARD is not null and d.PROXY_OPENBANK = 'BOC';

###规则引擎输入输出
select * from rule_freein_engine t order by t.create_time desc limit  10;
select * from Rule_param r where r.type =8 and r.create_time > date('2018-04-29') limit 10;
select * from rule_param r where r.key_param ='31801042801861';
select * from rule_out_engine t where t.create_time > date('2018-04-29') order by t.create_time limit 10;

select * from rule_in_engine t where t.app_no='31801050100006';
select * from rule_in_engine_sec t where t.app_no='31801050100006';

select * from rule_param r where r.key_param='31801050100006' order by r.create_time;
select * from rule_param r where r.key_param='31801050100039';
select * from rule_out_engine r where r.appno in ('31801050100006','31801050100039');

select * from rule_out_engine r where r.appno='31801042900141';
select * from rule_param r where r.key_param='31801042900141';

select * from rule_out_engine r where r.appno='31801050100350';
select * from rule_out_engine r where r.appno in ('31801050100027');
select * from (
  select
    r.key_param,
    substring(r.in_param, locate('phone_3m_dtjd_total', r.in_param), length('phone_3m_dtjd_total'))         key_sub,
    substring(r.in_param, locate('phone_3m_dtjd_total', r.in_param) + length('phone_3m_dtjd_total') + 2, 1) value_sub,
    substring(r.in_param, locate('id_3m_dtjd_total', r.in_param), length('id_3m_dtjd_total'))         key_sub1,
    substring(r.in_param, locate('id_3m_dtjd_total', r.in_param) + length('id_3m_dtjd_total') + 2, 1) value_sub1,
    ro.facresult
  from rule_param r, rule_out_engine ro
  where r.key_param = ro.appno
        and r.create_time > date('2018-05-01') and r.create_time < date('2018-05-02')
        and r.type = 8
) t where t.value_sub != 0 limit  10;


  select
    r.key_param,
    substring(r.in_param, locate('phone_3m_dtjd_total', r.in_param), length('phone_3m_dtjd_total'))         key_sub,
    substring(r.in_param, locate('phone_3m_dtjd_total', r.in_param) + length('phone_3m_dtjd_total') + 2, 1) value_sub,
    substring(r.in_param, locate('id_3m_dtjd_total', r.in_param), length('id_3m_dtjd_total'))         key_sub1,
    substring(r.in_param, locate('id_3m_dtjd_total', r.in_param) + length('id_3m_dtjd_total') + 2, 1) value_sub1,
    ro.facresult,
    d.hy_industry_code,
    d.product_name,
    r.create_time
  from rule_param r, rule_out_engine ro, d_application_pay d
  where r.key_param = ro.appno
    and ro.appno = d.app_application_no
        and r.create_time > date('2018-05-01') and r.create_time < date('2018-05-03')
        and r.type = 8
and d.HY_INDUSTRY_CODE = 'MDCP'
order by r.create_time
;


select * from rule_out_engine r where r.appno ='31801050100051';
select * from rule_param r where r.key_param ='31801050100051';

SELECT hy_industry_code FROM d_application_pay WHERE app_application_no=31801050100046;
select * from d_application_pay WHERE app_application_no=31801050100046;

select * from rule_in_engine t where t.app_no='31801050100006';
select * from rule_in_engine_sec  t where t.app_no='31801050100006';
select * from rule_in_engine_sec r order by r.create_time desc limit 20;
select * from rule_out_engine;
select * from rule_param limit 10;
select * from hy_vip_user u where u.username='15860674508' limit 10;
select * from param_record p where p.username='15860674508' limit 10;


select * from rule_in_engine_sec r order by r.create_time desc limit 10;
select * from rule_param  t where t.type=2 and t.create_time >= date('2018-05-08') and t.in_param like '%15860674508%' limit 20;
select * from rule_param  t where t.type=2 and t.create_time >= date('2017-03-24') and t.key_param ='18349197032' order by t.create_time desc limit 20;

SELECT
	  a.username     AS username,
	  a.init_period  AS period,
	  MAX(b.due_date) AS dueDate,
	  CASE WHEN SUM(b.amount) <=0 THEN 'Y' ELSE 'N' END AS is_over,
	  NOW()
	FROM hy_vip_user a
	  INNER JOIN loan_vip_temp b
	    ON a.username = b.username
	WHERE a.is_vip = 1
	    AND a. status != 'CANL'
    and a.username='15860674508'
	GROUP BY a.username;

SELECT
	  username,
	  SUM(prin_paid) AS prin_paid,
	  SUM(loan_amt) AS loan_amt,
	  MAX(lateday) AS lateday,
	  GROUP_CONCAT(DISTINCT(period)) AS period_group
	FROM loan_vip_temp
	WHERE industry_code = 'VIPD'
    and username = '15860674508'
	GROUP BY username;


SELECT
	  username,
	  SUM(prin_paid) AS prin_paid,
	  SUM(loan_amt) AS loan_amt,
	  MAX(lateday) AS lateday,
	  GROUP_CONCAT(DISTINCT(period)) AS period_group
	FROM loan_vip_temp
	WHERE 1=1
    and industry_code = 'VIPD'
    and username = '15860674508'
	GROUP BY username;





