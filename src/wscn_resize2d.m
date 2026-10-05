function B = wscn_resize2d(A,target)
% Base-MATLAB 2-D resize using interp2.

A=double(A);
[m,n]=size(A);
mt=target(1); nt=target(2);

if m==mt && n==nt, B=A; return; end
if m==1 && n==1, B=repmat(A,mt,nt); return; end
if m==1, A=repmat(A,2,1); m=2; end
if n==1, A=repmat(A,1,2); n=2; end

xq=linspace(1,n,nt);
yq=linspace(1,m,mt);
[Xq,Yq]=meshgrid(xq,yq);
B=interp2(1:n,1:m,A,Xq,Yq,'linear',0);
end
