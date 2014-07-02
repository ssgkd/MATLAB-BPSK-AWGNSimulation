clc
clear
close all


N_bits=7000000;     % ������ ��Ʈ ��
Eb_No_dB=0:2:10;    % Eb/N0 dB scale
BER_buffer=zeros(size(Eb_No_dB));   % BER ������ ���� 


for n=1:length(Eb_No_dB)
    Eb_No_ral_scale= 10 ^(Eb_No_dB(n)/10);    % Eb/N0 real scale �� ��ȯ
    sigma_v=sqrt(1./(2*Eb_No_ral_scale));     % ������ ǥ�� ���� �� ���
    
    bits_v=randi([0 1],N_bits,1);         % ��Ʈ ����
    Symbols=bits_v*(-2)+1;                % symbol mapping
    
    noise_v=randn(N_bits,1)*sigma_v;       % AWGN ����
    
    tx_signal=Symbols + noise_v ;         % ��ȣ + ����
    
    demapped_bits= tx_signal < 0 ;        % ���Ŵ� demapping
    
    BER_buffer(n)=sum(bits_v ~= demapped_bits) ./ N_bits; % BER calculation
    
    fprintf('Eb/No= %g   BER:    %g\n',Eb_No_dB(n) ,BER_buffer(n))    
end

%%  �̷����� BPSK BER ��� Using communication toolbox

Eb_N0_theory=0:0.05:10 ;
Ber_value_theory=berawgn(Eb_N0_theory,'psk',2,'nondiff');
%% �׷��� �׸��� 

figure(1),semilogy(Eb_No_dB,BER_buffer,'b*',Eb_N0_theory,Ber_value_theory,'r--'), xlabel('Eb/No [dB]'), ylabel('BER')
grid,axis([0 10 0.000001 1]), legend('Simulated result','Theoretical BPSK result')

