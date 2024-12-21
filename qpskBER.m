function BER = qpskBER(n,k,simParams)
    %qpskBER Bit error rate (BER) simulation for QPSK modulation
    %   BER = qpskBER(n,k,simParams) estimates the BER performance of a QPSK
    %   system over an AWGN channel using Monte Carlo simulations.
    
    EbNoVec = simParams.EbNoVec;
    
    numSymbolsPerFrame = simParams.NumSymbolsPerFrame;
    BER = zeros(size(EbNoVec));
    for EbNoIdx = 1:length(EbNoVec)
        EbNo = EbNoVec(EbNoIdx);
        chan = comm.AWGNChannel("BitsPerSymbol",2, ...
            "EbNo", EbNo, "SamplesPerSymbol", 1, "SignalPower", 1);
    
        numBitErrors = 0;
        frameCnt = 0;
        while (numBitErrors < simParams.MinNumErrors) ...
                && (frameCnt < simParams.MaxNumFrames)
            d = randi([0 3],numSymbolsPerFrame,1);
            x = pskmod(d, 4);
            y = chan(x);
            dHat = pskdemod(y, 4);
            
            % Convert symbols to bits for bit error counting
            dBits = de2bi(d, 2);
            dHatBits = de2bi(dHat, 2);
            numBitErrors = numBitErrors + sum(sum(dBits ~= dHatBits));
            
            frameCnt = frameCnt + 1;
        end
        totalBits = frameCnt * numSymbolsPerFrame * 2;
        BER(EbNoIdx) = numBitErrors / totalBits;
    end
    end