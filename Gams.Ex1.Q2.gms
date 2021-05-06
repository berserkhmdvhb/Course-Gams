set
         i/1*4/;
alias(i,j);


parameter
         y0(i) /1 8, 2 1, 3 8, 4 0/
         ye(i)/1 6, 2 3, 3 1, 4 10/;
table w(i,j)
         1               2               3               4
1        1               0.58928         1.743           138.3
2        1.697           1               2.9579          234.7
3        0.57372         0.33808         1               79.346
4        0.007233        0.00426         0.126           1
;
variable
         x(i,j)
         y(i)
         z;
nonnegative variable x, y;

equation
         ObjFunc , con1, con2, con3;
ObjFunc..
         z =e= sum(i, y(i)*(w(i,'1') + 1/w('1',i))/2);

con1(i)..
         y(i) =e= y0(i) + sum(j$(j.val <> i.val), w(j,i)*x(j,i)) - sum(j$(j.val <> i.val), x(i,j));

con2(i)..
         y(i) =g= ye(i);
con3(i,j)..
         x(i,j) =l= 100

model Projects /ObjFunc, con1, con2, con3/;
solve Projects maximizing z using LP;
display x.l, y.l, z.l;
