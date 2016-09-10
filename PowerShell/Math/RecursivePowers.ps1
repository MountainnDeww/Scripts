Function isEven($n) {
    return ($n % 2 -eq 0);
};

Function isOdd($n) {
    return !(isEven($n));
};

Function power($x, $n) {
    #Write-Host "Computing $x raised to power $n.";
    # base case
    if ($n -eq 0) {
        return 1;
    }
    
    # recursive case: n is negative 
    if ($n -lt 0) {
        return 1 / (power $x (-$n));
    }
    
    # recursive case: $n is odd
    if (isOdd($n)) {
        return (power $x ($n - 1)) * $x;
    }
  
    # recursive case: $n is even
    if (isEven($n)) {
        $y = (power $x ($n/2));
        return $y*$y;
    }
};

Function displayPower($x, $n) {
    Write-Host "$x to the $n is" (power $x $n);
};

displayPower 3 0 ;
[System.Diagnostics.Debug]::Assert((power 3 0), 1);
displayPower 3 1 ;
[System.Diagnostics.Debug]::Assert((power 3 1), 3);
displayPower 3 2 ;
[System.Diagnostics.Debug]::Assert((power 3 2), 9);
displayPower 3 -1 ;
[System.Diagnostics.Debug]::Assert((power 3 -1), 1/3);

displayPower 5 6 ;
[System.Diagnostics.Debug]::Assert((power 5 6), 15625);

displayPower 4 3 ;
[System.Diagnostics.Debug]::Assert((power 4 3), 64);

displayPower 7 -4 ;
[System.Diagnostics.Debug]::Assert((power 7 -4), 4.1649312786339025406080799666805e-4);

displayPower 3 -3 ;
[System.Diagnostics.Debug]::Assert((power 3 -3), 0.03703703703703703703703703703704);
