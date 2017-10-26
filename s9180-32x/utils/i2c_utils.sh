#!/bin/bash

# Copyright (C) 2017 Ingrasys, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

VERSION="1.0.0"
TRUE=200
FALSE=404

EXEC_FUNC=${1}
QSFP_PORT=${2}
QSFP_ACTION=${2}
MB_EEPROM_ACTION=${2}
COLOR_PORT_LED=${3}
ONOFF_LED=${3}
COLOR_SYS_LED=${2}
BLINK_LED=${4}
FAN_TRAY=${4}

############################################################
# Distributor ID: Debian
# Description:    Debian GNU/Linux 8.6 (jessie)
# Release:        8.6
# Codename:       jessie
# Linux debian 3.16.0-4-amd64 #1
# SMP Debian 3.16.36-1+deb8u1 (2016-09-03) x86_64 GNU/Linux
############################################################

# Color Definition
COLOR_TITLE="\e[1;32m"   ### Green ###
COLOR_WARNING="\e[1;33m" ### Yellow ###
COLOR_ERROR="\e[1;31m"   ### Red ###
COLOR_END="\e[0m"        ### END ###

NUM_I801_DEVICE=0 # Main I2C
NUM_MUX1_CHAN0_DEVICE=$(( ${NUM_I801_DEVICE} + 1 ))  # zQSFP I/O 0-7
NUM_MUX1_CHAN1_DEVICE=$(( ${NUM_MUX1_CHAN0_DEVICE} + 1 ))  # zQSFP I/O 8-15
NUM_MUX1_CHAN2_DEVICE=$(( ${NUM_MUX1_CHAN1_DEVICE} + 1 ))  # zQSFP I/O 16-23
NUM_MUX1_CHAN3_DEVICE=$(( ${NUM_MUX1_CHAN2_DEVICE} + 1 ))  # zQSFP I/O 24-31
NUM_MUX1_CHAN4_DEVICE=$(( ${NUM_MUX1_CHAN3_DEVICE} + 1 ))  # zQSFP I/O ABS#, INT
NUM_MUX1_CHAN5_DEVICE=$(( ${NUM_MUX1_CHAN4_DEVICE} + 1 ))  # zQSFP I/O LPMODE, RST, MODSEL
NUM_MUX1_CHAN6_DEVICE=$(( ${NUM_MUX1_CHAN5_DEVICE} + 1 ))  # MAC CLK CPLD
NUM_MUX1_CHAN7_DEVICE=$(( ${NUM_MUX1_CHAN6_DEVICE} + 1 ))  # P1V0 PWR
NUM_MUX3_CHAN0_DEVICE=$(( ${NUM_MUX1_CHAN7_DEVICE} + 1 )) # zQSFP I/O 0-7
NUM_MUX4_CHAN0_DEVICE=$(( ${NUM_MUX3_CHAN0_DEVICE} + 8 )) # zQSFP I/O 8-15
NUM_MUX5_CHAN0_DEVICE=$(( ${NUM_MUX4_CHAN0_DEVICE} + 8 )) # zQSFP I/O 16-23
NUM_MUX6_CHAN0_DEVICE=$(( ${NUM_MUX5_CHAN0_DEVICE} + 8 )) # zQSFP I/O 24-31
NUM_MUX7_CHAN0_DEVICE=$(( ${NUM_MUX6_CHAN0_DEVICE} + 8 )) # Temp Sensor 0x48-0x4D
NUM_MAIN_MUX_CHAN0_DEVICE=$(( ${NUM_MUX7_CHAN0_DEVICE} + 8 )) # System LED HWMON
NUM_MAIN_MUX_CHAN1_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 1 )) # System LED
NUM_MAIN_MUX_CHAN2_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 2 )) # Board ID
NUM_MAIN_MUX_CHAN3_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 3 )) # MAX_Slave
NUM_MAIN_MUX_CHAN4_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 4 )) # TEMP Sensor
NUM_MAIN_MUX_CHAN5_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 5 )) # CLK GEN
NUM_MAIN_MUX_CHAN6_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 6 )) # VDD CORE
NUM_MAIN_MUX_CHAN7_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 7 )) # HWMON
NUM_FRU_MUX_CHAN0_DEVICE=$(( ${NUM_MAIN_MUX_CHAN0_DEVICE} + 8 )) # PSU2
NUM_FRU_MUX_CHAN1_DEVICE=$(( ${NUM_FRU_MUX_CHAN0_DEVICE} + 1 )) # PSU1
NUM_FRU_MUX_CHAN2_DEVICE=$(( ${NUM_FRU_MUX_CHAN0_DEVICE} + 2 )) # FAN
NUM_CPLD_DEVICE=$(( ${NUM_MUX7_CHAN0_DEVICE} + 3 )) # CPLD
NUM_SFP1_DEVICE=$(( ${NUM_MUX7_CHAN0_DEVICE} + 4 )) # CPLD
NUM_SFP2_DEVICE=$(( ${NUM_MUX7_CHAN0_DEVICE} + 5 )) # CPLD

PATH_SYS_I2C_DEVICES="/sys/bus/i2c/devices"
PATH_HWMON_ROOT_DEVICES="/sys/class/hwmon"
PATH_HWMON_W83795_DEVICE="${PATH_HWMON_ROOT_DEVICES}/hwmon1"
PATH_I801_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_I801_DEVICE}"
PATH_ISMT_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_ISMT_DEVICE}"
PATH_MUX_CHAN0_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN0_DEVICE}"
PATH_MUX_CHAN1_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN1_DEVICE}"
PATH_MUX_CHAN2_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN2_DEVICE}"
PATH_MUX_CHAN3_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN3_DEVICE}"
PATH_MUX_CHAN4_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN4_DEVICE}"
PATH_MUX_CHAN5_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN5_DEVICE}"
PATH_MUX_CHAN6_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN6_DEVICE}"
PATH_MUX_CHAN7_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN7_DEVICE}"
PATH_MUX7_CHAN0_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX7_CHAN0_DEVICE}"
PATH_MAIN_MUX_CHAN0_DEVICE="${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MAIN_MUX_CHAN0_DEVICE}"

#Power Supply Status
PSU_DC_ON=1
PSU_DC_OFF=0
PSU_EXIST=1
PSU_NOT_EXIST=0

