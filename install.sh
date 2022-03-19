#!/bin/bash -e

CLR_R="\033[0m"
CLR_31="\033[31m"
CLR_36="\033[36m"
CLR_41="\033[41m"
CLR_91="\033[91m"
CLR_92="\033[92m"
CLR_93="\033[93m"
ARG_WGET_0="--no-check-certificate --content-disposition "
ARG_WGET_1="--continue --show-progress "
ARG_WGET_jdk="${ARG_WGET_0}${ARG_WGET_1}-q -O "
ARG_WGET_other="${ARG_WGET_1}-q"

# GravitLauncher Logotype
echo -e "   _____ _____       __      _______ _______ "
echo -e "  / ____${CLR_91}|${CLR_R}  __ ${CLR_36}\     ${CLR_R}/${CLR_36}\ \    ${CLR_R}/ /_   _${CLR_91}|${CLR_R}__   __${CLR_91}|${CLR_R}"
echo -e " ${CLR_91}| |  ${CLR_R}__${CLR_91}| |${CLR_R}__) ${CLR_91}|${CLR_R}   /  ${CLR_36}\ \  ${CLR_R}/ /  ${CLR_91}| |    | |   ${CLR_R}"
echo -e " ${CLR_91}| | |${CLR_R}_ ${CLR_91}|${CLR_R}  _  /   / /${CLR_36}\ \ \/${CLR_R} /   ${CLR_91}| |    | |   ${CLR_R}"
echo -e " ${CLR_91}| |${CLR_R}__${CLR_91}| | | ${CLR_36}\ \  ${CLR_R}/ ____ ${CLR_36}\  ${CLR_R}/   _${CLR_91}| |${CLR_R}_   ${CLR_91}| |   ${CLR_R}"
echo -e "  ${CLR_36}\_${CLR_R}____${CLR_91}|_${CLR_91}|  ${CLR_36}\_\/${CLR_R}_/    ${CLR_36}\_\/   ${CLR_91}|${CLR_R}_____${CLR_91}|  |${CLR_R}_${CLR_91}|   ${CLR_R}"
echo -e ""

# Checks
set -e
echo -e "${CLR_92}Phase 0: ${CLR_93}Checking${CLR_R}"
which unzip >/dev/null || (echo -e "${CLR_41}Check failed:${CLR_R}${CLR_93} unzip ${CLR_31}not found \n${CLR_93}May be install:${CLR_R} \n${CLR_92}apt-get update ; apt-get install unzip -y${CLR_R}" && exit -1)
which tar >/dev/null || (echo -e "${CLR_41}Check failed:${CLR_R}${CLR_93} tar ${CLR_31}not found \n${CLR_93}May be install:${CLR_R} \n${CLR_92}apt-get update ; apt-get install tar -y${CLR_R}" && exit -1)

# Download local BellSoft JDK 17
echo -e "${CLR_92}Phase 1: ${CLR_93}Download local BellSoft JDK 17${CLR_R}"
s_arch=$(uname -m | awk '{print(substr($0,0,3))}')
s_bitness=$(getconf LONG_BIT)
jdk_link_json=$(wget ${ARG_WGET_0} -q -O - "https://api.bell-sw.com/v1/liberica/releases?version-modifier=latest&os=linux&bundle-type=jdk-full&package-type=tar.gz&bitness=${s_bitness}&arch=${s_arch}")
jdk_link_version=$(echo $jdk_link_json | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^version/ {print $2}' | sed -e "s/^.//;s/.$//")
jdk_link_version_short=$(echo $jdk_link_version | egrep '^[0-9]{2}[/.][0-9][/.][0-9]{1,2}' -o)
jdk_link_filename=$(echo $jdk_link_json | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^filename/ {print $2}' | sed -e "s/^.//;s/.$//")
jdk_link=$(echo "https://github.com/bell-sw/Liberica/releases/download/$jdk_link_version/$jdk_link_filename")
wget ${ARG_WGET_jdk}$jdk_link_filename $jdk_link

# Unpack local BellSoft JDK 17
echo -e "${CLR_92}Phase 2: ${CLR_93}Unpack local BellSoft JDK 17${CLR_R}"
tar -xzf $jdk_link_filename

# Download latest LaunchServer
echo -e "${CLR_92}Phase 3: ${CLR_93}Download LaunchServer${CLR_R}"
wget ${ARG_WGET_other} https://github.com/GravitLauncher/Launcher/releases/latest/download/LaunchServer.jar
wget ${ARG_WGET_other} https://github.com/GravitLauncher/Launcher/releases/latest/download/ServerWrapper.jar
wget ${ARG_WGET_other} https://github.com/GravitLauncher/Launcher/releases/latest/download/libraries.zip
echo -e "${CLR_92}Phase 4: ${CLR_93}Unpack LaunchServer${CLR_R}"
unzip libraries.zip >/dev/null

# Download latest Launcher & LaunchServer modules
echo -e "${CLR_92}Phase 5: ${CLR_93}Download Launcher & LaunchServer modules${CLR_R}"
mkdir -p modules-all
wget ${ARG_WGET_other} -P ./modules-all https://github.com/GravitLauncher/Launcher/releases/latest/download/LauncherModules.zip
wget ${ARG_WGET_other} -P ./modules-all https://github.com/GravitLauncher/Launcher/releases/latest/download/LaunchServerModules.zip
echo -e "${CLR_92}Phase 6: ${CLR_93}Unpack Launcher & LaunchServer modules${CLR_R}"
unzip ./modules-all/LauncherModules.zip -d ./modules-all >/dev/null
unzip ./modules-all/LaunchServerModules.zip -d ./modules-all >/dev/null

# Download latest Runtime
echo -e "${CLR_92}Phase 7: ${CLR_93}Download JavaRuntime${CLR_R}"
mkdir -p {launcher-modules,runtime}
wget_javaruntime_link=$(wget -q -O - https://api.github.com/repos/GravitLauncher/LauncherRuntime/releases/latest | egrep 'https.*/JavaRuntime.*\.jar' -o)
wget ${ARG_WGET_other} -P ./launcher-modules $wget_javaruntime_link
wget ${ARG_WGET_other} -P ./runtime https://github.com/GravitLauncher/LauncherRuntime/releases/latest/download/runtime.zip
echo -e "${CLR_92}Phase 8: ${CLR_93}Unpack JavaRuntime${CLR_R}"
unzip ./runtime/runtime.zip -d ./runtime >/dev/null

echo -e "${CLR_92}Phase 9: ${CLR_93}Remove Extra zip${CLR_R}"
rm libraries.zip
rm ./modules-all/LauncherModules.zip
rm ./modules-all/LaunchServerModules.zip
rm ./runtime/runtime.zip

# Create startup command LaunchServer
echo -e "${CLR_92}Phase 10: ${CLR_93}Create start.sh & startscreen.sh${CLR_R}"
echo "#!/bin/bash" >start.sh
echo "./jdk-${jdk_link_version_short}-full/bin/java -javaagent:LaunchServer.jar -jar LaunchServer.jar;" >>start.sh
echo "#!/bin/bash" >startscreen.sh
echo "screen -S launchserver ./jdk-${jdk_link_version_short}-full/bin/java -javaagent:LaunchServer.jar -jar LaunchServer.jar;" >>startscreen.sh

chmod +x start.sh
chmod +x startscreen.sh


