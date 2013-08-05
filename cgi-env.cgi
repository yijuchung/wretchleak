#!/usr/bin/perl

#####################################################################
# CGI環境變數測試 
# 程式提供 OECSPACE http://www.hsiu28.net/
#####################################################################

print "Content-type: text/html\n\n";
print "<html>\n";
print "<title>主機環境變數</title>\n";
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=big5\">\n";
print "<head>\n";
print "<style type=\"text/css\">\n";
print "<!--\n";
print "body{letter-spacing:0pt;color:#333;font-size:9px;font-family:verdana;}\n";
print "a{color: #000; text-decoration: none;}\n";
print "table{background:#ccc;letter-spacing:1px;color:#333;font-size:8pt;font-family:tahoma;}\n";
print "th{background:#C1AE26;color:#000;height:25px;font-weight: normal;text-align:left;}\n";
print ".td_m{background:#fff;color:#000}\n";
print ".key{background:#ffffff;}\n";
print "-->\n";
print "</style>\n";
print "</head>\n";
print "<body>\n";
print "<center><table cellpadding=\"4\" cellspacing=\"1\">\n";
print "<th>主機環境變數名稱</th><th>變數值</th>\n";
for $key (sort(keys(%ENV))) {
	print "<tr><td class=\"td_m\">$key</td><td class=\"key\">$ENV{$key}</td></tr>\n";
}
print "</table><br><a href=\"http://www.hsiu28.net/\">Cgi by OECSPACE</a></center>\n";
print "</body></html>\n"; 
exit;

