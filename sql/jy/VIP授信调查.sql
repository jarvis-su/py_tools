#功能1：ExportVipDataService:上传vip客户的txt文件到ftp
##逻辑：查询vip用户表，是vip的，当天的数据上传vip
##Sql语句：

SELECT <!-- 	  A.USERNAME, -->
	  A.MOBILE,
	  B.NAME,
	  B.IDENTITY_NO,
<!-- 	  B.CUSTOMERTYPE, -->
	  B.UNITNAME,
	  B.UNIT_TEL,
<!-- 	  B.UNIT_PROPERTIES, -->
<!-- 	  B.WORKEXPERIENCE, -->
<!-- 	  B.NOW_EDUCATION, -->
<!-- 	  B.WORK_AREA_ROAD, -->
	  B.OTHER_ACCOMMODATION_ADDRESS,
	  B.IMMEDIATE_NAME,
	  B.IMMEDIATE_MOBILE,
	  B.EMERGENCY_NAME,
	  B.EMERGENCY_MOBILE
	FROM HY_VIP_USER A
	  LEFT JOIN CUST_CUSTOMER B
	    ON A.USERNAME = B.USERNAME
	WHERE A.IS_VIP = 1 AND DATE(A.CREATE_TIME) = DATE(SYSDATE());

##功能2：AutoVipService，新进入VIP

##VIP贷的最高逾期天数：hy_vip_user_temp 表的latedate
##所有贷款是否已结清：hy_vip_user_temp 表的isover


##1: 先删除清空此表：delete from loan_vip_temp
##2: 按照订单来保存的每条记录
   /** INSERT INTO loan_vip_temp (
		username,
		apply_amount,
		mobile,
		id_no,
		real_name,
		cust_type,
		industry_code,
		loan_id,
		DUE_DATE,
		amount,
		prin_paid,
		loan_amt,
		is_lpc,
		COUNT,
		period,
		repay_status,
		total_period,
		history_overdue_term,
		create_time
	) **/
	SELECT
		a.USERNAME,
		e.apply_amount,
		e.app_user_mobile,
		e.app_user_identityno,
		e.app_user_realname,
		e.app_cust_type,
		e.HY_INDUSTRY_CODE,
		a.LOAN_ID,
		MAX(b.DUE_DATE),
		SUM(
				b.TOTAL_AMT - b.TOTAL_AMT_PAID
		),
		SUM(PRIN_PAID),
		a.PRINCIPAL,
		SUM(
				CASE
				WHEN b.LPC > 0
					THEN
						1
				ELSE
					0
				END
		),
		SUM(
				CASE
				WHEN b.REPAY_PLAN_STATUS = 'EPRF'
					THEN
						1
				ELSE
					0
				END
		),
		CASE
		WHEN a.TOTAL_TERM = 11
			THEN
				12
		ELSE
			a.TOTAL_TERM
		END                             AS period,
		max(CASE WHEN b.total_term = b.current_term
			THEN b.repay_plan_status end) as repay_status,
		a.TOTAL_TERM                    as total_period,
		a.history_overdue_term          as history_overdue_term,
		NOW()
	FROM
		loan_loan_acc a
		INNER JOIN loan_repay_plan b ON a.LOAN_ID = b.LOAN_ID
		INNER JOIN loan_loan d ON a.loan_id = d.ID
		INNER JOIN d_application_pay e ON d.APPLICATION_ID = e.app_application_no
	WHERE
		b.CURRENT_TERM != 0
	##		and a.USERNAME='1205032376'
	GROUP BY
		a.LOAN_ID;


select * from loan_vip_temp l where l.username='1205032376';
##3:清空删除表; delete from hy_vip_late_temp

select * from loan_loan_acc l where l.LOAN_ID=12;
select * from loan_loan_acc l where l.USERNAME='lili19930521';

##4:插入表：逾期天数，最早逾期的和当前时间天数差
	/**INSERT INTO hy_vip_late_temp(
	  loan_id,
	  lateday
	)
	**/
	SELECT
	  e.loan_id,
	  (TO_DAYS(NOW()) - TO_DAYS(MIN(f.DUE_DATE))) AS lateday
	FROM loan_loan_acc e
	  INNER JOIN loan_repay_plan f
	    ON e.loan_id = f.loan_id
	WHERE e.loan_status = 'D'
	    AND f.REPAY_PLAN_STATUS = 'REXP'
	GROUP BY e.loan_id;
