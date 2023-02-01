function  f=g(x)
    f=0.*(x<=0)+1.*(x>=1)+x.*(x>0).*(x<1);
end