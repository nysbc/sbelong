#!/usr/bin/env python
from sh import sinfo
from prettytable import PrettyTable

nodes=[node for node in sinfo("-h", o="%n",S="+n").split("\n") if node]
partitions=[partition for partition in sinfo("-h",o="%R",S="+R").split("\n") if partition]

memberships={}

for node in nodes:
    memberships[node]=[]
    for line in [membership for membership in sinfo("-h",o="%R,%n",S="+n",n=node).split("\n") if membership]:
        line=line.split(",")
        if len(line) == 2:
            if line[1].strip() == node:
                memberships[node].append(line[0].strip())

partitions=[partition for partition in partitions if not partition.endswith("-ingest")]
table = PrettyTable()
table.field_names = ["Node Name"] + partitions
for node in nodes:
    table.add_row([node] + [partition in memberships[node] for partition in partitions])

print(table)
