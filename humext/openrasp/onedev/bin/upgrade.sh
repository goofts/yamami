#! /bin/sh

#
# Copyright (c) 1999, 2021 Tanuki Software, Ltd.
# http://www.tanukisoftware.com
# All rights reserved.
#
# This software is the proprietary information of Tanuki Software.
# You shall use it only in accordance with the terms of the
# license agreement you entered into with Tanuki Software.
# http://wrapper.tanukisoftware.com/doc/english/licenseOverview.html
#
# Java Service Wrapper sh script.  Suitable for starting and stopping
#  wrapped Java applications on UNIX platforms.
# Optimized for use with version 3.5.48-st of the Wrapper.
#

#-----------------------------------------------------------------------------
# These settings can be modified to fit the needs of your application

# IMPORTANT - Please always stop and uninstall an application before making
#             any changes to this file.  Failure to do so could remove the
#             script's ability to control the application.

# NOTE - After loading the variables below, the script will attempt to locate a
#  file with the same basename as this script and having a '.shconf' extension.
#  If such file exists, it will be executed giving the user a chance to
#  override the default settings. Having the customized configuration in a
#  separate '.shconf' file makes it easier to upgrade the Wrapper, as the
#  present script file can then be replaced with minimal changes (although at
#  least the 'INIT INFO' below needs to be updated).

# Initialization block for the install_initd and remove_initd scripts used by
#  SUSE linux, CentOS and RHEL distributions.  Also used by update-rc.d.
# Note: From CentOS 6, make sure the BEGIN INIT INFO section is before any line 
#       of code otherwise the service won't be displayed in the Service 
#       Configuration GUI.
### BEGIN INIT INFO
# Provides: onedev_upgrade
# Required-Start: $remote_fs $syslog
# Should-Start: $network $time
# Should-Stop: $network $time
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: OneDev Upgrade
# Description: OneDev Upgrade
### END INIT INFO

# Application name and long name: If these variables are not set (or left to
#  the default tokens), APP_NAME will default to the name of the script, then
#  APP_LONG_NAME will default to the value of APP_NAME.
APP_NAME="onedev_upgrade"
APP_LONG_NAME="OneDev Upgrade"

# If uncommented (and set to false), APP_NAME and APP_LONG_NAME will no longer 
#  be passed to the wrapper. See documentation for details.
#APP_NAME_PASS_TO_WRAPPER=false

# Wrapper
WRAPPER_CMD="../boot/wrapper"
WRAPPER_CONF="../conf/wrapper.conf"

# Priority at which to run the wrapper.  See "man nice" for valid priorities.
#  nice is only used if a priority is specified.
PRIORITY=

# Location of the pid file.
PIDDIR="."

# PIDFILE_CHECK_PID tells the script to double check whether the pid in the pid
#  file actually exists and belongs to this application.  When not set, only
#  check the pid, but not what it is.  This is only needed when multiple
#  applications need to share the same pid file.
PIDFILE_CHECK_PID=true

# FIXED_COMMAND tells the script to use a hard coded action rather than
#  expecting the first parameter of the command line to be the command.
#  By default the command will be expected to be the first parameter.
FIXED_COMMAND=console

# PASS_THROUGH controls how the script arguments should be passed to the
#  Wrapper. Possible values are:
#  - commented or 'false': the arguments will be ignored (not passed).
#  - 'app_args' or 'true': the arguments will be passed through the Wrapper as
#                          arguments for the Java Application.
#  - 'both': both Wrapper properties and Application arguments can be passed to
#            the Wrapper. The Wrapper properties come in first position. The
#            user can optionally add a '--' separator followed by application
#            arguments.
# NOTE - If FIXED_COMMAND is set to true the above applies to all arguments,
#        otherwise it applies to arguments starting with the second.
# NOTE - Passing arguments is only valid with the following commands:
#          - 'console'
#          - 'start', 'restart', 'condrestart' (if not installed as a daemon)
PASS_THROUGH=true

# If uncommented, causes the Wrapper to be shutdown using an anchor file.
#  When launched with the 'start' command, it will also ignore all INT and
#  TERM signals.
#IGNORE_SIGNALS=true

# Wrapper will start the JVM asynchronously. Your application may have some
#  initialization tasks and it may be desirable to wait a few seconds
#  before returning.  For example, to delay the invocation of following
#  startup scripts.  Setting WAIT_AFTER_STARTUP to a positive number will
#  cause the start command to delay for the indicated period of time 
#  (in seconds).
WAIT_AFTER_STARTUP=0

# If set, wait for the wrapper to report that the daemon has started
WAIT_FOR_STARTED_STATUS=true
WAIT_FOR_STARTED_TIMEOUT=120

# If set, the status, start_msg and stop_msg commands will print out detailed
#   state information on the Wrapper and Java processes.
#DETAIL_STATUS=true

# If set, the 'pause' and 'resume' commands will be enabled.  These make it
#  possible to pause the JVM or Java application without completely stopping
#  the Wrapper.  See the wrapper.pausable and wrapper.pausable.stop_jvm
#  properties for more information.
#PAUSABLE=true

# Set the mode used to 'pause' or 'resume' the Wrapper. Possible values are
#  'signals' which uses SIGUSR1 and SIGUSR2, and 'file' which uses the command
#  file to communicate these actions.  The default value is 'signals'.
#  Be aware that depending on the mode, the properties wrapper.signal.mode.usr1,
#  wrapper.signal.mode.usr2, or wrapper.commandfile of the configuration file may
#  be overriden.
#PAUSABLE_MODE=signals

# If set, the Wrapper will be run as the specified user.
# IMPORTANT - Make sure that the user has the required privileges to write
#  the PID file and wrapper.log files.  Failure to be able to write the log
#  file will cause the Wrapper to exit without any way to write out an error
#  message.
# NOTES - This will set the user which is used to run the Wrapper as well as
#  the JVM and is not useful in situations where a privileged resource or
#  port needs to be allocated prior to the user being changed.
#       - Setting this variable will cause stdin to be closed. While this
#  should not be a problem when running as Daemon, it would disable ability
#  for console applications to receive inputs.
#RUN_AS_USER=

# When RUN_AS_USER is set, the 'runuser' command will be used to substitute the
#  user. If not present on the machine, 'su' will be used as a fallback.
#  The parameter below lets you specify option(s) for the 'runuser' (or 'su')
#  command.
# NOTES - The '-u' option is not allowed. Please set the user with RUN_AS_USER.
#       - On GNU/Linux systems, if the user specified by RUN_AS_USER doesn't
#  have a default shell please specify one with the '-s' option.
#SU_OPTS="-s /bin/bash"

# By default we show a detailed usage block.  Uncomment to show brief usage.
#BRIEF_USAGE=true

# Set which service management tool to use.
# Possible values are: 
#   for linux...: auto, systemd, upstart, initd
#   for aix.....: auto, src, initd
# When set to 'auto', this script file will try to detect in the order of the 
# list for each platform which service management tool to use to install the Wrapper.
SERVICE_MANAGEMENT_TOOL=auto

# Specify how the Wrapper daemon and its child processes should be killed
#  when using systemd.
#  The default is 'control-group' which tells systemd to kill all child
#  processes (including detached ones) in the control group of the daemon
#  when it stops.
#  Alternatively, 'process' can be specified to prevent systemd from
#  killing the child processes leaving this responsibility to the Wrapper.
#  In this case child processes marked as 'detached' will not be killed on shutdown.
# NOTE - the daemon must be reinstalled for any changes on this property to take effect.
SYSTEMD_KILLMODE=control-group

# When installing on Mac OSX platforms, the following domain will be used to
#  prefix the plist file name.
PLIST_DOMAIN=org.tanukisoftware.wrapper

# When installing on Mac OSX platforms, this parameter controls whether the daemon
#  is to be kept continuously running or to let demand and conditions control the 
#  invocation.
MACOSX_KEEP_RUNNING="false"

# The following two lines are used by the chkconfig command. Change as is
#  appropriate for your application.  They should remain commented.
# chkconfig: 2345 20 80
# description: OneDev Upgrade

# Set run level to use when installing the application to start and stop on
#  system startup and shutdown.  It is important that the application always
#  be uninstalled before making any changes to the run levels.
# It is also possible to specify different run levels based on the individual
#  platform.  When doing so this script will look for defined run levels in
#  the following order:
#   1) "RUN_LEVEL_S_$DIST_OS" or "RUN_LEVEL_K_$DIST_OS", where "$DIST_OS" is
#      the value of DIST_OS.  "RUN_LEVEL_S_solaris=20" for example.
#   2) RUN_LEVEL_S or RUN_LEVEL_K, to specify specify start or stop run levels.
#   3) RUN_LEVEL, to specify a general run level.
RUN_LEVEL=20

# List of files to source prior to executing any commands. Use ';' as delimiter.
# For example: 
#  FILES_TO_SOURCE="/home/user/.bashrc;anotherfile;../file3"
FILES_TO_SOURCE=

# Do not modify anything beyond this point
#-----------------------------------------------------------------------------

gettext() {
    "$WRAPPER_CMD" --translate "$1" "$WRAPPER_CONF" 2>/dev/null
    if [ $? != 0 ] ; then 
        echo "$1"
    fi
}

checkIsRoot() {
    if [ `id | sed 's/^uid=//;s/(.*$//'` != "0" ] ; then
        IS_ROOT=false
    else
        IS_ROOT=true
    fi
}

mustBeRootOrExit() {
    checkIsRoot
    if [ "$IS_ROOT" != "true" ] ; then
        eval echo `gettext 'Must be root to perform this action.'`
        exit 1
    fi
}

##
# Normalize a dir path.
#
# $1: the name of the variable to set (without the $)
# $2: the path to normalize
normalizeDirPath() {
    # NOTE: Variables are prefixed with 'ndp_' to avoid conflict with code
    #       outside this function. Keyword 'local' is not supported on some
    #       systems (z/OS, Solaris 10)
    #
    # Use '&&' to ensure pwd is only executed on an existing directory
    ndp_normalDirPath=`unset CDPATH && cd "$2" 2>/dev/null && pwd`
    ndp_ret=$?
    if [ $ndp_ret -eq 0 ] ; then
        eval "$1=$ndp_normalDirPath"
    else
        eval "$1=$2"
    fi
    return $ndp_ret
}

##
# Normalize a file path.
#
# $1: the name of the variable to set (without the $)
# $2: the path to normalize
normalizeFilePath() {
    # NOTE: Variables are prefixed with 'nfp_' to avoid conflict with code
    #       outside this function. Keyword 'local' is not supported on some
    #       systems (z/OS, Solaris 10)
    nfp_dirPath=`dirname "$2"`
    normalizeDirPath nfp_normalDirPath $nfp_dirPath
    nfp_ret=$?
    if [ $nfp_ret -eq 0 ] ; then
        nfp_fileName=`basename "$2"`
        eval "$1=$nfp_normalDirPath/$nfp_fileName"
    else
        eval "$1=$2"
    fi
    return $nfp_ret
}

##
# Resolves the location of a system command.
#
# $1: the name of the variable to set (without the $)
# $2: the name of the command
# $3: an ordered and semicolon-separated list of paths where the command should
#     be searched. The list should contain an empty value for the command to be
#     searched using the PATH environment variable.
# $4: 1 to be strict (the script will stop with an error), 0 otherwise.
resolveLocation() {
    eval "CMD_TEMP=\$$1"
    if [ "X$CMD_TEMP" = "X" ] ; then
        found=0
        
        OIFS=$IFS
        IFS=';'
        for CMD_PATH in $3
        do
            if [ -z "$CMD_PATH" ] ; then
                # empty path
                CMD_TEMP="$2"
                ret=`command -v $CMD_TEMP 2>/dev/null`
                if [ $? -eq 0 ] ; then
                    found=1
                    break
                fi
            else
                CMD_TEMP="${CMD_PATH}/$2"
                if [ -x "$CMD_TEMP" ] ; then
                    found=1
                    break
                fi
            fi
        done
        IFS=$OIFS
        
        if [ $found -eq 1 ] ; then
            eval "$1=$CMD_TEMP"
        elif [ $4 -eq 1 ] ; then
            eval echo `gettext 'Unable to locate "$2".'`
            eval echo `gettext 'Please report this message along with the location of the command on your system.'`
            exit 1
        else
            # return the error
            return 1
        fi
    fi
    return 0
}

resolveIdLocation() {
    # On Solaris, the version in /usr/xpg4/bin should be used in priority.
    resolveLocation ID_BIN id "/usr/xpg4/bin;;/usr/bin" 1
}

resolveCurrentUser() {
    if [ "X$CURRENT_USER" = "X" ] ; then
        resolveIdLocation
        CURRENT_USER=`$ID_BIN -u -n 2>/dev/null`
    fi
}

validateRunUser() {
    if [ "X$RUN_AS_USER" != "X" ]
    then
        resolveCurrentUser
        if [ "$CURRENT_USER" = "$RUN_AS_USER" ]
        then
            # Already running as the configured user.
            RUN_AS_USER=""
        fi
    fi
    if [ "X$RUN_AS_USER" != "X" ]
    then
        # Make sure the user exists
        if [ "`$ID_BIN -u -n "$RUN_AS_USER" 2>/dev/null`" != "$RUN_AS_USER" ]
        then
            eval echo `gettext 'User $RUN_AS_USER does not exist.'`
            exit 1
        fi

        # Make sure to be root when using RUN_AS_USER. This is required for runuser. For su, it is technically possible to use
        #  it with a normal user, but we are using the command several times so this would result in multiple password prompts.
        checkIsRoot
        if [ "$IS_ROOT" != "true" ] ; then
            eval echo `gettext 'Must be root to run with RUN_AS_USER=$RUN_AS_USER.'`
            exit 1
        fi

        # Resolve the location of the 'runuser' command, or fall back on 'su' if it is not present.
        resolveLocation RUNUSER_BIN runuser ";/sbin;/usr/sbin" 0
        ret=$?
        if [ $ret -eq 1 ] ; then
            resolveLocation RUNUSER_BIN su ";/bin" 0
            ret=$?
        fi
        if [ $ret -eq 1 ] ; then
            eval echo `gettext 'Unable to locate the command to run with a substitute user.'`
            exit 1
        fi
    fi
}

