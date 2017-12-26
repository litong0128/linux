#!/usr/bin/perl -W
#########################################################################
#功能说明：邮件服务调用
#查询的表：无
#
#
#创 建 人： 李童
#创建时间：2017-07-05
#运行周期：日
#例    程：perl mailsent.pl yyyymmdd taskid Table_Name
#备    注：yyymmdd(文件数据日期) taskid(任务id) Table_Name(导出表名称)
#------------------------------------------------------------------------
#维 护 人：
#维护时间：
#维护说明：
#########################################################################


##传入参数变量
my $i_date=$ARGV[0];                                         ##数据日期
my $i_taskid=$ARGV[1];                                      ##taskid名称
my $i_tabname=$ARGV[2];                                      ##表名

my $execjava ='java -Dfile.encoding=gbk -jar mailserver-0.0.1-SNAPSHOT.jar'.' '.$i_date.' '.$i_taskid.' '.$i_tabname;
$output = qx($execjava);
$exitcode = $? >>8;
print "output = " . $output;
print "exitcode = " . $exitcode;
exit($exitcode);