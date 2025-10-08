# sbelong

----------------------------------

*sbelong* is a simple wrapper around *sinfo* that allows one to visualize which nodes belong to which partitions in a table.
It exists because our end-users wanted a simple way to see which nodes were in which partition on our Slurm cluster.

To remove specific nodes or partitions from the output, add the undesired node/partition names to a list and then serialize that list to a JSON
file.  

Set the shell environment variable SBELONG_PARTITION_DENY to the path for the JSON file containing the list of partitions to remove from the output.
Set the shell environment variable SBELONG_NODE_DENY to the path for the JSON file containing the list of nodes to remove from the output.
