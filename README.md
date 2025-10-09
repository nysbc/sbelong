# sbelong

----------------------------------

`sbelong` is a simple wrapper around `sinfo` that allows one to visualize which nodes belong to which partitions in a table.
It exists because our end-users wanted a simple way to see which nodes were in which partition on our Slurm cluster.

## Configuration

`sbelong` uses a simple JSON file for its configuration.  This JSON file allows you to define block lists to remove certain nodes/partitions
from the output.  It is formatted as a dictionary with two keys: `sbelong_node_deny` and `sbelong_partition_deny` (see the `examples` subdirectory).

To define the configuration file, set the shell environment variable SBELONG_CONF to the path to the JSON file.
