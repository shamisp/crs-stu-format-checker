#!/bin/bash
# CRS and STU file format checker
# Copyright (C) 2015>  Pavel Shamis
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

for ff in `ls *.crs | awk -F. '{print $1}'` ;
	do echo ">>> Processing $ff files <<<"
	error=0
	for c in `cat $ff.crs  | tail -n +2 | awk '{print $1}'` ; do  
		if [ `cat $ff.crs | tail -n +2 | grep -c ^"\<$c\>"` -gt 1 ]; then 
			echo Error ${ff}.crs: Duplicated $c in ${ff}.crs file - found `grep -c ^"\<$c\>"  $ff.crs` 
			error=1
			break 
		fi 
		stu_cnt=`grep -c "\<$c\>" $ff.stu | tr -d "\r "`
		crs_cnt=`cat  $ff.crs | tail -n +2 | grep   ^"\<$c\>" | awk '{print $2}'| tr -d "\r "` 
		if [ $stu_cnt -ne $crs_cnt ]; then 
			echo "Error ${ff}.stu: course $c is expected $crs_cnt (according ${ff}.crs) but found $stu_cnt"
			error=1
		fi
	done
done 
