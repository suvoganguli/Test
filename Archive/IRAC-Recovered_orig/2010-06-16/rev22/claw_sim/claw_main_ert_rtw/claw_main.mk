# Copyright 1994-2008 The MathWorks, Inc.
#
# File    : ert_lcc.tmf   $Revision: 1.26.4.40 $
#
# Abstract:
#       Real-Time Workshop template makefile for building a PC-based
#       stand-alone embedded real-time version of Simulink model using
#       generated C code and 
#			LCC compiler Version 2.4
#
#       This makefile attempts to conform to the guidelines specified in the
#       IEEE Std 1003.2-1992 (POSIX) standard. It is designed to be used
#       with GNU Make (gmake) which is located in matlabroot/bin/win32.
#
#       Note that this template is automatically customized by the Real-Time
#       Workshop build procedure to create "<model>.mk"
#
#       The following defines can be used to modify the behavior of the
#       build:
#         OPT_OPTS       - Optimization options. Default is none. To enable 
#                          debugging specify as OPT_OPTS=-g4. 
#         OPTS           - User specific compile options.
#         USER_SRCS      - Additional user sources, such as files needed by
#                          S-functions.
#         USER_INCLUDES  - Additional include paths 
#                          (i.e. USER_INCLUDES="-Iwhere-ever -Iwhere-ever2")
#                          (For Lcc, have a '/'as file seperator before the 
#                          file name instead of a '\' . 
#                          i.e.,  d:\work\proj1/myfile.c - reqd for 'gmake')
#       This template makefile is designed to be used with a system target
#       file that contains 'rtwgensettings.BuildDirSuffix' see ert.tlc


#------------------------ Macros read by make_rtw ------------------------------
#
# The following macros are read by the Real-Time Workshop build procedure:
#
#  MAKECMD         - This is the command used to invoke the make utility
#  HOST            - What platform this template makefile is targeted for
#                    (i.e. PC or UNIX)
#  BUILD           - Invoke make from the Real-Time Workshop build procedure
#                    (yes/no)?
#  SYS_TARGET_FILE - Name of system target file.

MAKECMD         = "%MATLAB%\bin\win32\gmake"
SHELL           = cmd
HOST            = PC
BUILD           = yes
SYS_TARGET_FILE = any
COMPILER_TOOL_CHAIN = lcc

MAKEFILE_FILESEP = /

#---------------------- Tokens expanded by make_rtw ----------------------------
#
# The following tokens, when wrapped with "|>" and "<|" are expanded by the
# Real-Time Workshop build procedure.
#
#  MODEL_NAME          - Name of the Simulink block diagram
#  MODEL_MODULES       - Any additional generated source modules
#  MAKEFILE_NAME       - Name of makefile created from template makefile <model>.mk
#  MATLAB_ROOT         - Path to were MATLAB is installed.
#  MATLAB_BIN          - Path to MATLAB executable.
#  S_FUNCTIONS         - List of additional S-function modules.
#  S_FUNCTIONS_LIB     - List of S-functions libraries to link. 
#  NUMST               - Number of sample times
#  NCSTATES            - Number of continuous states
#  BUILDARGS           - Options passed in at the command line.
#  MULTITASKING        - yes (1) or no (0): Is solver mode multitasking
#  INTEGER_CODE        - yes (1) or no (0): Is generated code purely integer
#  MAT_FILE            - yes (1) or no (0): Should mat file logging be done,
#                        if 0, the generated code runs indefinitely
#  EXT_MODE            - yes (1) or no (0): Build for external mode
#  TMW_EXTMODE_TESTING - yes (1) or no (0): Build ext_test.c for external mode
#                        testing.
#  EXTMODE_TRANSPORT   - Index of transport mechanism (e.g. tcpip, serial) for extmode
#  EXTMODE_STATIC      - yes (1) or no (0): Use static instead of dynamic mem alloc.
#  EXTMODE_STATIC_SIZE - Size of static memory allocation buffer.
#  MULTI_INSTANCE_CODE - Is the generated code multi instantiable (1/0)?
#  PORTABLE_WORDSIZES  - Is this build intented for SIL simulation with portable word sizes (1/0)?
#  SHRLIBTARGET        - Is this build intended for generation of a shared library instead 
#                        of executable (1/0)?
#  MAKEFILEBUILDER_TGT - Is this build performed by the MakefileBuilder class
#                        e.g. to create a PIL executable?

