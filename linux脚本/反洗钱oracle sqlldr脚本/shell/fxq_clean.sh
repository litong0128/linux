#!/bin/bash
/usr/bin/find /home/litong/FXQ/data -name "201*" -mtime +7 -exec rm -rf {} \;
rm /home/litong/FXQ/shell/fxq_sqlldr.out
