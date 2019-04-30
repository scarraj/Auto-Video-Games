@echo off
"C:\Visiual Studio\MSBuild\15.0\Bin\MSBuild.exe" "C:\CSE201\CSE 201.sln" /t:build /p:Configuration=Release

cd \Program Files (x86)\IIS Express

start iisexpress /path:"C:\CSE201\CSE 201" /port:9090 /clr:v4.0
start  http://localhost:9090