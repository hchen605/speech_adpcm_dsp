%%%% 2 bit quantizer

function code=quantizer_2(diff,step)  % step=0.5*amplitude
code=round(diff/step);
if -2^(2-1) >= code
   code=-2^(2-1);
elseif code >= 2^(2-1)-1
    code = 2^(2-1)-1;
end;