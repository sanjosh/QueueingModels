

# we eventually want MCON

require(queueing)

lookup_cpu_throughput = 400 # microsec
lookup_ssd_throughput = 400 * 3 

# lambda = arrival rate
# mu = service rate
# num_server = 
# num_customers = 0
# method to compute num customers in system = 0/1 = exact/approx
cpu_node <- NewInput.MMC(lambda=lookup_cpu_throughput, mu=1, c=64, n=0, method=1)
ssd_node <- NewInput.MMC(lambda=lookup_ssd_throughput, mu=1, c=8, n=0, method=1)

# model <- NewInput.MCON(num_classes, arrival_vector, num_nodes, node_vector, visit_2d_matrix, service_demand_2d_matrix)

CheckInput(x)

soln <- QueueingModel(model)
