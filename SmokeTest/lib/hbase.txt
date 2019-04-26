#!/bin/sh


create 'test', 'cf'
list 'test'
put 'test', 'row1', 'cf:a', 'value1'
scan 'test'
exit
EOF

