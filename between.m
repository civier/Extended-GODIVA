function bool = between(x,A)

bool = (x > A(:,1)) & (x < A(:,2));
