# sfputil.py
#
# Platform-specific SFP transceiver interface for SONiC
#

import subprocess
import re

try:
    import time
    from sonic_sfp.sfputilbase import SfpUtilBase
except ImportError as e:
    raise ImportError("%s - required module not found" % str(e))

class SfpUtil(SfpUtilBase):
    """Platform-specific SfpUtil class"""

    PORT_START = 0

    @property
    def port_start(self):
        return self.PORT_START

    @property
    def port_end(self):
        cmd = "docker exec -i syncd sfputil get_number_qsfp_ports"
        count=subprocess.Popen(cmd, shell=True,stdout=subprocess.PIPE).stdout.read()
        return int(count.strip())-1

    """ BFN Wedge based platform do not export eeprom info via sysfs path. Hence we skip this"""
    @property
    def port_to_eeprom_mapping(self):
        pass

    def __init__(self):
        SfpUtilBase.__init__(self)

    def get_presence(self, port_num):
        # Check for invalid port_num
        if port_num < self.port_start or port_num > self.port_end:
            return False
        qsfp_port = port_num + 1
        cmd = "docker exec -i syncd sfputil get_presence {0:s}".format(str(qsfp_port))
        presence=subprocess.Popen(cmd, shell=True,stdout=subprocess.PIPE).stdout.read()
        if presence.strip() == "True":
            return True
        else:
            return False

    def get_low_power_mode(self, port_num):
        # Check for invalid port_num
        if port_num < self.port_start or port_num > self.port_end:
            return False
        qsfp_port = port_num + 1
        cmd = "docker exec -i syncd sfputil get_lp_mode {0:s}".format(str(qsfp_port))
        lpmode=subprocess.Popen(cmd, shell=True,stdout=subprocess.PIPE).stdout.read()
        if lpmode.strip() == "True":
            return True
        else:
            return False

    @property
    def qsfp_ports(self):
        return range(self.port_start, self.port_end + 1)

    def reset(self, port_num):
        # Check for invalid port_num
        if port_num < self.port_start or port_num > self.port_end:
            return False
        qsfp_port = port_num + 1
        cmd = "docker exec -i syncd sfputil sfp_reset {0:s}".format(str(qsfp_port))
        output = subprocess.Popen(cmd, shell=True,stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = output.communicate()

        if err != "":
            print "Unable to reset port {0:d} {1:s}".format(port_num, err)
            return False
        else:
            return True
   
    def set_low_power_mode(self, port_num, lpmode):
        # Check for invalid port_num
        if port_num < self.port_start or port_num > self.port_end:
            return False

        if lpmode is True:
            mode = 1
        else:
            mode = 0
        qsfp_port = port_num + 1
        cmd = "docker exec -i syncd sfputil set_low_power_mode {0:s} {1:d}".format(str(qsfp_port),mode)
        output = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out,err = output.communicate()

        if err != "":
            print "Unable to set low power mode {0:s}".format(err)
            return False

        return True

    """ Overrides method get_eeprom_raw of baseclasee SpfUtilBase. This method return data from lower & upper page0"""
    def get_eeprom_raw(self, port_num):
        # Check for invalid port_num
        if port_num < self.port_start or port_num > self.port_end:
            return False
        qsfp_port = port_num + 1
        cmd = "docker exec -i syncd sfputil get_eeprom_raw {0:s}".format(str(qsfp_port))
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        sfp_raw, err = process.communicate()
        if sfp_raw != "":
            raw = re.findall('..?', sfp_raw)
            return raw[:256]
        else:
            return None

    """ Overrides method get_eeprom_raw of baseclasee SpfUtilBase. This method return data from page3"""
    def get_eeprom_dom_raw(self, port_num):
        # Check for invalid port_num
        if port_num < self.port_start or port_num > self.port_end:
            return False
        qsfp_port = port_num + 1
        cmd = "docker exec -i syncd sfputil get_eeprom_raw {0:s}".format(str(qsfp_port))
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        sfp_raw, err = process.communicate()
        if sfp_raw != "":
            raw = re.findall('..?', sfp_raw)
            return raw[256:]
        else:
            return None
