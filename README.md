# RRD_Data_Check
This Script will check your RRA files to ensure there is Data being written to them

The Script is built Around Cacti the script calls on the RRDtool fetch command
then analyzes the amount of time either your enter or by default 10 minutes of data

If checking 10 minutes of data for a 1 minute polling cycle yields 10 NaN values
then the RRD has not recived any data at all and either the Device has been down 
or the RRD file is not reciving data from the datasource this can be used as a QA tool
to ensure your Cacti graphs are working properly especially on large systems where it can 
be hard to keep track of hundreds/thousands of graphs to ensure they are working


### Example Output

```
/var/www/html/cacti/rra/1_1_1_1_active_60.rrd Dead RRD the Last 11 values were NaN
/var/www/html/cacti/rra/1_1_1_6_5min_cpu_134.rrd Dead RRD the Last 11 values were NaN
/var/www/html/cacti/rra/mancini-sw1-test_nonunicast_out_256.rrd Dead RRD the Last 11 values were NaN
/var/www/html/cacti/rra/mancini-sw1-test_traffic_in_130.rrd Dead RRD the Last 11 values were NaN
/var/www/html/cacti/rra/mancini-sw1-test_traffic_in_131.rrd Dead RRD the Last 11 values were NaN
/var/www/html/cacti/rra/mancini-sw1-test_traffic_in_132.rrd Dead RRD the Last 11 values were NaN
/var/www/html/cacti/rra/mancini-sw1-test_traffic_in_133.rrd Dead RRD the Last 11 values were NaN
```
Manually looking at the RRD yields the same data

```
RRD_Data_Check# rrdtool fetch /var/www/html/cacti/rra/mancini-sw1-test_traffic_in_130.rrd  LAST  -s 1613268033

1613268060: -nan -nan
1613268120: -nan -nan
1613268180: -nan -nan
1613268240: -nan -nan
```

## Script Options
--a sets the script to automatic mode which will look at the past 10 minutes of data
if you would like Automode to default to your rra folder and a specific timeframe update the
rrd_path and past_min variables
 
--i sets the script into interactive mode which allows you to set which path and timeframe
 
-h prints this menu
 
###
A note if you are using cacti boost you should either check against a longer length of time or after Boost has run
as with Boost the RRD files are not constantly updated so it can be normaly to show NaN values in the RRD for a period of time
If you see an abnormal amount of Dead RRD messeges from this script that may be the cause so either wait for the Boost poller to finish
Or chooise a longer length of time
###
