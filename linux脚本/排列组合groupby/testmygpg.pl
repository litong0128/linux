#!/usr/bin/perl
use lib '/home/unicom/shell';
use mygpb;
#定义模板语句
my $m_sql_str = "
,sum(amt)
from bdw_adl.test 
where 1=1
group by ";
my $e_sql_str = "'$v_mdt',to_char(sysdate,'yyyymmdd')";
#定义维度，调用拼接union all语句 方法
my @var_arr = (a,b,c,d);
my $union_m_sql_str = consist($m_sql_str,$e_sql_str,@var_arr);
print $union_m_sql_str. "\n";

my $del_sql_str = "delete from bdw_adl.test where stat_date='$v_mdt';";
my $ins_sql_str = "insert into bdw_adl.test(\n$union_m_sql_str);";
my $v_inssql = qq{$del_sql_str\n$ins_sql_str};
print $v_inssql;
