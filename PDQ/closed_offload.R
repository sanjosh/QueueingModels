
require(pdq)

lookup_job <- "LookupJob"
scan_job <- "ScanJob"
bulkinsert_job <- "BulkInsertJob"
compact_job <- "CompactJob"

# divide by 64 for cpu since we cant have multinode + multiclass
lookup_cpu_time <- 0.005 # microsec
scan_cpu_time <- 0.4 
bulkinsert_cpu_time <- 0.1 
compact_cpu_time <- 0.4 

# divide by 8 for ssd since we cant have multinode + multiclass
lookup_ssd_time <- 0.003 # microsec
scan_ssd_time <- 0.05 
bulkinsert_ssd_time <- 0.01 
compact_ssd_time <- 0.02 


CPU <- "CPU"
SSD <- "SSD"

modelName <- "Offload Node"
pdq::Init(modelName)

# Create traffic stream
CreateClosed(lookup_job, TERM, 128, 0.0)
CreateClosed(scan_job, TERM, 4, 0.0)
CreateClosed(bulkinsert_job, TERM, 8, 0.0)
#CreateClosed(compact_job, TERM, 1, 0.0)

# All operations in microsec
SetTUnit("millisec")

# Create M/M/64 node to model 64 CPU cores 
# CreateMultiNode(64, CPU, CEN, FCFS)
CreateMultiNode(8, CPU, CEN, FCFS)

# Create M/M/8 node to model 8 SSDs of 2.5 TB = 20TB
# CreateMultiNode(8, SSD, CEN, FCFS)
CreateMultiNode(8, SSD, CEN, FCFS)

# Set service demand made by each job on each system resource
SetDemand(CPU, lookup_job, lookup_cpu_time)
SetDemand(CPU, scan_job, scan_cpu_time)
SetDemand(CPU, bulkinsert_job, bulkinsert_cpu_time)
#SetDemand(CPU, compact_job, compact_cpu_time)

SetDemand(SSD, lookup_job, lookup_ssd_time)
SetDemand(SSD, scan_job, scan_ssd_time)
SetDemand(SSD, bulkinsert_job, bulkinsert_ssd_time)
#SetDemand(SSD, compact_job, compact_ssd_time)

pdq::SetDebug(TRUE)

# cant use EXACT or CANON
Solve(APPROX)

Report()
