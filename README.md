# Checkpatch task 1

Scripts and output files for task 1

## Scripts information

- get_commits.sh
  ```-> get all non merge commits for the linux kernel between versions 5.7 and 5.8.```
- run_checkpatch.pl 
  ```-> runs checkpatch.pl on all the commits found using the previous script.```
- generate_stats.pl
  ```-> aggregates the checkpatch output data to generate some statistical information.```

## Output files
- commits.txt
  ```-> contains all commit hashes and author names for non merge commits between v5.7 and v5.8.```
- checkpatch_out.txt
  ```-> contains checkpatch output data for all the commit hashes in commits.txt.```
- stats.txt
  ```-> contains statistical data generated using generate_stats.pl``` 
