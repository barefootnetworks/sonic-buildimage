# libsaithrift-dev package

LIBSAITHRIFT_DEV_NEPHOS = libsaithrift-dev_1.2.1_amd64.deb
$(LIBSAITHRIFT_DEV_NEPHOS)_SRC_PATH = $(SRC_PATH)/sonic-sairedis/SAI
$(LIBSAITHRIFT_DEV_NEPHOS)_DEPENDS += $(LIBTHRIFT) $(LIBTHRIFT_DEV) $(THRIFT_COMPILER) $(NEPHOS_SAI) $(NEPHOS_SAI_DEV)
$(LIBSAITHRIFT_DEV_NEPHOS)_RDEPENDS += $(LIBTHRIFT) $(NEPHOS_SAI)
SONIC_DPKG_DEBS += $(LIBSAITHRIFT_DEV_NEPHOS)
