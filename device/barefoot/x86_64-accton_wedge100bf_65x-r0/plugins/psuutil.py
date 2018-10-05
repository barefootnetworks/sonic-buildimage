#
# psuutil.py
# Platform-specific PSU status interface for SONiC
#


import os.path
import subprocess

try:
    from sonic_psu.psu_base import PsuBase
except ImportError as e:
    raise ImportError(str(e) + "- required module not found")


class PsuUtil(PsuBase):
    """Platform-specific PSUutil class"""

    def __init__(self):
        PsuBase.__init__(self)

    def get_num_psus(self):
        """
        Retrieves the number of PSUs available on the device
        :return: An integer, the number of PSUs available on the device
         """
        cmd = "docker exec -it syncd ps_info get_num_psus"
        output = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        num,err = output.communicate()
        if err != "":
            sys.stderr.write("{0:s}".format(err))
            raise Exception('Runtime Exception')
        else:
            return int(num.strip())

    def get_psu_status(self, index):
        """
        Retrieves the oprational status of power supply unit (PSU) defined
                by index <index>
        :param index: An integer, index of the PSU of which to query status
        :return: Boolean, True if PSU is operating properly, False if PSU is\
        faulty
        """

        cmd = "docker exec -it syncd ps_info get_psu_presence {0:d}".format(index)
        output = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out,err = output.communicate()
        if err != "":
            sys.stderr.write("{0:s}".format(err))
            raise Exception('Runtime Exception')
        else:
            if out.strip() == "True":
                presence = True
            else:
                presence = False

        cmd = "docker exec -it syncd ps_info get_psu_status {0:d}".format(index)
        status = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        sout,serr = status.communicate()

        if serr != "":
            sys.stderr.write("{0:s}".format(serr))
            raise Exception('Runtime Exception')
        else:
            if sout.strip() == "True":
                 psu_status = True
            else:
                psu_status = False
       
        return (presence & psu_status)

    def get_psu_presence(self, index):
        """
        Retrieves the presence status of power supply unit (PSU) defined
                by index <index>
        :param index: An integer, index of the PSU of which to query status
        :return: Boolean, True if PSU is plugged, False if not
        """

        cmd = "docker exec -it syncd ps_info get_psu_presence {0:d}".format(index)
        output = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out,err = output.communicate()
        if err != "":
            sys.stderr.write("{0:s}".format(err))
            raise Exception('Runtime Exception')
        else:
            if out.strip() == "True":
                presence = True
            else:
                presence = False

        return presence
