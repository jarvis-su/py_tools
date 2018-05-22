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
GROUP BY
  a.LOAN_ID;
