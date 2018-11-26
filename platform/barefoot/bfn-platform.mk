BFN_PLATFORM = bfnplatform_1.0.0_amd64.deb

ifeq ($(CONFIGURED_P4_STACK),p4_16)
$(BFN_PLATFORM)_PATH = /sonic # use local path, should be changed as soon as we released p4-16 and make pub available
SONIC_COPY_DEBS +=$(BFN_PLATFORM)
else
$(BFN_PLATFORM)_URL =   "https://github.com/barefootnetworks/sonic-release-pkgs/raw/sde-sai1.3.3/bfnplatform_1.0.0_amd64.deb"
SONIC_ONLINE_DEBS += $(BFN_PLATFORM) # $(BFN_SAI_DEV)
endif

$(BFN_SAI_DEV)_DEPENDS += $(BFN_PLATFORM)
