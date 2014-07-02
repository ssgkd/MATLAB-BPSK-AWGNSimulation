clc
clear
close all


N_bits=7000000;     % 생성할 비트 수
Eb_No_dB=0:2:10;    % Eb/N0 dB scale
BER_buffer=zeros(size(Eb_No_dB));   % BER 저장할 버퍼 


for n=1:length(Eb_No_dB)
    Eb_No_ral_scale= 10 ^(Eb_No_dB(n)/10);    % Eb/N0 real scale 값 변환
    sigma_v=sqrt(1./(2*Eb_No_ral_scale));     % 잡음의 표준 편차 값 계산
    
    bits_v=randi([0 1],N_bits,1);         % 비트 생성
    Symbols=bits_v*(-2)+1;                % symbol mapping
    
    noise_v=randn(N_bits,1)*sigma_v;       % AWGN 생성
    
    tx_signal=Symbols + noise_v ;         % 신호 + 잡음
    
    demapped_bits= tx_signal < 0 ;        % 수신단 demapping
    
    BER_buffer(n)=sum(bits_v ~= demapped_bits) ./ N_bits; % BER calculation
    
    fprintf('Eb/No= %g   BER:    %g\n',Eb_No_dB(n) ,BER_buffer(n))    
end

%%  이론적인 BPSK BER 계산 Using communication toolbox

Eb_N0_theory=0:0.05:10 ;
Ber_value_theory=berawgn(Eb_N0_theory,'psk',2,'nondiff');
%% 그래프 그리기 

figure(1),semilogy(Eb_No_dB,BER_buffer,'b*',Eb_N0_theory,Ber_value_theory,'r--'), xlabel('Eb/No [dB]'), ylabel('BER')
grid,axis([0 10 0.000001 1]), legend('Simulated result','Theoretical BPSK result')

