#!/bin/bash
# Только для локальной разработки: Tomcat запущен из IntelliJ (JMX 127.0.0.1:1099) и отдаёт папку out/.
# Сборка в %TEMP%\fmbuild, копирование классов и страниц в out/, перезагрузка приложения по JMX (сам Tomcat не останавливается).
set -e
P=/d/Dragle/Projects/fm
JDK=/d/install/dev/binaries/jdk1.8.0_102/bin
B="C:/Users/Asus/AppData/Local/JetBrains/IntelliJIdea2026.2/tomcat/fdd9e2e1-f033-48b9-bf63-a8dbb96b339b"
HERE="$(cd "$(dirname "$0")" && pwd)"
cd $P
rm -rf $TEMP/fmbuild
powershell -ExecutionPolicy Bypass -File deploy/build.ps1 -OutDir "$(cygpath -w $TEMP/fmbuild)" > $TEMP/fmbuild.log 2>&1 || { tail -20 $TEMP/fmbuild.log; exit 1; }
[ -d $TEMP/fmbuild/app/WEB-INF/classes ] || { echo "no classes"; tail -20 $TEMP/fmbuild.log; exit 1; }
cp -r $TEMP/fmbuild/app/WEB-INF/classes/. out/WEB-INF/classes/
cp -r $TEMP/fmbuild/app/WEB-INF/pages/. out/WEB-INF/pages/
cp -r $TEMP/fmbuild/app/res/. out/res/
rm -rf $TEMP/fmbuild
mkdir -p "$TEMP/jmxc"
[ -f "$TEMP/jmxc/JmxReload.class" ] || "$JDK/javac" -d "$(cygpath -w "$TEMP/jmxc")" "$(cygpath -w "$HERE/JmxReload.java")"
"$JDK/java" -cp "$(cygpath -w "$TEMP/jmxc")" JmxReload 1099 "$(cygpath -w "$B/jmxremote.password")"
