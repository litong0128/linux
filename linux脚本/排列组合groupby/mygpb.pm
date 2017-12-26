#!/usr/bin/perl
#package mygpb
#拼接组合方法
sub consist{
	(my $m_sql_str,$e_sql_str,my @var_arr) = @_;
	my $var_size = $#var_arr+1;
	my $union_m_sql_str = '';
	#定义最大组合个数，根据维度个数计算最大组合个数
	my $var_max = '';
	for(my $i = 0;$i < $var_size;$i++){
		$var_max = $var_max.'1';
	}
	$var_max = oct( '0b' . $var_max );
	print "最大组合数：".($var_max+1)."\n";
	print "组合长度：$var_size\n";
	print "=========组合形式如下=========\n";
	#根据最大组合次数，推算出各种组合
	for(my $j = 0;$j <= $var_max;$j++){
		#"%0".$#var_size."b"根据数组维度个数生成二进制数字自动补0长度，例如：'1'如果数组长度是3变成二进制'001'
		my $bin = sprintf("%0".$var_size."b",$j);
		print $bin."\n";
		#根据组合形式对维度进行all转换：例如：维度（a,b,c），组合形式010 ，转换成（a,'all',c）
		my $tmpstr = '';
		for($m = 0 ;$m < $var_size;$m++){
			if(substr($bin,$m,1)==1){
				$tmpstr = $tmpstr."'all'".',';
			}else{
				$tmpstr = $tmpstr.$var_arr[$m].',';	
			}
		}
		#进行语句的union拼接
		if($j==$var_max){
			$union_m_sql_str = $union_m_sql_str."select ".$tmpstr.$m_sql_str.$tmpstr.$e_sql_str."\n";
			#print "finish \n";
		}else{
			$union_m_sql_str = $union_m_sql_str."select ".$tmpstr.$m_sql_str.$tmpstr.$e_sql_str."\n"."union all \n";
			#print $j ."\n";
		}		
		#print $union_m_sql_str. "\n";
	}	
	return $union_m_sql_str;
}
1;