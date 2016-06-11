Function FirstChar($str) {
    return $str[0]
}

Function LastChar($str) {
    return $str[$str.length-1]
}

Function LeftChars($str, $count) {
    return $str.substring(0, $count)
}

Function MiddleChars($str, $count) {
    return $str.substring([Int](($str.length / 2) - ($count / 2)), $count)
}

Function RightChars($str, $count) {
    return $str.substring($str.length-$count, $count)
}

Function FirstWord($str) {
    return $str.substring(0, $str.IndexOf(' '))
}

Function LastWord($str) {
    $index = $str.LastIndexOf(' ') + 1
    $length = $str.length - $index
    return $str.substring($index, $length)
}

Function ReverseString($str) {
    For($i = $str.length - 1; $i -ge 0; $i--) {
        $revstr+=$str[$i]
    }
    return $revstr
}

Function ReverseWords($str) {
    $array = $str.split(' ')
    For($i = $array.length - 1; $i -ge 0; $i--) {
        $revwords+=([String]::Format("{0} ", $array[$i]))
    }
    return $revwords.Trim()
}

Function ReverseWordStrings($str) {
    ForEach ($word In $str.split(' ')) {
        $revwords+=([String]::Format("{0} ", (ReverseString($word))))
    }
    return $revwords.Trim()
}

$string = "Hello There World!"
$number = 3
Write-Host "Whole string = $string"
Write-Host "First Character =" (FirstChar $string)
Write-Host "Last Character =" (LastChar $string)
Write-Host "Left $number Characters =" ( LeftChars $string $number)
Write-Host "Middle $number Characters =" ( MiddleChars $string $number)
Write-Host "Right $number Characters =" ( RightChars $string $number)
Write-Host "First Word =" (FirstWord $string)
Write-Host "Last Word =" (LastWord $string)
Write-Host "Reversed Words =" (ReverseWords $string)
Write-Host "Reversed Word Strings =" (ReverseWordStrings $string)
Write-Host "Reversed String =" (ReverseString $string)
