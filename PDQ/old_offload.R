
require(pdq)

BulkInsertJob <- "BulkInsertJob"
LookupJob <- "LookupJob"
ScanJob <- "ScanJob"
CompactionJob <- "CompactionJob"

bulkInsertRate <- 4/1000000
lookupRate <- 128000/1000000
scanRate <- 8
compactionRate <- 1

bulkCPUDemand <- 1000
lookupCPUDemand <- 200
scanCPUDemand <- 2000
compactionCPUDemand <- 5000

bulkSSDDemand <- 20
lookupSSDDemand <- 25
scanSSDDemand <- 10
compactionSSDDemand <- 100

CPU <- "CPU"
SSD <- "SSD"

modelName <- "Offload Node"

pdq::Init("Offload node")

# Create 4 traffic streams
#CreateOpen(BulkInsertJob, bulkInsertRate)
CreateOpen(LookupJob, lookupRate)
#CreateOpen(ScanJob, scanRate)
#CreateOpen(CompactionJob, compactionRate)

# M/M/64 to model 64 core system
CreateMultiNode(64, CPU, CEN, FCFS)

# M/M/8 - to model 8 SSD of 2.5 TB = 20TB
CreateMultiNode(8, SSD, CEN, FCFS)

SetTUnit("usec")

# Input service demand made by each job on each system resource
#SetDemand(CPU, BulkInsertJob, bulkCPUDemand)
SetDemand(CPU, LookupJob, lookupCPUDemand)
#SetDemand(CPU, ScanJob, scanCPUDemand)
#SetDemand(CPU, CompactionJob, compactionCPUDemand)

#SetDemand(SSD, BulkInsertJob, bulkSSDDemand)
SetDemand(SSD, LookupJob, lookupSSDDemand)
#SetDemand(SSD, ScanJob, scanSSDDemand)
#SetDemand(SSD, CompactionJob, compactionSSDDemand)

# Only CANON supported for open queueing networks
Solve(CANON)

Report()