# Help usage function
function _help {
    echo "========================================================="
    echo "# Description: Help Function"
    echo "========================================================="
    echo "----------------------------------------------------"
    echo "EX       : ${0} help"
    echo "         : ${0} i2c_init"
    echo "         : ${0} i2c_deinit"
    echo "         : ${0} i2c_temp_init"
    echo "         : ${0} i2c_fan_init"
    echo "         : ${0} i2c_volmon_init"
    echo "         : ${0} i2c_io_exp_init"
    echo "         : ${0} i2c_gpio_init"
    echo "         : ${0} i2c_gpio_deinit"

    echo "         : ${0} i2c_psu_eeprom_get"
    echo "         : ${0} i2c_mb_eeprom_get"
    echo "         : ${0} i2c_cpu_eeprom_get"
    echo "         : ${0} i2c_qsfp_eeprom_get [1-34]"
    echo "         : ${0} i2c_qsfp_eeprom_init new|delete"
    echo "         : ${0} i2c_sfp_eeprom_init new|delete"
    echo "         : ${0} i2c_mb_eeprom_init new|delete"
    echo "         : ${0} i2c_qsfp_status_get [1-34]"
    echo "         : ${0} i2c_qsfp_type_get [1-34]"
    echo "         : ${0} i2c_board_type_get"
    echo "         : ${0} i2c_psu_status"
    echo "         : ${0} i2c_led_fan_status_set"
    echo "         : ${0} i2c_led_fan_tray_status_set"
    echo "         : ${0} i2c_cpld_version"
    echo "         : ${0} i2c_port_led_set [1-34] green|yellow|off blink|noblink"
    echo "         : ${0} i2c_test_all"
    echo "         : ${0} i2c_sys_led green|amber"
    echo "         : ${0} i2c_fan_led green|amber on|off"
    echo "         : ${0} i2c_fan_tray_led green|amber on|off [1-4]"
    echo "----------------------------------------------------"
}

#Pause function
function _pause {
    read -p "$*"
}

#Retry command function
function _retry {
    local i
    for i in {1..5};
    do
       eval "${*}" && break || echo "retry"; sleep 1;
    done
}

#I2C Init
function _i2c_init {
    echo "========================================================="
    echo "# Description: I2C Init"
    echo "========================================================="

    rmmod eeprom
    rmmod i2c_i801
    modprobe i2c_i801
    modprobe i2c_dev
    modprobe i2c_mux_pca954x force_deselect_on_exit=1

    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX1_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x70' > ${PATH_I801_DEVICE}/new_device"
    else
        echo "${PATH_I801_DEVICE} 0x70 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX3_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN0_DEVICE}/new_device"
    else
        echo "${PATH_MUX_CHAN0_DEVICE} 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX4_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN1_DEVICE}/new_device"
    else
        echo "${PATH_MUX_CHAN1_DEVICE} 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX5_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN2_DEVICE}/new_device"
    else
        echo "${PATH_MUX_CHAN2_DEVICE} 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX6_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN3_DEVICE}/new_device"
    else
        echo "${PATH_MUX_CHAN3_DEVICE} 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MUX7_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x71' > ${PATH_MUX_CHAN6_DEVICE}/new_device"
    else
        echo "${PATH_MUX_CHAN6_DEVICE} 0x71 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MAIN_MUX_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9548 0x76' > ${PATH_I801_DEVICE}/new_device"
    else
        echo "${PATH_MAIN_MUX_CHAN0_DEVICE} 0x76 already init."
    fi
    if [ ! -e "${PATH_SYS_I2C_DEVICES}/i2c-${NUM_FRU_MUX_CHAN0_DEVICE}" ]; then
        _retry "echo 'pca9545 0x72' > ${PATH_I801_DEVICE}/new_device"
    else
        echo "${PATH_MAIN_MUX_CHAN0_DEVICE} 0x72 already init."
    fi

    rmmod coretemp
    rmmod jc42
    rmmod w83795
    rmmod lm75
    rmmod lm90
    rmmod eeprom
    modprobe coretemp
    modprobe w83795
    modprobe lm75
    modprobe lm90
    modprobe eeprom_mb
    modprobe gpio-pca953x
    _i2c_io_exp_init
    _i2c_fan_init
    _i2c_volmon_init
    _i2c_fan_speed_init
    _i2c_temp_init
    modprobe jc42
    _i2c_gpio_init
    _i2c_mb_eeprom_init "new"
    _i2c_qsfp_eeprom_init "new"
    _i2c_sfp_eeprom_init "new"
    _i2c_led_fan_status_set
    _i2c_led_fan_tray_status_set

    #SYS LED set green
    COLOR_SYS_LED="green"
    _i2c_sys_led
}

#I2C Deinit
function _i2c_deinit {
    _i2c_gpio_deinit
    for mod in coretemp jc42 w83795 lm75 lm90 eeprom eeprom_mb gpio-pca953x i2c_mux_pca954x i2c_ismt i2c_i801;
    do
        [ "$(lsmod | grep "^$mod ")" != "" ] && rmmod $mod
    done
}

#FAN Init
function _i2c_fan_speed_init {
    echo -n "FAN INIT..."
    if [ -e "${PATH_HWMON_W83795_DEVICE}" ]; then
        echo 120 > ${PATH_HWMON_W83795_DEVICE}/device/pwm1
        echo 120 > ${PATH_HWMON_W83795_DEVICE}/device/pwm2
        echo "SUCCESS"
    else
        echo "FAIL"
    fi

}

#VOLMON Init
function _i2c_volmon_init {
    echo "VOLMON INIT..."
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x00 0x80
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x01 0x1C
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x00 0x80
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x02 0xFF
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x03 0x50
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x04 0x0A
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x00 0x80
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x01 0x1D

    # add w83795 to sysfs
    dev_path="${PATH_SYS_I2C_DEVICES}/${NUM_MAIN_MUX_CHAN7_DEVICE}-0x2f"
    if ! [ -L ${dev_path} ]; then
        echo "w83795adg 0x2f" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_MAIN_MUX_CHAN7_DEVICE}/new_device #hwmon
    else
        echo "${dev_path} already exist"
    fi
    echo "Done"
}

