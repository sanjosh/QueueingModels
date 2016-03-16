
require(pdq)

lookup_job <- "LookupJob"

# All operations in microsec
SetTUnit("usec")

# want to support 128K ops/sec
lookup_throughput <- 128000/1000000

lookup_cpu_time <- 400 # microsec
lookup_ssd_time <- 25 # microsec

CPU <- "CPU"
SSD <- "SSD"

modelName <- "Offload Node"
pdq::Init(modelName)

# Create traffic stream
CreateOpen(lookup_job, lookup_throughput)

# Create M/M/64 node to model 64 CPU cores 
CreateMultiNode(64, CPU, CEN, FCFS)

# Create M/M/8 node to model 8 SSDs of 2.5 TB = 20TB
CreateMultiNode(8, SSD, CEN, FCFS)

# Set service demand made by each job on each system resource
SetDemand(CPU, lookup_job, lookup_cpu_time)
SetDemand(SSD, lookup_job, lookup_ssd_time)

# Only CANON method supported for open queues
Solve(CANON)

Report()