# Make sure APP_NAME is less than 14 characters, otherwise in AIX, the commands
# "lsitab" or "lssrc" will fail
validateAppNameLength() {
    if [ ${#APP_NAME} -gt 14 ] ; then
        eval echo `gettext ' APP_NAME must be less than 14 characters long. Length of ${APP_NAME} is ${#APP_NAME}.'`
        exit 1
    fi
}

# Method to check if systemd is running.
# Returns 0 if systemd is found, otherwise returns 1.
systemdDetection() {
    if [ ! -d "/etc/systemd" ] ; then
        return 1
    fi

    resolveLocation PIDOF_BIN pidof ";/bin;/usr/sbin" 1
    result=`$PIDOF_BIN systemd`
    return $?
}

# Detect if upstart is installed
# Returns 0 if upstart is found, otherwise returns 1.
upstartDetection() {
    if [ ! -d "/etc/init" ] ; then
        return 1
    fi
    
    INITCTL_BIN="initctl"
    result=`command -v $INITCTL_BIN 2>/dev/null`
    if [ $? -ne 0 ] ; then
        INITCTL_BIN="/sbin/initctl"
        if [ ! -x "$INITCTL_BIN" ] ; then
            return 1
        fi
    fi
    
    result=`$INITCTL_BIN version 2>/dev/null`
    if [ $? -eq 0 ] ; then
        # if the word "upstart" is in the result, then we assume upstart is installed.
        result=`echo $result | grep upstart`
        if [ $? -eq 0 ] ; then
            return 0
        fi
    fi
    
    # The command /sbin/initctl may fail if the user doesn't have enough privilege 
    # but that doesn't mean upstart is not present.
    # In this case we can assume upstart exists if the service was previously 
    # installed by the root user.
    if  [ -f "/etc/init/${APP_NAME}.conf" ] ; then
        return 0
    fi
    
    return 1
}

# Method to check if SRC is running.
# Returns 0 if SRC is found, otherwise returns 1.
srcDetection() {
    # $PS_BIN has already been resolved at startup
    result=`$PS_BIN -A | grep srcmstr`
    return $?
}

setServiceManagementToolLinux() {
    case "$SERVICE_MANAGEMENT_TOOL" in
        'auto')
            systemdDetection
            if [ $? -eq 0 ] ; then
                USE_SYSTEMD=1
                return
            fi
            
            upstartDetection
            if [ $? -eq 0 ] ; then
                USE_UPSTART=1
                return
            fi
            ;;
        'systemd')
            USE_SYSTEMD=1
            ;;
        'upstart')
            USE_UPSTART=1
            ;;
        'initd')
            ;;
        *)
            return 1
    esac
}

setServiceManagementToolAix() {
    case "$SERVICE_MANAGEMENT_TOOL" in
        'auto')
            srcDetection
            if [ $? -eq 0 ] ; then
                USE_SRC=1
            fi
            ;;
        'src')
            USE_SRC=1
            ;;
        'initd')
            ;;
        *)
            return 1
    esac
}

# Resolve the service management tool for linux and aix.
setServiceManagementTool() {
    if [ ! -n "$SERVICE_MANAGEMENT_TOOL" ] ; then
        # Set the default value to auto.
        SERVICE_MANAGEMENT_TOOL=auto
    fi
    
    if [ "$DIST_OS" = "linux" ] ; then
        setServiceManagementToolLinux
    elif [ "$DIST_OS" = "aix" ] ; then
        setServiceManagementToolAix
    else
        if [ "$SERVICE_MANAGEMENT_TOOL" != "auto" ] ; then
            eval echo `gettext 'The script does not support the service management tool \"$SERVICE_MANAGEMENT_TOOL\" on this platform.'`
            SERVICE_MANAGEMENT_TOOL=auto
        fi
        return
    fi
    
    if [ $? = 1 ] ; then
        eval echo `gettext 'Service management tool value is invalid: $SERVICE_MANAGEMENT_TOOL.'`
        exit 1
    fi
}

# default location for the service file
SYSTEMD_SERVICE_FILE="/etc/systemd/system/$APP_NAME.service"

# Installation status
SERVICE_NOT_INSTALLED=0
SERVICE_INSTALLED_DEFAULT=1
SERVICE_INSTALLED_SYSTEMD=2
SERVICE_INSTALLED_UPSTART=4
SERVICE_INSTALLED_SRC=8
SERVICE_INSTALLED_SRC_PARTIAL=16 #incomplete installation with SRC (lssrc or lsitab failed to return a record)

getServiceControlMethod() {
    if [ "$DIST_OS" = "macosx" -a -f "/Library/LaunchDaemons/${APP_PLIST}" ] ; then
        CTRL_WITH_LAUNCHD=true
    elif [ "$DIST_OS" = "linux" -a -n "$USE_UPSTART" ] && [ -f "/etc/init/${APP_NAME}.conf" ] ; then
        CTRL_WITH_UPSTART=true
    elif [ "$DIST_OS" = "linux" -a -n "$USE_SYSTEMD" -a -z "$SYSD" ] && [ -f "${SYSTEMD_SERVICE_FILE}" ] ; then
        CTRL_WITH_SYSTEMD=true
    elif [ "$DIST_OS" = "aix" -a -n "$USE_SRC" ] && [ -n "`/usr/bin/lssrc -S -s $APP_NAME`" ] ; then
        CTRL_WITH_SRC=true
    else
        CTRL_WITH_DEFAULT=true
    fi
}

checkInstalled() {
    # Install status
    installedStatus=$SERVICE_NOT_INSTALLED
    installedWith=""

    if [ "$DIST_OS" = "solaris" ] ; then
        if [ -f "/etc/init.d/$APP_NAME" -o -L "/etc/init.d/$APP_NAME" ] ; then
            installedStatus=$SERVICE_INSTALLED_DEFAULT
        fi
    elif [ "$DIST_OS" = "linux" ] ; then
        if [ "X$1" != "Xstrict" -o \( -z "$USE_SYSTEMD" -a -z "$USE_UPSTART" \) ] ; then
            if [ -f "/etc/init.d/$APP_NAME" -o -L "/etc/init.d/$APP_NAME" ] ; then
                installedStatus=$SERVICE_INSTALLED_DEFAULT
                installedWith="init.d"
            fi
        fi
        if [ "X$1" != "Xstrict" -o -n "$USE_SYSTEMD" ] ; then
            if [ -f "${SYSTEMD_SERVICE_FILE}" ] ; then
                installedStatus=`expr $installedStatus + $SERVICE_INSTALLED_SYSTEMD`
                installedWith="${installedWith}${installedWith:+, }systemd"
            fi
        fi
        if [ "X$1" != "Xstrict" -o -n "$USE_UPSTART" ] ; then
            if [ -f "/etc/init/${APP_NAME}.conf" ] ; then
                installedStatus=`expr $installedStatus + $SERVICE_INSTALLED_UPSTART`
                installedWith="${installedWith}${installedWith:+, }upstart"
            fi
        fi
    elif [ "$DIST_OS" = "hpux" ] ; then
        if [ -f "/sbin/init.d/$APP_NAME" -o -L "/sbin/init.d/$APP_NAME" ] ; then
            installedStatus=$SERVICE_INSTALLED_DEFAULT
        fi
    elif [ "$DIST_OS" = "aix" ] ; then
        if [ "X$1" != "Xstrict" -o -z "$USE_SRC" ] ; then
            if [ -f "/etc/rc.d/init.d/$APP_NAME" -o -L "/etc/rc.d/init.d/$APP_NAME" ] ; then
                installedStatus=$SERVICE_INSTALLED_DEFAULT
                installedWith="init.d"
            fi
        fi
        if [ "X$1" != "Xstrict" -o -n "$USE_SRC" ] ; then
            validateAppNameLength
            if [ "$IS_ROOT" = "true" ] ; then
                # Check both lssrc & lsitab to make sure the installation is complete. lsitab requires root privileges.
                # We will go through this case before installing or removing a service, so we can redo a clean installation
                # or a clean removal if installedStatus=5
                if [ -n "`/usr/sbin/lsitab $APP_NAME`" -a -n "`/usr/bin/lssrc -S -s $APP_NAME`" ] ; then
                    installedStatus=`expr $installedStatus + $SERVICE_INSTALLED_SRC`
                    installedWith="${installedWith}${installedWith:+, }SRC"
                elif [ -n "`/usr/sbin/lsitab $APP_NAME`" -o -n "`/usr/bin/lssrc -S -s $APP_NAME`" ] ; then
                    installedStatus=`expr $installedStatus + $SERVICE_INSTALLED_SRC_PARTIAL`
                    installedWith="${installedWith}${installedWith:+, }SRC"
                fi
            else
                # Using lssrc is enough to test normal installations and doesn't require root privileges
                if [ -n "`/usr/bin/lssrc -S -s $APP_NAME`" ] ; then
                    installedStatus=`expr $installedStatus + $SERVICE_INSTALLED_SRC`
                    installedWith="${installedWith}${installedWith:+, }SRC"
                fi
            fi
        fi
    elif [ "$DIST_OS" = "freebsd" ] ; then
        if [ -f "/etc/rc.d/$APP_NAME" -o -L "/etc/rc.d/$APP_NAME" ] ; then
            installedStatus=$SERVICE_INSTALLED_DEFAULT
        fi
    elif [ "$DIST_OS" = "macosx" ] ; then
        if [ -f "/Library/LaunchDaemons/${APP_PLIST}" -o -L "/Library/LaunchDaemons/${APP_PLIST}" ] ; then
            installedStatus=$SERVICE_INSTALLED_DEFAULT
        fi
    elif [ "$DIST_OS" = "zos" ] ; then
        if [ -f /etc/rc.bak ] ; then
            installedStatus=$SERVICE_INSTALLED_DEFAULT
        fi
    fi
}

showUsage() {
    # $1 bad command

    if [ -n "$1" ]
    then
        eval echo `gettext 'Unexpected command: $1'`
        echo "";
    fi
    
    if [ "X${PASS_THROUGH}" = "Xapp_args" ] ; then
        ARGS=" {JavaAppArgs}"
    elif [ "X${PASS_THROUGH}" = "Xboth" ] ; then
        ARGS=" {WrapperProperties} [-- {JavaAppArgs}]"
    else
        ARGS=""
    fi

    eval MSG=`gettext 'Usage: '`
    if [ -n "$FIXED_COMMAND" ] ; then
        echo "${MSG} $0${ARGS}"
    else
        setServiceManagementTool
        checkInstalled "strict"
        if [ $installedStatus -eq $SERVICE_NOT_INSTALLED ] ; then
            # not installed, allow arguments to be passed through
            ARGS_START=$ARGS
        else
            ARGS_START=""
        fi
        if [ -n "$PAUSABLE" ] ; then
            echo "${MSG} $0 [ console${ARGS} | start${ARGS_START} | stop | restart${ARGS_START} | condrestart${ARGS_START} | pause | resume | status | install | installstart | remove | dump ]"
        else
            echo "${MSG} $0 [ console${ARGS} | start${ARGS_START} | stop | restart${ARGS_START} | condrestart${ARGS_START} | status | install | installstart | remove | dump ]"
        fi
    fi

    if [ ! -n "$BRIEF_USAGE" ]
    then
        echo "";
        if [ ! -n "$FIXED_COMMAND" ] ; then
            echo "`gettext 'Commands:'`"
            echo "`gettext '  console      Launch in the current console.'`"
            echo "`gettext '  start        Start in the background as a daemon process.'`"
            echo "`gettext '  stop         Stop if running as a daemon or in another console.'`"
            echo "`gettext '  restart      Stop if running and then start.'`"
            echo "`gettext '  condrestart  Restart only if already running.'`"
            if [ -n "$PAUSABLE" ] ; then
                echo "`gettext '  pause        Pause if running.'`"
                echo "`gettext '  resume       Resume if paused.'`"
            fi
            echo "`gettext '  status       Query the current status.'`"
            echo "`gettext '  install      Install to start automatically when system boots.'`"
            echo "`gettext '  installstart Install and start running as a daemon process.'`"
            echo "`gettext '  remove       Uninstall.'`"
            echo "`gettext '  dump         Request a Java thread dump if running.'`"
            echo "";
        fi
        if [ "X${PASS_THROUGH}" = "Xapp_args" -o "X${PASS_THROUGH}" = "Xboth" ] ; then
            if [ "X${PASS_THROUGH}" = "Xboth" ] ; then
                echo "WrapperProperties:"
                echo "`gettext '  Optional configuration properties which will be passed to the Wrapper.'`"
                echo "";
            fi
            echo "JavaAppArgs:"
            echo "`gettext '  Optional arguments which will be passed to the Java application.'`"
            echo "";
        fi
    fi

    exit 1
}

# Output help to understand why the working directory is not accessible.
#  The permissions of each folder composing the path will be printed.
#  If a folder doesn't have enough permissions, the wrapper binaries or the
#  script located in that directory won't be able to execute.
#  - When running with the current user, this means we won't be able to detect
#    whether the Wrapper binaries are executable, nor send requests such as
#    --translate, --request_delta_binary_bits, --request_log_file.
#  - When RUN_AS_USER is set, we must be root so the current user should always
#    have enough permission. However the command to substitute the user would
#    fail if the specified user doesn't have permission on the full path.
#
# $1: The name of the user for which we fail to execute a command in the
#     working directory.
reportRealDirNotAccessible() {
    # Unfortunately the following message will not be translated because currently the Wrapper fails to execute correctly when it can't access to the absolute path.
    eval echo `gettext 'Failed to access the script using an absolute path. Insufficient permissions may prevent the user \"$1\" from traversing one of the folders. Please check the following permissions:'`

    OIFS=$IFS
    IFS='/'
    for DIR in $REALDIR
    do
        # REALDIR should already be normalized, but skip '.' if any remains.
        if [ "$DIR" != "" -a "$DIR" != "." ] ; then
            INT_PATH="${INT_PATH}/$DIR"
            ALL_PATHS="${ALL_PATHS} ${INT_PATH}"
            result=`cd "${INT_PATH}" 2>/dev/null`
            if [ $? -ne 0 ] ; then
                # no access to this folder and so to the rest of the path.
                break
            fi
        fi
    done
    IFS=$OIFS
    ls -dal $ALL_PATHS
}

# check if we are running under Cygwin terminal.
# Note: on some OS's (for example Solaris, MacOS), -o is not a valid parameter 
# and it shows an error message. We redirect stderr to null so the error message
# doesn't show up.
CYGWIN=`uname -o 2>/dev/null`
if [ "$CYGWIN" = "Cygwin" ]
then
  eval echo `gettext 'This script is not compatible with Cygwin.  Please use the Wrapper batch files to control the Wrapper.'`
  exit 1
fi

# Resolve the location of the 'ps' & 'tr' command
resolveLocation PS_BIN ps "/usr/ucb;/usr/bin;/bin" 1
resolveLocation TR_BIN tr "/usr/bin;/bin" 1

# Resolve the OS (needs to be done before any call to showUsage, checkInstalled, etc.)
DIST_OS=`uname -s | $TR_BIN "[A-Z]" "[a-z]" | $TR_BIN -d ' '`
case "$DIST_OS" in
    'sunos')
        DIST_OS="solaris"
        ;;
    'hp-ux' | 'hp-ux64')
        # HP-UX needs the XPG4 version of ps (for -o args)
        DIST_OS="hpux"
        UNIX95=""
        export UNIX95
        PATH=$PATH:/usr/bin
        ;;
    'darwin')
        DIST_OS="macosx"
        ;;
    'unix_sv')
        DIST_OS="unixware"
        ;;
    'os/390')
        DIST_OS="zos"
        ;;
    'linux')
        DIST_OS="linux"
        ;;
esac

