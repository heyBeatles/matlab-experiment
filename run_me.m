clear all
close all
clc
alpha=1e-1;
epsilon=1e3;
K=1; % K-winner-take-all

L=[
    0 -1  0 0 ;
    -1 0 -1 0 ;
    0 -1 0 -1 ;
    0 0 -1 0 ];

u= [1.1; 2.5; 4; 3.2];


N = size(L,2);
C_0=1;  %Here is the key, C_0 can take 1, otherwise the discrete model is not stable and will diverge
x=rands(4,1);
y=zeros(4,1);
randSize = 100;  %Set the multiplier of the generated random number
vec_1=ones(N,1);
tau = 1e-4;
length =2000;
z = g(x+u/alpha);   
x_all = zeros(length,N);
y_all = zeros(length,N);
z_all = zeros(length,N);
x_all(1,:) = x';
y_all(1,:) = y';
z_all(1,:) = z';
P(N) = PaillierCrypto(256)
for i = 1:N
    P(i).generateKeys();
    ranP(i) = P(1).bi((round((0.001 + 0.998 * rand) * 1000)));
end

for ind =1:length-1
ind
a1 = -(C_0*statechange(x,P,ranP,L)');
a2 = C_0*(-y-z);
a3 = C_0*(K*vec_1/N);
x = x+tau*epsilon*(a1+a2+a3);
m=statechange(y,P,ranP,L)';
t=statechange(z,P,ranP,L)';
y = y+tau*(-epsilon*(m+t));
z = g(x+u/alpha);
x_all(ind+1,:) = x';
y_all(ind+1,:) = y';
z_all(ind+1,:) = z';
end
t=(0:length-1)';
figure
plot(t,x_all)
xlabel('t')
ylabel('x')
figure
plot(t,y_all)
xlabel('t')
ylabel('y')
figure
plot(t,z_all)
xlabel('t')
ylabel('z')

