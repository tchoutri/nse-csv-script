NSE CSV script
--------------

This script outputs the data collected by nmap during the scan and outputs them to a CSV file.


Usage:


    nmap --script csv-output --script-args=filename=myscan.csv -p 1-1000 scanme.nmap.org

OR

    nmap -Pn -v0 -A --script csv-output -p 50-5000 leto.p
    hostname,ip,port,protocol,state,service,version
    ,xxx.27.8.7,22,tcp,open,ssh,OpenSSH7.2
