#!/bin/bash -e

CLR_R="\033[0m"
CLR_32="\033[32m"
CLR_33="\033[33m"
CLR_36="\033[36m"
CLR_41="\033[41m"
CLR_91="\033[91m"
CLR_92="\033[92m"
CLR_93="\033[93m"

# Dev. by XJIuPa#7732 / https://vk.com/xxxjiupa
# GravitLauncher Logotype
echo -e "   _____ _____       __      _______ _______ ";
echo -e "  / ____${CLR_91}|${CLR_R}  __ ${CLR_36}\     ${CLR_R}/${CLR_36}\ \    ${CLR_R}/ /_   _${CLR_91}|${CLR_R}__   __${CLR_91}|${CLR_R}";
echo -e " ${CLR_91}| |  ${CLR_R}__${CLR_91}| |${CLR_R}__) ${CLR_91}|${CLR_R}   /  ${CLR_36}\ \  ${CLR_R}/ /  ${CLR_91}| |    | |   ${CLR_R}";
echo -e " ${CLR_91}| | |${CLR_R}_ ${CLR_91}|${CLR_R}  _  /   / /${CLR_36}\ \ \/${CLR_R} /   ${CLR_91}| |    | |   ${CLR_R}";
echo -e " ${CLR_91}| |${CLR_R}__${CLR_91}| | | ${CLR_36}\ \  ${CLR_R}/ ____ ${CLR_36}\  ${CLR_R}/   _${CLR_91}| |${CLR_R}_   ${CLR_91}| |   ${CLR_R}";
echo -e "  ${CLR_36}\_${CLR_R}____${CLR_91}|_${CLR_91}|  ${CLR_36}\_\/${CLR_R}_/    ${CLR_36}\_\/   ${CLR_91}|${CLR_R}_____${CLR_91}|  |${CLR_R}_${CLR_91}|   ${CLR_R}";
echo -e "";

# INST_ROOT override root for install
if [[ -n $INST_ROOT ]]; then pushd $INST_ROOT; fi

# Install java 17 full
apt-get update;
apt-get install gnupg2 wget apt-transport-https unzip -y ;
wget -q -O - https://download.bell-sw.com/pki/GPG-KEY-bellsoft | apt-key add - ;
echo "deb [arch=amd64] https://apt.bell-sw.com/ stable main" | tee /etc/apt/sources.list.d/bellsoft.list;
apt-get update;
apt-get install -y bellsoft-java17-full;

# Download latest LaunchServer
wget https://github.com/GravitLauncher/Launcher/releases/latest/download/LaunchServer.jar;
wget https://github.com/GravitLauncher/Launcher/releases/latest/download/LauncherAuthlib.jar;
wget https://github.com/GravitLauncher/Launcher/releases/latest/download/ServerWrapper.jar;
wget https://github.com/GravitLauncher/Launcher/releases/latest/download/libraries.zip;
unzip libraries.zip;
rm libraries.zip;

# Download latest launcher&launchserver modules
mkdir modules-all;
cd modules-all;
wget https://github.com/GravitLauncher/Launcher/releases/latest/download/LauncherModules.zip;
wget https://github.com/GravitLauncher/Launcher/releases/latest/download/LaunchServerModules.zip;
unzip LauncherModules;
unzip LaunchServerModules.zip;
rm LauncherModules.zip;
rm LaunchServerModules.zip;
cd ../;

# Download latest Runtime
mkdir launcher-modules;
cd launcher-modules;
wget https://github.com/GravitLauncher/LauncherRuntime/releases/latest/download/JavaRuntime-2.0.8.jar;
cd ../;

mkdir runtime;
cd runtime;
wget https://github.com/GravitLauncher/LauncherRuntime/releases/latest/download/runtime.zip;
unzip runtime.zip;
rm runtime.zip;
cd ../;

# Create startup command LaunchServer
echo "#!/bin/bash" > start.sh;
echo "/usr/lib/jvm/bellsoft-java17-full-amd64/bin/java -javaagent:LaunchServer.jar -jar LaunchServer.jar;" >> start.sh;
echo "#!/bin/bash" > startscreen.sh;
echo "screen -S launchserver /usr/lib/jvm/bellsoft-java17-full-amd64/bin/java -javaagent:LaunchServer.jar -jar LaunchServer.jar;" >> startscreen.sh;

chmod +x start.sh;
chmod +x startscreen.sh;

# INST_ROOT override root for install
if [[ -n $INST_ROOT ]]; then popd; fi;



