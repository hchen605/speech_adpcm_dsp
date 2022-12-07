%%%% 4 bit quantizer

function code=quantizer_4(diff,step)  % 
code=round(diff/step);
if -2^(4-1) >= code
   code=-2^(4-1);
elseif code >= 2^(4-1)-1
    code = 2^(4-1)-1;
end