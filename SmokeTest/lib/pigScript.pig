A = LOAD '$input'  USING PigStorage(',');
B = FOREACH A GENERATE \$0 AS id;
STORE B INTO '$output';
