#!../../bin/linux-x86_64/WS3122

#< envPaths

require ws3000,0.0.1
require iocStats,1856ef5
require autosave,5.9.0

epicsEnvSet("IOC","iocws3122")


#epicsEnvSet("EPICS_CAS_INTF_ADDR_LIST" "10.0.7.1")

epicsEnvSet(P, "usbtmc")
epicsEnvSet(R, "icslab")
epicsEnvSet(USBTMCPORT, "usbtmc0")
epicsEnvSet(WS3122PORT, "WS3122" )

#dbLoadDatabase "dbd/WS3122.dbd"
#WS3122_registerRecordDeviceDriver pdbbase

# Bus 001 Device 084: ID 05ff:0a21 LeCroy Corp.
epicsEnvSet(vendorNum,  "05ff")
epicsEnvSet(productNum, "0a21")


# usbtmcConfigure(port, vendorNum, productNum, serialNumberStr, priority, flags)
usbtmcConfigure("$(USBTMCPORT)", "0x$(vendorNum)", "0x$(productNum)")

# 
drvWS3122Configure("$(WS3122PORT)", "$(USBTMCPORT)")

dbLoadRecords("asynRecord.db", "P=$(P), R=$(R),  PORT=$(USBTMCPORT), ADDR=0, OMAX=100,IMAX=100")

dbLoadRecords("WS3122Base.db", "P=$(P):,R=$(R):, PORT=$(WS3122PORT)")
dbLoadRecords("BasicWave.db",  "P=$(P):,R=$(R):, PORT=$(WS3122PORT)")
dbLoadRecords("BurstWave.db",  "P=$(P):,R=$(R):, PORT=$(WS3122PORT)")
dbLoadRecords("WS3122Cmds.db", "P=$(P):,R=$(R):, PORT=$(WS3122PORT)")

dbLoadRecords("iocAdminSoft.db", "IOC=$(P):$(R):IocStats")


< save_restore_before_init.cmd

iocInit

< save_restore_after_init.cmd

dbl > "${IOC}_PVs.list"

#-< asyn_report.cmd

#-< asyn_db.cmd

#- Twice the commands
#- caput usbtmc:icslab:DevGetIDN 1

#- epics> hello
#- *IDN?
#- hello
#- *IDN?
#- *IDN WST,WaveStation 3122,LCRY3601C00251,5.01.02.13,00-00-00-17-35
