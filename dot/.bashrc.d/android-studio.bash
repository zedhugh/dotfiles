basedir=$(realpath -m $(dirname "${BASH_SOURCE[0]:-$0}"))
source "${basedir}/function.bash"

unset basedir

export JAVA_HOME="/opt/android-studio/jbr"
export ANDROID_HOME="${HOME}/Android/Sdk"

if [[ -d "${ANDROID_HOME}/ndk" ]]; then
    export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
fi

add-to-path -s "${ANDROID_HOME}/emulator" "${ANDROID_HOME}/platform-tools"