# check if there is a parameter "sysd"
SYSD=
if [ $# -gt 1 ] ; then
    if [ $2 = "sysd" ] ; then
        SYSD=1
    fi
fi

# Get the fully qualified path to the script
case $0 in
    /*)
        SCRIPT="$0"
        ;;
    *)
        PWD=`pwd`
        if [ $? -ne 0 ] ; then
            # On some systems pwd may fail if one of the parent folder has insufficient permissions.
            #  Is there a way to access the current location which would allow to print the permissions
            #  for each folder like we do below?
            exit 1
        fi
        SCRIPT="$PWD/$0"
        ;;
esac

# Resolve the true real path without any sym links.
CHANGED=true
while [ "X$CHANGED" != "X" ]
do
    # Change spaces to ":" so the tokens can be parsed.
    SAFESCRIPT=`echo "$SCRIPT" | sed -e 's; ;:;g'`
    # Get the real path to this script, resolving any symbolic links
    TOKENS=`echo $SAFESCRIPT | sed -e 's;/; ;g'`
    REALPATH=
    for C in $TOKENS; do
        # Change any ":" in the token back to a space.
        C=`echo $C | sed -e 's;:; ;g'`
        REALPATH="$REALPATH/$C"
        # If REALPATH is a sym link, resolve it.  Loop for nested links.
        while [ -h "$REALPATH" ] ; do
            LS="`ls -ld "$REALPATH"`"
            LINK="`expr "$LS" : '.*-> \(.*\)$'`"
            if expr "$LINK" : '/.*' > /dev/null; then
                # LINK is absolute.
                REALPATH="$LINK"
            else
                # LINK is relative.
                REALPATH="`dirname "$REALPATH"`""/$LINK"
            fi
        done
    done

    if [ "$REALPATH" = "$SCRIPT" ]
    then
        CHANGED=""
    else
        SCRIPT="$REALPATH"
    fi
done

normalizeFilePath REALPATH $REALPATH

# Try to source a file with the same filename as the script and with the '.shconf' extension.
case $REALPATH in
    *.sh)
        SHCONF_FILE=`echo $REALPATH | rev | cut -d "." -f2- | rev`
        ;;
    *)
        SHCONF_FILE="$REALPATH"
        ;;
esac

SHCONF_FILE="${SHCONF_FILE}.shconf"

if [ -f "$SHCONF_FILE" ] ; then
    if [ ! -x "$SHCONF_FILE" ] ; then
        # We should stop here because the configuration expected in the shconf file will not be loaded.
        eval echo `gettext 'Found $SHCONF_FILE but could not execute it. Please make sure that the file has execute permissions.'`
        exit 1
    fi
    . "$SHCONF_FILE"
fi

if [ -n "$FIXED_COMMAND" ] ; then
    COMMAND="$FIXED_COMMAND"
    FIRST_ARG=$1
else
    COMMAND="$1"
    FIRST_ARG=$2
fi

if [ "X${PASS_THROUGH}" = "Xtrue" -o "X${PASS_THROUGH}" = "Xapp_args" ] ; then
    PASS_THROUGH=app_args
elif [ "X${PASS_THROUGH}" != "Xboth" ] ; then
    PASS_THROUGH=false
fi

# Get the location of the script.
REALDIR=`dirname "$REALPATH"`

if [ "X$IS_SUBSTITUTE_USER" = "X" ] ; then
    # First check if the command is valid for the current user.
    case "$COMMAND" in
        'console' | 'dump' | 'start_msg' | 'stop_msg')
            validateRunUser
            ;;
        'install' | 'installstart' | 'remove')
            mustBeRootOrExit
            ;;
        'start' | 'stop' | 'restart' | 'condrestart')
            setServiceManagementTool
            getServiceControlMethod
            if [ "$CTRL_WITH_DEFAULT" = "true" -o "$CTRL_WITH_SYSTEMD" = "true" ] ; then
                validateRunUser
            else
                mustBeRootOrExit
            fi
            ;;
        'launchdinternal' | 'upstartinternal')
            if [ ! "$DIST_OS" = "macosx" -o ! -f "/Library/LaunchDaemons/${APP_PLIST}" ] ; then
                validateRunUser
            fi
            ;;
        'pause' | 'resume')
            if [ -z "$PAUSABLE" ] ; then
                showUsage "$COMMAND"
            fi
            ;;
        'status')
            ;;
        *)
            showUsage "$COMMAND"
            ;;
    esac
    
    # The user has appropriate rights for the given command, but we still need to verify that it has permission to acccess the real dir.
    #  NOTE: This is not necessary when running as a substitute user because runuser (or su) would have failed if the specified user could not access the real dir.
    result=`cd "${REALDIR}" 2>/dev/null`
    if [ $? -ne 0 ] ; then
        # The command can be run with a normal user, but we don't have sufficient permission to access the real dir.
        resolveCurrentUser
        reportRealDirNotAccessible $CURRENT_USER
        exit 1
    fi
fi

# If the PIDDIR is relative, set its value relative to the full REALPATH to avoid problems if
#  the working directory is later changed.
FIRST_CHAR=`echo $PIDDIR | cut -c1,1`
if [ "$FIRST_CHAR" != "/" ]
then
    PIDDIR=$REALDIR/$PIDDIR
    normalizeDirPath PIDDIR $PIDDIR
fi
# Same test for WRAPPER_CMD
FIRST_CHAR=`echo $WRAPPER_CMD | cut -c1,1`
if [ "$FIRST_CHAR" != "/" ]
then
    WRAPPER_CMD=$REALDIR/$WRAPPER_CMD
fi
# Same test for WRAPPER_CONF
FIRST_CHAR=`echo $WRAPPER_CONF | cut -c1,1`
if [ "$FIRST_CHAR" != "/" ]
then
    WRAPPER_CONF=$REALDIR/$WRAPPER_CONF
fi

# Give default values to $APP_NAME and $APP_LONG_NAME
DELIMITER="@"
if [ "X$APP_NAME" = "X" -o "$APP_NAME" = "${DELIMITER}app.name${DELIMITER}" ] ; then
    APP_NAME=`basename -- "$0"`
fi
if [ "X$APP_LONG_NAME" = "X" -o "$APP_LONG_NAME" = "${DELIMITER}app.long.name${DELIMITER}" ] ; then
    APP_LONG_NAME=$APP_NAME
fi

# Process ID
ANCHORFILE="$PIDDIR/$APP_NAME.anchor"
COMMANDFILE="$PIDDIR/$APP_NAME.command"
STATUSFILE="$PIDDIR/$APP_NAME.status"
JAVASTATUSFILE="$PIDDIR/$APP_NAME.java.status"
PIDFILE="$PIDDIR/$APP_NAME.pid"
LOCKDIR="/var/lock/subsys"
LOCKFILE="$LOCKDIR/$APP_NAME"
pid=""

# Compare Versions $1<$2=0, $1==$2=1, $1>$2=2
compareVersions () {
    if [ "$1" = "$2" ]
    then
        return 1
    else
        local i=1
        while true
        do
            local v1=`echo "$1" | cut -d '.' -f $i`
            local v2=`echo "$2" | cut -d '.' -f $i`
            if [ "X$v1" = "X" ]
            then
                if [ "X$v2" = "X" ]
                then
                    return 1
                fi
                v1="0"
            elif [ "X$v2" = "X" ]
            then
                v2="0"
            fi
            if [ $v1 -lt $v2 ]
            then
                return 0
            elif [ $v1 -gt $v2 ]
            then
                return 2
            fi
            i=`expr $i + 1`
        done
    fi
}

# Resolve the architecture
if [ "$DIST_OS" = "macosx" ]
then
    OS_VER=`sw_vers | grep 'ProductVersion:' | grep -o '[0-9]*\.[0-9]*\.[0-9]*\|[0-9]*\.[0-9]*'`
    DIST_ARCH=`uname -p 2>/dev/null | $TR_BIN "[A-Z]" "[a-z]" | $TR_BIN -d ' '`
    if [ "X${DIST_ARCH}" = "Xarm" ]
    then
        DIST_ARCH="arm"
    else
        DIST_ARCH="universal"
    fi
    compareVersions "$OS_VER" "10.5.0"
    if [ $? -lt 1 ]
    then
        DIST_BITS="32"
        KEY_KEEP_ALIVE="OnDemand"
    else
        # Note: "OnDemand" has been deprecated and replaced from Mac OS X 10.5 by "KeepAlive"
        KEY_KEEP_ALIVE="KeepAlive"
        
        if [ "X`/usr/sbin/sysctl -n hw.cpu64bit_capable`" = "X1" ]  
        then
            DIST_BITS="64"
        else
            DIST_BITS="32"
        fi
    fi
    APP_PLIST_BASE=${PLIST_DOMAIN}.${APP_NAME}
    APP_PLIST=${APP_PLIST_BASE}.plist
elif [ "$DIST_OS" = "zos" ] ; then
    # Z/Os is not supported in the Delta Pack, therefore we only provide a binary
    # file named "wrapper". However this script will still check for a file named
    # "wrapper-zos-390-32" and "wrapper-zos-390-64" in case the user edited the name.
    DIST_ARCH="390"
    DIST_BITS="64"
else
    if [ "$DIST_OS" = "linux" ]
    then
        DIST_ARCH=
    else
        DIST_ARCH=`uname -p 2>/dev/null | $TR_BIN "[A-Z]" "[a-z]" | $TR_BIN -d ' '`
    fi
    if [ "X$DIST_ARCH" = "X" ]
    then
        DIST_ARCH="unknown"
    fi
    if [ "$DIST_ARCH" = "unknown" ]
    then
        DIST_ARCH=`uname -m 2>/dev/null | $TR_BIN "[A-Z]" "[a-z]" | $TR_BIN -d ' '`
    fi
    case "$DIST_ARCH" in
        'athlon' | 'i386' | 'i486' | 'i586' | 'i686')
            DIST_ARCH="x86"
            if [ "${DIST_OS}" = "solaris" ] ; then
                DIST_BITS=`isainfo -b`
            else
                DIST_BITS="32"
            fi
            ;;
        'amd64' | 'x86_64')
            DIST_ARCH="x86"
            DIST_BITS="64"
            ;;
        'ia32')
            DIST_ARCH="ia"
            DIST_BITS="32"
            ;;
        'ia64' | 'ia64n' | 'ia64w')
            DIST_ARCH="ia"
            DIST_BITS="64"
            ;;
        'ip27')
            DIST_ARCH="mips"
            DIST_BITS="32"
            ;;
        'ppc64le')
            DIST_ARCH="ppcle"
            DIST_BITS="64"
            ;;
        'power' | 'powerpc' | 'power_pc' | 'ppc64')
            if [ "${DIST_ARCH}" = "ppc64" ] ; then
                DIST_BITS="64"
            else
                DIST_BITS="32"
            fi
            DIST_ARCH="ppcbe"
            
            if [ "${DIST_OS}" = "aix" ] ; then
                DIST_ARCH="ppc"
                if [ `getconf KERNEL_BITMODE` -eq 64 ]; then
                    DIST_BITS="64"
                else
                    DIST_BITS="32"
                fi
            fi
            ;;
        'pa_risc' | 'pa-risc')
            DIST_ARCH="parisc"
            if [ `getconf KERNEL_BITS` -eq 64 ]; then
                DIST_BITS="64"
            else
                DIST_BITS="32"
            fi    
            ;;
        'sun4u' | 'sparcv9' | 'sparc')
            DIST_ARCH="sparc"
            DIST_BITS=`isainfo -b`
            ;;
        '9000/800' | '9000/785')
            DIST_ARCH="parisc"
            if [ `getconf KERNEL_BITS` -eq 64 ]; then
                DIST_BITS="64"
            else
                DIST_BITS="32"
            fi
            ;;
        s390* )
            DIST_ARCH="390"
            if [ `getconf LONG_BIT` -eq 64 ] ; then
                DIST_BITS="64"
            else
                DIST_BITS="32"
            fi
            ;;
        aarch64* | arm64*)
            # 'aarch64_be', 'aarch64', 'arm64', etc.
            DIST_ARCH="arm"
            DIST_BITS="64"
            ;;
        armv*)
            # 'armv8b', 'armv8l', 'armv7l', 'armv5tel', etc.
            # => armv8 and above should be 64-bit, but it is more reliable to check the bits with getconf.
            if [ `getconf LONG_BIT` -eq 64 ]; then
                DIST_ARCH="arm"
                DIST_BITS="64"
            else
                # Note: The following command returns nothing on SUSE for Raspberry Pi 3 (aarch64).
                #       An alternative command would be 'dpkg --print-architecture', but dpkg may not exist.
                if [ -z "`readelf -A /proc/self/exe | grep Tag_ABI_VFP_args`" ] ; then 
                    DIST_ARCH="armel"
                else 
                    DIST_ARCH="armhf"
                fi
                DIST_BITS="32"
            fi
            ;;
    esac
fi

# OSX always places Java in the same location so we can reliably set JAVA_HOME
if [ "$DIST_OS" = "macosx" ]
then
    if [ -z "$JAVA_HOME" ]; then
        if [ -x /usr/libexec/java_home ]; then
            JAVA_HOME=`/usr/libexec/java_home`; export JAVA_HOME
        else
            JAVA_HOME="/Library/Java/Home"; export JAVA_HOME
        fi
    fi
fi

# Test Echo
ECHOTEST=`echo -n "x"`
if [ "$ECHOTEST" = "x" ]
then
    ECHOOPT="-n "
    ECHOOPTC=""
else
    ECHOOPT=""
    ECHOOPTC="\c"
fi

outputFile() {
    if [ -f "$1" ]
    then
        eval echo `gettext '  $1  Found but not executable.'`;
    else
        echo "  $1"
    fi
}

# Check if the first parameter is an existing executable file.
detectWrapperBinary() {
    if [ -f "$1" ] ; then
        WRAPPER_TEST_CMD="$1"
        if [ ! -x "$WRAPPER_TEST_CMD" ] ; then
            chmod +x "$WRAPPER_TEST_CMD" 2>/dev/null
        fi
        if [ -x "$WRAPPER_TEST_CMD" ] ; then
            WRAPPER_CMD="$WRAPPER_TEST_CMD"
        else
            outputFile "$WRAPPER_TEST_CMD"
            WRAPPER_TEST_CMD=""
        fi
    fi
}

# Decide on the wrapper binary to use.
# If the bits of the OS could be detected, we will try to look for the
#  binary with the correct bits value.  If it doesn't exist, fall back
#  and look for the 32-bit binary.  If that doesn't exist either then
#  look for the default.
WRAPPER_TEST_CMD=""

BIN_BITS=$DIST_BITS
if [ ! "$BIN_BITS" = "32" ] ; then
    # On a 64-bit platform, both Wrapper 32-Bit and 64-Bit can be used.
    #  Send a request to the Wrapper to know if the license has the 64-bit feature.
    WRAPPER_CMD_ORIG=$WRAPPER_CMD
    detectWrapperBinary "$WRAPPER_CMD-$DIST_OS-$DIST_ARCH-$BIN_BITS"
    if [ ! -z "$WRAPPER_TEST_CMD" ] ; then
        if [ "$COMMAND" = "console" -o "$COMMAND" = "start" -o "$COMMAND" = "restart" -o "$COMMAND" = "condrestart" -o "$COMMAND" = "installstart" ] ; then
            "$WRAPPER_CMD" --request_delta_binary_bits "$WRAPPER_CONF" 2>/dev/null
            if [ $? = 32 ] ; then
                # License is 32-Bit. Reset and search for 32-Bit Wrapper binaries.
                WRAPPER_TEST_CMD=""
                WRAPPER_CMD=$WRAPPER_CMD_ORIG
                BIN_BITS=32
            fi
        fi
    fi
fi

if [ -z "$WRAPPER_TEST_CMD" ] ; then
    detectWrapperBinary "$WRAPPER_CMD-$DIST_OS-$DIST_ARCH-32"
fi
if [ -z "$WRAPPER_TEST_CMD" ] ; then
    detectWrapperBinary "$WRAPPER_CMD"
fi
    

if [ -z "$WRAPPER_TEST_CMD" ] ; then
    eval echo `gettext 'Unable to locate any of the following binaries:'`
    outputFile "$WRAPPER_CMD-$DIST_OS-$DIST_ARCH-$BIN_BITS"
    if [ ! "$BIN_BITS" = "32" ] ; then
        outputFile "$WRAPPER_CMD-$DIST_OS-$DIST_ARCH-32"
    fi
    outputFile "$WRAPPER_CMD"

    exit 1
fi


# Build the nice clause
if [ "X$PRIORITY" = "X" ]
then
    CMDNICE=""
else
    CMDNICE="nice -$PRIORITY"
fi

# Build the anchor file clause.
if [ "X$IGNORE_SIGNALS" = "X" ]
then
   ANCHORPROP=
   IGNOREPROP=
else
   ANCHORPROP=wrapper.anchorfile=\"$ANCHORFILE\"
   IGNOREPROP=wrapper.ignore_signals=TRUE
fi

# Build the status file clause.
if [ "X$DETAIL_STATUS$WAIT_FOR_STARTED_STATUS" = "X" ]
then
   STATUSPROP=
else
   STATUSPROP="wrapper.statusfile=\"$STATUSFILE\" wrapper.java.statusfile=\"$JAVASTATUSFILE\""
fi

# Build the command file clause.
if [ -n "$PAUSABLE" ]
then
    if [ "$PAUSABLE_MODE" = "file" ] ; then
        COMMANDPROP="wrapper.commandfile=\"$COMMANDFILE\" wrapper.pausable=TRUE"
    else
        COMMANDPROP="wrapper.signal.mode.usr1=PAUSE wrapper.signal.mode.usr2=RESUME wrapper.pausable=TRUE"
    fi
else
   COMMANDPROP=
fi

if [ ! -n "$WAIT_FOR_STARTED_STATUS" ]
then
    WAIT_FOR_STARTED_STATUS=true
fi

if [ $WAIT_FOR_STARTED_STATUS = true ] ; then
    DETAIL_STATUS=true
fi


# Build the lock file clause.  Only create a lock file if the lock directory exists on this platform.
LOCKPROP=
if [ -d $LOCKDIR ]
then
    if [ -w $LOCKDIR ]
    then
        LOCKPROP=wrapper.lockfile=\"$LOCKFILE\"
    fi
fi

# Build app name clause
if [ ! -n "$APP_NAME_PASS_TO_WRAPPER" ]
then
    APP_NAME_PASS_TO_WRAPPER=true
fi
if [ $APP_NAME_PASS_TO_WRAPPER = false ]
then
   APPNAMEPROP=
else
   APPNAMEPROP="wrapper.name=\"$APP_NAME\" wrapper.displayname=\"$APP_LONG_NAME\""
fi

# Decide on run levels.
RUN_LEVEL_S_DIST_OS_TMP=`eval "echo \$\{RUN_LEVEL_S_${DIST_OS}\}"`
RUN_LEVEL_S_DIST_OS=`eval "echo ${RUN_LEVEL_S_DIST_OS_TMP}"`
if [ "X${RUN_LEVEL_S_DIST_OS}" != "X" ] ; then
    APP_RUN_LEVEL_S=${RUN_LEVEL_S_DIST_OS}
elif [ "X$RUN_LEVEL_S" != "X" ] ; then
    APP_RUN_LEVEL_S=$RUN_LEVEL_S
else
    APP_RUN_LEVEL_S=$RUN_LEVEL
fi
APP_RUN_LEVEL_S_CHECK=`echo "$APP_RUN_LEVEL_S" | sed "s/[(0-9)*]/0/g"`
if [ "X${APP_RUN_LEVEL_S_CHECK}" != "X00" ] ; then
    eval echo `gettext 'Run level \"${APP_RUN_LEVEL_S}\" must be numeric and have a length of two \(00-99\).'`
    exit 1;
fi
RUN_LEVEL_K_DIST_OS_TMP=`eval "echo \$\{RUN_LEVEL_K_${DIST_OS}\}"`
RUN_LEVEL_K_DIST_OS=`eval "echo ${RUN_LEVEL_K_DIST_OS_TMP}"`
if [ "X${RUN_LEVEL_K_DIST_OS}" != "X" ] ; then
    APP_RUN_LEVEL_K=${RUN_LEVEL_K_DIST_OS}
elif [ "X$RUN_LEVEL_K" != "X" ] ; then
    APP_RUN_LEVEL_K=$RUN_LEVEL_K
else
    APP_RUN_LEVEL_K=$RUN_LEVEL
fi
APP_RUN_LEVEL_K_CHECK=`echo "$APP_RUN_LEVEL_K" | sed "s/[(0-9)*]/0/g"`
if [ "X${APP_RUN_LEVEL_K_CHECK}" != "X00" ] ; then
    eval echo `gettext 'Run level \"${APP_RUN_LEVEL_K}\" must be numeric and have a length of two \(00-99\).'`
    exit 1;
fi

prepAdditionalParams() {
    ADDITIONAL_PARA=""
    if [ "X${PASS_THROUGH}" = "Xapp_args" -o "X${PASS_THROUGH}" = "Xboth" ] ; then
        if [ "X${PASS_THROUGH}" = "Xapp_args" ] ; then
            ADDITIONAL_PARA="wrapper.logfile.loglevel=NONE wrapper.console.title='OneDev Upgrade' wrapper.description='OneDev upgrade' -- upgrade"
            ARGS_ARE_APP_PARAMS=true
        fi
        while [ -n "$1" ] ; do
            if [ ! -n "$ARGS_ARE_APP_PARAMS" ] ; then
                if [ "$1" = "--" ] ; then
                    ARGS_ARE_APP_PARAMS=true
                else
                    # Check that the arg matches the pattern of a property
                    case "$1" in
                        wrapper.*=*)
                            # Correct, nothing to do
                            ;;
                        *=*)
                            # The property name is not starting with 'wrapper.' so invalid.
                            COMMAND_PROP=${1%%=*}
                            eval echo `gettext 'WARNING: Encountered an unknown configuration property \"${COMMAND_PROP}\". When PASS_THROUGH is set to \"both\", any argument before \"--\" should target a valid Wrapper configuration property.'`
                            ;;
                        *)
                            # Not a valid assignment.
                            eval echo `gettext 'WARNING: Encountered an invalid configuration property assignment \"$1\". When PASS_THROUGH is set to \"both\", any argument before \"--\" should be in the format \"\<property_name\>=\<value\>\".'`
                            ;;
                    esac
                fi
            fi
            ADDITIONAL_PARA="$ADDITIONAL_PARA \"$1\""
            shift
        done
    fi
}

resolveSysLocale() {
    # First try to get the system encoding from /etc/default/locale.
    # Note: For some reason, the system encoding stored in /etc/default/locale and the value returned by localectl may differ.
    #       When using 'localectl set-local', /etc/default/locale is always updated accordingly, but when manually editing /etc/default/locale,
    #       the output of the command sometimes doesn't get updated. When the values differ, SU uses the same locale as /etc/default/locale,
    #       so that's why we start trying to get the locale using this method.
    if [ -f "/etc/default/locale" ] ; then
        PASS_SYS_LANG=`grep 'LANG=' /etc/default/locale`
        case "$PASS_SYS_LANG" in
            LANG=*)
                PASS_SYS_LANG="$PASS_SYS_LANG "
                ;;
            *)
                PASS_SYS_LANG=""
                ;;
        esac
    fi
    if [ "X$PASS_SYS_LANG" = "X" ] ; then
        # Try to get the system encoding using localectl.
        LOCALECTL_BIN="localectl"
        result=`command -v $LOCALECTL_BIN 2>/dev/null`
        if [ $? -ne 0 ] ; then
            LOCALECTL_BIN="/usr/bin/localectl"
            if [ ! -x "$LOCALECTL_BIN" ] ; then
                # Keep the warning for debugging, but don't actually show it because it may be normal for some OS to not have the command. 
                # echo " WARNING: Could not locate localectl used to get the system locale. The encoding may not be correct when running as $RUN_AS_USER."
                LOCALECTL_BIN=""
            fi
        fi
        if [ "X$LOCALECTL_BIN" != "X" ] ; then
            # The first line that localectl outputs should look like this: '    System Locale: n/a'
            PASS_SYS_LANG=`$LOCALECTL_BIN | grep "System Locale" | awk '{print $3}' 2>/dev/null`
            case "$PASS_SYS_LANG" in
                *n/a*)
                    # No system locale set. Skip.
                    PASS_SYS_LANG=""
                    ;;
                LANG=*)
                    PASS_SYS_LANG="$PASS_SYS_LANG "
                    ;;
                *)
                    # echo " WARNING: Failed to parse the output of localectl. The encoding may not be correct when running as $RUN_AS_USER.'"
                    PASS_SYS_LANG=""
                    ;;
            esac
        fi
    fi
}


checkRunUser() {
    # $1 touchLock flag
    # $2.. [command] args

    # Make sure the configuration is valid.
    validateRunUser

    # Check the configured user.  If necessary rerun this script as the desired user.
    if [ "X$RUN_AS_USER" != "X" ]
    then
        # If LOCKPROP and $RUN_AS_USER are defined then the new user will most likely not be
        # able to create the lock file.  The Wrapper will be able to update this file once it
        # is created but will not be able to delete it on shutdown.  If $1 is set then
        # the lock file should be created for the current command
        if [ "X$LOCKPROP" != "X" ]
        then
            if [ "X$1" != "X" ]
            then
                # Resolve the primary group 
                RUN_AS_GROUP=`groups $RUN_AS_USER | awk '{print $3}' | tail -1`
                if [ "X$RUN_AS_GROUP" = "X" ]
                then
                    RUN_AS_GROUP=$RUN_AS_USER
                fi
                touch $LOCKFILE
                chown $RUN_AS_USER:$RUN_AS_GROUP $LOCKFILE
            fi
        fi

        # Still want to change users, recurse.  This means that the user will only be
        #  prompted for a password once. Variables shifted by 1
        shift

        # Wrap the parameters so they can be passed.
        ADDITIONAL_PARA=""
        while [ -n "$1" ] ; do
            if [ "$1" = 'installstart' ] ; then
                # At this point the service is already installed. When we will fork the process we only need to start the service.
                ADDITIONAL_PARA="$ADDITIONAL_PARA \"start\""
            else
                ADDITIONAL_PARA="$ADDITIONAL_PARA \"$1\""
            fi
            shift
        done

        resolveSysLocale
        RUNUSER_INTERRUPT_TRAPPED=false
        $RUNUSER_BIN - $RUN_AS_USER -c "IS_SUBSTITUTE_USER=true $PASS_SYS_LANG\"$REALPATH\" $ADDITIONAL_PARA" $SU_OPTS
        RUN_AS_USER_EXITCODE=$?
        
        if [ $RUN_AS_USER_EXITCODE -eq 126 ] ; then
            reportRealDirNotAccessible $RUN_AS_USER
        elif [ $RUN_AS_USER_EXITCODE -gt 128 -o "$RUNUSER_INTERRUPT_TRAPPED" = "true" ] ; then
            # The range 128-255 is reserved for signals, but if the user presses CTRL+C (or sends a signal?) two consecutive times, runuser/su will be interrupted and may return 0.
            #  The RUNUSER_INTERRUPT_TRAPPED is set when trapping INT, TERM, QUIT or HUP, but there might be other signals causing interruption.
            #  We use the 2 above conditions to cover most cases.
            
            # Why can this happen: If a signal causing interruption is sent to the process group of the parent script, it will also be caught by the
            #  runuser process which belongs to the same group. The parent script can ignore it but the runuser process will be terminated.
            #  The Wrapper will take some time to exit cleanly or may not even exit depending on the signal, so we should wait for its PID.
            #  NOTES: - it is not possible to use the wait command because the Wrapper is a child of the login shell started by runuser.
            #         - it is possible that Wrapper returned a reserved exit code, but we wouldn't wait below because getpid should return an empty $pid.
            getpid
            if [ "X$pid" != "X" ] ; then
                if [ $RUN_AS_USER_EXITCODE -eq 255 ] ; then
                    # On some system, su returns 255 if it has to kill the command (because it was asked to terminate, and the command did not terminate in time).
                    #  Print a different message to make it clear that runuser/su did not force kill the Wrapper process.
                    eval echo `gettext 'Intermediate login shell was killed. Still waiting for the Wrapper process to stop...'`
                else
                    eval echo `gettext 'Waiting for the Wrapper process to stop...'`
                fi
            fi
            while [ "X$pid" != "X" ] ; do
                sleep 1
                testpid
            done
        elif [ $RUN_AS_USER_EXITCODE -eq 1 ] ; then
            # 1 is a special case as it can either be a generic error before executing the Wrapper, or the Wrapper exit code returned on error.
            checkForkCommand
        fi
        
        # Now that we are the original user again, we may need to clean up the lock file.
        if [ "X$LOCKPROP" != "X" ]
        then
            getpid
            if [ "X$pid" = "X" ]
            then
                # Wrapper is not running so make sure the lock file is deleted.
                if [ -f "$LOCKFILE" ]
                then
                    rm "$LOCKFILE"
                fi
            fi
        fi

        exit $RUN_AS_USER_EXITCODE
    fi
}

# Try to fork by executing a simple command.
# With this function, we want to make sure we are able to fork.
checkForkCommand() {
    $RUNUSER_BIN - $RUN_AS_USER -c "ls \"$REALPATH\"" $SU_OPTS > /dev/null 2>&1 &
    CHECK_EXITCODE=$?
    
    if [ $CHECK_EXITCODE -ne 0 ]
    then
        # clearly a problem with forking
        eval echo `gettext 'Error: unable to create fork process.'`
        eval echo `gettext 'Advice:'`
        eval echo `gettext 'One possible cause of failure is when the user \(\"$RUN_AS_USER\"\) has no shell.'`
        eval echo `gettext 'In this case, two solutions are available by editing the script file:'`
        eval echo `gettext '1. Use \"SU_OPTS\" to set the shell for the user.'`
        eval echo `gettext '2. Use a OS service management tool \(only available on some platforms\).'`
        echo ""
    fi
}

getpid() {
    pid=""
    if [ -f "$PIDFILE" ]
    then
        if [ -r "$PIDFILE" ]
        then
            pid=`cat "$PIDFILE"`
            if [ "X$pid" != "X" ]
            then
                if [ "X$PIDFILE_CHECK_PID" != "X" ]
                then
                    # It is possible that 'a' process with the pid exists but that it is not the
                    #  correct process.  This can happen in a number of cases, but the most
                    #  common is during system startup after an unclean shutdown.
                    # The ps statement below looks for the specific wrapper command running as
                    #  the pid.  If it is not found then the pid file is considered to be stale.
                    case "$DIST_OS" in
                        'freebsd')
                            pidtest=`$PS_BIN -p $pid -o args | tail -1`
                            if [ "X$pidtest" = "XCOMMAND" ]
                            then 
                                pidtest=""
                            fi
                            ;;
                        'macosx')
                            pidtest=`$PS_BIN -ww -p $pid -o command | grep -F "$WRAPPER_CMD" | tail -1`
                            ;;
                        'solaris')
                            if [ -f "/usr/bin/pargs" ]
                            then
                                pidtest=`pargs $pid | fgrep "$WRAPPER_CMD" | tail -1`
                            else
                                case "$PS_BIN" in
                                    '/usr/ucb/ps')
                                        pidtest=`$PS_BIN -auxww $pid | fgrep "$WRAPPER_CMD" | tail -1`
                                        ;;
                                    '/usr/bin/ps')
                                        TRUNCATED_CMD=`$PS_BIN -o comm -p $pid | tail -1`
                                        COUNT=`echo $TRUNCATED_CMD | wc -m`
                                        COUNT=`echo ${COUNT}`
                                        COUNT=`expr $COUNT - 1`
                                        TRUNCATED_CMD=`echo $WRAPPER_CMD | cut -c1-$COUNT`
                                        pidtest=`$PS_BIN -o comm -p $pid | fgrep "$TRUNCATED_CMD" | tail -1`
                                        ;;
                                    '/bin/ps')
                                        TRUNCATED_CMD=`$PS_BIN -o comm -p $pid | tail -1`
                                        COUNT=`echo $TRUNCATED_CMD | wc -m`
                                        COUNT=`echo ${COUNT}`
                                        COUNT=`expr $COUNT - 1`
                                        TRUNCATED_CMD=`echo $WRAPPER_CMD | cut -c1-$COUNT`
                                        pidtest=`$PS_BIN -o comm -p $pid | fgrep "$TRUNCATED_CMD" | tail -1`
                                        ;;
                                    *)
                                        echo "Unsupported ps command $PS_BIN"
                                        exit 1
                                        ;;
                                esac
                            fi
                            ;;
                        'hpux')
                            pidtest=`$PS_BIN -p $pid -x -o args | grep -F "$WRAPPER_CMD" | tail -1`
                            ;;
                        'zos')
                            TRUNCATED_CMD=`$PS_BIN -p $pid -o args | tail -1`
                            COUNT=`echo $TRUNCATED_CMD | wc -m`
                            COUNT=`echo ${COUNT}`
                            COUNT=`expr $COUNT - 1`
                            TRUNCATED_CMD=`echo $WRAPPER_CMD | cut -c1-$COUNT`
                            pidtest=`$PS_BIN -p $pid -o args | grep -F "$TRUNCATED_CMD" | tail -1`
                            ;;
                        'linux')
                            pidtest=`$PS_BIN -ww -p $pid -o args | grep -F "$WRAPPER_CMD" | tail -1`
                            ;;
                        *)
                            pidtest=`$PS_BIN -p $pid -o args | grep -F "$WRAPPER_CMD" | tail -1`
                            ;;
                    esac
                else
                    # Check to see whether the pid exists as a running process, but in this mode, don't check what that pid is.
                    case "$DIST_OS" in
                        'solaris')
                            case "$PS_BIN" in
                                '/usr/ucb/ps')
                                    pidtest=`$PS_BIN $pid | grep "$pid" | awk '{print $1}' | tail -1`
                                    ;;
                                '/usr/bin/ps')
                                    pidtest=`$PS_BIN -p $pid -o pid | grep "$pid" | tail -1`
                                    ;;
                                '/bin/ps')
                                    pidtest=`$PS_BIN -p $pid -o pid | grep "$pid" | tail -1`
                                    ;;
                                *)
                                    echo "Unsupported ps command $PS_BIN"
                                    exit 1
                                    ;;
                            esac
                            ;;
                        *)
                            pidtest=`$PS_BIN -p $pid -o pid | grep "$pid" | tail -1`
                            ;;
                    esac
                fi

                if [ "X$pidtest" = "X" ]
                then
                    # This is a stale pid file.
                    rm -f "$PIDFILE"
                    eval echo `gettext 'Removed stale pid file: $PIDFILE'`
                    pid=""
                fi
            fi
        else
            eval echo `gettext 'Cannot read $PIDFILE.'`
            exit 1
        fi
    fi
}

getstatus() {
    STATUS=
    if [ -f "$STATUSFILE" ]
    then
        if [ -r "$STATUSFILE" ]
        then
            STATUS=`cat "$STATUSFILE"`
        fi
    fi
    if [ "X$STATUS" = "X" ]
    then
        STATUS="Unknown"
    fi
    
    JAVASTATUS=
    if [ -f "$JAVASTATUSFILE" ]
    then
        if [ -r "$JAVASTATUSFILE" ]
        then
            JAVASTATUS=`cat "$JAVASTATUSFILE"`
        fi
    fi
    if [ "X$JAVASTATUS" = "X" ]
    then
        JAVASTATUS="Unknown"
    fi
}

testpid() {
    case "$DIST_OS" in
     'solaris')
        case "$PS_BIN" in
        '/usr/ucb/ps')
            pid=`$PS_BIN  $pid | grep $pid | grep -v grep | awk '{print $1}' | tail -1`
            ;;
        '/usr/bin/ps')
            pid=`$PS_BIN -p $pid | grep $pid | grep -v grep | awk '{print $1}' | tail -1`
            ;;
        '/bin/ps')
            pid=`$PS_BIN -p $pid | grep $pid | grep -v grep | awk '{print $1}' | tail -1`
            ;;
        *)
            echo "Unsupported ps command $PS_BIN"
            exit 1
            ;;
        esac
        ;;
    *)
        pid=`$PS_BIN -p $pid | grep $pid | grep -v grep | awk '{print $1}' | tail -1` 2>/dev/null
        ;;
    esac
    if [ "X$pid" = "X" ]
    then
        pid=""
    fi
}

launchdtrap() {
    stopit
    exit 
}

waitForWrapperStop() {
    getpid
    while [ "X$pid" != "X" ] ; do
        sleep 1
        getpid
    done
}

launchinternal() {
    getpid
    trap launchdtrap TERM 
    if [ "X$pid" = "X" ]
    then 
        # The string passed to eval must handles spaces in paths correctly.
        COMMAND_LINE="$CMDNICE \"$WRAPPER_CMD\" \"$WRAPPER_CONF\" wrapper.syslog.ident=\"$APP_NAME\" wrapper.pidfile=\"$PIDFILE\" wrapper.daemonize=TRUE $APPNAMEPROP $ANCHORPROP $IGNOREPROP $STATUSPROP $COMMANDPROP $LOCKPROP wrapper.script.version=3.5.48 $ADDITIONAL_PARA"
        eval "$COMMAND_LINE"
    else
        eval echo `gettext '$APP_LONG_NAME is already running.'`
        exit 1
    fi
    # launchd expects that this script stay up and running so we need to do our own monitoring of the Wrapper process.
    if [ $WAIT_FOR_STARTED_STATUS = true ]
    then
        waitForWrapperStop
    fi
}

consoleTrapInterrupt() {
    # Set a flag to inform su/runuser that we caught an interrupt signal.
    RUNUSER_INTERRUPT_TRAPPED=true
}

consoleTrap() {
    if [ $2 = 1 ] ; then 
        # Set a flag to inform su/runuser that we caught an interrupt signal (do it as early as possible).
        RUNUSER_INTERRUPT_TRAPPED=true
    fi
    
    getpid
    if [ "X$pid" != "X" ] ; then
        # still alive
        kill -$1 $pid
        if [ $? -ne 0 ] ; then
            # log a message but do not exit
            eval echo `gettext 'Unable to forward $1 signal to $APP_LONG_NAME.'`
        fi
        
        # Nothing else to do. Let the script complete normally after the Wrapper exits.
    fi
}

consoleTrapSignals() {
    if [ "$IS_SUBSTITUTE_USER" != "true" ] ; then
        # Trap the following signals in order to forward them to the Wrapper.
        if [ "X$RUN_AS_USER" != "X" ] ; then
            trap "consoleTrap INT 1" INT
            trap "consoleTrap TERM 1" TERM
        else
            trap "consoleTrap INT 0" INT
            trap "consoleTrap TERM 0" TERM
        fi
        
        # SIGQUIT is usually triggered with the keyboard (CTRL+\). Forward it when running as a user.
        # When running normally, the Wrapper being member of the same process group will also get the signal, so no need to forward it.
        if [ "X$RUN_AS_USER" != "X" ] ; then
            trap "consoleTrap QUIT 1" QUIT
        else
            trap '' QUIT
        fi
        
        # SIGHUP should be caught otherwise it would interrupt the script, but do not forward it.
        if [ "X$RUN_AS_USER" != "X" ] ; then
            # SIGHUP behaves differently than INT/TERM/QUIT and should not interrupt su/runuser when a custom handler is registered.
            #  But this might depend on the shell & platform.  Be safe and set the RUNUSER_INTERRUPT_TRAPPED flag anyway.
            trap 'consoleTrapInterrupt' HUP
        else
            trap '' HUP
        fi
    fi
}

console() {
    eval echo `gettext 'Running $APP_LONG_NAME...'`
    getpid
    if [ "X$pid" = "X" ]
    then
        prepAdditionalParams "$@"

        # The string passed to eval must handles spaces in paths correctly.
        COMMAND_LINE="$CMDNICE \"$WRAPPER_CMD\" \"$WRAPPER_CONF\" wrapper.syslog.ident=\"$APP_NAME\" wrapper.pidfile=\"$PIDFILE\" $APPNAMEPROP $ANCHORPROP $STATUSPROP $COMMANDPROP $LOCKPROP wrapper.script.version=3.5.48 $ADDITIONAL_PARA"
        eval "$COMMAND_LINE"
        COMMAND_EXIT_CODE=$?
        if [ $COMMAND_EXIT_CODE -ne 0 ] ; then
            exit $COMMAND_EXIT_CODE
        fi
    else
        eval echo `gettext '$APP_LONG_NAME is already running.'`
        exit 1
    fi
}

waitforjavastartup() {
    getstatus
    eval echo $ECHOOPT `gettext 'Waiting for $APP_LONG_NAME...$ECHOOPTC'` 
    
    # Wait until the timeout or we have something besides Unknown.
    counter=15
    while [ "$JAVASTATUS" = "Unknown" -a $counter -gt 0 -a -n "$JAVASTATUS" ] ; do
        echo $ECHOOPT".$ECHOOPTC"
        sleep 1
        getstatus
        counter=`expr $counter - 1`
    done
    
    if [ -n "$WAIT_FOR_STARTED_TIMEOUT" ] ; then 
        counter=$WAIT_FOR_STARTED_TIMEOUT
    else
        counter=120
    fi
    while [ "$JAVASTATUS" != "STARTED" -a "$JAVASTATUS" != "Unknown" -a $counter -gt 0 -a -n "$JAVASTATUS" ] ; do
        echo $ECHOOPT".$ECHOOPTC"
        sleep 1
        getstatus
        counter=`expr $counter - 1`
    done
    echo ""
}

##
# Request the path to the log file to the Wrapper and print it
#
# $1 prefix
printlogfilepath() {
    LOG_FILE1=`"$WRAPPER_CMD" --request_log_file "$WRAPPER_CONF" 2>/dev/null`
    if [ $? = 0 -a "X$LOG_FILE1" != "X" ] ; then
        # try to see if a default log file exists
        LOG_FILE2=`"$WRAPPER_CMD" --request_default_log_file "$WRAPPER_CONF" 2>/dev/null`
        if [ $? != 0 -o ! -f "$LOG_FILE2" ] ; then
            LOG_FILE2=""
        fi
    else
        # try to see if a default log file exists
        LOG_FILE1=`"$WRAPPER_CMD" --request_default_log_file "$WRAPPER_CONF" 2>/dev/null`
        if [ $? != 0 -o ! -f "$LOG_FILE1" ] ; then
            LOG_FILE1=""
        fi
    fi
    if [ "X$LOG_FILE2" != "X" ] ; then
        LOG_FILE_MSG=`gettext 'The log files \"${LOG_FILE1}\" and \"${LOG_FILE2}\" may contain further information.'`
    elif [ "X$LOG_FILE1" != "X" ] ; then
        LOG_FILE_MSG=`gettext 'The log file \"${LOG_FILE1}\" may contain further information.'`
    else
        LOG_FILE_MSG=`gettext 'The syslog may contain further information.'`
    fi
    LOG_FILE_MSG=`eval echo "${LOG_FILE_MSG}"`                  # expand ${LOG_FILE}
    echo "$1${LOG_FILE_MSG}"                                    # print with indentation
}

startwait() {
    if [ $WAIT_FOR_STARTED_STATUS = true ]
    then
        waitforjavastartup
    fi
    # Sleep for a few seconds to allow for intialization if required 
    #  then test to make sure we're still running.
    #
    i=0
    while [ $i -lt $WAIT_AFTER_STARTUP ]
    do
        sleep 1
        echo $ECHOOPT".$ECHOOPTC"
        i=`expr $i + 1`
    done
    if [ $WAIT_AFTER_STARTUP -gt 0 -o $WAIT_FOR_STARTED_STATUS = true ]
    then
        getpid
        if [ "X$pid" = "X" ]
        then
            eval echo `gettext 'WARNING: $APP_LONG_NAME may have failed to start.'`
            printlogfilepath "         "
            exit 1
        else
            eval echo `gettext ' running: PID:$pid'`
        fi
    else 
        echo ""
    fi
}

mustBeStoppedOrExit() {
    getpid
    if [ "X$pid" != "X" ] ; then
        eval echo `gettext '$APP_LONG_NAME is already running.'`
        exit 1
    fi
}

# Detect if the Wrapper is running
# Returns 0 if the process is running, otherwise returns 1.
checkRunning() {
    getpid
    if [ "X$pid" = "X" ] ; then
        eval echo `gettext '$APP_LONG_NAME is not running.'`
        if [ "X$1" = "X1" ] ; then
            exit 1
        fi
        return 1
    fi
    return 0
}


macosxStart() {
    mustBeRootOrExit
    mustBeStoppedOrExit
    
    eval echo `gettext 'Starting $APP_LONG_NAME with launchd...'`
    
    # If the daemon was just installed, it may not be loaded.
    LOADED_PLIST=`launchctl list | grep ${APP_PLIST_BASE}`
    if [ "X${LOADED_PLIST}" = "X" ] ; then
        launchctl load /Library/LaunchDaemons/${APP_PLIST}
    fi
    # If launchd is set to run the daemon already at Load, we don't need to call start
    getpid
    if [ "X$pid" = "X" ] ; then
        launchctl start ${APP_PLIST_BASE}
    fi
    
    startwait
}

macosxStop() {
    mustBeRootOrExit
    # The daemon must be running.
    checkRunning "1"
    
    eval echo `gettext 'Stopping $APP_LONG_NAME...'`
    
    if [ "$MACOSX_KEEP_RUNNING" = "true" ] ; then
        echo ""
        eval echo `gettext 'Daemon is set to be kept continuously running and it will be automatically restarted.'`
        eval echo `gettext 'To stop the daemon you need to uninstall it.'`
        eval echo `gettext 'If you want to use the \"stop\" argument, you need to find MACOSX_KEEP_RUNNING'`
        eval echo `gettext 'at the beginning of the script file and set it to \"false\".'`
        echo ""
    fi
    launchctl stop ${APP_PLIST_BASE}
}

macosxRestart() {
    mustBeRootOrExit
    checkRunning $1

    eval echo `gettext 'Restarting $APP_LONG_NAME...'`

    if [ "$MACOSX_KEEP_RUNNING" = "true" ] ; then
        # by stopping it, launchd will automatically restart it
        launchctl stop ${APP_PLIST_BASE}
    else
        launchctl unload "/Library/LaunchDaemons/${APP_PLIST}"
        sleep 1
        launchctl load   "/Library/LaunchDaemons/${APP_PLIST}"
    fi
    
    startwait
}

upstartInstall() {
    # Always verify that upstart exists.
    upstartDetection
    if [ $? -ne 0 ] ; then
        eval echo `gettext 'Unable to install the $APP_LONG_NAME daemon because upstart does not exist.'`
        return 1
    fi
    
    eval echo `gettext ' Installing the $APP_LONG_NAME daemon with upstart...'`
    if [ -f "${REALDIR}/${APP_NAME}.install" ] ; then 
        eval echo `gettext ' Custom upstart conf file ${APP_NAME}.install found.'`
        cp "${REALDIR}/${APP_NAME}.install" "/etc/init/${APP_NAME}.conf"
    else
        eval echo `gettext ' Creating default upstart conf file...'`
        echo "# ${APP_NAME} - ${APP_LONG_NAME}"                           > "/etc/init/${APP_NAME}.conf"
        echo "description \"${APP_LONG_NAME}\""                          >> "/etc/init/${APP_NAME}.conf"
        echo "author \"Tanuki Software Ltd. <info@tanukisoftware.com>\"" >> "/etc/init/${APP_NAME}.conf"
        echo "start on runlevel [2345]"                                  >> "/etc/init/${APP_NAME}.conf"
        echo "stop on runlevel [!2345]"                                  >> "/etc/init/${APP_NAME}.conf"
        echo "env LANG=${LANG}"                                          >> "/etc/init/${APP_NAME}.conf"
        echo "exec \"${REALPATH}\" upstartinternal"                      >> "/etc/init/${APP_NAME}.conf"
    fi
}

upstartStart() {
    mustBeRootOrExit
    mustBeStoppedOrExit

    eval echo `gettext 'Starting $APP_LONG_NAME with upstart...'`
    
    /sbin/start ${APP_NAME}
        
    startwait
}

upstartStop() {
    mustBeRootOrExit
    # The daemon must be running.
    checkRunning "1"

    eval echo `gettext 'Stopping $APP_LONG_NAME...'`
    
    /sbin/stop ${APP_NAME}
}

upstartRestart() {
    mustBeRootOrExit
    checkRunning $1

    if [ "X$pid" = "X" ] ; then
        # Don't use /sbin/restart because it requires the daemon to be running.
        #  We want to match with other systems behaviour which is to restart the
        #  daemon even if it was not running.
        upstartStart
    else
        # The daemon was running
        eval echo `gettext 'Restarting $APP_LONG_NAME...'`

        /sbin/restart ${APP_NAME}
        
        startwait
    fi
}

upstartRemove() {
    stopit "0"
    eval echo `gettext ' Removing the $APP_LONG_NAME daemon from upstart...'`
    rm "/etc/init/${APP_NAME}.conf"
}

systemdInstall() {
    # Always verify that systemd exists.
    systemdDetection
    if [ $? -ne 0 ] ; then
      eval echo `gettext 'Unable to install the $APP_LONG_NAME daemon because systemd does not exist.'`
      return 1
    fi
    
    eval echo `gettext ' Installing the $APP_LONG_NAME daemon with systemd...'`
    if [ -f "${REALDIR}/${APP_NAME}.service" ] ; then 
        eval echo `gettext ' Custom service file ${APP_NAME}.service found.'`
        cp "${REALDIR}/${APP_NAME}.service" "${SYSTEMD_SERVICE_FILE}"
    else
        eval echo `gettext ' Creating default service file...'`
        echo "[Unit]"                            > "${SYSTEMD_SERVICE_FILE}"
        echo "Description=${APP_LONG_NAME}"     >> "${SYSTEMD_SERVICE_FILE}"
        echo "After=syslog.target"              >> "${SYSTEMD_SERVICE_FILE}"
        echo ""                                 >> "${SYSTEMD_SERVICE_FILE}"
        echo "[Service]"                        >> "${SYSTEMD_SERVICE_FILE}"
        echo "Type=forking"                     >> "${SYSTEMD_SERVICE_FILE}"
        case "${REALPATH}" in
            *\ *)
                # REALPATH contains spaces
                LINE_HEAD='ExecStart=/usr/bin/env "'
                LINE_TAIL='" start sysd'
                echo "${LINE_HEAD}${REALPATH}${LINE_TAIL}" >> "${SYSTEMD_SERVICE_FILE}"
                LINE_HEAD='ExecStop=/usr/bin/env "'
                LINE_TAIL='" stop sysd'
                echo "${LINE_HEAD}${REALPATH}${LINE_TAIL}" >> "${SYSTEMD_SERVICE_FILE}"
                ;;
            *)
                echo "ExecStart=${REALPATH} start sysd" >> "${SYSTEMD_SERVICE_FILE}"
                echo "ExecStop=${REALPATH} stop sysd"   >> "${SYSTEMD_SERVICE_FILE}"
                ;;
        esac
        if [ "X${RUN_AS_USER}" != "X" ] ; then
          echo "User=${RUN_AS_USER}"            >> "${SYSTEMD_SERVICE_FILE}"
        fi
        if [ "X${SYSTEMD_KILLMODE}" != "X" ] ; then
          echo "KillMode=${SYSTEMD_KILLMODE}"   >> "${SYSTEMD_SERVICE_FILE}"
        fi
        if [ $SYSTEMD_KILLMODE != "process" -a $SYSTEMD_KILLMODE != "none" ] ; then
          # Set an environment variable to show a warning if a detached process is launched by the WrapperManager.
          echo "Environment=SYSTEMD_KILLMODE_WARNING=true" >> "${SYSTEMD_SERVICE_FILE}"
        fi
        echo ""                                 >> "${SYSTEMD_SERVICE_FILE}"
        echo "[Install]"                        >> "${SYSTEMD_SERVICE_FILE}"
        echo "WantedBy=multi-user.target"       >> "${SYSTEMD_SERVICE_FILE}"
    fi
    systemctl daemon-reload
    systemctl enable "${APP_NAME}"
}

systemdStart() {
    # Don't do mustBeRootOrExit because systemd will ask for the password when not root
    mustBeStoppedOrExit
    
    result=`systemctl -p KillMode show $APP_NAME`
    if [ $result != "KillMode=$SYSTEMD_KILLMODE" ] ; then
        eval echo `gettext 'SYSTEMD_KILLMODE is set to \"${SYSTEMD_KILLMODE}\" on the top of the script, but the daemon is running with $result.'`
        eval echo `gettext 'The daemon must be reinstalled for the value of SYSTEMD_KILLMODE to take effect.'`
        exit 1
    fi
    
    eval echo `gettext 'Starting $APP_LONG_NAME with systemd...'`

    systemctl start $APP_NAME
    if [ $? -ne 0 ] ; then
        eval echo `gettext 'Failed to start $APP_LONG_NAME.'`
        printlogfilepath
        exit 1
    fi
    
    startwait
}

systemdStop() {
    # Don't do mustBeRootOrExit because systemd will ask for the password when not root
    # The daemon must be running.
    checkRunning "1"

    eval echo `gettext 'Stopping $APP_LONG_NAME...'`

    systemctl stop $APP_NAME
    if [ $? -ne 0 ] ; then
        eval echo `gettext 'Failed to stop $APP_LONG_NAME.'`
        exit 1
    fi
}

systemdRestart() {
    # Don't do mustBeRootOrExit because systemd will ask for the password when not root
    checkRunning $1

    eval echo `gettext 'Restarting $APP_LONG_NAME...'`

    systemctl restart $APP_NAME
    if [ $? -ne 0 ] ; then
        eval echo `gettext 'Failed to restart service $APP_NAME'`
        printlogfilepath
        exit 1
    fi
    
    startwait
}

systemdRemove() {
    stopit "0"
    eval echo `gettext ' Removing the $APP_LONG_NAME daemon from systemd...'`
    systemctl disable $APP_NAME
    rm "/etc/systemd/system/${APP_NAME}.service"
    systemctl daemon-reload
}

srcInstall() {
    # Always verify that SRC exists.
    srcDetection
    if [ $? -ne 0 ] ; then
      eval echo `gettext 'Unable to install the $APP_LONG_NAME daemon because SRC does not exist.'`
      return 1
    fi
    
    if [ "X$RUN_AS_USER" = "X" ] ; then
        USERID="0"
    else
        resolveIdLocation
        USERID=`$ID_BIN -u "$RUN_AS_USER"`
        if [ $? -ne 0 ] ; then 
            eval echo `gettext 'Failed to get user id for $RUN_AS_USER'`
            exit 1
        fi
    fi
    
    validateAppNameLength
    /usr/bin/mkssys -s "$APP_NAME" -p "$REALPATH" -a "launchdinternal" -u "$USERID" -f 9 -n 15 -S
    /usr/sbin/mkitab "$APP_NAME":2:once:"/usr/bin/startsrc -s \"${APP_NAME}\" >/dev/console 2>&1"
}

srcStart() {
    mustBeRootOrExit
    mustBeStoppedOrExit

    eval echo `gettext 'Starting $APP_LONG_NAME with SRC...'`

    startsrc -s "${APP_NAME}"
    if [ $? -ne 0 ] ; then
        eval echo `gettext 'Failed to start $APP_LONG_NAME.'`
        printlogfilepath
        exit 1
    fi
    
    startwait
}

srcStop() {
    mustBeRootOrExit
    # The daemon must be running.
    checkRunning "1"

    eval echo `gettext 'Stopping $APP_LONG_NAME...'`

    stopsrc -s "${APP_NAME}"
    if [ $? -ne 0 ] ; then
        eval echo `gettext 'Failed to stop $APP_LONG_NAME.'`
        exit 1
    fi
}

srcRestart() {
    mustBeRootOrExit
    checkRunning $1

    if [ "X$pid" != "X" ] ; then
        # The daemon was running. Stop it first.
        eval echo `gettext 'Restarting $APP_LONG_NAME...'`
        srcStop
        waitForWrapperStop
    fi
    srcStart
}

start() {
    mustBeStoppedOrExit
    
    eval echo `gettext 'Starting $APP_LONG_NAME...'`
    
    prepAdditionalParams "$@"

    # The string passed to eval must handles spaces in paths correctly.
    COMMAND_LINE="$CMDNICE \"$WRAPPER_CMD\" \"$WRAPPER_CONF\" wrapper.syslog.ident=\"$APP_NAME\" wrapper.pidfile=\"$PIDFILE\" wrapper.daemonize=TRUE $APPNAMEPROP $ANCHORPROP $IGNOREPROP $STATUSPROP $COMMANDPROP $LOCKPROP wrapper.script.version=3.5.48 $ADDITIONAL_PARA"
    eval "$COMMAND_LINE"
    
    startwait
}
 
stopit() {
    # $1 exit if down flag
    checkRunning $1
    if [ $? -eq 0 ] ; then
        # The daemon should be running.
        eval echo `gettext 'Stopping $APP_LONG_NAME...'`

        if [ "X$IGNORE_SIGNALS" = "X" ]
        then
            # Running so try to stop it.
            kill $pid
            if [ $? -ne 0 ]
            then
                # An explanation for the failure should have been given
                eval echo `gettext 'Unable to stop $APP_LONG_NAME.'`
                exit 1
            fi
        else
            rm -f "$ANCHORFILE"
            if [ -f "$ANCHORFILE" ]
            then
                # An explanation for the failure should have been given
                eval echo `gettext 'Unable to stop $APP_LONG_NAME.'`
                exit 1
            fi
        fi

        # We can not predict how long it will take for the wrapper to
        #  actually stop as it depends on settings in wrapper.conf.
        #  Loop until it does.
        savepid=$pid
        CNT=0
        TOTCNT=0
        while [ "X$pid" != "X" ]
        do
            # Show a waiting message every 5 seconds.
            if [ "$CNT" -lt "5" ]
            then
                CNT=`expr $CNT + 1`
            else
                eval echo `gettext 'Waiting for $APP_LONG_NAME to exit...'`
                CNT=0
            fi
            TOTCNT=`expr $TOTCNT + 1`

            sleep 1

            # Check if the process is still running.
            testpid
            
            if [ "X$pid" = "X" ]
                then
                # The process is gone, but it is possible that another instance restarted while we waited...
                SAVE_PIDFILE_CHECK_PID=$PIDFILE_CHECK_PID
                PIDFILE_CHECK_PID=""
                getpid
                PIDFILE_CHECK_PID=$SAVE_PIDFILE_CHECK_PID
                
                if [ "X$pid" != "X" ]
                then
                    # Another process is running.
                    if [ "$pid" = "$savepid" ]
                    then
                        # This should never happen, unless the PID was recycled?
                        eval echo `gettext 'Failed to stop $APP_LONG_NAME.'`
                        exit 1
                    else
                        eval echo `gettext 'The content of $PIDFILE has changed.'`
                        eval echo `gettext 'Another instance of the Wrapper might have started in the meantime.'`
                        
                        # Exit now. Any further actions might compromise the running instance.
                        exit 1
                    fi
                fi
            fi
        done

        eval echo `gettext 'Stopped $APP_LONG_NAME.'`
    fi
}
 
pause() {
    getpid
    if [ "X$pid" = "X" ] ; then
        # The application is not running, print the status
        status
    else
        if [ "$PAUSABLE_MODE" = "file" ] ; then
            echo "PAUSE" >> $COMMANDFILE
            if [ $? != 0 ] ; then
                eval echo `gettext 'Failed to write in the command file to pause $APP_LONG_NAME.'`
                exit 1
            fi
        else
            # send a SIGUSR1 (use constants because numbers change depending on the platform)
            kill -USR1 $pid 2>/dev/null
            if [ $? != 0 ] ; then
                kill -SIGUSR1 $pid
                if [ $? != 0 ] ; then
                    eval echo `gettext 'Failed to send a signal to pause $APP_LONG_NAME.'`
                    exit 1
                fi
            fi
        fi
        eval echo `gettext 'Pausing $APP_LONG_NAME.'`
    fi
}

resume() {
    getpid
    if [ "X$pid" = "X" ] ; then
        # The application is not running, print the status
        status
    else
        if [ "$PAUSABLE_MODE" = "file" ] ; then
            echo "RESUME" >> $COMMANDFILE
            if [ $? != 0 ] ; then
                eval echo `gettext 'Failed to write in the command file to resume $APP_LONG_NAME.'`
                exit 1
            fi
        else
            # send a SIGUSR2 (use constants because numbers change depending on the platform)
            kill -USR2 $pid 2>/dev/null
            if [ $? != 0 ] ; then
                kill -SIGUSR2 $pid
                if [ $? != 0 ] ; then
                    eval echo `gettext 'Failed to send a signal to resume $APP_LONG_NAME.'`
                    exit 1
                fi
            fi
        fi
        eval echo `gettext 'Resuming $APP_LONG_NAME.'`
    fi
}

# Get the status of SELinux and sets SELINUX_STATUS
#   0: Not present or unkown
#   1: Disabled
#   2: Permissive (unauthorized access attempts aren't denied but logs are written)
#   3: Enforcing
getSELinuxStatus() {
    result=`getenforce 2>/dev/null`
    if [ $? -ne 0 ] ; then
        # Not present
        SELINUX_STATUS=0
    else
        case "$result" in
            'Disabled')
                SELINUX_STATUS=1
                ;;
            'Permissive')
                SELINUX_STATUS=2
                ;;
            'Enforcing')
                SELINUX_STATUS=3
                ;;
            *)
                SELINUX_STATUS=0
                ;;
        esac
    fi
}

status() {
    checkInstalled
    getpid
    if [ "X$pid" = "X" ]
    then
        if [ $installedStatus -eq $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext '$APP_LONG_NAME \(not installed\) is not running.'`
        elif [ "X$installedWith" = "X" ] ; then
            eval echo `gettext '$APP_LONG_NAME \(installed\) is not running.'`
        else
            eval echo `gettext '$APP_LONG_NAME \(installed with $installedWith\) is not running.'`
        fi
        exit 1
    else
        if [ "X$DETAIL_STATUS" = "X" ]
        then
            if [ $installedStatus -eq $SERVICE_NOT_INSTALLED ] ; then
                eval echo `gettext '$APP_LONG_NAME \(not installed\) is running: PID:$pid'`
            elif [ "X$installedWith" = "X" ] ; then
                eval echo `gettext '$APP_LONG_NAME \(installed\) is running: PID:$pid'`
            else
                eval echo `gettext '$APP_LONG_NAME \(installed with $installedWith\) is running: PID:$pid'`
            fi
        else
            getstatus
            if [ $installedStatus -eq $SERVICE_NOT_INSTALLED ] ; then
                eval echo `gettext '$APP_LONG_NAME \(not installed\) is running: PID:$pid, Wrapper:$STATUS, Java:$JAVASTATUS'`
            elif [ "X$installedWith" = "X" ] ; then
                eval echo `gettext '$APP_LONG_NAME \(installed\) is running: PID:$pid, Wrapper:$STATUS, Java:$JAVASTATUS'`
            else
                eval echo `gettext '$APP_LONG_NAME \(installed with $installedWith\) is running: PID:$pid, Wrapper:$STATUS, Java:$JAVASTATUS'`
            fi
        fi
        exit 0
    fi
}

resolveInitdCommand() {
    # NOTE: update-rc.d & chkconfig are the recommended interfaces for managing
    #       init scripts. insserv is a low level tool used by these interfaces.
    #       chkconfig was available on old versions Ubuntu, but update-rc.d is
    #       preferred. chkconfig is used on RHEL based Linux.

    # update-rc.d is used on distros such as Debian/Ubuntu
    resolveLocation INITD_COMMAND "update-rc.d" ";/usr/sbin" 0
    if [ $? -eq 0 ] ; then
        USE_UPDATE_RC=1
    else
        # chkconfig is used on distros such as RHEL or Amazon Linux
        resolveLocation INITD_COMMAND chkconfig ";/sbin" 0
        if [ $? -eq 0 ] ; then
            USE_CHKCONFIG=1
        else
            # if neither chkconfig nor update-rc.d are present, try insserv 
            resolveLocation INITD_COMMAND insserv ";/sbin" 0
            if [ $? -eq 0 ] ; then
                USE_INSSERV=1
            else
                INITD_COMMAND=""
            fi
        fi
    fi
}

installdaemon() {
    mustBeRootOrExit
    
    checkInstalled
    APP_NAME_LOWER=`echo "$APP_NAME" | $TR_BIN "[A-Z]" "[a-z]"`
    if [ "$DIST_OS" = "solaris" ] ; then
        eval echo `gettext 'Detected Solaris:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is already installed.'`
        else
            eval echo `gettext ' Installing the $APP_LONG_NAME daemon...'`
            ln -s "$REALPATH" "/etc/init.d/$APP_NAME"
            for i in `ls "/etc/rc3.d/K"??"$APP_NAME_LOWER" "/etc/rc3.d/S"??"$APP_NAME_LOWER" 2>/dev/null` ; do
                eval echo `gettext ' Removing unexpected file before proceeding: $i'`
                rm -f $i
            done
            ln -s "/etc/init.d/$APP_NAME" "/etc/rc3.d/K${APP_RUN_LEVEL_K}$APP_NAME_LOWER"
            ln -s "/etc/init.d/$APP_NAME" "/etc/rc3.d/S${APP_RUN_LEVEL_S}$APP_NAME_LOWER"
        fi
    elif [ "$DIST_OS" = "linux" ] ; then
        eval echo `gettext 'Detected Linux:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is already installed with $installedWith.'`
        elif [ -n "$USE_SYSTEMD" ] ; then
            systemdInstall

            # If SELinux is present and enabled, then the context of the script needs to be updated for systemd to be allowed to execute it.
            getSELinuxStatus
            if [ $SELINUX_STATUS -ge 2 ] ; then
                # Use chcon rather than semanage because it is present on more installations and also allows us to restore the default context more easily.
                result=`chcon -t bin_t $REALPATH 2>/dev/null`
                if [ $? -ne 0 ] ; then
                    # Print a warning, but the user can still configure SELinux manually.
                    SCRIPT_BASENAME=`basename "$REALDIR"`
                    eval echo `gettext ' WARNING: Could not update the SELinux context of $SCRIPT_BASENAME.'`
                fi
            fi
        elif [ -n "$USE_UPSTART" ] ; then
            upstartInstall
        else
            resolveInitdCommand
            if [ -n "$USE_CHKCONFIG" ] ; then
                eval echo `gettext ' Installing the $APP_LONG_NAME daemon with init.d \($INITD_COMMAND\)...'`
                ln -s "$REALPATH" "/etc/init.d/$APP_NAME"
                $INITD_COMMAND --add "$APP_NAME"
                $INITD_COMMAND "$APP_NAME" on
            elif [ "$USE_INSSERV" ] ; then
                eval echo `gettext ' Installing the $APP_LONG_NAME daemon with init.d \($INITD_COMMAND\)...'`
                ln -s "$REALPATH" "/etc/init.d/$APP_NAME"
                $INITD_COMMAND "/etc/init.d/$APP_NAME"
            elif [ "$USE_UPDATE_RC" ] ; then
                eval echo `gettext ' Installing the $APP_LONG_NAME daemon with init.d \($INITD_COMMAND\)...'`
                ln -s "$REALPATH" "/etc/init.d/$APP_NAME"
                $INITD_COMMAND "$APP_NAME" defaults
            else
                eval echo `gettext ' Installing the $APP_LONG_NAME daemon with init.d...'`
                ln -s "$REALPATH" /etc/init.d/$APP_NAME
                for i in `ls "/etc/rc3.d/K"??"$APP_NAME_LOWER" "/etc/rc5.d/K"??"$APP_NAME_LOWER" "/etc/rc3.d/S"??"$APP_NAME_LOWER" "/etc/rc5.d/S"??"$APP_NAME_LOWER" 2>/dev/null` ; do
                    eval echo `gettext ' Removing unexpected file before proceeding: $i'`
                    rm -f $i
                done
                ln -s "/etc/init.d/$APP_NAME" "/etc/rc3.d/K${APP_RUN_LEVEL_K}$APP_NAME_LOWER"
                ln -s "/etc/init.d/$APP_NAME" "/etc/rc3.d/S${APP_RUN_LEVEL_S}$APP_NAME_LOWER"
                ln -s "/etc/init.d/$APP_NAME" "/etc/rc5.d/S${APP_RUN_LEVEL_S}$APP_NAME_LOWER"
                ln -s "/etc/init.d/$APP_NAME" "/etc/rc5.d/K${APP_RUN_LEVEL_K}$APP_NAME_LOWER"
            fi
        fi
    elif [ "$DIST_OS" = "hpux" ] ; then
        eval echo `gettext 'Detected HP-UX:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is already installed.'`
        else
            eval echo `gettext ' Installing the $APP_LONG_NAME daemon...'`
            ln -s "$REALPATH" "/sbin/init.d/$APP_NAME"
            for i in `ls "/sbin/rc3.d/K"??"$APP_NAME_LOWER" "/sbin/rc3.d/S"??"$APP_NAME_LOWER" 2>/dev/null` ; do
                eval echo `gettext ' Removing unexpected file before proceeding: $i'`
                rm -f $i
            done
            ln -s "/sbin/init.d/$APP_NAME" "/sbin/rc3.d/K${APP_RUN_LEVEL_K}$APP_NAME_LOWER"
            ln -s "/sbin/init.d/$APP_NAME" "/sbin/rc3.d/S${APP_RUN_LEVEL_S}$APP_NAME_LOWER"
        fi
    elif [ "$DIST_OS" = "aix" ] ; then
        eval echo `gettext 'Detected AIX:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED -a $installedStatus -ne $SERVICE_INSTALLED_SRC_PARTIAL ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is already installed with $installedWith.'`
        else
            eval echo `gettext ' Installing the $APP_LONG_NAME daemon...'`
            if [ -n "`/usr/sbin/lsitab install_assist`" ] ; then 
                eval echo `gettext ' The task /usr/sbin/install_assist was found in the inittab, this might cause problems for all subsequent tasks to launch as this process is known to block the init task. Please make sure this task is not needed anymore and remove/deactivate it.'`
            fi
            
            for i in `ls "/etc/rc.d/rc2.d/K"??"$APP_NAME_LOWER" "/etc/rc.d/rc2.d/S"??"$APP_NAME_LOWER" 2>/dev/null` ; do
                eval echo `gettext ' Removing unexpected file before proceeding: $i'`
                rm -f $i
            done
            
            if [ -n "$USE_SRC" ] ; then
                srcInstall
            else
                # install using initd
                ln -s "$REALPATH" "/etc/rc.d/init.d/$APP_NAME"
                ln -s "/etc/rc.d/init.d/$APP_NAME" "/etc/rc.d/rc2.d/K${APP_RUN_LEVEL_K}$APP_NAME_LOWER"
                ln -s "/etc/rc.d/init.d/$APP_NAME" "/etc/rc.d/rc2.d/S${APP_RUN_LEVEL_S}$APP_NAME_LOWER"
            fi
        fi
    elif [ "$DIST_OS" = "freebsd" ] ; then
        eval echo `gettext 'Detected FreeBSD:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is already installed.'`
        else
            eval echo `gettext ' Installing the $APP_LONG_NAME daemon...'`
            sed -i.bak "/${APP_NAME}_enable=\"YES\"/d" /etc/rc.conf
            if [ -f "${REALDIR}/${APP_NAME}.install" ] ; then
                ln -s "${REALDIR}/${APP_NAME}.install" "/etc/rc.d/$APP_NAME"
            else
                echo '#!/bin/sh'                    > "/etc/rc.d/$APP_NAME"
                echo "#"                           >> "/etc/rc.d/$APP_NAME"
                echo "# PROVIDE: $APP_NAME"        >> "/etc/rc.d/$APP_NAME"
                echo "# REQUIRE: NETWORKING"       >> "/etc/rc.d/$APP_NAME"
                echo "# KEYWORD: shutdown"         >> "/etc/rc.d/$APP_NAME"
                echo ". /etc/rc.subr"              >> "/etc/rc.d/$APP_NAME"
                echo "name=\"$APP_NAME\""          >> "/etc/rc.d/$APP_NAME"
                echo "rcvar=\`set_rcvar\`"         >> "/etc/rc.d/$APP_NAME"
                echo "command=\"${REALPATH}\""     >> "/etc/rc.d/$APP_NAME"
                echo 'start_cmd="${name}_start"'   >> "/etc/rc.d/$APP_NAME"
                echo 'load_rc_config $name'        >> "/etc/rc.d/$APP_NAME"
                echo 'status_cmd="${name}_status"' >> "/etc/rc.d/$APP_NAME"
                echo 'stop_cmd="${name}_stop"'     >> "/etc/rc.d/$APP_NAME"
                echo "${APP_NAME}_status() {"      >> "/etc/rc.d/$APP_NAME"
                echo '${command} status'           >> "/etc/rc.d/$APP_NAME"
                echo '}'                           >> "/etc/rc.d/$APP_NAME"
                echo "${APP_NAME}_stop() {"        >> "/etc/rc.d/$APP_NAME"
                echo '${command} stop'             >> "/etc/rc.d/$APP_NAME"
                echo '}'                           >> "/etc/rc.d/$APP_NAME"
                echo "${APP_NAME}_start() {"       >> "/etc/rc.d/$APP_NAME"
                echo '${command} start'            >> "/etc/rc.d/$APP_NAME"
                echo '}'                           >> "/etc/rc.d/$APP_NAME"
                echo 'run_rc_command "$1"'         >> "/etc/rc.d/$APP_NAME"
            fi
            echo "${APP_NAME}_enable=\"YES\"" >> /etc/rc.conf
            chmod 555 "/etc/rc.d/$APP_NAME"
        fi
    elif [ "$DIST_OS" = "macosx" ] ; then
        eval echo `gettext 'Detected Mac OSX:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is already installed.'`
        else
            eval echo `gettext ' Installing the $APP_LONG_NAME daemon...'`
            if [ -f "${REALDIR}/${APP_PLIST}" ] ; then
                ln -s "${REALDIR}/${APP_PLIST}" "/Library/LaunchDaemons/${APP_PLIST}"
            else
                echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"                       > "/Library/LaunchDaemons/${APP_PLIST}"
                echo "<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\"" >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"             >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "<plist version=\"1.0\">"                                         >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "    <dict>"                                                      >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <key>Label</key>"                                        >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <string>${APP_PLIST_BASE}</string>"                      >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <key>ProgramArguments</key>"                             >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <array>"                                                 >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "            <string>${REALPATH}</string>"                        >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "            <string>launchdinternal</string>"                    >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        </array>"                                                >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <key>${KEY_KEEP_ALIVE}</key>"                            >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <${MACOSX_KEEP_RUNNING}/>"                               >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <key>RunAtLoad</key>"                                    >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "        <true/>"                                                 >> "/Library/LaunchDaemons/${APP_PLIST}"
                if [ "X$RUN_AS_USER" != "X" ] ; then
                    echo "        <key>UserName</key>"                                 >> "/Library/LaunchDaemons/${APP_PLIST}"
                    echo "        <string>${RUN_AS_USER}</string>"                     >> "/Library/LaunchDaemons/${APP_PLIST}"
                fi
                echo "    </dict>"                                                     >> "/Library/LaunchDaemons/${APP_PLIST}"
                echo "</plist>"                                                        >> "/Library/LaunchDaemons/${APP_PLIST}"
            fi
            chmod 555 "/Library/LaunchDaemons/${APP_PLIST}"
        fi
    elif [ "$DIST_OS" = "zos" ] ; then
        eval echo `gettext 'Detected z/OS:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is already installed.'`
        else
            eval echo `gettext ' Installing the $APP_LONG_NAME daemon...'`
            cp /etc/rc /etc/rc.bak
            sed  "s:echo /etc/rc script executed, \`date\`::g" /etc/rc.bak > /etc/rc
            echo "_BPX_JOBNAME='${APP_NAME}' \"${REALDIR}/${APP_NAME}\" start" >>/etc/rc
            echo '/etc/rc script executed, `date`' >>/etc/rc
        fi
    else
        eval echo `gettext 'Install not currently supported for $DIST_OS.'`
        exit 1
    fi
    
    # Exit with 1 if the daemon was already installed when calling installdaemon().
    #  The test below requires $installedStatus to be unchanged since the call to
    #  checkInstalled() at the beginning of the function. If the script was launched
    #  with 'installstart' we want to start normally, so don't exit here.
    if [ $installedStatus -ne $SERVICE_NOT_INSTALLED -a "$COMMAND" != 'installstart' ] ; then
        exit 1
    fi
    
    # Check again the installation status. The script should exit with 1 if the service
    #  could not be installed (even if it was launched with 'installstart').
    checkInstalled
    if [ $installedStatus -eq $SERVICE_NOT_INSTALLED ] ; then
        eval echo `gettext 'Service not installed.'`
        exit 1
    fi
}

startdaemon() {
    getServiceControlMethod
    if [ "$CTRL_WITH_LAUNCHD" = "true" ] ; then
        macosxStart
    elif [ "$CTRL_WITH_UPSTART" = "true" ] ; then
        upstartStart
    elif [ "$CTRL_WITH_SYSTEMD" = "true" ] ; then
        systemdStart
    elif [ "$CTRL_WITH_SRC" = "true" ] ; then
        srcStart
    else
        if [ -n "$SYSD" ] ; then
            shift
        fi
        
        checkRunUser touchlock "$@"
        if [ ! -n "$FIXED_COMMAND" ] ; then
            shift
        fi
        
        if [ "$SERVICE_MANAGEMENT_TOOL" != "auto" -a "$SERVICE_MANAGEMENT_TOOL" != "initd" ] ; then
            eval echo `gettext 'Starting without using the configured service management tool \"$SERVICE_MANAGEMENT_TOOL\" because the service $APP_NAME is not installed.'`
        fi
        
        start "$@"
    fi
}

restartdaemon() {
    getServiceControlMethod
    if [ "$CTRL_WITH_LAUNCHD" = "true" ] ; then
        macosxRestart $1
    elif [ "$CTRL_WITH_UPSTART" = "true" ] ; then
        upstartRestart $1
    elif [ "$CTRL_WITH_SYSTEMD" = "true" ] ; then
        systemdRestart $1
    elif [ "$CTRL_WITH_SRC" = "true" ] ; then
        srcRestart $1
    else
        checkRunUser touchlock "$COMMAND"

        checkRunning $1
        if [ "X$pid" != "X" ] ; then
            # The daemon was running. Stop it first.
            eval echo `gettext 'Restarting $APP_LONG_NAME...'`
            stopit $1
        fi
        shift
        if [ ! -n "$FIXED_COMMAND" ] ; then
            shift
        fi
        start "$@"
    fi
}

isBitSet() {
    if [ `expr \( $1 / $2 \) % 2` -eq 1 ]; then
        return 1
    else
        return 0
    fi
}

removedaemon() {
    mustBeRootOrExit
    
    checkInstalled
    APP_NAME_LOWER=`echo "$APP_NAME" | $TR_BIN "[A-Z]" "[a-z]"`
    if [ "$DIST_OS" = "solaris" ] ; then
        eval echo `gettext 'Detected Solaris:'`
        isBitSet $installedStatus $SERVICE_INSTALLED_DEFAULT
        if [ $? -eq 1 ] ; then
            stopit "0"
            eval echo `gettext ' Removing the $APP_LONG_NAME daemon...'`
            for i in `ls "/etc/rc3.d/K"??"$APP_NAME_LOWER" "/etc/rc3.d/S"??"$APP_NAME_LOWER" "/etc/init.d/$APP_NAME" 2>/dev/null` ; do
                rm -f $i
            done
        else
            eval echo `gettext ' The $APP_LONG_NAME daemon is not currently installed.'`
            exit 1
        fi
    elif [ "$DIST_OS" = "linux" ] ; then
        eval echo `gettext 'Detected Linux:'`
        isBitSet $installedStatus $SERVICE_INSTALLED_SYSTEMD
        if [ $? -eq 1 ] ; then
            systemdRemove

            # Always try to restore the SELinux context.
            result=`restorecon $REALPATH 2>/dev/null`
            if [ $? -ne 0 ] ; then
                # Only print a warning if 'restorecon' exists or if SELinux is present.
                getSELinuxStatus
                result=`command -v restorecon 2>/dev/null`
                if [ $? -eq 0 -o $SELINUX_STATUS -gt 0 ] ; then
                    SCRIPT_BASENAME=`basename "$REALDIR"`
                    eval echo `gettext ' WARNING: Could not restore the SELinux context of $SCRIPT_BASENAME.'`
                fi
            fi
        fi
        isBitSet $installedStatus $SERVICE_INSTALLED_UPSTART
        if [ $? -eq 1 ] ; then
            upstartRemove
        fi
        isBitSet $installedStatus $SERVICE_INSTALLED_DEFAULT
        if [ $? -eq 1 ] ; then
            stopit "0"
            eval echo `gettext ' Removing the $APP_LONG_NAME daemon from init.d...'`
            resolveInitdCommand
            if [ -n "$USE_CHKCONFIG" ] ; then
                $INITD_COMMAND "$APP_NAME" off
                $INITD_COMMAND --del "$APP_NAME"
                rm -f "/etc/init.d/$APP_NAME"
            elif [ "$USE_INSSERV" ] ; then
                $INITD_COMMAND -r "/etc/init.d/$APP_NAME"
                rm -f "/etc/init.d/$APP_NAME"
            elif [ "$USE_UPDATE_RC" ] ; then
                $INITD_COMMAND -f "$APP_NAME" remove
                rm -f "/etc/init.d/$APP_NAME"
            else
                for i in `ls "/etc/rc3.d/K"??"$APP_NAME_LOWER" "/etc/rc5.d/K"??"$APP_NAME_LOWER" "/etc/rc3.d/S"??"$APP_NAME_LOWER" "/etc/rc5.d/S"??"$APP_NAME_LOWER" "/etc/init.d/$APP_NAME" 2>/dev/null` ; do
                    rm -f $i
                done
            fi
        fi
        if [ $installedStatus -eq $SERVICE_NOT_INSTALLED ] ; then
            eval echo `gettext ' The $APP_LONG_NAME daemon is not currently installed.'`
            exit 1
        fi
    elif [ "$DIST_OS" = "hpux" ] ; then
        eval echo `gettext 'Detected HP-UX:'`
        isBitSet $installedStatus $SERVICE_INSTALLED_DEFAULT
        if [ $? -eq 1 ] ; then
            stopit "0"
            eval echo `gettext ' Removing the $APP_LONG_NAME daemon...'`
            for i in `ls "/sbin/rc3.d/K"??"$APP_NAME_LOWER" "/sbin/rc3.d/S"??"$APP_NAME_LOWER" "/sbin/init.d/$APP_NAME" 2>/dev/null` ; do
                rm -f $i
            done
        else
            eval echo `gettext ' The $APP_LONG_NAME daemon is not currently installed.'`
            exit 1
        fi
    elif [ "$DIST_OS" = "aix" ] ; then
        eval echo `gettext 'Detected AIX:'`
        if [ $installedStatus -ne $SERVICE_NOT_INSTALLED ] ; then
            stopit "0"
            eval echo `gettext ' Removing the $APP_LONG_NAME daemon...'`
            isBitSet $installedStatus $SERVICE_INSTALLED_DEFAULT
            if [ $? -eq 1 ] ; then
                for i in `ls "/etc/rc.d/rc2.d/K"??"$APP_NAME_LOWER" "/etc/rc.d/rc2.d/S"??"$APP_NAME_LOWER" "/etc/rc.d/init.d/$APP_NAME" 2>/dev/null` ; do
                    rm -f $i
                done
            fi
            isBitSet $installedStatus $SERVICE_INSTALLED_SRC
            isSrcSet=$?
            isBitSet $installedStatus $SERVICE_INSTALLED_SRC_PARTIAL
            isSrcPartialSet=$?
            if [ $isSrcSet -eq 1 -o $isSrcPartialSet -eq 1 ] ; then
                validateAppNameLength
                /usr/sbin/rmitab $APP_NAME
                /usr/bin/rmssys -s $APP_NAME
            fi
        else 
            eval echo `gettext ' The $APP_LONG_NAME daemon is not currently installed.'`
            exit 1
        fi
    elif [ "$DIST_OS" = "freebsd" ] ; then
        eval echo `gettext 'Detected FreeBSD:'`
        if [ -f "/etc/rc.d/$APP_NAME" -o -L "/etc/rc.d/$APP_NAME" ] ; then
            stopit "0"
            eval echo `gettext ' Removing the $APP_LONG_NAME daemon...'`
            for i in "/etc/rc.d/$APP_NAME"
            do
                rm -f $i
            done
            sed -i.bak "/${APP_NAME}_enable=\"YES\"/d" /etc/rc.conf
        else
            eval echo `gettext ' The $APP_LONG_NAME daemon is not currently installed.'`
            exit 1
        fi
    elif [ "$DIST_OS" = "macosx" ] ; then
        eval echo `gettext 'Detected Mac OSX:'`
        if [ -f "/Library/LaunchDaemons/${APP_PLIST}" -o -L "/Library/LaunchDaemons/${APP_PLIST}" ] ; then
            stopit "0"
            eval echo `gettext ' Removing the $APP_LONG_NAME daemon...'`
            # Make sure the plist is installed
            LOADED_PLIST=`launchctl list | grep ${APP_PLIST_BASE}`
            if [ "X${LOADED_PLIST}" != "X" ] ; then
                launchctl unload "/Library/LaunchDaemons/${APP_PLIST}"
            fi
            rm -f "/Library/LaunchDaemons/${APP_PLIST}"
        else
            eval echo `gettext ' The $APP_LONG_NAME daemon is not currently installed.'`
            exit 1
        fi
    elif [ "$DIST_OS" = "zos" ] ; then
        eval echo `gettext 'Detected z/OS:'`
        if [ -f /etc/rc.bak ] ; then
            stopit "0"
            eval echo `gettext ' Removing the $APP_LONG_NAME daemon...'`
            cp /etc/rc /etc/rc.bak
            sed  "s/_BPX_JOBNAME=\'APP_NAME\'.*//g" /etc/rc.bak > /etc/rc
            rm /etc/rc.bak
        else
            eval echo `gettext ' The $APP_LONG_NAME daemon is not currently installed.'`
            exit 1
        fi
    else
        eval echo `gettext 'Remove not currently supported for $DIST_OS.'`
        exit 1
    fi
}

