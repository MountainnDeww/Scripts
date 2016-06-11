# Returns the first character of the string str
Function firstCharacter ($str) {
    return $str[0];
};

# Returns the last character of a string str
Function lastCharacter ($str) {
    return $str[$str.length-1];
};

# Returns the string that results from removing the first
#  and last characters from str
Function middleCharacters ($str) {
    return $str.substring(1, $str.length-2);
};

Function isPalindrome ($str) {
    # base case #1
    if ($str.length -le 1) {
        return $true;
    }
    
    # base case #2
    if ((firstCharacter($str)) -ne (lastCharacter($str))) {
        return $false;
    }
    
    # recursive case
    return isPalindrome(middleCharacters($str));
};

Function checkPalindrome ($str) {
    Write-Host "Is this word a palindrome? $str";
    Write-Host (isPalindrome($str));
};

checkPalindrome("a");
[System.Diagnostics.Debug]::Assert((isPalindrome("a")));
checkPalindrome("motor");
[System.Diagnostics.Debug]::Assert(!(isPalindrome("motor")));
checkPalindrome("rotor");
[System.Diagnostics.Debug]::Assert((isPalindrome("rotor")));

[System.Diagnostics.Debug]::Assert(!(isPalindrome("follow")));
[System.Diagnostics.Debug]::Assert(!(isPalindrome("race car")));
[System.Diagnostics.Debug]::Assert((isPalindrome("racecar")));
[System.Diagnostics.Debug]::Assert((isPalindrome("rotator")));



