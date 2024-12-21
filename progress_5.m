% Parameters for simulation
simParams.EbNoVec = 0:1:10;
simParams.NumSymbolsPerFrame = 1000;
simParams.MinNumErrors = 100;
simParams.MaxNumFrames = 1e5;

% Hamming code parameters
n1 = 7;   k1 = 4;    % First Hamming code (7,4)
n2 = 63;  k2 = 57;   % Second Hamming code (63,57)

% Run simulations for different modulations
BER_bpsk = bpskBER(n1, k1, simParams);
BER_bpsk_hamming74 = hammingBER(n1, k1, 'hard', simParams, 'bpsk');
BER_bpsk_hamming6357 = hammingBER(n2, k2, 'hard', simParams, 'bpsk');

BER_qpsk = qpskBER(n1, k1, simParams);
BER_qpsk_hamming74 = hammingBER(n1, k1, 'hard', simParams, 'qpsk');
BER_qpsk_hamming6357 = hammingBER(n2, k2, 'hard', simParams, 'qpsk');

BER_qam16 = qam16BER(n1, k1, simParams);
BER_qam16_hamming74 = hammingBER(n1, k1, 'hard', simParams, '16qam');
BER_qam16_hamming6357 = hammingBER(n2, k2, 'hard', simParams, '16qam');

% Calculate theoretical BER
EbNo = 10.^(simParams.EbNoVec/10);
theoretical_BER_bpsk = qfunc(sqrt(2*EbNo));
theoretical_BER_qpsk = qfunc(sqrt(2*EbNo));
theoretical_BER_qam16 = (3/2)*qfunc(sqrt((4/5)*EbNo));

% Plot BPSK Results
figure(1);
semilogy(simParams.EbNoVec, theoretical_BER_bpsk, 'k--', 'LineWidth', 2);
hold on;
semilogy(simParams.EbNoVec, BER_bpsk, 'b-o', 'LineWidth', 2);
semilogy(simParams.EbNoVec, BER_bpsk_hamming74, 'g-^', 'LineWidth', 2);
semilogy(simParams.EbNoVec, BER_bpsk_hamming6357, 'r-d', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance: BPSK with Hamming Codes');
legend('Theoretical BPSK', 'Uncoded BPSK', 'Hamming(7,4)', 'Hamming(63,57)', ...
    'Location', 'southwest');
ylim([1e-5 1]);
xlim([0 10]);

% Plot QPSK Results
figure(2);
semilogy(simParams.EbNoVec, theoretical_BER_qpsk, 'k--', 'LineWidth', 2);
hold on;
semilogy(simParams.EbNoVec, BER_qpsk, 'b-o', 'LineWidth', 2);
semilogy(simParams.EbNoVec, BER_qpsk_hamming74, 'g-^', 'LineWidth', 2);
semilogy(simParams.EbNoVec, BER_qpsk_hamming6357, 'r-d', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance: QPSK with Hamming Codes');
legend('Theoretical QPSK', 'Uncoded QPSK', 'Hamming(7,4)', 'Hamming(63,57)', ...
    'Location', 'southwest');
ylim([1e-5 1]);
xlim([0 10]);

% Plot 16-QAM Results
figure(3);
semilogy(simParams.EbNoVec, theoretical_BER_qam16, 'k--', 'LineWidth', 2);
hold on;
semilogy(simParams.EbNoVec, BER_qam16, 'b-o', 'LineWidth', 2);
semilogy(simParams.EbNoVec, BER_qam16_hamming74, 'g-^', 'LineWidth', 2);
semilogy(simParams.EbNoVec, BER_qam16_hamming6357, 'r-d', 'LineWidth', 2);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Performance: 16-QAM with Hamming Codes');
legend('Theoretical 16-QAM', 'Uncoded 16-QAM', 'Hamming(7,4)', 'Hamming(63,57)', ...
    'Location', 'southwest');
ylim([1e-5 1]);
xlim([0 10]);

% Print Results for each modulation separately
fprintf('\n=== BPSK Results ===\n');
fprintf('Eb/N0(dB) | Theoretical | Uncoded | Hamming(7,4) | Hamming(63,57)\n');
fprintf('----------------------------------------------------------\n');
for i = 1:length(simParams.EbNoVec)
    fprintf('%8.2f | %10.2e | %7.2e | %12.2e | %13.2e\n', ...
        simParams.EbNoVec(i), theoretical_BER_bpsk(i), ...
        BER_bpsk(i), BER_bpsk_hamming74(i), BER_bpsk_hamming6357(i));
end

fprintf('\n=== QPSK Results ===\n');
fprintf('Eb/N0(dB) | Theoretical | Uncoded | Hamming(7,4) | Hamming(63,57)\n');
fprintf('----------------------------------------------------------\n');
for i = 1:length(simParams.EbNoVec)
    fprintf('%8.2f | %10.2e | %7.2e | %12.2e | %13.2e\n', ...
        simParams.EbNoVec(i), theoretical_BER_qpsk(i), ...
        BER_qpsk(i), BER_qpsk_hamming74(i), BER_qpsk_hamming6357(i));
end

fprintf('\n=== 16-QAM Results ===\n');
fprintf('Eb/N0(dB) | Theoretical | Uncoded | Hamming(7,4) | Hamming(63,57)\n');
fprintf('----------------------------------------------------------\n');
for i = 1:length(simParams.EbNoVec)
    fprintf('%8.2f | %10.2e | %7.2e | %12.2e | %13.2e\n', ...
        simParams.EbNoVec(i), theoretical_BER_qam16(i), ...
        BER_qam16(i), BER_qam16_hamming74(i), BER_qam16_hamming6357(i));
end