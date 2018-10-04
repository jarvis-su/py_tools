select
  t.*,
  if(@appNo = t.app_no, @rank := @rank + 1, @rank := 1) as rank,
  (@appNo := t.app_no)                                     app_no
from rule_in_engine t, (select
                          @rank := 0,
                          @appNo := null) b
where t.app_no in (31801033100693,
                   31801040100047,
                   31801040100072,
                   31801040100089,
                   31801040100109,
                   31801040100180,
                   31801040100197,
                   31801040100208)
order by t.APP_NO, t.CREATE_TIME desc;

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
         where b.APP_NO is not null and  b.CREATE_TIME >= DATE('2018-04-18') and b.CREATE_TIME < DATE('2018-04-19')
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
         where x.APP_NO is not null and  x.CREATE_TIME >= DATE('2018-04-18') and x.CREATE_TIME < DATE('2018-04-19')
       ) t, (select @rank:=0,@appNo:=null) b  order by t.APP_NO, t.CREATE_TIME
) t2 , kq_daifu k where t2.app_no = k.APP_NO and t2.rank =1;


select * from rule_param  r where r.type=6;
select * from rule_param  r where r.type=7;
select * from rule_param r where r.in_param like '%zx_highest_yq%';
select * from rule_param r where r.in_param like '%zx_dk_ye%';