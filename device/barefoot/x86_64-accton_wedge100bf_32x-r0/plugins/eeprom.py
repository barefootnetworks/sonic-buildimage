#!/usr/bin/env python

#############################################################################
#Barefoot Montara/Mavericks
#
# Platform and model specific eeprom subclass, inherits from the base class,
# and provides the followings:
# - the eeprom format definition
# - specific encoder/decoder if there is special need
#############################################################################

try:
    import exceptions
    import binascii
    import time
    import optparse
    import warnings
    import os
    import sys
    import subprocess
    import json
    from sonic_eeprom import eeprom_base
    from sonic_eeprom import eeprom_tlvinfo
except ImportError, e:
    raise ImportError (str(e) + "- required module not found")

eeprom_dict = { "version": ("Version", None, 0 ),
                "pcb_mfger": ("PCB Manufacturer", "0x01", 8),
                "prod_ser_num": ("Serial Number","0x23",12),
                "bfn_pcba_part_num": ("Switch PCBA Part Number","0x02",12),
                "odm_pcba_part_num": ("Part Number","0x22",13),
                "bfn_pcbb_part_num": ("Switch PCBB Part Number","0x04",12),
                "sys_asm_part_num": ("System Assembly Part Number", "0x05", 12),
                "prod_state": ("Product Production State", "0x06", 1),
                "location": ("EEPROM Location of Fabric", "0x07", 8),
                "ext_mac_addr_size": ("Extende MAC Address Size", "0x08", 2),
                "sys_mfg_date": ("System Manufacturing Date", "0x25", 4),
                "prod_name": ("Product Name", "0x21",12),
                "prod_ver": ("Product Version", "0x26", 1),
                "prod_part_num": ("Product Part Number", "0x09", 8),
                "sys_mfger": ("Manufacturer", "0x2B", 8),
                "assembled_at": ("Assembled at","0x08" ,8),
                "prod_ast_tag": ("Product Asset Tag", "0x09", 12),
                "loc_mac_addr": ("Local MAC address", "0x0A",12),
                "crc8": ("CRC8", "0xFE", 1),
                "odm_pcba_ser_num": ("ODM PBCA Serial Number", "0x0B", 12),
                "ext_mac_addr": ("Extended MAC Address Base", "0x0C",12),
                "prod_sub_ver": ("Product Sub Version", "0x0D",1)
              }

product_dict = {"Montara":"Wedge100BF-32X-O-AC-F-BF",
                "Lower MAV":"Wedge100BF-65X-O-AC-F-BF",
                "Upper MAV":"Wedge100BF-65X-O-AC-F-BF"
               }

class board(eeprom_tlvinfo.TlvInfoDecoder, eeprom_base.EepromDecoder):

    """ On BFN platform onie system eeprom is not mapped to sysfs tree """
    def __init__(self, name, path, cpld_root, ro):
        self.eeprom_path = ""
        super(board, self).__init__(self.eeprom_path, 0, '', True)

    def set_cache_name(self,name):
        pass
 
    def update_cache(self,e):
        pass
 
    def write_cache(self,e):
        pass


    def read_eeprom(self):
        cmd = "docker exec -it syncd eeprom read_eeprom"
        output = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        eeprom,err = output.communicate()
        if err != "":
            sys.stderr.write("{0:s}".format(err))
            raise Exception('Runtime Exception')
        else:
            return eeprom


    def base_mac_addr(self,e):
        eeprom = json.loads(e)
        mac = eeprom.get("loc_mac_addr",None)
        if mac is None:
            return "Bad Base Mac Address"
        else:
            return mac

    def serial_number_str(self,e):
        eeprom = json.loads(e)
        serial = eeprom.get("prod_ser_num", None)
        if serial is None:
            return "Bad service tag"
        else:
            return serial

    def decode_eeprom(self,e):
        eeprom = json.loads(e)
        value = ""
        total_len = 0
	tlvHeader = ""
	tlvBody = ""

	tlvHeader += "TlvInfo Header:\n"
	tlvHeader += "    Id String:    TlvInfo\n"
	tlvHeader += "    Version:      {0:d}\n".format(eeprom.get("version",1))

	for attr, val in eeprom.iteritems():
	    if val is not None:
		if isinstance(val, basestring):
		    value = val
		else:
		    value = str(val)
		type, code, tlvlen = eeprom_dict.get(attr)
		if type is not None and tlvlen > 0 and value:
		    product  = product_dict.get(value)
		    if product is not None:
			value = product

		    tlvlen = len(value)
		    if tlvlen > 0:
			total_len += tlvlen
			tlvBody += "{0:s} {1:s} {2:d} {3:s}\n".format(type, code, tlvlen, value)

	tlvHeader += "    Total Length: {0:d}\n".format(total_len)
	tlvHeader += "TLV Name             Len Value\n"
	tlvHeader += "-------------------- --- -----\n"

	sys.stdout.write(tlvHeader)
	sys.stdout.write(tlvBody)

    def is_checksum_valid(self,e):
        # Assumption is checksum verification already done in BMC and correctly parsed and verified information is avail 
        return (True,0)


#    def is_valid_block(self, e):
#        pass
#
#    def is_valid_block_checksum(self, e):
#        pass
#
#    def decoder(self, s, t):
#        pass
#
#    def get_tlv_index(self, e, code):
#        pass
