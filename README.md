quickfast

repo for quickfast codecs.

#Install

##1. cd <repo>\win\v1.4\quickfast_1_4_0

##2. fix setup.cmd as following:

REM EDIT THE FOLLOWING LINES OR SET THESE VALUES IN YOUR ENVIRONMENT BEFORE RUNNING SETUP
@echo make sure to use MPC v4.1, config/boost_system.mpb is present
if "a" == "a%MPC_ROOT%" set MPC_ROOT=D:\workspace\github\quickfast\depends\MPC_4_1_0\MPC
if "a" == "a%XERCES_ROOT%" set XERCES_ROOT=D:\workspace\github\quickfast\depends\xerces
if "a" == "a%XERCES_LIBNAME%" set XERCES_LIBNAME=xerces-c_3
if "a" == "a%BOOST_VERSION%" set BOOST_VERSION=boost_1_57_0
if "a" == "a%BOOST_ROOT%" set BOOST_ROOT=D:\workspace\github\quickfast\depends\boost_1_57_0
REM END OF VALUES TO BE SET

##3. in VC command line, execute setup.cmd and m.cmd to generate vc projects.

##4. start QuickFast.sln






