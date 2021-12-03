#!/bin/bash
cat << THE_END
<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
</head>
<body>
THE_END

ZOZ=0

while IFS= read LINE
do  

    if echo "$LINE" | grep '[^<]*<\(https://[^ ]*\)>' > /dev/null
    then 
        LINE=$(echo "$LINE" | sed 's@\([^<]*\)<\(https://[^>]*\)>@\1<a href="\2">\2</a>@g')
        echo "$LINE"
        continue;
    fi
    
    if echo "$LINE" | grep ' - ' > /dev/null
    then 
        if test "$ZOZ" = 0
        then
            echo '<ul>'
	    ZOZ=1
        fi

        LINE=$(echo "$LINE" | sed 's@ - @<li>@')
        echo "$LINE"'</li>'
        continue;
    fi
    
    if test "$ZOZ" = 1
    then
    	ZOZ=0
        echo '</ul>'
    fi

    if echo "$LINE" | grep '^[[:space:]]*$' > /dev/null
    then 
        LINE=$(echo "$LINE" | sed 's@^[[:space:]]*$@@')
        echo '<p>'
        continue;
    fi

    if echo "$LINE" | grep '^# ' > /dev/null
    then   
        LINE=$(echo "$LINE" | sed 's@# @<h1>@')
        echo "$LINE"'</h1>'
        continue;
    fi

    if echo "$LINE" | grep '^## ' > /dev/null
    then
        LINE=$(echo "$LINE" | sed 's@## @<h2>@')
        echo "$LINE"'</h2>' 
        continue;
    fi

    if echo "$LINE" | grep '__\([^_]*\)__' > /dev/null
    then 
        LINE=$(echo "$LINE" | sed 's@__\([^_]*\)__@<strong>\1</strong>@g')
        echo "$LINE"
        continue;
    fi

    if echo "$LINE" | grep '_\([^_]*\)_' > /dev/null
    then 
        LINE=$(echo "$LINE" | sed 's@_\([^_]*\)_@<em>\1</em>@g')
        echo "$LINE"
        continue;
    fi

    echo "$LINE"
 
done

cat << THE_END
</body>
</html>
THE_END
