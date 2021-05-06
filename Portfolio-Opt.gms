set
         i/1*5/
         iter/1*101/;
alias(i,j);

parameter
         mu(i), mu0, var(i), cov(i,j), portfolio(iter, i), z_mu(iter), z_var(iter),
         ideal_z_mu, nadir_z_mu, dis, FixedRisk;

$call GDXXRW Data.xlsx par=mu rdim=1 rng=sheet2!B2:C6
$GDXIN Data.gdx
$LOADm mu
$GDXIN



$call GDXXRW Data.xlsx par=var rdim=1 rng=sheet2!F2:G6
$GDXIN Data.gdx
$LOAD var
$GDXIN

$call GDXXRW Data.xlsx par=cov cdim=1 rdim=1 rng=sheet2!J3:O8
$GDXIN Data.gdx
$LOAD cov
$GDXIN



variable
         x(i)
         z;
nonnegative variable x;

equation
         objfmu, objfvar, objfmain, const1, const2, FRconstr;
const1..
         sum(i,x(i)) =e= 1;
const2..
         sum(i, mu(i)*x(i)) =g= mu0;
objfmain..
         z =e= -sum(i, var(i)*x(i)**2) - 2*sum(i, sum(j$(j.val > i.val), cov(i,j)*x(i)*x(j)));
objfmu..
         z =e= sum(i, mu(i)*x(i));
objfvar..
         z =e= -sum(i, var(i)*x(i)**2) - 2*sum(i, sum(j$(j.val > i.val), cov(i,j)*x(i)*x(j)));
FRconstr..
        -sum(i, var(i)*x(i)**2) - 2*sum(i, sum(j$(j.val > i.val), cov(i,j)*x(i)*x(j))) =e= FixedRisk;


model Main /objfmain, const1, const2/;
model IDmu /objfmu, const1/;
model IDvar /objfvar, const1/;
model NADmu /objfmu, const1, FRconstr/;


solve IDmu maximizing z using LP;
ideal_z_mu = z.l;

solve IDvar maximizing z using NLP;
FixedRisk = z.l;

solve NADmu maximizing z using NLP;
nadir_z_mu = z.l;


mu0 = nadir_z_mu;
dis = (ideal_z_mu - nadir_z_mu) / (card(iter) - 1);
loop(iter,
         solve Main using NLP maximizing z;
         portfolio(iter, i) = x.l(i);
         z_var(iter) = z.l;
         z_mu(iter) = sum(i, mu(i)*x.l(i));
         mu0 = mu0 + dis;
    )