dump() {
    eval echo `gettext 'Dumping $APP_LONG_NAME...'`
    getpid
    if [ "X$pid" = "X" ]
    then
        eval echo `gettext '$APP_LONG_NAME was not running.'`
    else
        kill -3 $pid

        if [ $? -ne 0 ]
        then
            eval echo `gettext 'Failed to dump $APP_LONG_NAME.'`
            exit 1
        else
            eval echo `gettext 'Dumped $APP_LONG_NAME.'`
        fi
    fi
}

# Used by HP-UX init scripts.
startmsg() {
    getpid
    if [ "X$pid" = "X" ]
    then
        eval echo `gettext 'Starting $APP_LONG_NAME...  Wrapper:Stopped'`
    else
        if [ "X$DETAIL_STATUS" = "X" ]
        then
            eval echo `gettext 'Starting $APP_LONG_NAME...  Wrapper:Running'`
        else
            getstatus
            eval echo `gettext 'Starting $APP_LONG_NAME...  Wrapper:$STATUS, Java:$JAVASTATUS'`
        fi
    fi
}

# Used by HP-UX init scripts.
stopmsg() {
    getpid
    if [ "X$pid" = "X" ]
    then
        eval echo `gettext 'Stopping $APP_LONG_NAME...  Wrapper:Stopped'`
    else
        if [ "X$DETAIL_STATUS" = "X" ]
        then
            eval echo `gettext 'Stopping $APP_LONG_NAME...  Wrapper:Running'`
        else
            getstatus
            eval echo `gettext 'Stopping $APP_LONG_NAME...  Wrapper:$STATUS, Java:$JAVASTATUS'`
        fi
    fi
}

