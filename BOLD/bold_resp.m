function [b,x] = bold_resp(x,hrf,max_x,min_x,dodiff);

%function [b,x] = bold_resp(x,hrf,max_x,min_x,dodiff);
% Funciton to convolve the hrf function with neural activations

if nargin<4,
    min_x = 0;
end
if nargin<5,
    dodiff = 0;
end
dodiff = 0;
if size(x,1)>size(x,2),
    x =x';
end
if prod(size(max_x)) == 1,
    max_x = repmat(max_x,size(x,1),1);
end
if prod(size(min_x)) == 1,
    min_x = repmat(min_x,size(x,1),1);
end
if dodiff,
    x = diff((x-repmat(min_x(:),1,size(x,2)))./repmat(max_x(:)-min_x(:),1,size(x,2)),2);
else,
    x = (x-repmat(min_x(:),1,size(x,2)))./repmat(max_x(:)-min_x(:),1,size(x,2));
end


for n=1:size(x,1)
  b(n,:)=conv(x(n,:),hrf);
end
b=sum(b,1);