#IO Expander Init
function _i2c_io_exp_init {
    echo "========================================================="
    echo "# Description: I2C IO Expender Init"
    echo "========================================================="

    #Golden Finger to active CPLD
    i2cget -y ${NUM_CPLD_DEVICE} 0x74 2
    #BMC dummy board reset
    echo "BMC dummy board reset"
    i2cset -y -r ${NUM_I801_DEVICE} 0x26 4 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x26 5 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x26 2 0x3F
    i2cset -y -r ${NUM_I801_DEVICE} 0x26 3 0x1F
    i2cset -y -r ${NUM_I801_DEVICE} 0x26 6 0xC0
    i2cset -y -r ${NUM_I801_DEVICE} 0x26 7 0x00

    #CPU Baord
    i2cset -y -r ${NUM_I801_DEVICE} 0x77 6 0xFF
    i2cset -y -r ${NUM_I801_DEVICE} 0x77 7 0xFF

    #SMBUS1
    #ABS
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x20 6 0xFF
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x20 7 0xFF

    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x21 6 0xFF
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x21 7 0xFF

    #Transcevior INT
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x22 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x22 6 0xFF
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x22 7 0xFF

    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x23 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x23 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x23 2 0xCF
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x23 3 0xF0
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x23 6 0xCF
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x23 7 0xF0

    #SFP+ PRES, TX FAULT, TX DIS, RX LOS, RS, TS
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x27 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x27 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x27 2 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x27 3 0x00
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x27 6 0xCF
    i2cset -y -r ${NUM_MUX1_CHAN4_DEVICE} 0x27 7 0xF0


    echo "Init ZQSFP IO Expender"
    echo "set ZQSFP LP_MODE = 0"
    #set ZQSFP LP_MODE = 0
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x20 2 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x20 3 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x20 6 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x20 7 0x00

    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x21 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x21 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x21 2 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x21 3 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x21 6 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x21 7 0x00

    echo "set ZQSFP RST = 1"
    #set ZQSFP RST = 1
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x22 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x22 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x22 2 0xFF
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x22 3 0xFF
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x22 6 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x22 7 0x00

    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x23 4 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x23 5 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x23 2 0xFF
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x23 3 0xFF
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x23 6 0x00
    i2cset -y -r ${NUM_MUX1_CHAN5_DEVICE} 0x23 7 0x00

    #0.0: TH_RST_L - 0:Reset
    #0.1: TH_PCIE_RST_L - 0:Reset
    #0.2: LED_CLR - 0: Off, 1:On
    #0.3: Host to BMC
    #0.4: UART_SEL - 0:Host
    #0.5: USB_SEL - 0: Host
    #0.[7:6]: TH_CLK_FSEL (00)
    #1.0: TH_INT_L
    #1.1: QSFP0_INT_L - 0:Interrupt
    #1.2: QSFP1_INT_L - 0:Interrupt
    #1.3: QSFP2_INT_L - 0:Interrupt
    #1.4: QSFP3_INT_L - 0:Interrupt
    #1.5: TH_CLK_SEL (0)
    #1.6: I210_RST_L - 0:Reset
    #1.6: I210_PE_RST_L - 0:Reset
    echo "Init HOST GPIO"
    i2cset -y -r ${NUM_I801_DEVICE} 0x74 4 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x74 5 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x74 2 0x0F
    i2cset -y -r ${NUM_I801_DEVICE} 0x74 3 0xDF
    i2cset -y -r ${NUM_I801_DEVICE} 0x74 6 0x08
    i2cset -y -r ${NUM_I801_DEVICE} 0x74 7 0x1F


    #LED board after PVT (BAREFOOT_IO_EXP_LED_ID)
    echo "Init LED IO Expender"
    echo "LED_CHANNEL=${NUM_MAIN_MUX_CHAN1_DEVICE}"
    i2cset -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 4 0x00
    i2cset -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 5 0x00
    i2cset -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 6 0x00
    i2cset -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 7 0xFF

    #Board ID
    echo "Init Board ID"
    i2cset -y -r ${NUM_MAIN_MUX_CHAN2_DEVICE} 0x27 4 0x00
    i2cset -y -r ${NUM_MAIN_MUX_CHAN2_DEVICE} 0x27 5 0x00
    i2cset -y -r ${NUM_MAIN_MUX_CHAN2_DEVICE} 0x27 6 0xFF
    i2cset -y -r ${NUM_MAIN_MUX_CHAN2_DEVICE} 0x27 7 0xFF

    #Board ID of dummy card
    echo "Init Board ID of dummy card"
    i2cset -y -r ${NUM_I801_DEVICE} 0x24 4 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x24 5 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x24 6 0xFF
    i2cset -y -r ${NUM_I801_DEVICE} 0x24 7 0xFF

    #PSU I/O (BAREFOOT_IO_EXP_PSU_ID)
    echo "Init PSU IO Expender"
    i2cset -y -r ${NUM_I801_DEVICE} 0x25 4 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x25 5 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x25 2 0x00
    i2cset -y -r ${NUM_I801_DEVICE} 0x25 3 0x1D
    i2cset -y -r ${NUM_I801_DEVICE} 0x25 6 0xDB
    i2cset -y -r ${NUM_I801_DEVICE} 0x25 7 0x03

    #FAN I/O (BAREFOOT_IO_EXP_FAN_ID)
    echo "Init FAN IO Expender"
    i2cset -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} 0x20 4 0x00
    i2cset -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} 0x20 5 0x00
    i2cset -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} 0x20 2 0x11
    i2cset -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} 0x20 3 0x11
    i2cset -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} 0x20 6 0xCC
    i2cset -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} 0x20 7 0xCC

}

#FANIN Init
function _i2c_fan_init {
    echo "FANIN INIT..."
    # enable fan monitor on w83795
    # 4 fantray with 8 FANIN
    # select bank0
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x00 0x80
    # enable FANIN1~8
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x06 0xFF
    # disable FANIN9~14
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x07 0x00

    # select bank 2
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x00 0x82
    # set PWM mode in FOMC
    i2cset -y -r ${NUM_MAIN_MUX_CHAN7_DEVICE} 0x2F 0x0F 0x00

    echo "Done"
}

