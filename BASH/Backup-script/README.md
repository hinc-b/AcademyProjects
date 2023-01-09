# Backup task
Bash script, which will be run every day at 8am and it will backup all \*.gz files from /var/log into local directory.

### Description 
Script packs all specified file into one tarball with **.tar**.
Script is automatically executed at 8am each day with crontab.
Execution of backup script creates entry to log file in the same directory where backup files are.
The log file contains the information about date and time of the execution, and number of backed up files.
Log is rotated with logrotate each day, and keep 10 versions.

## Process of backup
Here you can find the **backupscript.sh**, that is also added to crontab.
In order to run the script, do as follows:
```
./backupscript.sh
```

Then, you need to add a cron job to the crontab.
Go to the terminal and type:
```
crontab -e
```

This will open cron configuration file. The structure of every line is:
```
minute hour day-of-month month day-of-week command
```

So to run a command at 8am each day:
```
0 8 * * * /usr/local/gzbackup/backupscript.sh > /dev/null 2>&1
```
**'> /dev/null 2>&1'** redirects the output and the error stream into /dev/null.

Next step is to copy gzbackup_logrotate to /etc/lograte.d directory:
```
cp gzbackup_logrotate /etc/logrotate.d
```

## How to extract tar archive
To extract a tarball, enter:
```
tar -xvf backup.tar -C /
```
**-C /** means that files will be extracted into root directory

## Running the tests
Run below command:
```
tar -tf backup.tar
```
and check if backup contains any files.

## Authors

* **Blazej Hinc** - [Gitlab](https://git.epam.com/blazej_hinc/backup-script-task)
* **Maciej Niemcewicz** - [Gitlab](https://git.epam.com/maciej_niemcewicz/backup_task)


## Acknowledgments

* Hat tip to anyone whose code was used
