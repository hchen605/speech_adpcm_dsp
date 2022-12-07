function encode_out=encoder_2(in)

Ns=length(in);
n=1;
pre=0;
%%%%parameter setting
step=0.001; 
scaler=0.8;
step_min=0.0008;
%step_max=0.5;
u=0.9563;
window_length=20;

d_buffer=zeros(1,window_length);
encode_out=[];

buffer=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fixed point
step = round(step*2^16);
step_min = round(step_min*2^16);
%step_max = round(step_max*2^16);
step_max =2^15/(2^2);
u=round(u*2^16);
scaler=round(scaler*2^16);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while n<Ns
      
    diff=in(n)-pre;
    
    code=quantizer_2(diff,step);  %% quantization       
    diff_d=dequantizer_2(code,step); %% dequantization
    
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
    