#GPIO Init
function _i2c_gpio_init {
    local i=0
    #ABS Port 0-15
    echo "pca9535 0x20" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/new_device
    for i in {240..255};
    do
        echo $i > /sys/class/gpio/export
        echo 1 > /sys/class/gpio/gpio${i}/active_low
    done

    #ABS Port 16-31
    echo "pca9535 0x21" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/new_device
    for i in {224..239};
    do
        echo $i > /sys/class/gpio/export
        echo 1 > /sys/class/gpio/gpio${i}/active_low
    done

    #INT Port 0-15
    echo "pca9535 0x22" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/new_device
    for i in {208..223};
    do
        echo $i > /sys/class/gpio/export
        echo 1 > /sys/class/gpio/gpio${i}/active_low
    done

    #INT Port 16-31
    echo "pca9535 0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/new_device
    for i in {192..207};
    do
        echo $i > /sys/class/gpio/export
        echo 1 > /sys/class/gpio/gpio${i}/active_low
    done

    #SFP+
    echo "pca9535 0x27" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/new_device
    for i in {176..191};
    do
        echo $i > /sys/class/gpio/export
        case ${i} in
            176|177|178|179|182|183|188|189|190|191)
                echo 1 > /sys/class/gpio/gpio${i}/active_low
            ;;
            180|181|184|185|186|187)
                echo out > /sys/class/gpio/gpio${i}/direction
            ;;
        esac
    
    done
    #echo 176 > /sys/class/gpio/export
    #echo 177 > /sys/class/gpio/export
    #echo 178 > /sys/class/gpio/export
    #echo 179 > /sys/class/gpio/export
    #echo 180 > /sys/class/gpio/export
    #echo 181 > /sys/class/gpio/export
    #echo 182 > /sys/class/gpio/export
    #echo 183 > /sys/class/gpio/export
    #echo 184 > /sys/class/gpio/export
    #echo 185 > /sys/class/gpio/export
    #echo 186 > /sys/class/gpio/export
    #echo 187 > /sys/class/gpio/export
    #echo 188 > /sys/class/gpio/export
    #echo 189 > /sys/class/gpio/export
    #echo 190 > /sys/class/gpio/export
    #echo 191 > /sys/class/gpio/export
    #echo 1 > /sys/class/gpio/gpio176/active_low #SFP+0 ABS
    #echo 1 > /sys/class/gpio/gpio177/active_low #SFP+1 ABS
    #echo 1 > /sys/class/gpio/gpio178/active_low #SFP+0 TX_FAULT
    #echo 1 > /sys/class/gpio/gpio179/active_low #SFP+1 TX_FAULT
    #echo out > /sys/class/gpio/gpio180/direction #SFP+0 TX_DIS
    #echo out > /sys/class/gpio/gpio181/direction #SFP+1 TX_DIS
    #echo 1 > /sys/class/gpio/gpio182/active_low #SFP+0 RX_LOS
    #echo 1 > /sys/class/gpio/gpio183/active_low #SFP+1 RX_LOS
    #echo out > /sys/class/gpio/gpio184/direction #SFP+0 RS
    #echo out > /sys/class/gpio/gpio185/direction #SFP+1 RS
    #echo out > /sys/class/gpio/gpio186/direction #SFP+0 TS
    #echo out > /sys/class/gpio/gpio187/direction #SFP+1 TS
    #echo 1 > /sys/class/gpio/gpio188/active_low #N/A
    #echo 1 > /sys/class/gpio/gpio189/active_low #N/A
    #echo 1 > /sys/class/gpio/gpio190/active_low #N/A
    #echo 1 > /sys/class/gpio/gpio191/active_low #N/A

    #LP Mode Port 0-15
    echo "pca9535 0x20" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/new_device
    for i in {160..175};
    do
        echo $i > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio${i}/direction
    done

    #LP Mode Port 16-31
    echo "pca9535 0x21" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/new_device
    for i in {144..159};
    do
        echo $i > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio${i}/direction
    done

    #RST Port 0-15
    echo "pca9535 0x22" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/new_device
    for i in {128..143};
    do
        echo $i > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio${i}/direction
        echo 1 > /sys/class/gpio/gpio${i}/active_low
        echo 0 > /sys/class/gpio/gpio${i}/value
    done

    #RST Port 16-31
    echo "pca9535 0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/new_device
    for i in {112..127};
    do
        echo $i > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio${i}/direction
        echo 1 > /sys/class/gpio/gpio${i}/active_low
        echo 0 > /sys/class/gpio/gpio${i}/value
    done
}

#GPIO DeInit
function _i2c_gpio_deinit {
    echo "0x20" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/delete_device
    echo "0x21" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/delete_device
    echo "0x22" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/delete_device
    echo "0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/delete_device
    echo "0x27" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN4_DEVICE}/delete_device
    echo "0x20" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/delete_device
    echo "0x21" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/delete_device
    echo "0x22" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/delete_device
    echo "0x23" > /sys/bus/i2c/devices/i2c-${NUM_MUX1_CHAN5_DEVICE}/delete_device
}

#TMP75 Init
function _i2c_temp_init {
    echo "lm86 0x4c" > ${PATH_MUX7_CHAN0_DEVICE}/new_device  # ASIC Coretemp and Front MAC
    echo "tmp75 0x4f" > ${PATH_I801_DEVICE}/new_device #CPU Board
    echo "tmp75 0x48" > ${PATH_MUX7_CHAN0_DEVICE}/new_device # Near PSU1
    echo "tmp75 0x4a" > ${PATH_MUX7_CHAN0_DEVICE}/new_device # Rear MAC
    echo "tmp75 0x4b" > ${PATH_MUX7_CHAN0_DEVICE}/new_device # Near Port 32
    echo "tmp75 0x4d" > ${PATH_MUX7_CHAN0_DEVICE}/new_device # Near PSU2
}

#Set FAN Tray LED
function _i2c_led_fan_tray_status_set {
    echo "FAN Tray Status Setup"
    #FAN Status get
    FAN1_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan1_alarm`
    FAN2_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan2_alarm`
    FAN3_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan3_alarm`
    FAN4_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan4_alarm`
    FAN5_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan5_alarm`
    FAN6_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan6_alarm`
    FAN7_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan7_alarm`
    FAN8_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan8_alarm`

    # check if io expander for fan tray exist
    #i2cset -m $mask -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} $i2cAddr $ioPort 0x33
    result=`i2cget -y ${NUM_FRU_MUX_CHAN2_DEVICE} 0x20 0 2>/dev/null`
    err_code=$?
    if [ "$err_code" != "0" ]; then
        echo "fan tray not exist!"
        return
    fi

    if [ "${FAN1_ALARM}" == "0" ] && [ "${FAN2_ALARM}" == "0" ]; then
        FAN_TRAY=1
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=1
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi

    if [ "${FAN3_ALARM}" == "0" ] && [ "${FAN4_ALARM}" == "0" ]; then
	FAN_TRAY=2
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=2
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi

    if [ "${FAN5_ALARM}" == "0" ] && [ "${FAN6_ALARM}" == "0" ]; then
	FAN_TRAY=3
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=3
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi

    if [ "${FAN7_ALARM}" == "0" ] && [ "${FAN8_ALARM}" == "0" ]; then
	FAN_TRAY=4
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    else
	FAN_TRAY=4
	echo "FAN_TRAY${FAN_TRAY}..."
        COLOR_SYS_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
        COLOR_SYS_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_tray_led
    fi
}

