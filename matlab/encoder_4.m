function encode_out=encoder_4(in)

Ns=length(in);
n=1;
pre=0;
%%%% parameter setting
u=0.9563;%0.9563 0.11111 scale to 5 bits =31
%max=0.5; min=-0.5;
step=0.01; 
step_min=0.005;
%step_max=0.125;
scaler=0.05; 
window_length=20;

d_buffer=zeros(1,window_length);
encode_out=[];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fixed point
step = round(step*2^16);
step_min = round(step_min*2^16);
%step_max = round(step_max*2^16);
step_max =2^15/(2^4);
u=round(u*2^16);
scaler=round(scaler*2^16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while n<Ns
      
    diff=in(n)-pre;
    
    code=quantizer_4(diff,step);  %% quantization    
    diff_d=dequantizer_4(code,step); %% dequantization
    
    s_d=pre+diff_d;
    %%%%%%%%%%%%%%%%%%%%%%%%
    pre=u*s_d;% overflow: take 16 bits
    pre=round(pre/2^16);
    
    d_buffer=[diff_d d_buffer(1:end-1)];
      
    step=(scaler*mean(abs(d_buffer)));
    step=round(step/2^16);
    
    if step>step_max 
        step=step_max;
    elseif  step<step_min
        step=step_min;
    
    end

    %buffer=[buffer step];
    
    encode_out=[code encode_out];
    n=n+1;
end

%length(encode_out)
%encode=dec2bin(encode);
%figure;
%plot(buffer);

%%% step size proportional to mean(abs(s(n)-pre))