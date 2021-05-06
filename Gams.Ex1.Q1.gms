set
         t/0*6/
         i/1*3/;


table a(t,i)
         1       2       3
0        -3      -2      -2
1        -1      -0.5    -2
2        1.8     1.5     -1.8
3        1.4     1.5     1
4        1.8     1.5     1
5        1.8     0.2     1
6        5.5     -1      6
;


variable
         x(i)
         y(t)
         w(t)
         z;
nonnegative variable x, y, w;

equation
         ObjFunc , constr0 , constr1, constr2, constr3, constr4;
ObjFunc..
         z =e= -sum(i, a('6',i)*x(i)) + 1.03*y('5') - 1.035*w('5');

constr0..
         -sum(i, a('0',i)*x(i)) + y('0') =e= 2 + w('0');

constr1(t)$(1 <= t.val and t.val <= 5)..
         -sum(i, a(t,i)*x(i)) + y(t) + 1.035*w(t-1) =e= 1.03*y(t-1) + w(t);

constr2(t)..
         w(t) =l= 2;
constr3(i)..
        x(i) =g= 0;
constr4(i)..
         x(i) =l= 1;
model Projects /ObjFunc , constr0 , constr1 , constr2,constr3 constr4/;
solve Projects maximizing z using LP;
display x.l, y.l, w.l, z.l, a;
