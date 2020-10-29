c=3*10^8; % speed of light in vaccum
h=6.625*10.^-34; %  Planck constant 
k=1.38*10.^-23; %   Boltzmann constant
T=[ 500 600 700 ]; % Temperatures in Kelvin
fs=10%Sampling frequency
x=(0.0:1/fs:20).*1e-6;%wavelrngth vector 
E= ((2*h*c*c)./(x.^5)).*(exp(-(h*c)./(x*k*T(1))))%Intensity vector by plancks law
plot(x,E)%plotting intensity 
set(gca,'Fontsize',8,'Fontweight','bold')
title('Original spectrum(18BEC1160) at temp 500K');
xlabel('Wavelength','FontSize',8,'FontWeight',"bold");
ylabel('Intensity','FontSize',8,'FontWeight',"bold");
figure(2)
stem(x,E); % plot of sampled signal
set(gca,'Fontsize',8,'Fontweight','bold')
title('SAMPLED SPECTRUM(18BEC1160)');
xlabel('Wavelength','FontSize',8,'FontWeight',"bold");
ylabel('Intensity','FontSize',8,'FontWeight',"bold");

n1=4;%number of bits per sample
L=2^n1;%number of quantization levels
xmax=1.3e+08;%max value of quantization vector
xmin=0;%min value of quantization vector
del=(xmax-xmin)/L; %Difference between each quantization level
partition=xmin:del:xmax% definition of decision lines
codebook=xmin-(del/2):del:xmax+del/2; % definition of representation levels
[index,quants]=quantiz(E,partition,codebook);%quantiz is inbuilt function which is used to quantize the signal
% gives rounded off values of the samples
figure(3)
set(gca,'Fontsize',8,'Fontweight','bold')
stem(quants,"color",'r');%plotting of quantized signal
title('QUANTIZED SIGNAL(18BEC1160)');
xlabel('Wavelength','FontSize',8,'FontWeight',"bold");
ylabel('Intensity','FontSize',8,'FontWeight',"bold");


% NORMALIZATION
l1=length(index); % to convert 1 to n as 0 to n-1 indicies
for i=1:l1
if (index(i)~=0)
index(i)=index(i)-1;
end
end
l2=length(quants);
for i=1:l2 % to convert the end representation levels within the range.
if(quants(i)==xmin-(del/2))
quants(i)=xmin+(del/2);
end
if(quants(i)==xmax+(del/2))
quants(i)=xmax-(del/2);
end
end
% ENCODING
code=de2bi(quants,'left-msb'); % Decimal to binary conversion of quantization vector
k=1;
for i=1:l1 % to convert column vector to row vector
for j=1:n1
coded(k)=code(i,j);
j=j+1;
k=k+1;
end
i=i+1;
end
figure(4);
stairs(coded);%plotting digital signal
xlim([0,400])
ylim([-1 2])
%plot of digital signal
title('DIGITAL SIGNAL(18BEC1160)');
set(gca,'Fontsize',8,'Fontweight','bold')
xlabel('Wavelength','FontSize',8,'FontWeight',"bold");
ylabel('Intensity','FontSize',8,'FontWeight',"bold");
%Demodulation
code1=reshape(coded,n1,(length(coded)/n1));
index1=bi2de(code1,'left-msb');
resignal=del*index+xmin+(del/2);%decoding the binary sequence
figure(5);%plot of demodulated signal compared to original signl
subplot(2,1,1)%plot of demodulated signal
plot(x,resignal,"color",'k');
set(gca,'Fontsize',8,'Fontweight','bold')
title('DEMODULATAED SIGNAL(18BEC1160)');
xlabel('Wavelength','FontSize',8,'FontWeight',"bold");
ylabel('Intensity','FontSize',8,'FontWeight',"bold");
subplot(2,1,2)
plot(x,E,"color",'m');%plot of original signal
set(gca,'Fontsize',8,'Fontweight','bold')
title('ORIGINALSIGNAL(18BEC1160)');
xlabel('Wavelength','FontSize',8,'FontWeight',"bold");
ylabel('Intensity','FontSize',8,'FontWeight',"bold");

