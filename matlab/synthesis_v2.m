function y=synthesis_v2(d0,d1,h0,n)

dd0=d0+d1; dd1=d0-d1;

e0=h0(1:2:end);
e1=h0(2:2:end);

u0=2*filter(e1,1,[dd0 0]');
u1=2*filter(e0,1,[dd1 0]');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(u0)
    u0(i) = round(u0(i)/2^16);
    u1(i) = round(u1(i)/2^16);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%upsampling
y0=zeros(1,n);
y1=zeros(1,n);

%y0(1:2:n)=u0;
%y1(1:2:n)=u1;
y0(1:2:n)=u0(1:n/2);
y1(1:2:n)=u1(1:n/2);

y=2*([0,y0(1:n-1)]+y1);

y = y';