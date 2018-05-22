select * from hy_vip_user h where date(h.create_time)=date('2018-05-15') and h.is_vip =1 ;

select * from loan_vip_temp l where l.username='13565733055';
select * from hy_vip_user_temp t where t.username='13565733055';

select max(l.TOTAL_TERM)
from loan_loan_acc l;

SELECT
   a.username as username,
   max(a.apply_amount) as applyAmount, ##已结清的最大批准金额
   a.mobile as mobile,
   a.real_name as realName,
   a.cust_type as custType,
   a.id_no as idNo,
   max(a.due_date) as dueDate,##已结清贷款中最近一次账单日
   sum(a.count) as count,##已结清贷款的逾期次数
   sum(a.is_lpc) as isLpc,    ##产生过滞纳金的次数
   SUM(a.loan_amt) AS loanAmt,   ##合同金额总额
   max(a.period) as period,   ##贷款中最高期数
   sum(a.total_period) as totalPeriod, ##已结清贷款期数总和
   max(a.history_overdue_term) as historyOverdueTerm,##历史最长逾期阶段
   count(1) as creditcounts  ##已结清贷款总笔数
FROM
   loan_vip_temp a
WHERE
   a.username='13565733055'
GROUP BY
   a.username;

select * from hy_vip_user v where v.username='13739857292';
select * from hy_vip_user v where v.status='CANL' and date(v.update_time) = date('2018-05-16');
select * from hy_vip_user h where h.message='进件黑名单';
select count(1),h.status,h.is_vip,h.message from hy_vip_user h group by h.status,h.is_vip,h.message;
select max(v.amount) from hy_vip_user v where v.is_vip=1 and v.status='NOML' and v.amount <500000 ;
select * from hy_vip_user h where h.amount in (50000,100000);

select * ,app_application_no  from d_application_pay where app_username='13739857292';

select * from rule_freeout_engine where appno='31801051600613';


select * from hy_vip_user h ;
select count(1),date(h.create_time) current_day,h.status,h.is_vip from hy_vip_user h where h.create_time > date('2018-05-01') group by date(h.create_time),h.status,h.is_vip;
select * from hy_vip_user h where h.create_time > date('2018-05-10') order by h.create_time limit 100;
select count(1),date(h.create_time) current_day,h.status,h.is_vip from hy_vip_user h where h.create_time > date('2018-05-05') group by date(h.create_time),h.status,h.is_vip order by current_day;
select count(1),date(h.create_time) current_day,h.status,h.is_vip from hy_vip_user h where h.create_time > date('2018-05-05') and h.update_time is not null group by date(h.create_time),h.status,h.is_vip order by current_day;
select * from hy_vip_user h where h.is_vip=1 and date(h.update_time)<> date('2018-05-16') and h.status<> 'CANL' order by h.create_time desc limit 100;
select count(1),h.status,h.is_vip,date(h.update_time) from hy_vip_user h where h.update_time>date('2018-01-01') group by h.status,h.is_vip,date(h.update_time);

select count(1),h.is_vip,h.status,h.message,h.adjust_again from hy_vip_user h group by  h.is_vip,h.status,h.message,h.adjust_again ;

 ##and h.update_time<str_to_date('2018-05-15 09:00:00', '%Y-%m-%d %h:%i:%s')

select * from hy_vip_user h where h.is_vip=1 and h.status='NOML' limit 100000;
select * from hy_vip_user h where h.is_vip=1 and h.message like '%新进%';

select * from rule_param r where r.type =7 and r.key_param='31801033100693';

select * from rule_freein_engine r where r.fqz_facresult;
select date(r.create_time),count(1) from rule_freeout_engine r where r.facresult ='DC' and r.create_time > date('2018-05-01') group by  date(r.create_time);

select * from rule_freeout_engine r where r.facresult = 'DC' and (r.reasononegrade = 'V036' or r.reasononegrade2 = 'V036') order by r.create_time desc limit  20;