#!/usr/bin/expect
###############################################################################
#    文件名  :    scp_file.sh                                                 #
#    功  能  :    scp文件通用脚本                                              #
#    编  写  :    李童                                                        #
#    修  改  :                                                                #
#    时  间  :    2017-12-26                                                  #
#    版  权  :    litong                                                      #
#    修  订  :                                                                #
#    时  间  :                                                                #
#    修  改  :    			                                                #
#    说  明  :    使用方法例子：scp_file.sh 192.168.1.100 root password test.txt /app/data  #
###############################################################################
set host [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set src_file [lindex $argv 3]
set dir_file [lindex $argv 4]

spawn scp $src_file $username@$host:$dir_file
expect "*assword:" { send "$password\n"}
expect "100%"
expect eof