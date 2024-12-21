function BER = qam16BER(n,k,simParams)
    %qam16BER Bit error rate (BER) simulation for 16-QAM modulation
    
    EbNoVec = simParams.EbNoVec;
    numBitsPerFrame = simParams.NumSymbolsPerFrame * 4; % 4 bits per symbol for 16-QAM
    BER = zeros(size(EbNoVec));
    
    for EbNoIdx = 1:length(EbNoVec)
        EbNo = EbNoVec(EbNoIdx);
        % Adjust EbNo for 16-QAM (average symbol energy is 10)
        chan = comm.AWGNChannel("BitsPerSymbol", 4, ...
            "EbNo", EbNo, "SamplesPerSymbol", 1);
    
        numBitErrors = 0;
        frameCnt = 0;
        while (numBitErrors < simParams.MinNumErrors) ...
                && (frameCnt < simParams.MaxNumFrames)
            % Generate random bits
            d = randi([0 1], numBitsPerFrame, 1);
            
            % Convert bits to symbols
            symbols = reshape(d, 4, [])';
            symbolInts = bi2de(symbols);
            
            % Modulate
            x = qammod(symbolInts, 16, 'InputType', 'integer', ...
                'UnitAveragePower', true);
            
            % Channel
            y = chan(x);
            
            % Demodulate
            dHat_symbols = qamdemod(y, 16, 'OutputType', 'bit', ...
                'UnitAveragePower', true);
            dHat = reshape(dHat_symbols', [], 1);
            
            numBitErrors = numBitErrors + sum(d ~= dHat);
            frameCnt = frameCnt + 1;
        end
        
        totalBits = frameCnt * numBitsPerFrame;
        BER(EbNoIdx) = numBitErrors / totalBits;
    end
end
