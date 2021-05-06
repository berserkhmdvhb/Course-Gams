set
         i/1*12/;

parameter c(i) /1 -12, 2 -10, 3 -8, 4 -10, 5 -4, 6 5, 7 -7, 8 -2, 9 15, 10 12, 11 -7, 12 45/;

variable
         y(i)
         z
         v(i)
         w(i)
         p;
nonnegative variable y, w, v, p;

equation
         ObjFunc , constr0, constr1, constr2, constr3, constr4, constr5, constr6;
ObjFunc..
         z =e= y('12');

constr0(i)$(i.val <= 11)..
         w(i+1) =e= w(i) - (p - 0.01*w(i));
constr1..
         w('12') =e= 0;

constr2..
         y('1') =e= c('1') + w('1') + v('1');
constr3(i)$(2 <= i.val and i.val <= 11)..
         y(i) =e= c(i) - 1.015*v(i-1) + (1.004)*y(i-1) - p + v(i);
constr4..
         y('12') =e= c('12') - 1.015*v('11') + (1.004)*y('11') -p;

constr5..
         w('1') =l= 50;
constr6..
         v('1') =l= 50;


model Projects /all/;
solve Projects maximizing z using LP;
display y.l, w.l, v.l, z.l;
