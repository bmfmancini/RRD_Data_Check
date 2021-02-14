#!/bin/bash

##Author Sean Mancini
#www.seanmancini.com
#Version 1.0


## Purpose This script will check the RRD files in the chosen directory for NAN values indicating
##The RRD file has not recvived any new data either because no input has been pushed to the graph or a permissions issue

#    This program is free software: you can redistribute it and/or modify#
#    it under the terms of the GNU General Public License as published by#
#    the Free Software Foundation, either version 3 of the License, or#
#    (at your option) any later version.#
#    This program is distributed in the hope that it will be useful,#
#    but WITHOUT ANY WARRANTY; without even the implied warranty of#
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the#
#    GNU General Public License for more details.#
#    You should have received a copy of the GNU General Public License#
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.#



#!/bin/bash

rm rrd_checkresults.txt > /dev/null
input=$1

if [[ $1 = "" ]]
then input=-h
fi

if [[ $input = -h ]] || [[ $input = -H ]]
then
  echo " "
  echo "~~~~~~~~~~~"
  echo " U S A G E"
  echo "~~~~~~~~~~~"
  echo "Usage: ./rrd_data_check.sh [option]"
  echo "  options:"
  echo "    -i : Interactive Mode"
  echo "    -a : Automatice mode (Use script defaults"
  echo "    -h : Show this help"
  echo ""

echo "A note if you are using cacti boost you should either check against a longer length of time or after Boost has run"
echo "as with Boost the RRD files are not constantly updated so it can be normaly to show NaN values in the RRD for a period of time"
echo "If you see an abnormal amount of Dead RRD messeges from this script that may be the cause so either wait for the Boost poller to finish"
echo "Or chooise a longer length of time"
echo " "
exit 0
fi

if [[ $input = -i ]] || [[ $input = -I ]]
then
echo "script in interactive mode"

echo "Enter RRA Path typically /var/www/html/cacti/rra"
read -r rrd_path
echo "How many minutes in the past would you like to fetch data for NAN values"
read -r past_min


fi


if [[ $input = -a ]] || [[ $input = -A ]]
then
echo "Automatic mode selected default are 10 minutes and looking in <cacti dir>/rra"
rrd_path="/var/www/html/cacti/rra/*"
past_min="10"
fi


timestamp=$(date +%s -d $past_min'mins ago');

for rrd in $rrd_path;
do

scan=$(rrdtool fetch $rrd LAST -s $timestamp | grep nan | wc -l  )

if (( $scan >  $past_min ))
then 
echo $rrd "Dead RRD or Device Offline " the Last $scan values were NaN

## Log these bad results to a file
echo  $rrd "Dead RRD" the Last $scan values were NaN >> rrd_checkresults.txt
fi
done


echo "Script done results stored in rrd_checkresults.txt"