MODEL                = claw_main
MODULES              = claw_main_data.c rtGetInf.c rtGetNaN.c rt_atan2_snf.c rt_backsubrr_dbl.c rt_forwardsubrr_dbl.c rt_hypot_snf.c rt_lu_real.c rt_matdivrr_dbl.c rt_nonfinite.c rt_pow_snf.c smn_sfunc_gam_mpass_epsposdef_wrapper.c ch_smn_wrapper.c axpy_0ir20_1r20_1r.c axpy_0ir3_1r3_1r.c better_lam_bi_0rrrrrr.c better_lam_lo_0rrr.c compute_dgamma_0r3_3r3_1r3_1r3_1rii.c compute_eta_0i20_1r20_1r20_1r.c compute_gamma_0i20_1r20_1r.c compute_u_0r3_3r20_3r3_1r3_1riir.c controlh_types.c dot_0i20_1r20_1r.c dot_0i3_1r3_1r.c get_lam_bisect_0rrrr3_3r20_3r3_1r3_1r20_1r20_1rii.c get_unlwp_03_20r3_1r20_1r20_20riir.c get_wpplusnp_03_20r3_1r20_1r20_20r3_1rii.c ins_real_matrix_self.c interp_u_gamma_020_1r20_1r20_1ri.c mach_process_0_params_gv_0.c posdeffac_020_20rir.c posdeffac_03_3rir.c posdefsol_020_20r20_1riir.c posdefsol_020_20r20_3riir.c posdefsol_03_3r3_1riir.c round_real_matrix.c semn_03_20r3_1r3_1r20_1r20_20r20_1r20_1rrii.c smn_03_20r3_1r20_1r20_1r3_1r20_1r20_20r.c spmn_03_20r3_1r20_1r20_1r3_1r20_1r20_20rrii.c 
MAKEFILE             = claw_main.mk
MATLAB_ROOT          = C:/Program Files/MATLAB/R2008b
ALT_MATLAB_ROOT      = C:/PROGRA~1/MATLAB/R2008b
MATLAB_BIN           = C:/Program Files/MATLAB/R2008b/bin
ALT_MATLAB_BIN       = C:/PROGRA~1/MATLAB/R2008b/bin
S_FUNCTIONS          = 
S_FUNCTIONS_LIB      = 
NUMST                = 1
NCSTATES             = 0
BUILDARGS            =  GENERATE_REPORT=0 GENERATE_ASAP2=0
MULTITASKING         = 0
INTEGER_CODE         = 0
MAT_FILE             = 0
ONESTEPFCN           = 1
TERMFCN              = 1
B_ERTSFCN            = 0
MEXEXT               = mexw32
EXT_MODE             = 0
TMW_EXTMODE_TESTING  = 0
EXTMODE_TRANSPORT    = 0
EXTMODE_STATIC       = 0
EXTMODE_STATIC_SIZE  = 1000000
MULTI_INSTANCE_CODE  = 0
MODELREFS            = 
SHARED_SRC           = 
SHARED_SRC_DIR       = 
SHARED_BIN_DIR       = 
SHARED_LIB           = 
MEX_OPT_FILE         = -f D:/DOCUME~1/E183308/APPLIC~1/MATHWO~1/MATLAB/R2008b/mexopts.bat
PORTABLE_WORDSIZES   = 0
SHRLIBTARGET         = 0
MAKEFILEBUILDER_TGT  = 0
OPTIMIZATION_FLAGS   = 
ADDITIONAL_LDFLAGS   = 

