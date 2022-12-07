clc;
clear all;
close all;

%get speech data
[x fs]=LoadWav('f216_d.wav');
x=resample(x,1,2);
fs=8000;%always works at 8000
audioplayer(x,fs);
n=length(x);


s = x;

%QMF_design(fs, df, Astop, fstep, Niter, FLength);
[h0, h1, f0, f1]=QMF_design(fs,fs/10,60,fs/800,100,20);

%%%%%%%%%%%%%%%%%%%%%%%&
%change to fix
for i = 1:n
    x(i) = round(x(i)*2^16);
end

for i = 1:length(h0)
    h0(i) = round(h0(i)*2^16);
end
%%%%%%%%%%%%%%%%%%%%%%%%

%analysis
[c0,c1]=analysis_v2(x,h0,n);
[c00,c01]=analysis_v2(c0',h0,length(c0));
[c10,c11]=analysis_v2(c1',h0,length(c0));

encode_00=encoder_4(c00);  encode_10=encoder_2(c10);
encode_01=encoder_4(c01);  encode_11=encoder_2(c11);
d00=decoder_4(encode_00);  d10=decoder_2(encode_10);
d01=decoder_4(encode_01);  d11=decoder_2(encode_11);

%d0=c0; d1=c1;

%synthesis
d0=synthesis_v2(d00,d01,h0,length(c0));
d1=synthesis_v2(d10,d11,h0,length(c0));

y=-1*synthesis_v2(d0',d1',h0,n+2);

%%%%%%%%%%%%%%%%%%%%%%%&
%change to fix
for i = 1:n
    y(i) = y(i)/2^16;
end
%%%%%%%%%%%%%%%%%%%%%%%%

%play again and plot figure
audioplayer(y,fs);
figure;
%plot(x,'r');hold;plot(y);
plot(s,'r');hold;plot(y);
figure;
plot(x,'r');
figure;
plot(y);
figure;
spectrogram(x,1024,400)
figure;
spectrogram(y,1024,400)