function decode=decoder_2(encode_in)

Ns=length(encode_in);
nbit=2;
pre=0;
%%%%parameter setting 
step=0.001; 
scaler=0.8;
step_min=0.0008;
%step_max=0.5;
u=0.9563;
window_length=20;

d_buffer=zeros(1,window_length);
decode=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fixed point
step = round(step*2^16);
step_min = round(step_min*2^16);
%step_max = round(step_max*2^16);
step_max =2^15/(2^2);
u=round(u*2^16);
scaler=round(scaler*2^16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n=1:Ns
    
    diff_d=dequantizer_2(encode_in(n),step); %% dequantization
    
    d_buffer=[diff_d d_buffer(1:end-1)];
    s_d=pre+diff_d;
    pre=u*s_d;% overflow: take 16 bits
    pre=round(pre/2^16);
    
    d_buffer=[diff_d d_buffer(1:end-1)];
      
    step=(scaler*mean(abs(d_buffer)));
    step=round(step/2^16);
    
    
    if step>step_max 
        step=step_max;
    elseif  step<step_min
        step=step_min;
    else
        step=step;
    end
    decode=[s_d decode];
    n=n+1;
end

%encode=dec2bin(encode);
%%% step size proportional to mean(abs(s(n)-pre))
    