#--------------------------- Model and reference models -----------------------
MODELLIB                  = claw_mainlib.lib
MODELREF_LINK_LIBS        = 
MODELREF_LINK_RSPFILE     = claw_main_ref.rsp
MODELREF_INC_PATH         = 
RELATIVE_PATH_TO_ANCHOR   = ..
# NONE: standalone, SIM: modelref sim, RTW: modelref rtw
MODELREF_TARGET_TYPE       = NONE

#-- In the case when directory name contains space ---
ifneq ($(MATLAB_ROOT),$(ALT_MATLAB_ROOT))
MATLAB_ROOT := $(ALT_MATLAB_ROOT)
endif
ifneq ($(MATLAB_BIN),$(ALT_MATLAB_BIN))
MATLAB_BIN := $(ALT_MATLAB_BIN)
endif

#----------------------------- External mode -----------------------------------
# Uncomment -DVERBOSE to have information printed to stdout
# To add a new transport layer, see the comments in
#   <matlabroot>/toolbox/simulink/simulink/extmode_transports.m
ifeq ($(EXT_MODE),1)
  EXT_CC_OPTS = -DEXT_MODE -DWIN32 # -DVERBOSE
  ifeq ($(EXTMODE_TRANSPORT),0) #tcpip
    EXT_SRC = ext_svr.c updown.c ext_work.c rtiostream_interface.c rtiostream_tcpip.c
    EXT_LIB = $(MATLAB_ROOT)\sys\lcc\lib\wsock32.lib
  endif
  ifeq ($(EXTMODE_TRANSPORT),1) #serial_win32
    EXT_SRC  = ext_svr.c updown.c ext_work.c ext_svr_serial_transport.c
    EXT_SRC += ext_serial_pkt.c ext_serial_win32_port.c
  endif
  ifeq ($(TMW_EXTMODE_TESTING),1)
    EXT_SRC     += ext_test.c
    EXT_CC_OPTS += -DTMW_EXTMODE_TESTING
  endif
  ifeq ($(EXTMODE_STATIC),1)
    EXT_SRC     += mem_mgr.c
    EXT_CC_OPTS += -DEXTMODE_STATIC -DEXTMODE_STATIC_SIZE=$(EXTMODE_STATIC_SIZE)
  endif
endif

#--------------------------- Tool Specifications -------------------------------

LCC = $(MATLAB_ROOT)\sys\lcc
include $(MATLAB_ROOT)\rtw\c\tools\lcctools.mak

# Determine if we are generating an s-function
SFCN = 0
ifeq ($(MODELREF_TARGET_TYPE),SIM)
  SFCN = 1
endif
ifeq ($(B_ERTSFCN),1)
  SFCN = 1
endif

#------------------------------ Include Path -----------------------------------

# Additional includes 

ADD_INCLUDES = \
	-ID:/Projects/2003-2~1/IRAC-L~1/users/suvo/TechWork/2010/2010-0~3/rev22/claw_sim/CLAW_M~4 \
	-ID:/Projects/2003-2~1/IRAC-L~1/users/suvo/TechWork/2010/2010-0~3/rev22/claw_sim \
	-IP:/oav-unix/FlightControl/MACH/smn/smn_sfunc_gam_mpass_epsposdef/c_code_smn \


# see MATLAB_INCLUDES and COMPILER_INCLUDES from lcctool.mak

SHARED_INCLUDES =
ifneq ($(SHARED_SRC_DIR),)
SHARED_INCLUDES = -I$(SHARED_SRC_DIR) 
endif

INCLUDES = -I. -I$(RELATIVE_PATH_TO_ANCHOR) $(MATLAB_INCLUDES) $(ADD_INCLUDES) \
           $(COMPILER_INCLUDES) $(USER_INCLUDES) $(MODELREF_INC_PATH) \
           $(SHARED_INCLUDES)

INCLUDES += -I$(MATLAB_ROOT)\rtw\c\ert

#-------------------------------- C Flags --------------------------------------

# Optimization Options
OPT_OPTS = $(DEFAULT_OPT_OPTS)

# General User Options
OPTS =

