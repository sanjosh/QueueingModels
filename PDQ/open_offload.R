
require(pdq)

lookup_job <- "LookupJob"
scan_job <- "ScanJob"
bulkinsert_job <- "BulkInsertJob"
compact_job <- "CompactJob"

# divide by 1000 to get microsec

lookup_arrival <- 128
scan_arrival <- 8/1000
bulkinsert_arrival <- 4/1000
compact_arrival <- 1/1000

# could use probability transition matrix to simulate 64 cpus
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
CreateOpen(lookup_job, lookup_arrival)
CreateOpen(scan_job, scan_arrival)
CreateOpen(bulkinsert_job, bulkinsert_arrival)
CreateOpen(compact_job, compact_arrival)

# All operations in microsec
SetTUnit("millisec")

# Create M/M/64 node to model 64 CPU cores 
# CreateMultiNode(64, CPU, CEN, FCFS)
CreateNode(CPU, CEN, FCFS)

# Create M/M/8 node to model 8 SSDs of 2.5 TB = 20TB
# CreateMultiNode(8, SSD, CEN, FCFS)
CreateNode(SSD, CEN, FCFS)

# Set service demand made by each job on each system resource
SetDemand(CPU, lookup_job, lookup_cpu_time)
SetDemand(CPU, scan_job, scan_cpu_time)
SetDemand(CPU, bulkinsert_job, bulkinsert_cpu_time)
SetDemand(CPU, compact_job, compact_cpu_time)

SetDemand(SSD, lookup_job, lookup_ssd_time)
SetDemand(SSD, scan_job, scan_ssd_time)
SetDemand(SSD, bulkinsert_job, bulkinsert_ssd_time)
SetDemand(SSD, compact_job, compact_ssd_time)

# Only CANON method supported for open queues
Solve(CANON)

Report()
