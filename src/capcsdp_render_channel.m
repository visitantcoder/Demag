function E = capcsdp_render_channel(x,A,C)
% Channel-wise fixed-reference amplitude-preserving CSDP.
%
% u(k) = clip((x(k)+A)/(2A),0,1)
% r(k) = u(k)
% theta_m,+/- = m*psi +/- delta*u(k+l)
% w(k) = clip(|x(k-l)|/A,0,1)
%
% Output E is a zero-background nonnegative energy map.
% There is NO per-state max normalization.

x=double(x(:));
N=numel(x);
L=C.Lag;

if N<=2*L+2
    error('Signal is too short for lag=%d.',L);
end
if ~(isfinite(A) && A>0)
    error('Invalid fixed reference amplitude.');
end

u=min(max((x+A)/(2*A),0),1);
Q=zeros(C.ImageSize,C.ImageSize);

for k=(L+1):(N-L)
    r=u(k);
    uDelay=u(k+L);
    w=min(abs(x(k-L))/A,1);

    for m=0:5
        base=m*C.PsiDeg;
        for sgn=[-1 1]
            th=deg2rad(base+sgn*C.DeltaDeg*uDelay);
            xx=r*cos(th);
            yy=r*sin(th);

            col=1+(xx+1)*0.5*(C.ImageSize-1);
            row=1+(1-(yy+1)*0.5)*(C.ImageSize-1);
            Q=localBilinearSplat(Q,row,col,w);
        end
    end
end

if C.BlurSigmaPx>0
    K=localGaussianKernel(C.BlurSigmaPx);
    Q=conv2(Q,K,'same');
end

Q=Q/C.AccumulatorDivisor;
E=1-exp(-C.RenderGain*Q);
E=min(max(E,0),1);
end

function A=localBilinearSplat(A,row,col,w)
r0=floor(row); c0=floor(col);
dr=row-r0; dc=col-c0;
rr=[r0 r0+1]; cc=[c0 c0+1];
wr=[1-dr dr]; wc=[1-dc dc];

for ir=1:2
    for ic=1:2
        r=rr(ir); c=cc(ic);
        if r>=1 && r<=size(A,1) && c>=1 && c<=size(A,2)
            A(r,c)=A(r,c)+w*wr(ir)*wc(ic);
        end
    end
end
end

function K=localGaussianKernel(sigma)
rad=max(1,ceil(3*sigma));
[x,y]=meshgrid(-rad:rad,-rad:rad);
K=exp(-(x.^2+y.^2)/(2*sigma^2));
K=K/sum(K(:));
end