# 'source' files
sourceFiles() {
    if [ -n "$FILES_TO_SOURCE" ] ; then
        OIFS=$IFS
        IFS=';'
        files=$FILES_TO_SOURCE
        for file in $files
        do
            . $file
        done

        IFS=$OIFS
    fi
}

# Check if arguments are correct. This needs to be done after knowing the
#  command, the application name and OS (to check the installation status).
# NOTE: When the validity of the arguments depends on the daemon installation,
#       make sure to call setServiceManagementTool() before this function.
#
# $1 0: no parameter allowed
#   -1: parameter allowed if not installed
#    1: parameter allowed
checkArguments() {
    # If this is a systemd call (from the systemd service file), we don't want
    #  to check arguments ('sysd' itself should not be blocking and the user
    #  may also have edited the file and added additional args in it).
    if [ -n "$SYSD" ] ; then
        return
    fi
    
    if [ -n "$FIRST_ARG" ] ; then
        if [ $1 = -1 ] ; then
            checkInstalled "strict"
            if [ $installedStatus -eq $SERVICE_NOT_INSTALLED ] ; then
                PASS_THROUGH_ALLOWED=true
            fi
        elif [ $1 = 1 ] ; then
            PASS_THROUGH_ALLOWED=true
        fi

        if [ "X${PASS_THROUGH_ALLOWED}" != "Xtrue" ] ; then
            eval echo `gettext 'Additional arguments are not allowed with the ${COMMAND} command.'`
            
            if [ -n "$FIXED_COMMAND" ] ; then
                # The command can't be used with PASS_THROUGH, so disable it to show appropriate usage.
                PASS_THROUGH=false
            fi
            showUsage
            exit 2 # LSB - invalid or excess argument(s)
        elif [ "X${PASS_THROUGH}" = "Xfalse" ] ; then
            eval echo `gettext 'Additional arguments are not allowed when PASS_THROUGH is set to false.'`
            showUsage
            exit 2 # LSB - invalid or excess argument(s)
        fi
    fi
}

