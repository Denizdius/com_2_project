function BER = bpskBER(n,k,simParams)
    %bpskBER Bit error rate (BER) simulation for BPSK modulation
    
    EbNoVec = simParams.EbNoVec;
    numBitsPerFrame = simParams.NumSymbolsPerFrame;
    BER = zeros(size(EbNoVec));
    
    for EbNoIdx = 1:length(EbNoVec)
        EbNo = EbNoVec(EbNoIdx);
        chan = comm.AWGNChannel("BitsPerSymbol",1, ...
            "EbNo", EbNo, "SamplesPerSymbol", 1, "SignalPower", 1);
    
        numBitErrors = 0;
        frameCnt = 0;
        while (numBitErrors < simParams.MinNumErrors) ...
                && (frameCnt < simParams.MaxNumFrames)
            d = randi([0 1],numBitsPerFrame,1);
            x = pskmod(d,2);
            y = chan(x);
            dHat = pskdemod(y,2);
            
            numBitErrors = numBitErrors + sum(d ~= dHat);
            frameCnt = frameCnt + 1;
        end
        totalBits = frameCnt * numBitsPerFrame;
        BER(EbNoIdx) = numBitErrors / totalBits;
    end
end
