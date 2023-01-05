function [results] = statechange(vector,P,ranP,L) %compute ∑ with neighbors
Q = 100000000;
N = size(L,2);
results = zeros(1,N);

for i = 1:N
    if(vector(i)>=0)
        vector_bi(i) = P(1).bi(uint64(round(vector(i) * Q))); %补码表示负数
        neg_vector_bi(i) = P(1).bi(uint64(2^64 - round(vector(i) * Q)));
    else
        vector_bi(i) = P(1).bi(uint64(2^64 - round(-1*vector(i) * Q)));
        neg_vector_bi(i) = P(1).bi(uint64(round(-1*vector(i) * Q)));
    end
    a = vector_bi(i).longValue();
    b = neg_vector_bi(i).longValue();
    c = P(i).encrypt(vector_bi(i));
    d = P(i).encrypt(neg_vector_bi(i));
    e = P(i).decrypt(c).longValue();
    f = P(i).decrypt(d).longValue();
    
    PK(i) = P(i).getPublicKey.n2;
end


for i = 1:N
    for j = i:N
        if(L(i,j) ~= 0)
            vector_eni = P(i).encrypt(vector_bi(i));
            vector_enj = P(j).encrypt(vector_bi(j));
            neg_vector_eni = P(j).encrypt(neg_vector_bi(i));
            neg_vector_enj = P(i).encrypt(neg_vector_bi(j));
            results(i) = results(i) + (ranP(i).intValue()/100)*(P(i).decrypt(vector_eni.multiply(neg_vector_enj).modPow(ranP(j),PK(i))).longValue()/(Q*1000));
            results(j) = results(j) + (ranP(j).intValue()/100)*(P(j).decrypt(vector_enj.multiply(neg_vector_eni).modPow(ranP(i),PK(j))).longValue()/(Q*1000));
        end
    end
end