# Compiler options, etc:
ifneq ($(OPTIMIZATION_FLAGS),)
CC_OPTS = $(OPTS) $(ANSI_OPTS) $(EXT_CC_OPTS) $(OPTIMIZATION_FLAGS)
MEX_OPT_OPTS = OPTIMFLAGS="$(OPTIMIZATION_FLAGS)"
else
CC_OPTS = $(OPT_OPTS) $(OPTS) $(ANSI_OPTS) $(EXT_CC_OPTS)
MEX_OPT_OPTS = $(OPT_OPTS)
endif

CPP_REQ_DEFINES = -DMODEL=$(MODEL) -DNUMST=$(NUMST) -DNCSTATES=$(NCSTATES) \
		  -DMAT_FILE=$(MAT_FILE) -DINTEGER_CODE=$(INTEGER_CODE) \
		  -DONESTEPFCN=$(ONESTEPFCN) -DTERMFCN=$(TERMFCN) \
		  -DHAVESTDIO -DMULTI_INSTANCE_CODE=$(MULTI_INSTANCE_CODE)

ifeq ($(MODELREF_TARGET_TYPE),SIM)
CPP_REQ_DEFINES += -DMDL_REF_SIM_TGT=1
else
CPP_REQ_DEFINES += -DMT=$(MULTITASKING)
endif

ifeq ($(PORTABLE_WORDSIZES),1)
CPP_REQ_DEFINES += -DPORTABLE_WORDSIZES
endif

CFLAGS = $(CC_OPTS) $(CPP_REQ_DEFINES) $(INCLUDES) -w -noregistrylookup 

ifeq ($(OPT_OPTS),$(DEFAULT_OPT_OPTS))
LDFLAGS = -s -L$(LIB)
else
LDFLAGS = -L$(LIB)
endif

ifneq ($(ADDITIONAL_LDFLAGS),)
MEX_LDFLAGS = LINKFLAGS="$$LINKFLAGS $(ADDITIONAL_LDFLAGS)"
else
MEX_LDFLAGS =
endif

#-------------------------- Additional Libraries ------------------------------

LIBS =


LIBS += $(EXT_LIB) $(S_FUNCTIONS_LIB)

ifeq ($(SFCN),1)
LIBFIXPT = $(MATLAB_ROOT)\extern\lib\win32\lcc\libfixedpoint.lib
LIBS += $(LIBFIXPT)
endif

ifeq ($(MODELREF_TARGET_TYPE),SIM)
LIBMWMATHUTIL = $(MATLAB_ROOT)\extern\lib\win32\lcc\libmwmathutil.lib
LIBS += $(LIBMWMATHUTIL)
endif


#----------------------------- Source Files ------------------------------------
ADD_SRCS =

ifeq ($(SFCN),0)
  SRCS  = $(MODULES) $(ADD_SRCS) $(S_FUNCTIONS)
  SRC_DEP =
  ifeq ($(MODELREF_TARGET_TYPE), NONE)
    ifeq ($(SHRLIBTARGET),1)
#--- Shared library target (.dll) ---
      PRODUCT            = $(RELATIVE_PATH_TO_ANCHOR)/$(MODEL)_win32.dll
      BIN_SETTING        = $(LD) $(LDFLAGS) $(ADDITIONAL_LDFLAGS) -dll -o $(PRODUCT) $(SYSLIBS) 
      BUILD_PRODUCT_TYPE = dynamically linked library
      SRCS               += $(MODEL).c lcc_dll_main.c $(EXT_SRC) 
    else
      ifeq ($(MAKEFILEBUILDER_TGT),1)
        PRODUCT            = $(MODEL).exe
        BIN_SETTING        =  $(LD) $(LDFLAGS) $(ADDITIONAL_LDFLAGS) -o $(PRODUCT) $(SYSLIBS) 
        BUILD_PRODUCT_TYPE = executable
      else