##5：从表1的逾期天数更新到表2
UPDATE loan_vip_temp h1
	  INNER JOIN hy_vip_late_temp h2
	    ON h1.loan_id = h2.LOAN_ID
	SET h1.lateday = h2.lateday;



SELECT
   a.username as username,
   max(a.apply_amount) as applyAmount, ##已结清的最大批准金额
   a.mobile as mobile,
   a.real_name as realName,
   a.cust_type as custType,
   a.id_no as idNo,
   max(a.due_date) as dueDate,##已结清贷款中最近一次账单日
   sum(a.count) as count,##已结清贷款的逾期次数
   sum(a.is_lpc) as isLpc,##产生过滞纳金的次数
   SUM(a.loan_amt) AS loanAmt,##合同金额总额
   max(a.period) as period,##贷款中最高期数
   sum(a.total_period) as totalPeriod, ##已结清贷款期数总和
   max(a.history_overdue_term) as historyOverdueTerm,##历史最长逾期阶段
   count(1) as creditcounts ##已结清贷款总笔数
FROM
   loan_vip_temp a
WHERE
   NOT EXISTS (
      SELECT
         1
      FROM
         hy_vip_user b
      WHERE
         a.username = b.username
   )
   ##and a.username='1205032376'
GROUP BY
   a.username
HAVING  SUM(a.amount) = 0;
##功能3：AutoVipService，剔除冻结VIP

##1：删除表：delete from hy_vip_user_temp;
##2：查询是vip的客户，剩余还款金额（为0接请），初始期数？，所有贷款的最近的应还款日期
/**INSERT INTO hy_vip_user_temp (
		username,
		period,
		due_date,
		is_over,
		create_time
	) **/
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
	GROUP BY a.username;
##表3：删除表：
##delete from loan_vip_count_temp;

SELECT
	  username,
	  SUM(prin_paid) AS prin_paid,
	  SUM(loan_amt) AS loan_amt,
	  MAX(lateday) AS lateday,
	  GROUP_CONCAT(DISTINCT(period)) AS period_group
	FROM loan_vip_temp
	WHERE industry_code = 'VIPD'
		and username in (18184855550,13593700630,18667235714)
	GROUP BY username;

##表4：表数据复制

UPDATE hy_vip_user_temp h1
	  INNER JOIN loan_vip_count_temp h2
	    ON h1.username = h2.username
	SET h1.lateday = h2.lateday,
	  h1.prin_paid = h2.prin_paid,
	  h1.loan_amt = h2.loan_amt,
	  h1.period_group = h2.period_group;



#########
select * from hy_vip_user_temp t where t.username='15860674508';
select * from hy_vip_user_temp t  where t.lateday <> 0;
select * from loan_vip_temp l where l.username='15860674508';
select * from loan_repay_plan l where l.CREATE_TIME>date('2018-05-10') order by l.CREATE_TIME desc limit 10 ;
select * from loan_loan_acc l where l.LOAN_ID='3500588';
select distinct l.LOAN_STATUS from loan_loan_acc l ;
select distinct  v.is_vip,v.status,v.message,count(1) from hy_vip_user v group by v.is_vip,v.status,v.message;
select * from hy_vip_user v where v.is_vip=0 and v.status='NOML';

select * from hy_vip_user h where h.is_vip=0 and h.status='NOML' and h.message='新进VIP客户成功!' order by h.create_time desc;


SELECT
	  username,
	  SUM(prin_paid) AS prin_paid,
	  SUM(loan_amt) AS loan_amt,
	  MAX(lateday) AS lateday,
	  GROUP_CONCAT(DISTINCT(period)) AS period_group
	FROM loan_vip_temp
	WHERE industry_code = 'VIPD'
		and username in (select v.username from hy_vip_user v where v.update_time > date('2018-05-16') and v.status = 'CANL')
	GROUP BY username;

;