docommand() {
  
    case "$COMMAND" in
        'console')
            checkArguments 1
            # trap signals (this must be done before changing the user)
            consoleTrapSignals
            checkRunUser touchlock "$@"
            if [ ! -n "$FIXED_COMMAND" ] ; then
                shift
            fi
            console "$@"
            ;;
    
        'start')
            setServiceManagementTool
            checkArguments -1
            startdaemon "$@"
            ;;
    
        'stop')
            checkArguments 0
            setServiceManagementTool
            getServiceControlMethod
            if [ "$CTRL_WITH_LAUNCHD" = "true" ] ; then
                macosxStop
            elif [ "$CTRL_WITH_UPSTART" = "true" ] ; then
                upstartStop
            elif [ "$CTRL_WITH_SYSTEMD" = "true" ] ; then
                systemdStop
            elif [ "$CTRL_WITH_SRC" = "true" ] ; then
                srcStop
            else
                checkRunUser "" "$COMMAND"
                stopit "0"
            fi
            ;;
    
        'restart')
            setServiceManagementTool
            checkArguments -1
            restartdaemon "0" "$@"
            ;;
    
        'condrestart')
            setServiceManagementTool
            checkArguments -1
            restartdaemon "1" "$@"
            ;;
    
        'pause')
            checkArguments 0
            setServiceManagementTool
            if [ -n "$PAUSABLE" ]
            then
                pause
            else
                showUsage "$COMMAND"
            fi
            ;;
    
        'resume')
            checkArguments 0
            setServiceManagementTool
            if [ -n "$PAUSABLE" ]
            then
                resume
            else
                showUsage "$COMMAND"
            fi
            ;;
    
        'status')
            checkArguments 0
            setServiceManagementTool
            status
            ;;
    
        'install')
            checkArguments 0
            setServiceManagementTool
            installdaemon "$@"
            ;;
    
        'installstart')
            checkArguments 0
            setServiceManagementTool
            installdaemon "$@"
            startdaemon "$@"
            ;;
    
        'remove')
            checkArguments 0
            setServiceManagementTool
            removedaemon
            ;;
    
        'dump')
            checkArguments 0
            checkRunUser "" "$COMMAND"
            dump
            ;;
    
        'start_msg')
            # Internal command called by launchd on HP-UX.
            checkRunUser "" "$COMMAND"
            startmsg
            ;;
    
        'stop_msg')
            # Internal command called by launchd on HP-UX.
            checkRunUser "" "$COMMAND"
            stopmsg
            ;;
    
        'launchdinternal' | 'upstartinternal')
            if [ ! "$DIST_OS" = "macosx" -o ! -f "/Library/LaunchDaemons/${APP_PLIST}" ] ; then
                checkRunUser touchlock "$@"
            fi
            # Internal command called by launchd on Max OSX.
            # We do not want to call checkRunUser here as it is handled in the launchd plist file.  Doing it here would confuse launchd.
            if [ ! -n "$FIXED_COMMAND" ] ; then
                shift
            fi
            launchinternal "$@"
            ;;
    
        *)
            showUsage "$COMMAND"
            ;;
    esac
}

sourceFiles
docommand "$@"

exit 0