#--- Stand-alone model (.exe) ---
        PRODUCT            = $(RELATIVE_PATH_TO_ANCHOR)/$(MODEL).exe
        BIN_SETTING        = $(LD) $(LDFLAGS) $(ADDITIONAL_LDFLAGS) -o $(PRODUCT) $(SYSLIBS) 
        BUILD_PRODUCT_TYPE = executable
        SRCS               += $(MODEL).c ert_main.c $(EXT_SRC)
      endif
    endif
  else
    # Model reference rtw target
    PRODUCT            = $(MODELLIB)
    BUILD_PRODUCT_TYPE = library
  endif
else
  ifeq ($(MODELREF_TARGET_TYPE), SIM)
  PRODUCT            = $(RELATIVE_PATH_TO_ANCHOR)/$(MODEL)_msf.$(MEXEXT)
  RTW_SFUN_SRC       = $(MODEL)_msf.c
  SRCS               = $(MODULES) $(ADD_SRCS)
  else
  PRODUCT            = $(RELATIVE_PATH_TO_ANCHOR)/$(MODEL)_sf.$(MEXEXT)
  RTW_SFUN_SRC       = $(MODEL)_sf.c
  SRCS               = $(MODULES) $(ADD_SRCS) $(S_FUNCTIONS)
  BIN_SETTING        = $(MATLAB_BIN)\mex.bat $(MEX_OPT_OPTS) -win32 $(MEX_LDFLAGS) $(RTW_SFUN_SRC) $(MEX_OPT_FILE) $(INCLUDES) -outdir $(RELATIVE_PATH_TO_ANCHOR) 
  endif  
  BUILD_PRODUCT_TYPE = mex file
  ifeq ($(B_ERTSFCN),1)
    SRCS              += $(MODEL).c    
  endif
  SRC_DEP            = $(RTW_SFUN_SRC)
endif

USER_SRCS =

USER_OBJS       = $(USER_SRCS:.c=.obj)
LOCAL_USER_OBJS = $(notdir $(USER_OBJS))

OBJS      = $(SRCS:.c=.obj) $(USER_OBJS)
LINK_OBJS = $(SRCS:.c=.obj) $(LOCAL_USER_OBJS)

SHARED_OBJS := $(addsuffix .obj, $(basename $(wildcard $(SHARED_SRC))))
FMT_SHARED_OBJS = $(subst /,\,$(SHARED_OBJS))

#--------------------------------- Rules ---------------------------------------
ifeq ($(MODELREF_TARGET_TYPE),NONE)
  ifeq ($(SHRLIBTARGET),1)
    $(PRODUCT) : $(OBJS) $(SHARED_LIB) $(LIBS) $(MODELREF_LINK_LIBS)
	$(BIN_SETTING) $(LINK_OBJS) @$(MODELREF_LINK_RSPFILE) $(SHARED_LIB) $(LIBS) $(MODEL).def
#--- Comment out the next line to retain .lib and .exp files ---
	@del $(RELATIVE_PATH_TO_ANCHOR)\$(MODEL)_win32.lib $(RELATIVE_PATH_TO_ANCHOR)\$(MODEL)_win32.exp
	@cmd /C "echo ### Created $(BUILD_PRODUCT_TYPE): $@"
  else
    ifeq ($(MAKEFILEBUILDER_TGT),1)
      $(PRODUCT) : $(OBJS) $(MODELLIB) $(SHARED_LIB) $(LIBS) $(SRC_DEP) $(MODELREF_LINK_LIBS)
	$(BIN_SETTING) $(LINK_OBJS) $(MODELLIB) @$(MODELREF_LINK_RSPFILE) $(SHARED_LIB) $(LIBS)
	@cmd /C "echo ### Created $(BUILD_PRODUCT_TYPE): $@"
    else
      $(PRODUCT) : $(OBJS) $(SHARED_LIB) $(LIBS) $(SRC_DEP) $(MODELREF_LINK_LIBS)
	$(BIN_SETTING) $(LINK_OBJS) @$(MODELREF_LINK_RSPFILE) $(SHARED_LIB) $(LIBS) 
	@cmd /C "echo ### Created $(BUILD_PRODUCT_TYPE): $@"
    endif
  endif
