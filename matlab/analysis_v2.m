function [c0,c1]=analysis_v2(signal,h0,n)

e0=[h0(1:2:end) 0];
e1=[0 h0(2:2:end)];

c0=0.5*(filter(e0,1,signal(1:2:n)')+filter(e1,1,signal(2:2:n)'));
c1=0.5*(filter(e0,1,signal(1:2:n)')-filter(e1,1,signal(2:2:n)'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% avoid overflow
for i = 1:length(c0)
    c0(i) = round(c0(i)/2^16);
    c1(i) = round(c1(i)/2^16);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%