function BER = hammingBER(n,k,~,simParams,modType)
if nargin < 5
    modType = 'qpsk'; % default modulation
end

EbNoVec = simParams.EbNoVec;
R = k/n;

numBitsPerFrame = simParams.NumSymbolsPerFrame * k;
BER = zeros(size(EbNoVec));

% Set modulation parameters
switch lower(modType)
    case 'bpsk'
        M = 2;
        bitsPerSymbol = 1;
    case 'qpsk'
        M = 4;
        bitsPerSymbol = 2;
    case '16qam'
        M = 16;
        bitsPerSymbol = 4;
end

parfor EbNoIdx = 1:length(EbNoVec)
    EbNo = EbNoVec(EbNoIdx) + 10*log10(R);
    chan = comm.AWGNChannel("BitsPerSymbol", bitsPerSymbol, ...
        "EbNo", EbNo, "SamplesPerSymbol", 1, "SignalPower", 1);
    
    numBitErrors = 0;
    frameCnt = 0;
    
    while (numBitErrors < simParams.MinNumErrors) ...
            && (frameCnt < simParams.MaxNumFrames)
        d = randi([0 1], numBitsPerFrame, 1);
        e = encode(d, n, k, 'hamming');
        
        % Modulation based on specified type
        switch lower(modType)
            case 'bpsk'
                x = pskmod(e, 2);
            case 'qpsk'
                x = pskmod(e, 4, pi/4, 'InputType', 'bit');
            case '16qam'
                % Reshape bits into groups of 4 for 16-QAM
                symbols = reshape(e, 4, [])';
                symbolInts = bi2de(symbols);
                x = qammod(symbolInts, 16, 'InputType', 'integer', ...
                    'UnitAveragePower', true);
        end
        
        y = chan(x);
        
        % Demodulation based on specified type
        switch lower(modType)
            case 'bpsk'
                eHat = pskdemod(y, 2);
            case 'qpsk'
                eHat = pskdemod(y, 4, pi/4, 'OutputType', 'bit');
            case '16qam'
                eHat_symbols = qamdemod(y, 16, 'OutputType', 'bit', ...
                    'UnitAveragePower', true);
                eHat = reshape(eHat_symbols', [], 1);
        end
        
        dHat = decode(eHat, n, k, 'hamming');
        numBitErrors = numBitErrors + sum(d ~= dHat);
        frameCnt = frameCnt + 1;
    end
    
    totalBits = frameCnt * numBitsPerFrame;
    BER(EbNoIdx) = numBitErrors / totalBits;
end
end