else
 ifeq ($(MODELREF_TARGET_TYPE),SIM)
  $(PRODUCT) : $(OBJS) $(SHARED_LIB) $(LIBS) $(SRC_DEP)
	@if exist $(MODELLIB) del $(MODELLIB)
	$(LIBCMD) /out:$(MODELLIB) $(LINK_OBJS)
	@cmd /C "echo ### Created $(MODELLIB)"
	$(MATLAB_BIN)\mex.bat -win32 $(MEX_LDFLAGS) -c $(RTW_SFUN_SRC) $(MEX_OPT_FILE) $(INCLUDES) 
	$(MATLAB_BIN)\mex.bat -win32 $(MEX_OPT_FILE) $(MEX_LDFLAGS) -outdir $(RELATIVE_PATH_TO_ANCHOR) $(MODEL)_msf.obj $(MODELLIB) @$(MODELREF_LINK_RSPFILE) $(SHARED_LIB) $(LIBS) 
	@cmd /C "echo ### Created $(BUILD_PRODUCT_TYPE): $@"
 else
  $(PRODUCT) : $(OBJS) $(SHARED_LIB) $(SRC_DEP)
	@if exist $(MODELLIB) del $(MODELLIB)
	$(LIBCMD) /out:$(MODELLIB) $(LINK_OBJS)
	@cmd /C "echo ### Created $(MODELLIB)"
	@cmd /C "echo ### Created $(BUILD_PRODUCT_TYPE): $@"
 endif
endif

%.obj : %.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : %.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(RELATIVE_PATH_TO_ANCHOR)/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(RELATIVE_PATH_TO_ANCHOR)/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/ert/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/ert/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/ext_mode/common/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/rtiostream/rtiostreamtcpip/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/rtiostream/rtiostreamtcpip/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/ext_mode/serial/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/ext_mode/serial/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/ext_mode/custom/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/ext_mode/custom/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : P:/oav-unix/FlightControl/MACH/smn/smn_sfunc_gam_mpass_epsposdef/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : P:/oav-unix/FlightControl/MACH/smn/smn_sfunc_gam_mpass_epsposdef/c_code_smn/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<



%.obj : $(MATLAB_ROOT)/rtw/c/src/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : P:/oav-unix/FlightControl/MACH/smn/smn_sfunc_gam_mpass_epsposdef/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : P:/oav-unix/FlightControl/MACH/smn/smn_sfunc_gam_mpass_epsposdef/c_code_smn/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<



%.obj : $(MATLAB_ROOT)/simulink/src/%.c
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

%.obj : $(MATLAB_ROOT)/simulink/src/%.C
	$(CC) -c -Fo$(@F) $(CFLAGS) $<

# Libraries:





#----------------------------- Dependencies ------------------------------------

$(OBJS) : $(MAKEFILE) rtw_proj.tmw

$(SHARED_OBJS) : $(SHARED_BIN_DIR)/%.obj : $(SHARED_SRC_DIR)/%.c  
	$(CC) -c -Fo$@ $(CFLAGS) $<

$(SHARED_LIB) : $(SHARED_OBJS)
	@cmd /C "echo ### Creating $@"
	@if exist $@ del $@
	$(LIBCMD) /out:$@ $(FMT_SHARED_OBJS)
	@cmd /C "echo ### $@ Created"

#--------- Miscellaneous rules to purge, clean and lint (sol2 only) ------------

purge : clean
	@cmd /C "echo ### Deleting the generated source code for $(MODEL)"
	@del $(MODEL).c $(MODEL).h $(MODEL)_types.h $(MODEL)_data.c $(MODEL).rtw \
	        $(MODEL)_private.h $(MODULES) rtw_proj.tmw $(MAKEFILE)

clean :
	@cmd /C "echo ### Deleting the objects and $(PROGRAM)"
	@del $(LINK_OBJS) ..\$(MODEL).exe

# EOF: ert_lcc.tmf
