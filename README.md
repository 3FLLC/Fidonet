# Fidonet
Nodelist Downloader (automated)

**download_nodelist.p**
* You can run on a daily cron/scheduler task... this will reach out to Filegate.net and download the latest nodelist, and unpack it.

**INA_export.p**
Exports from nodelist all systems with INA address into a POLLLIST.

**POLL_and_LOG.p**
please modify to your INTRO not mine!	Reads everything INA_export.p renerated, and logs everything each of those nodes say in their INTRO. Great to find other FTN networks!
