#!/usr/bin/env lua

-- strip the basic html out of a calibre html section

for line in io.lines() do
  local fixed = line:gsub([[<p.-class="copy.->]],'\n')
                    :gsub([[</p>]],'')
                    :gsub([[</div>]],'')
                    :gsub([[<a[^>]-></a>]],'')
                    :gsub([[</span></div>$]],'\n')
                    :gsub([[<em .->(.-)</em>]],"''%1''")
                    :gsub([[<pre class="programlisting" .->]],'\n<syntaxhighlight lang="lua">')
		    :gsub([[%-%-&gt;]],[[-->]]) -- in code samples...
		    :gsub([[^      &gt;]],[[      >]]) -- in code samples...
                    :gsub([[</pre>]],'</syntaxhighlight>')
                    :gsub([[<code .->]],[[<code>]])
		    :gsub([[<h2.->(.-)</h2>]],'\n== %1 ==\n')
                    --  for mystical qablah... if the start of the line is CAPS then make a definition list
                    -- :gsub("^([%u -][%u -][%u -]+):","; %1\n:")
  print(fixed)
end
