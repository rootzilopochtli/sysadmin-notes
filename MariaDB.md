# MariaDB Notes

- Reset root password
<pre>
<i>Inspect the status from MariaDB or MySQL</i>
&num; systemctl status mariadb
<br>
<i>Stop service</i>
&num; systemctl stop mariadb
<br>
<i>Start mysqld_safe service in background</i>
&num; mysqld&lowbar;safe --skip-grant-tables --skip-networking &amp;
<br>
<i>Access to MariaDB and change root password</i>
&num; mysql -u root

MariaDB [(none)]> use mysql;
MariaDB [mysql]> update user set password=PASSWORD("<b>NewPasswordHere</b>") where User='root';
MariaDB [mysql]> update user set plugin="";
MariaDB [mysql]> flush privileges;
MariaDB [mysql]> exit
<br>
<i>Stop mysqld_safe service</i>
&num; systemctl stop mariadb
&num; killall -s 9 <b>mysqld&lowbar;safe</b>
<br>
<i>Start MariaDB service</i>
&num; systemctl start mariadb
<br>
<i>Verify root password change</i>
&num; mysql -u root -p
</pre>
