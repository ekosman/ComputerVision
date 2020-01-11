function H = getProjectiveTransform(p1, p2)
    
    pp = [p1' ones(size(p1',1),1)];
    pX = [pp zeros(size(p1',1),3)];
    pX = reshape(pX',3,[])';
    pY = [zeros(size(p1',1),3) pp];
    pY = reshape(pY',3,[])';
    P = [pX pY];
    pp2 = reshape(p2, [], 1);
    pp2 = repelem(pp2, 1, 3);
    mult = -[p1' ones(size(p1',1),1)];
    mult = repelem(mult, 2, 1);
    pp2 = pp2 .* mult;
    P = [P pp2];

    % SVD
    [U,D,V]=svd(P,0);
    h = V(:,end);
    h = h ./ h(9);
    H = reshape(h, 3, 3)';
end