#Set FAN LED
function _i2c_led_fan_status_set {
    echo "FAN Status Setup"
    #PSU Status set
    FAN1_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan1_alarm`
    FAN2_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan2_alarm`
    FAN3_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan3_alarm`
    FAN4_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan4_alarm`
    FAN5_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan5_alarm`
    FAN6_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan6_alarm`
    FAN7_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan7_alarm`
    FAN8_ALARM=`cat ${PATH_HWMON_W83795_DEVICE}/device/fan8_alarm`

    echo "led_fan setup..."
    # all fan ok
    if [ "${FAN1_ALARM}" == "0" ] && [ "${FAN2_ALARM}" == "0" ] \
       && [ "${FAN3_ALARM}" == "0" ] && [ "${FAN4_ALARM}" == "0" ] \
       && [ "${FAN5_ALARM}" == "0" ] && [ "${FAN6_ALARM}" == "0" ] \
       && [ "${FAN7_ALARM}" == "0" ] && [ "${FAN8_ALARM}" == "0" ]; then
        COLOR_SYS_LED="green"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_led
    # all fan fail
    elif [  "${FAN1_ALARM}" == "1" ] && [ "${FAN2_ALARM}" == "1" ] \
       && [ "${FAN3_ALARM}" == "1" ] && [ "${FAN4_ALARM}" == "1" ] \
       && [ "${FAN5_ALARM}" == "1" ] && [ "${FAN6_ALARM}" == "1" ] \
       && [ "${FAN7_ALARM}" == "1" ] && [ "${FAN8_ALARM}" == "1" ]; then
        COLOR_SYS_LED="green"
        ONOFF_LED="off"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_led
    # partial fan fail
    else
        COLOR_SYS_LED="amber"
        ONOFF_LED="on"
        echo "${COLOR_SYS_LED} ${ONOFF_LED}"
        _i2c_fan_led
    fi
}

#Set QSFP Port variable
function _qsfp_port_i2c_var_set {
    local port=$1
    case ${port} in
        1|2|3|4|5|6|7|8)
            i2cbus=${NUM_MUX1_CHAN4_DEVICE}
            regAddr=0x20
            dataAddr=0
            eeprombusbase=${NUM_MUX3_CHAN0_DEVICE}
            gpioBase=240
        ;;
        9|10|11|12|13|14|15|16)
            i2cbus=${NUM_MUX1_CHAN4_DEVICE}
            regAddr=0x20
            dataAddr=1
            eeprombusbase=${NUM_MUX4_CHAN0_DEVICE}
            gpioBase=240
        ;;
        17|18|19|20|21|22|23|24)
            i2cbus=${NUM_MUX1_CHAN4_DEVICE}
            regAddr=0x21
            dataAddr=0
            eeprombusbase=${NUM_MUX5_CHAN0_DEVICE}
            gpioBase=$((224 - 16))
        ;;
        25|26|27|28|29|30|31|32)
            i2cbus=${NUM_MUX1_CHAN4_DEVICE}
            regAddr=0x21
            dataAddr=1
            eeprombusbase=${NUM_MUX6_CHAN0_DEVICE}
            gpioBase=$((224 - 16))
        ;;
        33)
            i2cbus=${NUM_MUX1_CHAN7_DEVICE}
            regAddr=0x27
            dataAddr=0
            gpioBase=145
        ;;
        34)
            i2cbus=${NUM_MUX1_CHAN7_DEVICE}
            regAddr=0x27
            dataAddr=1
            gpioBase=143
        ;;
        *)
            echo "Please input 1~34"
        ;;
    esac
}

#Set QSFP Port variable
function _qsfp_eeprom_var_set {
    local port=$1
    if [ ${port} -lt 33 ]; then
        eeprombusidx=$(( ${port} % 8))
        case $eeprombusidx in
            1)
              eeprombus=$(( $eeprombusbase + 1 ))
              eepromAddr=0x50
              ;;
            2)
              eeprombus=$(( $eeprombusbase + 0 ))
              eepromAddr=0x50
              ;;
            3)
              eeprombus=$(( $eeprombusbase + 3 ))
              eepromAddr=0x50
              ;;
            4)
              eeprombus=$(( $eeprombusbase + 2 ))
              eepromAddr=0x50
              ;;
            5)
              eeprombus=$(( $eeprombusbase + 5 ))
              eepromAddr=0x50
              ;;
            6)
              eeprombus=$(( $eeprombusbase + 4 ))
              eepromAddr=0x50
              ;;
            7)
              eeprombus=$(( $eeprombusbase + 7 ))
              eepromAddr=0x50
              ;;
            0)
              eeprombus=$(( $eeprombusbase + 6 ))
              eepromAddr=0x50
              ;;
        esac
    else
        case $port in
        33)
          eeprombus=${NUM_SFP1_DEVICE}
          eepromAddr=0x50
          ;;
        34)
          eeprombus=${NUM_SFP2_DEVICE}
          eepromAddr=0x50
          ;;
        esac
    fi
}

#Get QSFP EEPROM Information
function _i2c_qsfp_eeprom_get {

    _qsfp_port_i2c_var_set ${QSFP_PORT}

    #status: 0 -> Down, 1 -> Up
    status=`cat /sys/class/gpio/gpio$(( $(($gpioBase + (${QSFP_PORT} - 1) ^ 1)) ))/value`
    echo $status

    if [ $status = 0 ]; then
        exit
    fi

    _qsfp_eeprom_var_set ${QSFP_PORT}

    cat ${PATH_SYS_I2C_DEVICES}/$eeprombus-$(printf "%04x" $eepromAddr)/eeprom | hexdump -C
}

#Init QSFP EEPROM
function _i2c_qsfp_eeprom_init {
    echo -n "QSFP EEPROM INIT..."

    #Action check
    action=$1
    if [ -z "${action}" ]; then
        echo "No action, skip"
        return
    elif [ "${action}" != "new" ] && [ "${action}" != "delete" ]; then
        echo "Error action, skip"
        return
    fi

    #Init 1-32 ports EEPROM
    local i
    for i in {1..32};
    do
        _qsfp_port_i2c_var_set ${i}

        _qsfp_eeprom_var_set ${i}

        if [ "${action}" == "new" ] && \
           ! [ -L ${PATH_SYS_I2C_DEVICES}/$eeprombus-$(printf "%04x" $eepromAddr) ]; then
            echo "sff8436 $eepromAddr" > ${PATH_SYS_I2C_DEVICES}/i2c-$eeprombus/new_device
        elif [ "${action}" == "delete" ] && \
             [ -L ${PATH_SYS_I2C_DEVICES}/$eeprombus-$(printf "%04x" $eepromAddr) ]; then
            echo "$eepromAddr" > ${PATH_SYS_I2C_DEVICES}/i2c-$eeprombus/delete_device
        fi
    done
    echo "DONE"
}

#Init Main Board EEPROM
function _i2c_mb_eeprom_init {
    echo -n "Main Board EEPROM INIT..."

    #Action check
    action=$1
    if [ -z "${action}" ]; then
        echo "No action, skip"
        return
    elif [ "${action}" != "new" ] && [ "${action}" != "delete" ]; then
        echo "Error action, skip"
        return
    fi

    #Init CPU EEPROM
    if [ "${action}" == "new" ] && \
           ! [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_I801_DEVICE}-0051 ]; then
        echo "mb_eeprom 0x51" > ${PATH_I801_DEVICE}/new_device
    elif [ "${action}" == "delete" ] && \
           [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_I801_DEVICE}-0051 ]; then
        echo "0x51" > ${PATH_I801_DEVICE}/delete_device
    fi
    #Init MB EEPROM
    if [ "${action}" == "new" ] && \
           ! [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_I801_DEVICE}-0055 ]; then
        echo "mb_eeprom 0x55" > ${PATH_I801_DEVICE}/new_device
    elif [ "${action}" == "delete" ] && \
           [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_I801_DEVICE}-0055 ]; then
        echo "0x55" > ${PATH_I801_DEVICE}/delete_device
    fi
    echo "DONE"
}

#Init SFP EEPROM
function _i2c_sfp_eeprom_init {
    echo -n "SFP EEPROM INIT..."

    #Action check
    action=$1
    if [ -z "${action}" ]; then
        echo "No action, skip"
        return
    elif [ "${action}" != "new" ] && [ "${action}" != "delete" ]; then
        echo "Error action, skip"
        return
    fi

    #Init 1-32 ports EEPROM
    if [ "${action}" == "new" ] && \
       ! [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_SFP1_DEVICE}-0050 ] && \
       ! [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_SFP2_DEVICE}-0050 ]; then
        echo "sff8436 0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_SFP1_DEVICE}/new_device
        echo "sff8436 0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_SFP2_DEVICE}/new_device
    elif [ "${action}" == "delete" ] && \
         [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_SFP1_DEVICE}-0050 ] && \
         [ -L ${PATH_SYS_I2C_DEVICES}/${NUM_SFP2_DEVICE}-0050 ]; then
        echo "0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_SFP1_DEVICE}/delete_device
        echo "0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_SFP2_DEVICE}/delete_device
    fi
    echo "DONE"
}

#Get MotherBoard EEPROM Information
function _i2c_mb_eeprom_get {
    echo "========================================================="
    echo "# Description: I2C MB EEPROM Get..."
    echo "========================================================="

    ## MB EEPROM
    cat ${PATH_SYS_I2C_DEVICES}/${NUM_I801_DEVICE}-0055/eeprom | hexdump -C
    echo "done..."
}

#Get CPU EEPROM Information
function _i2c_cpu_eeprom_get {
    echo "========================================================="
    echo "# Description: I2C MB EEPROM Get..."
    echo "========================================================="

    ## MB EEPROM
    cat ${PATH_SYS_I2C_DEVICES}/${NUM_I801_DEVICE}-0051/eeprom | hexdump -C
    echo "done..."
}

#get QSFP Status
function _i2c_qsfp_status_get {

    _qsfp_port_i2c_var_set ${QSFP_PORT}

    #status: 0 -> Down, 1 -> Up
    status=`cat /sys/class/gpio/gpio$(( $(($gpioBase + (${QSFP_PORT} - 1) ^ 1)) ))/value`
    echo "status=$status"
}

#get QSFP Type
function _i2c_qsfp_type_get {

    _qsfp_port_i2c_var_set ${QSFP_PORT}

    _qsfp_eeprom_var_set ${QSFP_PORT}

    #Get QSFP EEPROM info
    qsfp_info=$(base64 ${PATH_SYS_I2C_DEVICES}/$eeprombus-$(printf "%04x" $eepromAddr)/eeprom)

    identifier=$(echo $qsfp_info | base64 -d -i | hexdump -s 128 -n 1 -e '"%x"')
    connector=$(echo $qsfp_info | base64 -d -i | hexdump -s 130 -n 1 -e '"%x"')
    transceiver=$(echo $qsfp_info | base64 -d -i | hexdump -s 131 -n 1 -e '"%x"')

    echo "identifier=$identifier"
    echo "connector=$connector"
    echo "transceiver=$transceiver"
}

#Get Board Version and Type
function _i2c_board_type_get {
    boardType=`i2cget -y ${NUM_CPLD_DEVICE} 0x33 0x00`
    boardBuildRev=$((($boardType) & 0x03))
    boardHwRev=$((($boardType) >> 2 & 0x03))
    boardId=$((($boardType) >> 4))
    printf "BOARD_ID is 0x%02x, HW Rev %d, Build Rev %d\n" $boardId $boardHwRev $boardBuildRev

}

#Get CPLD Version
function _i2c_cpld_version {
    cpldRev=`i2cget -y ${NUM_CPLD_DEVICE} 0x33 0x01`
    cpldRelease=$((($cpldRev) >> 6 & 0x01))
    cpldVersion=$((($cpldRev) & 0x3F))
    printf "CPLD is %s version(0:RD 1:Release), Revision is 0x%02x\n" $cpldRelease $cpldVersion

}

#Set Port LED behavior
function _i2c_port_led_set {
    local gy_offset=0x0
    local bl_offset=0x0
    local mask=0x0
    if [ "${QSFP_PORT}" == "" ]; then
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi
    case ${QSFP_PORT} in
        1|2|3|4)
          gy_offset=0x80
          bl_offset=0x90
        ;;
        5|6|7|8)
          gy_offset=0x81
          bl_offset=0x90
        ;;
        9|10|11|12)
          gy_offset=0x82
          bl_offset=0x91
        ;;
        13|14|15|16)
          gy_offset=0x83
          bl_offset=0x91
        ;;
        17|18|19|20)
          gy_offset=0x84
          bl_offset=0x92
        ;;
        21|22|23|24)
          gy_offset=0x85
          bl_offset=0x92
        ;;
        25|26|27|28)
          gy_offset=0x86
          bl_offset=0x93
        ;;
        29|30|31|32)
          gy_offset=0x87
          bl_offset=0x93
        ;;
        33)
          gy_offset=0x88
          bl_offset=0x94
          mask=0x01
        ;;
        34)
          gy_offset=0x88
          bl_offset=0x94
          mask=0x02
        ;;
        *)
            echo "Please input 1~34"
        ;;
    esac

    #Set green/yellow/off
    if [ ${QSFP_PORT} -lt 33 ]; then
        mask=$((  0x3  <<  $(( $((${QSFP_PORT} - 0x1))  % 0x4 )) * 0x2 ))
    elif [ ${QSFP_PORT} = 33 ]; then
        value=1
    elif [ ${QSFP_PORT} = 34 ]; then
        value=2
    fi

    if [ ${QSFP_PORT} -lt 33 ]; then
        if [ "${COLOR_PORT_LED}" == "green" ]; then
            i2cset -m $mask -y -r ${NUM_CPLD_DEVICE} 0x33 ${gy_offset} 0x55
        elif [ "${COLOR_PORT_LED}" == "yellow" ]; then
            i2cset -m $mask -y -r ${NUM_CPLD_DEVICE} 0x33 ${gy_offset} 0xaa
        elif [ "${COLOR_PORT_LED}" == "off" ]; then
            i2cset -m $mask -y -r ${NUM_CPLD_DEVICE} 0x33 ${gy_offset} 0x00
            return
        fi
    elif [ ${QSFP_PORT} -ge 33 ]; then
        if [ "${COLOR_PORT_LED}" == "green" ] ||
           [ "${COLOR_PORT_LED}" == "yellow" ]; then
            i2cset -m $mask -y -r ${NUM_CPLD_DEVICE} 0x33 ${gy_offset} $value
        elif [ "${COLOR_PORT_LED}" == "off" ]; then
            i2cset -m $mask -y -r ${NUM_CPLD_DEVICE} 0x33 ${gy_offset} $((! ${value} ))
            return
        fi
    fi

    #Set Blink/Unblink
    if [ ${QSFP_PORT} -lt 33 ]; then
        mask=$((  0x1  <<  $(( $((${QSFP_PORT} - 0x1))  % 0x4 )) ))
    elif [ ${QSFP_PORT} = 33 ]; then
        value=1
    elif [ ${QSFP_PORT} = 34 ]; then
        value=2
    fi

    if [ "${BLINK_LED}" == "blink"  ]; then
        i2cset -m $mask -y -r ${NUM_CPLD_DEVICE} 0x33 ${bl_offset} 0x00
    elif [ "${BLINK_LED}" == "noblink"  ]; then
        i2cset -m $mask -y -r ${NUM_CPLD_DEVICE} 0x33 ${bl_offset} 0xff
    fi

}

#Get PSU EEPROM Information
function _i2c_psu_eeprom_get {
    echo "========================================================="
    echo "# Description: I2C PSU EEPROM Get..."
    echo "========================================================="

    ## modprobe eeprom
    modprobe eeprom
    ## PUS(0) EEPROM
    echo "========PSU1========="
    echo "eeprom 0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_FRU_MUX_CHAN1_DEVICE}/new_device
    cat ${PATH_SYS_I2C_DEVICES}/${NUM_FRU_MUX_CHAN1_DEVICE}-0050/eeprom | hexdump -C
    echo "0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_FRU_MUX_CHAN1_DEVICE}/delete_device

    ## PUS(1) EEPROM
    echo "========PSU2========="
    echo "eeprom 0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_FRU_MUX_CHAN0_DEVICE}/new_device
    cat ${PATH_SYS_I2C_DEVICES}/${NUM_FRU_MUX_CHAN0_DEVICE}-0050/eeprom | hexdump -C
    echo "0x50" > ${PATH_SYS_I2C_DEVICES}/i2c-${NUM_FRU_MUX_CHAN0_DEVICE}/delete_device

    echo "done..."
}

#Set System Status LED
function _i2c_sys_led {

    if [ "${COLOR_SYS_LED}" == "green" ]; then
        # set sys_led_g (0.7) = 1
        output_reg=2
        mask=0x01
        value=0x01
    elif [ "${COLOR_SYS_LED}" == "amber" ]; then
        # set sys_led_g (0.7) = 0
        output_reg=2
        mask=0x01
        value=0x00
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    #apply to io expander
    i2cset -m ${mask} -y ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 2 ${value}
    echo "Done"

}

#Set FAN Tray LED
function _i2c_fan_tray_led {
    case ${FAN_TRAY} in
        1)
            i2cAddr=0x20
            ioPort=2
            if [ "${COLOR_SYS_LED}" == "green" ]; then
                mask=0x01
            elif [ "${COLOR_SYS_LED}" == "amber" ]; then
                mask=0x02
            fi
            ;;
        2)
            i2cAddr=0x20
            ioPort=2
            if [ "${COLOR_SYS_LED}" == "green" ]; then
                mask=0x10
            elif [ "${COLOR_SYS_LED}" == "amber" ]; then
                mask=0x20
            fi
            ;;
        3)
            i2cAddr=0x20
            ioPort=3
            if [ "${COLOR_SYS_LED}" == "green" ]; then
                mask=0x01
            elif [ "${COLOR_SYS_LED}" == "amber" ]; then
                mask=0x02
            fi
            ;;
        4)
            i2cAddr=0x20
            ioPort=3
            if [ "${COLOR_SYS_LED}" == "green" ]; then
                mask=0x10
            elif [ "${COLOR_SYS_LED}" == "amber" ]; then
                mask=0x20
            fi
            ;;
        *)
            echo "Please input 1~4"
            exit
        ;;
    esac

    if [ "${COLOR_SYS_LED}" == "green" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m $mask -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} $i2cAddr $ioPort 0x33
    elif [ "${COLOR_SYS_LED}" == "green" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m $mask -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} $i2cAddr $ioPort 0x00
    elif [ "${COLOR_SYS_LED}" == "amber" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m $mask -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} $i2cAddr $ioPort 0x33
    elif [ "${COLOR_SYS_LED}" == "amber" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m $mask -y -r ${NUM_FRU_MUX_CHAN2_DEVICE} $i2cAddr $ioPort 0x00
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    echo "done..."
}

#Set FAN LED
function _i2c_fan_led {
    if [ "${COLOR_SYS_LED}" == "green" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x06 -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 2 0x02
    elif [ "${COLOR_SYS_LED}" == "green" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x06 -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 2 0x00
    elif [ "${COLOR_SYS_LED}" == "amber" ] && [ "${ONOFF_LED}" == "on" ]; then
        i2cset -m 0x06 -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 2 0x06
    elif [ "${COLOR_SYS_LED}" == "amber" ] && [ "${ONOFF_LED}" == "off" ]; then
        i2cset -m 0x06 -y -r ${NUM_MAIN_MUX_CHAN1_DEVICE} 0x75 2 0x00
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    echo "done..."
}


#Get PSU Status
function _i2c_psu_status {
    psuStat=`i2cget -y ${NUM_I801_DEVICE} 0x25 0x00`
    psu2PwGood=$(($((($psuStat) & 0x01))?1:0)) # PSU0_PWROK (0.0)
    psu2Exist=$(($((($psuStat) >> 1 & 0x01))?0:1)) # PSU0_PRSNT_L (0.1)

    psu1PwGood=$(($((($psuStat) >> 3 & 0x01))?1:0)) # PSU1_PWROK (0.3)
    psu1Exist=$(($((($psuStat) >> 4 & 0x01))?0:1)) # PSU1_PRSNT_L (0.4)
    printf "PSU1 Exist:%x PSU1 PW Good:%d\n" $psu1Exist $psu1PwGood
    printf "PSU2 Exist:%d PSU2 PW Good:%d\n" $psu2Exist $psu2PwGood
}


#Main Function
function _main {
    start_time_str=`date`
    start_time_sec=$(date +%s)

    if [ "${EXEC_FUNC}" == "help" ]; then
        _help
    elif [ "${EXEC_FUNC}" == "i2c_init" ]; then
        _i2c_init
    elif [ "${EXEC_FUNC}" == "i2c_deinit" ]; then
        _i2c_deinit
    elif [ "${EXEC_FUNC}" == "i2c_temp_init" ]; then
        _i2c_temp_init
    elif [ "${EXEC_FUNC}" == "i2c_fan_init" ]; then
        _i2c_fan_init
    elif [ "${EXEC_FUNC}" == "i2c_volmon_init" ]; then
        _i2c_volmon_init
    elif [ "${EXEC_FUNC}" == "i2c_io_exp_init" ]; then
        _i2c_io_exp_init
    elif [ "${EXEC_FUNC}" == "i2c_gpio_init" ]; then
        _i2c_gpio_init
    elif [ "${EXEC_FUNC}" == "i2c_gpio_deinit" ]; then
        _i2c_gpio_deinit
    elif [ "${EXEC_FUNC}" == "i2c_temp_init" ]; then
        _i2c_temp_init
    elif [ "${EXEC_FUNC}" == "i2c_mb_eeprom_get" ]; then
        _i2c_mb_eeprom_get
    elif [ "${EXEC_FUNC}" == "i2c_cpu_eeprom_get" ]; then
        _i2c_cpu_eeprom_get
    elif [ "${EXEC_FUNC}" == "i2c_psu_eeprom_get" ]; then
        _i2c_psu_eeprom_get
    elif [ "${EXEC_FUNC}" == "i2c_qsfp_eeprom_get" ]; then
        _i2c_qsfp_eeprom_get
    elif [ "${EXEC_FUNC}" == "i2c_qsfp_eeprom_init" ]; then
        _i2c_qsfp_eeprom_init ${QSFP_ACTION}
    elif [ "${EXEC_FUNC}" == "i2c_sfp_eeprom_init" ]; then
        _i2c_sfp_eeprom_init ${QSFP_ACTION}
    elif [ "${EXEC_FUNC}" == "i2c_mb_eeprom_init" ]; then
        _i2c_mb_eeprom_init ${MB_EEPROM_ACTION}
    elif [ "${EXEC_FUNC}" == "i2c_qsfp_status_get" ]; then
        _i2c_qsfp_status_get
    elif [ "${EXEC_FUNC}" == "i2c_qsfp_type_get" ]; then
        _i2c_qsfp_type_get
    elif [ "${EXEC_FUNC}" == "i2c_led_fan_status_set" ]; then
        _i2c_led_fan_status_set
    elif [ "${EXEC_FUNC}" == "i2c_led_fan_tray_status_set" ]; then
        _i2c_led_fan_tray_status_set
    elif [ "${EXEC_FUNC}" == "i2c_sys_led" ]; then
        _i2c_sys_led
    elif [ "${EXEC_FUNC}" == "i2c_fan_led" ]; then
        _i2c_fan_led
    elif [ "${EXEC_FUNC}" == "i2c_fan_tray_led" ]; then
        _i2c_fan_tray_led
    elif [ "${EXEC_FUNC}" == "i2c_board_type_get" ]; then
        _i2c_board_type_get
    elif [ "${EXEC_FUNC}" == "i2c_cpld_version" ]; then
        _i2c_cpld_version
    elif [ "${EXEC_FUNC}" == "i2c_psu_status" ]; then
        _i2c_psu_status
    elif [ "${EXEC_FUNC}" == "i2c_port_led_set" ]; then
        _i2c_port_led_set
    elif [ "${EXEC_FUNC}" == "i2c_test_all" ]; then
        _i2c_init
        _i2c_temp_init
        _i2c_fan_init
        _i2c_io_exp_init
        _i2c_psu_eeprom_get
        _i2c_mb_eeprom_get
        _i2c_cpu_eeprom_get
        _i2c_board_type_get
        _i2c_cpld_version
        _i2c_psu_status
    else
        echo "Invalid Parameters, Exit!!!"
        _help
        exit ${FALSE}
    fi

    end_time_str=`date`
    end_time_sec=$(date +%s)
    diff_time=$[ ${end_time_sec} - ${start_time_sec} ]
    echo "Start Time: ${start_time_str} (${start_time_sec})"
    echo "End Time  : ${end_time_str} (${end_time_sec})"
    echo "Total Execution Time: ${diff_time} sec"

    echo "done!!!"
}

_main
