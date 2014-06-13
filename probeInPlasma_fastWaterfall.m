%%% Probe in plasma in 1D
%%% !! Just for fast waterfall : if ou want to plot intensity at each z, run
%%% probe_in_plasma !!

hollow = 0; % Choose 1 for a simulation with hollow plasma
            % 0 for a cylindrical plasma

            
% Properties

%Density
Np = 1E17 ; %Plasma
NLi = 3E16; %Lithium
%Wavelength
lambda = 800E-9;
lambda_plasma = 3.34E4/sqrt(Np);
lambda_Li = 670E-9;
%Refractive index
nPlasma = sqrt(1 - lambda^2/lambda_plasma^2); %nPlasma=0.999967999488;
re=1E-7;
nLi = 1 + (NLi*re/(2*pi))*0.744/(1/lambda_Li^2 - 1/lambda^2); %nLi=1.0004;
%Angle between plasma (z axis) and probe direction
alpha = pi/50;
%Step (accuracy) 
a = 1000;
%Plasma size
r0=25E-6; %Channel radius (plasma radius if cylindrical plasma)
r1=5E-6; %For hollow plasma (ring width)


%FFT Calculation for different z and waterfall

%Propagation from -zmax m to +zmax m, with nbz iterations, with a step of 2*zmax/nbz
zmax = 0.5;
nbz = 100;
step = 2*zmax/nbz;

W = ones(a,nbz+1); %waterfall matrix

for k=0:nbz
    
    %Propagation
    z=-zmax+step*k
    
    if (z<-0.04 || z>0.04)
        
        %Keep the same size of window for different z : L' = z'*L/z = z'*b
        b=4E-2/0.4;
        L=z*b;
        L_x=2*pi*lambda*a*z/L; %axes
        
        A=aperture_fastWaterfall(nLi,nPlasma,lambda,r0,r1,z,L,alpha,a,hollow);
        
        % abs(A(225,245))
        % sum((abs(A(:))-1).^2)
        % plot(atan(imag(A(:))./real(A(:))));
        
        U=fft(A)*z/0.4;
        U=fftshift(U);
        U=abs(U).^2;
        
        
        %Proportional factor in fresnel diffraction : can be ignored
        
        % z=linspace(-5,5,a);
        % y=linspace(-5,5,a);
        % for k =1:a
        %     for j=1:a
        %         U(k,j)=U(k,j)*1/(i*lambda*r0)*exp(2*i*pi/lambda*(r0+((z(j)^2+y(k)^2)/(2*r0))));
        %     end
        % end
        
        
        % Waterfall
        W(:,k+1)=U;
        
    end %if
end %for k

figure;
pcolor(linspace(-2,2,101),linspace(-L_x,L_x,a),W); axis xy;
shading interp;
colormap hot;















