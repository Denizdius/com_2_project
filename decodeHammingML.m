
function y = decodeHammingML(x,n,k)
    %ydecodeHammingML Maximum likelihood decoder for Hamming codes
    %   Y = decodeHammingML(X,n,k) decodes received symbols, X, of an (n,k)
    %   Hamming code using maximum likelihood decoding and produces data bit
    %   estimates, Y.
    
    m = n-k;
    h = hammgen(m);
    gen = gen2par(h);
    
    messages = de2bi(0:2^k-1, 4);
    codeWords = 1-2*rem(messages * gen,2);
    
    numCodeWords = length(x) / n;
    xIdx = 1:n;
    yIdx = 1:k;
    y = zeros(numCodeWords*k,1);
    for p=1:numCodeWords
      rcvdCodeWord = x(xIdx,1);
      decisionVar = codeWords * rcvdCodeWord;
      [~,cwIdx] = max(decisionVar);
      y(yIdx,1) = messages(cwIdx,:)';
      xIdx = xIdx + n;
      yIdx = yIdx + k;
    end
    end