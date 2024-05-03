@Echo Off
set ComTitle=Developer Console ^(%ComSpec%^)
title %ComTitle%
start /D "%~dp0" /B %ComSpec% /k "prompt DevCon$S$B$S$P$_$G: && cls && echo Developer Console"
::::: sig=c872bc595ac1273fbac1cd3066f2098cdb363628b16c111844a51dfc2ec1f13b113b825db26f851689ed63c603c396c4ba86f4d1dee0ef8080d1e35094053f53 :::::